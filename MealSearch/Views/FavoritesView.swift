//
//  FavoritesView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

class FavoriteStore: ObservableObject {
    @Published var favorites: [RecipeModel] = []
    
    func toggle(_ recipe: RecipeModel) -> Void {
        if self.contains(recipe) {
            self.remove(recipe)
        } else {
            self.add(recipe)
        }
    }
    
    func contains(_ recipe: RecipeModel) -> Bool {
        return favorites.contains {
            $0.id == recipe.id
        }
    }
    
    private func add(_ recipe: RecipeModel) -> Void {
        favorites.append(recipe)
    }
    
    private func remove(_ recipe: RecipeModel) -> Void {
        favorites = favorites.filter {
            $0.id != recipe.id
        }
    }    
}

struct FavoritesView: View {
    @Binding var isTabBarHidden: Bool
    @EnvironmentObject var favoriteStore: FavoriteStore
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundCream")
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    if (!$favoriteStore.favorites.isEmpty) {
                        RecipeList(
                            recipes: $favoriteStore.favorites,
                            isTabBarHidden: $isTabBarHidden
                        )
                    } else {
                        
                        Text("No Favorites Saved")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 24)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Text("Let's get cooking!")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 24)
                    }
                }
            }
            .navigationBarTitle("Favorites", displayMode: .large)
        }
    }
}

#Preview {
//    FavoritesView(isTabBarHidden: false)
}
