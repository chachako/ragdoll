//
//  Item.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/12.
//

import Foundation
import SwiftData

@Model
final class Item {
  var timestamp: Date
  
  init(timestamp: Date) {
    self.timestamp = timestamp
  }
}
