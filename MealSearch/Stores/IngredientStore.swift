//
//  IngredientStore.swift
//  MealSearch
//
//  Created by br-zee on 11/28/25.
//

import Foundation

struct IngredientTab: Identifiable {
    let id: Int
    let icon: String
    let title: String
    var list: IngredientListModel
}

class IngredientTabStore: ObservableObject {
    
    // Published for ease of access anywhere
    @Published var tabs: [IngredientTab] = []
    
    // Initialize 2 default lists, Pantry and Shopping List
    func initialize(from lists: [IngredientListModel]) {
        tabs = lists.map { list in
            IngredientTab(
                id: list.id,
                icon: list.id == 0 ? "archivebox.fill" : "cart.fill",
                title: list.id == 0 ? "My Pantry" : "Shopping List",
                list: list
            )
        }
    }

    // Find the list index that ingredient is at (can only exist in one)
    func ingredientExistsAt(ingredientName: String) -> Int {
        for tab in tabs {
            for item in tab.list.ingredients {
                if item.name == ingredientName {
                    return tab.id
                }
            }
        }
        return -1
    }
}
