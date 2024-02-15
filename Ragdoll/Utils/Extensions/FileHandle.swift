//
//  FileHandle.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/15.
//

import Foundation

extension FileHandle {
  /// Reads data from the specified range within the file without altering the handle's position.
  ///
  /// - Parameters:
  ///   - startIndex: The starting offset within the file. (inclusive)
  ///   - endIndex: The ending offset within the file. (exclusive)
  /// - Returns: Data read from the specified range, or `nil` if the read operation fails.
  func read(from startIndex: UInt64, to endIndex: UInt64) throws -> Data? {
    // Save the current handle position
    let originalPosition = try offset()
    
    // Move to the specified starting position
    try seek(toOffset: startIndex)
    
    // Read data within the specified range
    let length = Int(endIndex - startIndex)
    let data = try read(upToCount: length)
    
    // Restore the original handle position
    seek(toFileOffset: originalPosition)
    
    return data
  }
}
