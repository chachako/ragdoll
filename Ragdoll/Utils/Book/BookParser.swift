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

  /// 解析给定的书籍路径，如果失败则返回 nil。
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

      // Create a buffer of a specific size
      let chunkSize = 512 * 1024
      
      while true {
        // Read data of the specified chunk size
        let chunkData = fileHandle.readData(ofLength: chunkSize)

        // Check if the chunk is not empty, otherwise, the file is fully read
        guard !chunkData.isEmpty else { break }
        
        // Try to read the chunk as a string, otherwise skip this
        guard let chunkString = String(
          data: chunkData,
          encoding: chunkData.detectedEncoding ?? .utf8
        ) else { continue }
      }
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

}
