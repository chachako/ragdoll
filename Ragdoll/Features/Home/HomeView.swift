//
//  ContentView.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/8.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    NavigationView {
      VStack {
        Button(action: {
          let result = BookManager.importBooks()
          print("Selected \(result)")
        }) {
          Text("导入 TXT 文件")
            .font(.headline)
            .padding()
        }
        Text("Welcome to Ragdoll!")
          .font(.title)
          .padding()
        NavigationLink(destination: ReadingView()) {
          Text("Start Reading")
            .font(.headline)
            .padding()
        }
      }
      .navigationTitle("Home")
    }
  }
}

#Preview {
  HomeView()
}
