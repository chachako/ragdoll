//
//  Sequence.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/15.
//

import Foundation

extension Sequence {
  /// Finds the maximum element in the sequence based on a comparable property.
  ///
  /// - Parameter keyPath: The key path to the property used for comparison.
  /// - Returns: The maximum element in the sequence, or nil if the sequence is empty.
  func maxBy<T: Comparable>(_ keyPath: KeyPath<Element, T>) -> Element? {
    self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
  }

  /// Finds the minimum element in the sequence based on a comparable property.
  ///
  /// - Parameter keyPath: The key path to the property used for comparison.
  /// - Returns: The minimum element in the sequence, or nil if the sequence is empty.
  func minBy<T: Comparable>(_ keyPath: KeyPath<Element, T>) -> Element? {
    self.min(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
  }
}
