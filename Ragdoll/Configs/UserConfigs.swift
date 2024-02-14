//
//  UserConfigs.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/14.
//

import Foundation

final class UserConfigs {
  @UserConfig("chapterTitleRules")
  static var chapterTitleRules: [ChapterTitleRule] = defaultChapterTitleRules()
  
  private static func defaultChapterTitleRules() -> [ChapterTitleRule] {
    guard let url = Bundle.main.url(forResource: "ChapterTitleRules", withExtension: "json"),
          let json = try? Data(contentsOf: url)
          else { return [] }

    return (try? JSONDecoder().decode([ChapterTitleRule].self, from: json)) ?? []
  }
}
