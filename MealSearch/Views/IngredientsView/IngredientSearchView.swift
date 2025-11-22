//
//  IngredientSearchView.swift
//  MealSearch
//
//  Created by csuftitan on 11/20/25.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var tabs: [IngredientTab]
    @State private var searchQuery: String = ""
    @State private var showingPopover: Bool = false
    
    var body: some View {
        ZStack() {
            Button {
                showingPopover = true
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                    Text("Search for ingredients")
                        .padding(.vertical, 5)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.leading, 10)
            }
            .buttonStyle(.plain)
//            .padding(.leading, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.backgroundCream)
            }
            .popover(isPresented: $showingPopover, attachmentAnchor: .point(.center), arrowEdge: .bottom) {
                SearchPopover(tabs: $tabs, showingPopover: $showingPopover)
            }
        }
        .zIndex(1)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 30)
    }
}

struct SearchPopover: View {
    @Binding var tabs: [IngredientTab]
    @Binding var showingPopover: Bool
    @State private var selectedIngredient: IngredientModel?
    @State private var selectedTab: Int = -1
    
    @State private var defaultIngredients: [IngredientModel] = MockIngredients.pantry
    
    func ingredientExists(_ ingredient: String) -> Bool {
        for tab in tabs {
            for item in tab.list.ingredients {
                if item.name == ingredient {
                    return true
                }
            }
        }
        return false
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Select ingredients to add:")
                    .font(.headline)
                    .frame(alignment: .leading)
                Spacer()
                Button("Done") { showingPopover = false }
                    .font(.title3)
                    .foregroundStyle(.primaryRed)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 10)
            
            List {
                ForEach($defaultIngredients, id: \.id) {
                    ingredient in
                    HStack {
                        Text(ingredient.wrappedValue.name)
                        Spacer()
                        Button {
                            selectedIngredient = ingredient.wrappedValue
                        } label: {
                            Image(systemName: ingredientExists(ingredient.wrappedValue.name)
                                  ? "checkmark.app.fill"
                                  : "plus.app")
                            .foregroundStyle(.green)
                            .font(.title)
                        }
                        .sheet(item: $selectedIngredient) {
                            ingredient in
                            SearchPopoverSelection(
                                tabs: $tabs,
                                ingredient: ingredient
                            )
                        }
                        
                    }
                    .padding(.vertical, 10)
                }
            }
            .listStyle(.plain)
            
        }
        .padding(.horizontal, 20)
        .background(.backgroundCream)
    }
}

struct SearchPopoverSelection: View {
    @Binding var tabs: [IngredientTab]
    @State private var selectedTab: Int = 0
    let ingredient: IngredientModel
    
    func addIngredient(_ item: IngredientModel) -> Void {
        tabs[selectedTab].list.ingredients.append(item)
    }
    
    var body: some View {
        VStack {
            Text("Add \(ingredient.name) to:")
                .font(.system(size: 30))
                .padding(.top, 35)
            Picker("Tab", selection: $selectedTab) {
                ForEach(tabs, id: \.id) {
                    tab in
                    Text(tab.title)
                        .font(.title2)
                        .tag(tab.id)
                }
            }
            .padding(.vertical, -40)
            .pickerStyle(.wheel)
            
            Button {
                addIngredient(ingredient)
            } label: {
                HStack {
                    Text("Add")
                    Image(systemName: "plus")
                }
                .font(.title)
                .foregroundStyle(.white)
                
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.mint)
            }
            .buttonStyle(.plain)
        }
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
        .presentationBackground(.backgroundCream)
    }
}
