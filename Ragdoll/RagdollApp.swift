//
//  RagdollApp.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/12.
//

import SwiftUI
import SwiftData

@main
struct RagdollApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      HomeView()
    }
    .modelContainer(sharedModelContainer)
  }
}
