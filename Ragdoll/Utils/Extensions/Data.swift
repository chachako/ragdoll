//
//  Charset.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/14.
//

import Foundation

extension Data {
  /// The detected encoding of the data.
  /// If the encoding cannot be detected, `nil` is returned.
  var detectedEncoding: String.Encoding? {
    guard case let encoding = NSString.stringEncoding(
      for: self,
      encodingOptions: nil,
      convertedString: nil,
      usedLossyConversion: nil
    ), encoding != 0 else { return nil }
    return .init(rawValue: encoding)
  }
  
  mutating func removeUtf8Bom() {
    let containsBom = self.starts(with: [0xEF, 0xBB, 0xBF])
    if containsBom { self.removeFirst(3) }
  }
}
