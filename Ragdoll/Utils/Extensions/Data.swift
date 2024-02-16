//
//  Charset.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/14.
//

import Foundation

extension Data {
  /// Detects the encoding of the data, or `nil` if the encoding cannot be determined.
  var detectedEncoding: String.Encoding? {
    guard case let encoding = NSString.stringEncoding(
      for: self,
      encodingOptions: nil,
      convertedString: nil,
      usedLossyConversion: nil
    ), encoding != 0 else { return nil }
    return .init(rawValue: encoding)
  }

  /// Removes the UTF-8 Byte Order Mark (BOM) from the data, if present.
  mutating func removeUtf8Bom() {
    let containsBom = self.starts(with: [0xEF, 0xBB, 0xBF])
    if containsBom { self.removeFirst(3) }
  }
}
