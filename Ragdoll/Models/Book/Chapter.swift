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
  /// The first character index of the chapter in the book.
  var startIndex: Int64
  /// The last character index of the chapter in the book.
  var endIndex: Int64
  /// The book that the chapter belongs to.
  var book: Book?
  
  init(title: String, startIndex: Int64, endIndex: Int64) {
    self.title = title
    self.startIndex = startIndex
    self.endIndex = endIndex
  }
}

/// A model representing a rule for parsing chapter titles.
struct ChapterTitleRule: Codable, Defaults.Serializable {
  var id: Int
  var enable: Bool
  var name: String
  var rule: String
  var example: String
  var serialNumber: Int
}
