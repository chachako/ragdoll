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
    return self.trimmingCharacters(in: .whitespaces)
  }
}
