//
//  Chapter.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/12.
//

import Foundation
import SwiftData
import Defaults

/// A model representing a chapter in a book.
@Model
final class Chapter {
  /// The title of the chapter.
  var title: String
  /// The first character index of the chapter's body in the book. (inclusive)
  var bodyStart: UInt64
  /// The last character index of the chapter's body in the book. (exclusive)
  var bodyEnd: UInt64
  /// The book that the chapter belongs to.
  var book: Book?
  
  init(title: String, bodyStart: UInt64, bodyEnd: UInt64) {
    self.title = title
    self.bodyStart = bodyStart
    self.bodyEnd = bodyEnd
  }

  /// Creates a chapter representing "Preface".
  /// - Parameter length: The length of the preface body.
  static func preface(length: UInt64) -> Chapter {
    Chapter(title: String(localized: "Preface"), bodyStart: 0, bodyEnd: length)
  }
}

/// A model representing a rule for parsing chapter titles.
struct ChapterTitleRule: Codable, Hashable, Defaults.Serializable {
  var id: Int
  var enable: Bool
  var name: String
  var rule: String
  var example: String
  var serialNumber: Int
  
  /// Returns an initialized `NSRegularExpression` instance for the rule.
  ///
  /// - Parameter options: The regular expression options that are applied to the expression during matching.
  ///                      See `NSRegularExpression.Options` for possible values.
  func regex(options: NSRegularExpression.Options = .anchorsMatchLines) -> NSRegularExpression? {
    try? NSRegularExpression(pattern: rule, options: options)
  }
  
  /// Checks if the given input string matches the regular expression for the rule.
  /// If matches are found, returns an array of ranges representing the matched substrings in the input.
  ///
  /// - Parameter input: The input string to test against the rule.
  /// - Returns: An array of `NSRange` objects representing the ranges of matched substrings in the input,
  ///            or `nil` if no matches are found.
  func matches(_ input: String) -> [NSRange]? {
    let range = NSRange(location: 0, length: input.utf16.count)
    return regex()?.matches(in: input, options: [], range: range).map { $0.range }
  }
  
  static func == (lhs: ChapterTitleRule, rhs: ChapterTitleRule) -> Bool {
    lhs.rule == rhs.rule
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(rule)
  }
}
