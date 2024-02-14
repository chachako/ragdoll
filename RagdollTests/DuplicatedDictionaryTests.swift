//
//  DuplicatedDictionaryTests.swift
//  RagdollTests
//
//  Created by 茶茶 on 2024/2/15.
//

import XCTest
@testable import Ragdoll

class DuplicatedDictionaryTests: XCTestCase {
  func testAddValue() {
    var duplicatedDict = DuplicatedDictionary<String, Int>()

    duplicatedDict.addValue(1, forKey: "A")
    duplicatedDict.addValue(2, forKey: "A")
    duplicatedDict.addValue(3, forKey: "B")

    XCTAssertEqual(duplicatedDict.inner["A"], [1, 2])
    XCTAssertEqual(duplicatedDict.inner["B"], [3])
  }

  func testMostFrequentKey() {
    var duplicatedDict = DuplicatedDictionary<String, Int>()

    duplicatedDict.addValue(1, forKey: "A")
    duplicatedDict.addValue(2, forKey: "A")
    duplicatedDict.addValue(3, forKey: "B")

    XCTAssertEqual(duplicatedDict.mostFrequentKey, "A")

    duplicatedDict.addValue(4, forKey: "B")
    duplicatedDict.addValue(5, forKey: "B")
    XCTAssertEqual(duplicatedDict.mostFrequentKey, "B")

    duplicatedDict.addValue(6, forKey: "A")
    duplicatedDict.addValue(7, forKey: "A")
    XCTAssertEqual(duplicatedDict.mostFrequentKey, "A")
  }
}
