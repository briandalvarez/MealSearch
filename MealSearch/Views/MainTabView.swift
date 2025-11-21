//
//  MainTabView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 1
    @State private var isTabBarHidden = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        VStack(spacing: 0) {
            
            TabView(selection: $selectedTab) {
                IngredientsView()
                    .tag(0)
                
                SearchView(isTabBarHidden: $isTabBarHidden)
                    .tag(1)
                
                FavoritesView()
                    .tag(2)
            }
            if !isTabBarHidden {
                CustomTabBar(selectedTab: $selectedTab)
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
}
