//
//  BookManager.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/11.
//

import SwiftUI
import AppKit
import Cocoa

class BookManager {
  /// Opens system file picker and imports books selected by the user into the app's private directory.
  ///
  /// - Returns: An array of URLs pointing to the successfully imported books.
  static func importBooks() -> [URL] {
    let openPanel = NSOpenPanel()
    openPanel.title = "Choose Book Files"
    openPanel.canChooseFiles = true
    openPanel.canChooseDirectories = false
    openPanel.allowsMultipleSelection = true
    openPanel.allowedContentTypes = [.pdf, .epub, .plainText]
    
    guard openPanel.runModal() == .OK else {
      // User canceled the operation
      return []
    }
    
    return importBooksToPrivateDirectory(openPanel.urls)
  }
  
  /// Copies books from the provided URLs to a new directory named "book" within the app's private directory.
  ///
  /// - Parameter bookURLs: An array of URLs pointing to the books to be copied.
  /// - Returns: An array of URLs pointing to the copied books.
  private static func importBooksToPrivateDirectory(_ bookURLs: [URL]) -> [URL] {
    var copiedURLs: [URL] = []
    
    guard let bookDirectoryURL = FileHelper.createDirectory("book") else {
      return copiedURLs
    }
    
    for bookURL in bookURLs {
      let destinationURL = bookDirectoryURL.appendingPathComponent(bookURL.lastPathComponent)
      do {
        try FileManager.default.copyItem(at: bookURL, to: destinationURL)
        copiedURLs.append(destinationURL)
      } catch {
        print("Failed to copy book \(bookURL): \(error.localizedDescription)")
      }
    }
    
    return copiedURLs
  }
}
