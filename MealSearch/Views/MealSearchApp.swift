//
//  MealSearchApp.swift
//  MealSearch
//
//  Created by Brian Alvarez on 10/19/25.
//

import SwiftUI
import SwiftData
import UIKit

@main
struct MealSearchApp: App {
    @StateObject private var tabStore = IngredientTabStore()
    @StateObject private var favoriteStore = FavoriteStore()
        
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(tabStore)
                .environmentObject(favoriteStore)
        }
        .modelContainer(for: [IngredientModel.self, IngredientListModel.self, RecipeStore.self])
    }
}

