//
//  Book.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/12.
//

import Foundation
import SwiftData

/// A model representing a book.
@Model 
final class Book {
  /// The name of the book.
  var name: String
  /// The author of the book.
  var author: String?
  /// The path to the source file of the book.
  var sourcePath: URL
  /// The path to the imported file of the book.
  var importPath: URL?
  /// The number of chapters in the book.
  var totalChapters: Int = 0
  /// The index of the current chapter being read.
  /// - SeeAlso: `totalChapters`
  var currentChapterIndex: Int = 0
  /// The current reading position, which is the index of the
  /// first character displayed on the current page.
  var readingPosition: UInt64 = 0
  /// The date when the book was last updated.
  var updatedDate: Date = Date.now
  /// The list of chapters in the book.
  @Relationship(deleteRule: .cascade, inverse: \Chapter.book)
  var chapters: [Chapter] = []
  
  init(
    name: String,
    author: String?,
    sourcePath: URL
  ) {
    self.name = name
    self.author = author
    self.sourcePath = sourcePath
  }
}
