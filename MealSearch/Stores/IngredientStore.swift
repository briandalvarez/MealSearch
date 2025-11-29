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
    @Published var tabs: [IngredientTab] = []
    
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
