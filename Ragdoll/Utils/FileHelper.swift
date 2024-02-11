//
//  FileManager.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/11.
//

import Foundation

/// A helper class for file system operations within the app's private directory.
class FileHelper {
  static var privateDirectory: URL? {
    return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
  }
  
  /// Creates a directory at the specified path within the private documents directory.
  ///
  /// - Parameter path: The path where the directory should be created.
  /// - Returns: The URL of the created directory if successful, otherwise nil.
  static func createDirectory(_ path: String) -> URL? {
    guard let directoryURL = privateDirectory?.appendingPathComponent(path, isDirectory: true) else {
      return nil
    }
    
    do {
      try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
      return directoryURL
    } catch {
      print("Failed to create directory: \(error.localizedDescription)")
      return nil
    }
  }
  
  /// Creates a file at the specified path within the private documents directory.
  ///
  /// - Parameters:
  ///   - path: The path where the file should be created.
  ///   - contents: The data to be written to the file.
  ///   - attributes: The attributes for the file.
  /// - Returns: The URL of the created file if successful, otherwise nil.
  static func createFile(atPath path: String, contents: Data?, attributes: [FileAttributeKey : Any]? = nil) -> URL? {
    guard let fileURL = privateDirectory?.appendingPathComponent(path) else {
      return nil
    }
    
    do {
      try contents?.write(to: fileURL, options: .atomic)
      return fileURL
    } catch {
      print("Failed to create file: \(error.localizedDescription)")
      return nil
    }
  }
}
