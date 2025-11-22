//
//  IngredientsView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct IngredientList: View {
    @Binding var list: IngredientListModel
    
//    let ingredientsSorted = ingredients.sorted {
//        by: $0.name < $1.name
//    }
    
    var body: some View {
        ZStack {
            Color("BackgroundCream")
                .ignoresSafeArea()
            
            if list.ingredients.count == 0 {
                Text("No ingredients saved")
            }
            else {
                List {
                    ForEach(list.ingredients) {
                        ingredient in
                        
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: ingredient.formattedImage)) {
                                result in
                                result.image?
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading){
                                Text(ingredient.name.capitalized)
                                    .font(.headline)
                                Text(ingredient.aisle)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "x.circle")
                                    .foregroundStyle(.primaryRed)
                                    .font(.title)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 10)
                        
                    }
                }
                .scrollContentBackground(.hidden)
            }
            
        }
    }
}

#Preview {
//    IngredientList()
}
