//
//  ContentView.swift
//  MealSearch
//
//  Created by Brian Alvarez on 10/19/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("MealSearch Home")
            .font(.title)
            .padding()
            .task {
                print("Testing recipe information…")
//                await testRecipeInformation()
                print("Done testing recipe information")
            }
    }
}

#Preview {
    ContentView()
}
