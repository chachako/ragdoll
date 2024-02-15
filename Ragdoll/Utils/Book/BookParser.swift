//
//  BookParser.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/12.
//

import Foundation

class BookParser {
  /// The patterns that match the book name.
  private static let namePatterns = [
    try! NSRegularExpression(pattern: "《([^《》]+)》"),
    try! NSRegularExpression(pattern: "^(.+) (作\\s*者\\s*|by )", options: .caseInsensitive),
  ]
  
  /// The patterns that match the book author.
  private static let authorPatterns = [
    try! NSRegularExpression(pattern: "(作者[：:]|作\\s*者\\s*|by )(?<author>.*)著", options: .caseInsensitive),
    try! NSRegularExpression(pattern: "(作者[：:]|作\\s*者\\s*|by )(?<author>.*)", options: .caseInsensitive),
    try! NSRegularExpression(pattern: "(?<author>.+)《([^《》]+)\\W*"),
    try! NSRegularExpression(pattern: "^\\W*《([^《》]+)》(?<author>.+)"),
  ]
  
  /// Parses the given book path, and returns `nil` if parsing fails.
  static func parseBook(atPath path: URL) -> Book? {
    let (name, author) = parseBasicInfo(filePath: path)
    return Book(
      name: name,
      author: author,
      sourcePath: path
    )
  }
  
  /// Parses all the chapters of the given book and updates the `Book.chapters`
  /// with the parsed chapters.
  static func parseChapters(book: Book) -> Book {
    do {
      // Create a file handle for reading
      let fileHandle = try FileHandle(forReadingFrom: book.sourcePath)
      defer { fileHandle.closeFile() }
      
      var result: [Chapter] = []
      var encoding: String.Encoding? = nil
      let fileLength = try fileHandle.seekToEnd()
      // Create a buffer of a specific size
      let chunkSize = 512 * 1024
      // Count the total number of bytes read
      var totalRead: UInt64 = 0
      // Save the best rule, which is the one that matches the most times
      var bestRule: ChapterTitleRule? = nil
      
      /// 一轮接一轮地解析 chunk 中的章节，直到读取完整个文件。
      ///
      /// 1. 匹配这一轮中出现的所有章节标题：
      ///   - 尝试匹配用户配置中的所有标题规则，将成功次数最多的作为整本书的统一标题规则（通常一本书的所有标题格式都是一致的，因此无需考虑特殊情况）
      ///   - 如果在当前的 chunk 中没有任何标题匹配，说明都属于同一章节，不需要做任何处理
      ///
      /// 2. 处理在这一轮第一次出现的章节标题之前的内容：
      ///   - Case: 存在上一章
      ///     1. 将上一章的正文内容和这些剩余内容合并
      ///     2. 对合并后的内容再做一次解析。如果存在任何标题，则按顺序插入这些章节（这是为了应对标题跨越 chunk 边界的情况）
      ///   - Case: 不存在上一章
      ///     1. 直接将文件的开头到首个标题前的内容视为 “前言”
      ///
      /// 3. 添加章节：保存章节标题与章节的正文范围索引。
      ///
      /// 注：一个章节标题之后到下一个章节标题之前，即是正文内容。
      ///    因此一轮的章节总是在下一轮中完成，因为我们必须要知道下一个章节标题出现的位置。
      while true {
        // Read data of the specified chunk size
        guard var chunkData = try fileHandle.read(upToCount: chunkSize) else { break }
        
        // Skip UTF-8 BOM
        chunkData.removeUtf8Bom()
        
        // Check if the chunk is not empty, otherwise, the file is fully read
        guard !chunkData.isEmpty else { break }
        
        if encoding == nil { encoding = chunkData.detectedEncoding ?? .utf8 }
        
        // Try to read the chunk as a string, otherwise skip this
        guard let chunkString = String(data: chunkData, encoding: encoding!) else { continue }
        
        // Ranges of all the matched chapters in this round
        var matchedRanges: [NSRange] = []
        
        // Parse the titles using the best rule
        if let rule = bestRule {
          guard let matches = rule.matches(chunkString) else { continue }
          matchedRanges = matches
        } else {
          // Find the best rule and add the matched chapters to the result
          guard let (best, matches) = findBestTitleRule(chunkString) else { continue }
          matchedRanges = matches
          bestRule = best
        }
        
        if matchedRanges.isEmpty { continue }
        
        // Whether there is content before the first chapter in this round
        let remainingLength = matchedRanges.first!.startIndex
        let hasRemaingData = remainingLength > 0
        
        /// Maps the matched range to the whole book's range.
        func wholeRange(_ raw: NSRange) -> (startIndex: UInt64, endIndex: UInt64) {
          // The "startIndex" is inclusive, and the "endIndex" is exclusive
          (startIndex: totalRead + raw.startIndex.toUInt64(), endIndex: totalRead + raw.endIndex.toUInt64())
        }
        
        // Ranges of all the matched chapters in the whole book
        var titleRanges: [(startIndex: UInt64, endIndex: UInt64)] = matchedRanges.map { wholeRange($0) }
        
        // Process the remaining content before the first chapter
        if hasRemaingData {
          if let previousChapter = result.last {
            // Re-parse the remaining content and combine it with the previous chapter, in case we missed any boundary chapters
            if let remainingData = try fileHandle.read(from: previousChapter.bodyStart, to: titleRanges.first!.startIndex),
               let remainingContent = String(data: remainingData, encoding: encoding!),
               let missedRanges = bestRule!.matches(remainingContent)?.map({ wholeRange($0) }) {
              // Add the missed ranges to the beginning of "titleRanges"
              titleRanges.insert(contentsOf: missedRanges, at: 0)
              // At this time, we can truly append the remaining content to the previous chapter
              previousChapter.bodyEnd = titleRanges.first!.startIndex
            }
          } else {
            // There is no previous chapter, just create a new chapter to consider the remaining content as a "Preface"
            result.append(Chapter.preface(length: titleRanges.first!.startIndex))
          }
        }
        
        // Now we know that there is no remaining content, so we can simply add new chapters
        for (index, (titleStart, titleEnd)) in titleRanges.enumerated() {
          let chunkTitleRange = matchedRanges[index]
          let title = chunkString.substring(from: chunkTitleRange.startIndex, to: chunkTitleRange.endIndex) ?? String(localized: "Unknown")
          // Complete the previous chapter
          if let previousChapter = result.last { previousChapter.bodyEnd = titleStart }
          // Add the new chapter
          result.append(Chapter(title: title, bodyStart: titleEnd, bodyEnd: fileLength))
        }
        
        totalRead += chunkData.count.toUInt64()
      }
      
      // Update the chapter list
      book.chapters = result
      book.totalChapters = result.count
    } catch {
      print("Unable to parse book file at \(book.sourcePath)")
    }

    return book
  }
  
  /// Parses the basic information (name and author) from the file name of the given path.
  static func parseBasicInfo(filePath path: URL) -> (name: String, author: String?) {
    let fileName = path.deletingPathExtension().lastPathComponent
    var name = ""
    var author: String? = nil
    
    for pattern in namePatterns {
      if let match = pattern.firstMatch(
        in: fileName,
        options: [],
        range: NSRange(location: 0, length: fileName.count)
      ) {
        name = (fileName as NSString).substring(with: match.range(at: 1))
        break
      }
      
      // If no match is found, use the file name as the book name.
      name = fileName
    }
    
    for pattern in authorPatterns {
      if let match = pattern.firstMatch(
        in: fileName,
        options: [],
        range: NSRange(location: 0, length: fileName.count)
      ) {
        author = (fileName as NSString).substring(with: match.range(withName: "author"))
        break
      }
    }
    
    return (name.trimmingWhitespaces(), author?.trimmingWhitespaces())
  }
  
  /// Finds the best-matching chapter title rule for the given input string.
  ///
  /// - Parameter input: The input string to analyze for matching chapter title rules.
  /// - Returns: A tuple containing the best matching `ChapterTitleRule` and its corresponding matched ranges.
  static func findBestTitleRule(_ input: String) -> (rule: ChapterTitleRule, matchedRanges: [NSRange])? {
    // Create a dictionary to store the parsed rules and the ranges of the matched titles
    var ruleToTitles = DuplicatedDictionary<ChapterTitleRule, NSRange>()
    
    // Parse each rule one by one to find the best match
    for rule in UserConfigs.enabledChapterTitleRules() {
      // Add all successful matches to the dictionary
      rule.matches(input)?.forEach { ruleToTitles.addValue($0, forKey: rule) }
    }
    
    // Return nil if no matching rule is found
    guard let bestRule = ruleToTitles.mostFrequentKey else { return nil }
    
    // Return the best matching rule and its corresponding matched ranges
    return (bestRule, ruleToTitles[bestRule])
  }
}
