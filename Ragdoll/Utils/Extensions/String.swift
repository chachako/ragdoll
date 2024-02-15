//
//  String.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/14.
//

import Foundation

extension String {
  /// Returns a new string made by removing whitespaces and newlines from both ends.
  func trimmingWhitespaces() -> String {
    self.trimmingCharacters(in: .whitespaces)
  }
  
  /// Returns the substring starting at the `startIndex` and ending right before the `endIndex`.
  ///
  /// - Parameters:
  ///   - startIndex: The starting index of the substring (inclusive).
  ///   - endIndex: The ending index of the substring (exclusive).
  /// - Returns: The substring extracted from the original string, or nil if the indices are invalid.
  func substring(from startIndex: Int, to endIndex: Int) -> String? {
    // Ensure the index range is valid
    guard startIndex >= 0, endIndex <= self.count, startIndex <= endIndex else {
      return nil
    }
    
    // Use String.Index to get the starting and ending indices
    let startIdx = index(self.startIndex, offsetBy: startIndex)
    let endIdx = index(self.startIndex, offsetBy: endIndex)
    
    // Extract the substring using the index range
    return String(self[startIdx..<endIdx])
  }
}
