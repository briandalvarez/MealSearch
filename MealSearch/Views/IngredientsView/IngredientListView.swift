import SwiftUI
import SwiftData

struct IngredientList: View {
    @Environment(\.modelContext) private var context
    @Query private var recipeStore: [RecipeStore]
    
    var list: IngredientListModel
    @EnvironmentObject var tabStore: IngredientTabStore

    @State private var deletePrompt: Bool = false
    @State private var switchPrompt: Bool = false
    @State private var ingredientToSwitch: IngredientModel? = nil
    @State private var ingredientToDelete: IngredientModel? = nil
    
    var body: some View {
        ZStack {
            Color("BackgroundCream")
                .ignoresSafeArea()
            
            if list.ingredients.isEmpty {
                Text("No ingredients saved")
            } else {
                List {
                    ForEach(list.ingredients) { ingredient in
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: ingredient.formattedImage)) { result in
                                result.image?
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(ingredient.name.capitalized)
                                    .font(.headline)
                                Text(ingredient.aisle ?? "Other")
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            HStack {
                                Button {
                                    ingredientToSwitch = ingredient
                                    switchPrompt = true
                                } label: {
                                    Image(systemName: "arrow.left.arrow.right.circle")
                                        .foregroundStyle(.yellow)
                                }
                                
                                Button {
                                    ingredientToDelete = ingredient
                                    deletePrompt = true
                                } label: {
                                    Image(systemName: "x.circle")
                                        .foregroundStyle(.primaryRed)
                                }
                            }
                            .buttonStyle(.plain)
                            .font(.title)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .scrollContentBackground(.hidden)
                .alert("Confirm?", isPresented: $deletePrompt) {
                    Button("Confirm") {
                        if let ingredient = ingredientToDelete {
                            list.removeIngredient(ingredient)
                            ingredientToDelete = nil
                            
                            // If adding to pantry, clear fetched recipes so SearchView can fetch again
                            if list.id == 0 {
                                recipeStore[0].setFetchedRecipes(recipes: [], context: context)
                            }
                        }
                    }
                    Button("Cancel") {}
                } message: {
                    Text("Remove \(ingredientToDelete?.name ?? "") from list?")
                }
                .sheet(item: $ingredientToSwitch) {
                    ingredient in
                    SearchPopoverSelection(
                        ingredient: ingredient,
                        foundAt: tabStore.ingredientExistsAt(ingredientName: ingredient.name)
                    )
                }
            }
        }
    }
}
