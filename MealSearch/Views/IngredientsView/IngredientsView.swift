//
//  IngredientsView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI
import SwiftData

struct IngredientsView: View {
    @Query private var lists: [IngredientListModel]
    
    @EnvironmentObject var tabStore: IngredientTabStore
    @State private var selectedTab: Int = 0
    @State private var loadedOnce = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack() {
            VStack(spacing: 0) {
                VStack() {
                    SearchBar()
                    CustomIngredientsBar(selectedTab: $selectedTab)
                }
                .padding(.top, 10)
                .background(Color("PrimaryRed"))
                
                if tabStore.tabs.isEmpty {
                    Text("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TabView(selection: $selectedTab) {
                        ForEach($tabStore.tabs) { $tab in
                            IngredientList(list: tab.list)
                                .tag(tab.id)
                        }
                    }
                }
            }
        }
    }
}

struct CustomIngredientsBar: View {
    @EnvironmentObject var tabStore: IngredientTabStore
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(tabStore.tabs, id: \.id) {
                    tab in
                    Button(action: {selectedTab = tab.id}) {
                        HStack(spacing: 4) {
                            Text(tab.title)
                            Image(systemName: tab.icon)
                                .font(.largeTitle)
                                .frame(height: 30)
                        }
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity,
                           alignment: .top)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .border(tab.id == selectedTab
                            ? Color("BackgroundCream")
                            : Color("PrimaryRed"),
                            width: 3)
                    .background(tab.id == selectedTab
                                ? Color("PrimaryRed")
                                : Color("BackgroundCream"))
                    .foregroundColor(tab.id == selectedTab
                                     ? .white
                                     : .black)
                }
            }
            .background(Color("PrimaryRed"))
        }
    }
}

#Preview {
    IngredientsView()
        .environmentObject(IngredientTabStore())
}
