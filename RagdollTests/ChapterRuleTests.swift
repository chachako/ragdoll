//
//  ChapterRuleTests.swift
//  RagdollTests
//
//  Created by 茶茶 on 2024/2/14.
//

import XCTest
@testable import Ragdoll

final class ChapterRuleTests: XCTestCase {
  func testDefaultConfigs() {
    let config = UserConfigs.chapterTitleRules
    // Assert the expected number of rules
    XCTAssertEqual(config.count, 25)
    // Assert the expected values of the specified rule
    XCTAssertEqual(config[2].id, -3)
    XCTAssertEqual(config[2].enable, false)
    XCTAssertEqual(config[2].name, "目录(匹配简介)")
    XCTAssertEqual(config[2].rule, "(?<=[　\\s])(?:(?:内容|文章)?简介|文案|前言|序章|楔子|正文(?!完|结)|终章|后记|尾声|番外|第\\s{0,4}[\\d〇零一二两三四五六七八九十百千万壹贰叁肆伍陆柒捌玖拾佰仟]+?\\s{0,4}(?:章|节(?!课)|卷|集(?![合和])|部(?![分赛游])|回(?![合来事去])|场(?![和合比电是])|篇(?!张))).{0,30}$")
    XCTAssertEqual(config[2].example, "简介 老夫诸葛村夫")
    XCTAssertEqual(config[2].serialNumber, 2)
  }
}
