//
//  NavigationView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct NavigationView: View {
    @State private var selectedTab: Int = 0
    private var tabNames: [(String, String)] = [
        ("Ingredients", "🍅"),
        ("Meal Search", "🔎"),
        ("Favorites", "⭐️"),
    ]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Ingredients", systemImage: "", value: 0) { IngredientsView() }
            Tab("Meal Search", systemImage: "", value: 1) { SearchView() }
            Tab("Favorites", systemImage: "", value: 2) { FavoritesView() }
        }
        
        // Custom navigation bar implementation
        Divider()
            .frame(height: 1.5)
            .overlay(.gray)
            .padding(.bottom, 10)
        
        HStack() {
            ForEach(Array(tabNames.enumerated()), id:\.0) { index, tab in
                Button(action: { selectedTab = index }) {
                    VStack() {
                        Text(tab.1)
                            .font(.largeTitle)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                selectedTab == index
                                    ? .lighterRed
                                    : .clear
                            )
                            .cornerRadius(20)
                            .overlay(
                                selectedTab == index
                                ? RoundedRectangle(cornerRadius: 20)
                                        .stroke(.lightRed, lineWidth: 5)
                                : nil
                            )
                        Text(tab.0)
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                    }
                    
                    index+1 != tabNames.count ? Spacer() : nil
                }
            }
        }
        .padding(.horizontal, 30)
    }

}

#Preview {
    NavigationView()
}
