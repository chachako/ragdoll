//
//  ReadingView.swift
//  Ragdoll
//
//  Created by 茶茶 on 2024/2/10.
//

import SwiftUI

struct ReadingView: View {
  @State private var text = "This is an example text for the reader."
  
  var body: some View {
    VStack {
      Text(text)
        .padding()
      Spacer()
    }
    .navigationTitle("Reader")
  }
}

#Preview {
  ReadingView()
}
