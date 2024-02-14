//
//  BookParserTests.swift
//  RagdollTests
//
//  Created by 茶茶 on 2024/2/12.
//

import XCTest
@testable import Ragdoll

final class BookParserTests: XCTestCase {
  func testParseBasicInfo() {
    let testFilePath1 = URL(fileURLWithPath: "/path/to/经典文学《呐喊》- 作者：鲁迅.txt")
    let testFilePath2 = URL(fileURLWithPath: "/path/to/刘慈欣《三体》,,,.txt")
    let testFilePath3 = URL(fileURLWithPath: "/path/to/《白夜行》  东野圭吾.txt")
    let testFilePath4 = URL(fileURLWithPath: "/path/to/Title by Author.txt")
    let testFilePath5 = URL(fileURLWithPath: "/path/to/西游记 作 者 吴承恩.txt")
    let testFilePath6 = URL(fileURLWithPath: "/path/to/水浒传.txt")
    
    let result1 = BookParser.parseBasicInfo(filePath: testFilePath1)
    let result2 = BookParser.parseBasicInfo(filePath: testFilePath2)
    let result3 = BookParser.parseBasicInfo(filePath: testFilePath3)
    let result4 = BookParser.parseBasicInfo(filePath: testFilePath4)
    let result5 = BookParser.parseBasicInfo(filePath: testFilePath5)
    let result6 = BookParser.parseBasicInfo(filePath: testFilePath6)
    
    XCTAssertEqual(result1.name, "呐喊")
    XCTAssertEqual(result1.author, "鲁迅")
    
    XCTAssertEqual(result2.name, "三体")
    XCTAssertEqual(result2.author, "刘慈欣")
    
    XCTAssertEqual(result3.name, "白夜行")
    XCTAssertEqual(result3.author, "东野圭吾")
    
    XCTAssertEqual(result4.name, "Title")
    XCTAssertEqual(result4.author, "Author")
    
    XCTAssertEqual(result5.name, "西游记")
    XCTAssertEqual(result5.author, "吴承恩")
    
    XCTAssertEqual(result6.name, "水浒传")
    XCTAssertNil(result6.author)
  }
}
