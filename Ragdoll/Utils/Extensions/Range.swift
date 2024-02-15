//
//  Range.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/15.
//

import Foundation

extension NSRange {
  /// The start index of the range. (inclusive)
  var startIndex: Int { location }
  
  /// The end index of the range. (exclusive)
  var endIndex: Int { location + length }
}
