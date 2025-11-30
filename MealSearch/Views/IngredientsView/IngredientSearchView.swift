//
//  IngredientSearchView.swift
//  MealSearch
//
//  Created by csuftitan on 11/20/25.
//

import Foundation
import SwiftUI
import SwiftData

struct SearchBar: View {
    @EnvironmentObject var tabStore: IngredientTabStore
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
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.backgroundCream)
            }
            .sheet(isPresented: $showingPopover) {
                SearchPopover(showingPopover: $showingPopover)
            }
        }
        .zIndex(1)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 30)
    }
}

struct SearchPopover: View {
    @EnvironmentObject var tabStore: IngredientTabStore
    @Binding var showingPopover: Bool
    @State private var showingAdvancedSearch: Bool = false
    @State private var selectedIngredient: IngredientModel?
    @State private var selectedTab: Int = -1
    @State private var searchQuery: String = ""
        
    @State private var defaultIngredients: [IngredientModel] = MockIngredients.pantry
    @State private var filteredIngredients: [IngredientModel] = MockIngredients.pantry
    
    let spoonacularAPI = APIHandler.shared
    @State private var isLoading = false
    
    func filterIngredients() {
        filteredIngredients = defaultIngredients.filter {
            $0.name.lowercased().contains(searchQuery.lowercased())
        }
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
            
            // Actual search bar
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.title)
                TextField(text: $searchQuery) {
                    Text("Type ingredient here")
                        .foregroundStyle(.white)
                }
                .onChange(of: searchQuery, initial: false) {
                    oldVal, newVal in
                    if newVal.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                        filteredIngredients = defaultIngredients
                        showingAdvancedSearch = false
                    } else {
                        filterIngredients()
                        showingAdvancedSearch = true
                    }
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.leading, 10)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.primaryRed)
            }
            .shadow(color: .black.opacity(0.4), radius: 4, y: 2)
            .padding(.horizontal, 10)
            .padding(.bottom, 30)
            
            // Advanced search (calls spoonacular API for ingredients)
            if (showingAdvancedSearch) {
                Button {
                    isLoading = true
                    Task {
                        filteredIngredients = await spoonacularAPI.fetchIngredients(of: searchQuery)
                        isLoading = false
                    }
                } label: {
                    HStack {
                        VStack {
                            Text("Couldn't find your ingredient?")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            Text("Tap here to see more suggestions \n based on your search")
                                .font(.caption)
                                .foregroundStyle(Color(red: 0.827, green: 0.827, blue: 0.827))
                                .underline()
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "moon.stars.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .scaleEffect(1.2)
                    }
                    .padding(.horizontal, 10)
                }
                .disabled(isLoading)
                .buttonStyle(.plain)
                .padding(.vertical, 20)
                .padding(.horizontal, 10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.primaryRed)
                }
                .foregroundStyle(.white)
                
            }
            
            
            VStack {
                if !showingAdvancedSearch {
                    Text("Here are some suggestions:")
                }
                
                if isLoading {
                    ProgressView()
                        .padding(50)
                        .controlSize(.large)
                }
                
                List {
                    ForEach($filteredIngredients, id: \.id) {
                        ingredient in
                        
                        let ingredientFoundAt = tabStore.ingredientExistsAt(ingredientName: ingredient.wrappedValue.name)
                        
                        HStack {
                            Text(ingredient.wrappedValue.name.capitalized)
                            Spacer()
                            Button {
                                selectedIngredient = ingredient.wrappedValue
                            } label: {
                                Image(systemName: ingredientFoundAt > -1
                                      ? tabStore.tabs[ingredientFoundAt].icon
                                      : "plus.app")
                                .foregroundStyle(.green)
                                .font(.title)
                                .overlay(
                                    ZStack {
                                        if ingredientFoundAt > -1 {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                        .offset(x: -30)
                                        .foregroundStyle(.green)
                                )
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
                .listStyle(.plain)
                .padding(.top, 20)
            }
            
        }
        .padding(.horizontal, 20)
        .background(.backgroundCream)
        .sheet(item: $selectedIngredient) {
            ingredient in
            SearchPopoverSelection(
                ingredient: ingredient,
                foundAt: tabStore.ingredientExistsAt(ingredientName: ingredient.name)
            )
        }
    }
}

struct SearchPopoverSelection: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \IngredientListModel.id) private var lists: [IngredientListModel]
    @Query private var recipeStore: [RecipeStore]
    
    @EnvironmentObject var tabStore: IngredientTabStore
    @State private var selectedTab: Int = 0
    @Environment(\.dismiss) private var closeSelection
    
    let ingredient: IngredientModel
    let foundAt: Int
    
    var sortedLists: [IngredientListModel] {
        lists.sorted { $0.id < $1.id }
    }
    
    func addOrMoveIngredient(_ ingredient: IngredientModel) {
        // Remove ingredient if found
        if foundAt > -1 {
            let list = lists[foundAt]
            list.removeIngredient(ingredient)
        }

        // Add ingredient to valid tab
        if selectedTab != -1 {
            let list = lists[selectedTab]
            list.addIngredient(ingredient)
        }
        
        // If adding to pantry, clear fetched recipes so SearchView can fetch again
        if selectedTab == 0 {
            recipeStore[0].setFetchedRecipes(recipes: [], context: context)
        }
        
        do { try context.save() }
        catch { print("Save error:", error) }
    }

    var body: some View {
        VStack {
            let addOrMove = foundAt > -1 ? "Move" : "Add"
            Text("\(addOrMove) \(ingredient.name) to:")
                .font(.system(size: 30))
                .padding(.top, 35)
            Picker("Tab", selection: $selectedTab) {
                Text("Remove from list")
                    .font(.title2)
                    .foregroundStyle(.primaryRed)
                    .tag(-1)
                ForEach(tabStore.tabs, id: \.id) {
                    tab in
                    Text(tab.title)
                        .font(.title2)
                        .tag(tab.id)
                }
            }
            .padding(.vertical, -40)
            .pickerStyle(.wheel)
            
            Button {
                addOrMoveIngredient(ingredient)
                closeSelection()
            } label: {
                HStack {
                    Text("Confirm")
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
