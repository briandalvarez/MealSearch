//
//  MainTabView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \IngredientListModel.id) private var lists: [IngredientListModel]
    @Query private var recipeStore: [RecipeStore]
    
    @EnvironmentObject var tabStore: IngredientTabStore
    @EnvironmentObject var favoriteStore: FavoriteStore

        
    @State private var selectedTab: Int = 1
    @State private var isTabBarHidden = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        VStack(spacing: 0) {
            if tabStore.tabs.count >= 2 {
                TabView(selection: $selectedTab) {
                    IngredientsView()
                        .tag(0)
                    
                    SearchView(isTabBarHidden: $isTabBarHidden, selectedTab: $selectedTab)
                        .tag(1)
                    
                    FavoritesView(isTabBarHidden: $isTabBarHidden)
                        .tag(2)
                }
                if !isTabBarHidden {
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            if tabStore.tabs.isEmpty {
                createDefaultListsIfNeeded()
                tabStore.initialize(from: lists)
            }
            
            if recipeStore.isEmpty {
                createDefaultRecipeStore()
            } else {
                favoriteStore.favorites = recipeStore[0].favoritedRecipes
            }
        }
    }
    
    private func createDefaultListsIfNeeded() {
        let descriptor = FetchDescriptor<IngredientListModel>()

        // Create default ingredient lists
        if (try? context.fetch(descriptor))?.isEmpty ?? true {

            let pantry = IngredientListModel(id: 0)
            let shopping = IngredientListModel(id: 1)

            context.insert(pantry)
            context.insert(shopping)
            
            do {
                try context.save()
            } catch {
                print("filed to create default lists: \(error)")
            }
        }
    }
    
    private func createDefaultRecipeStore() {
        // Create default recipe store lists
        if recipeStore.isEmpty {
            context.insert(RecipeStore())
            
            do {
                try context.save()
            } catch {
                print("filed to create default lists: \(error)")
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        (icon: "carrot.fill", title: "Ingredients", tag: 0),
        (icon: "magnifyingglass", title: "Meal Search", tag: 1),
        (icon: "star.fill", title: "Favorites", tag: 2)
    ]
    var body: some View {
        VStack(spacing: 1) {	
            Divider()
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.tag) {
                    tab in
                    Button(action: {selectedTab = tab.tag}) {
                        VStack(spacing: 6) {
                            Spacer(minLength: 30)
                            Image(systemName: tab.icon)
                                .font(.system(size: 32))
                            Text(tab.title)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .bottom)
                        .padding(.bottom, 6)
                        .foregroundColor(selectedTab == tab.tag ? .white : .black)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(height: 60)
            .background(Color("PrimaryRed"))
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(IngredientTabStore())
        .environmentObject(FavoriteStore())
        .modelContainer(for: [IngredientListModel.self, RecipeStore.self], inMemory: true)
}
