//
//  IngredientsView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct IngredientTab: Identifiable {
    let id: Int
    let icon: String
    let title: String
    var list: IngredientListModel
}

struct IngredientsView: View {
    @State private var selectedTab: Int = 0    
    @State private var tabs = [
        IngredientTab(id: 0, icon: "archivebox.fill", title: "My Pantry", list: IngredientListModel(id: 0, ingredients: [])),
        IngredientTab(id: 1, icon: "cart.fill", title: "Shopping List", list: IngredientListModel(id: 1, ingredients: [])),
    ]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack() {
            VStack(spacing: 0) {
                VStack() {
                    SearchBar(tabs: $tabs)
                    CustomIngredientsBar(selectedTab: $selectedTab, tabs: $tabs)
                }
                .padding(.top, 10)
                .background(Color("PrimaryRed"))
                
                TabView(selection: $selectedTab) {
                    ForEach($tabs) {
                        $tab in
                        IngredientList(list: $tab.list)
                            .tag(tab.id)
                    }
                }
            }
        }
    }
}

struct CustomIngredientsBar: View {
    @Binding var selectedTab: Int
    @Binding var tabs: [IngredientTab]
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(tabs, id: \.id) {
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
}
