//
//  DuplicatedDictionary.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/15.
//

import Foundation

/// A specialized dictionary that allows the storage of multiple values for each key.
struct DuplicatedDictionary<Key: Hashable, Value> {
  /// Internal storage for the dictionary with keys mapped to an array of values.
  var inner: [Key: [Value]] = [:]

  /// Finds the key with the most frequent associated values, or nil if the dictionary is empty.
  var mostFrequentKey: Key? {
    inner.maxBy(\.value.count)?.key
  }

  /// Adds a new value to the array associated with the specified key.
  ///
  /// - Parameters:
  ///   - newValue: The value to be added.
  ///   - key: The key associated with the array to which the value will be added.
  mutating func addValue(_ newValue: Value, forKey key: Key) {
    inner[key, default: []].append(newValue)
  }
  
  /// Gets the values associated with the specified key.
  ///
  /// - Parameter key: The key whose values will be retrieved.
  /// - Returns: The values associated with the specified key, or an empty array if no values are found.
  subscript(key: Key) -> [Value] {
    inner[key, default: []]
  }
}
