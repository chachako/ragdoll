//
//  UserConfig.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/14.
//

import Defaults
import Foundation

/// A wrapper for [sindresorhus/Defaults](https://github.com/sindresorhus/Defaults).
///
/// ```swift
/// @UserConfig("key")
/// var value: String = "default"
/// ```
@propertyWrapper
struct UserConfig<Value: Defaults.Serializable> {
  let key: Defaults.Key<Value>

  var wrappedValue: Value {
    get { Defaults[key] }
    set { Defaults[key] = newValue }
  }

  init(wrappedValue defaultValue: Value, _ key: String) {
    self.key = Defaults.Key<Value>(key, default: defaultValue)
  }
}
