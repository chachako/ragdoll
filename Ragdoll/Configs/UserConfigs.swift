//
//  UserConfigs.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/14.
//

import Foundation

/// A class responsible for managing user configurations.
final class UserConfigs {
  /// The list of rules used to parse the chapter titles of the books.
  @UserConfig("chapterTitleRules")
  static var chapterTitleRules: [ChapterTitleRule] = defaultChapterTitleRules()
  
  /// Returns the list of enabled chapter title rules.
  static func enabledChapterTitleRules() -> [ChapterTitleRule] {
    chapterTitleRules.filter { $0.enable }
  }
  
  /// Retrieves the default chapter title rules from a bundled JSON file.
  private static func defaultChapterTitleRules() -> [ChapterTitleRule] {
    guard let url = Bundle.main.url(forResource: "ChapterTitleRules", withExtension: "json"),
          let json = try? Data(contentsOf: url)
          else { return [] }

    return (try? JSONDecoder().decode([ChapterTitleRule].self, from: json)) ?? []
  }
}
