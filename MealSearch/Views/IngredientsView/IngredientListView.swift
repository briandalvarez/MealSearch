import SwiftUI
import SwiftData

// Displays user's pantry or shopping list with options to switch/delete ingredients

struct IngredientList: View {
    // For saving changes (adding/deleting/moving ingredients)
    @Environment(\.modelContext) private var context
    // Access to recipe store for clearing cache of previously fetched recipes
    // This forces SearchView to load new results based on updated pantry ingredients
    @Query private var recipeStore: [RecipeStore]
    
    // The ingredient list to display (My Pantry or Shopping List)
    var list: IngredientListModel
    // A shared store that gives access to all ingredient tabs and lsits
    // Used here to switch ingredients between lists
    @EnvironmentObject var tabStore: IngredientTabStore

    @State private var deletePrompt: Bool = false // shows delete confirmation alert
    @State private var switchPrompt: Bool = false // shows ingredient switch sheet
    @State private var ingredientToSwitch: IngredientModel? = nil // ingredient switched between list
    @State private var ingredientToDelete: IngredientModel? = nil // ingredient being deleted
    
    var body: some View {
        ZStack {
            Color("BackgroundCream")
                .ignoresSafeArea()
            // For empty state when list has no ingredients
            if list.ingredients.isEmpty {
                Text("No ingredients saved")
            } else {
                // Otherwise show all ingredients in a List
                List {
                    // Show image, name, aisle, and action buttons for each ingredient
                    ForEach(list.ingredients) { ingredient in
                        HStack(spacing: 20) {
                            // Ingredient thumnbail loaded from spoonacular
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
                            
                            // Buttons for switching and deleting
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
                // Use BackgroundCream instead of default list color
                .scrollContentBackground(.hidden)
                
                // Delete confirmation alert
                .alert("Confirm?", isPresented: $deletePrompt) {
                    Button("Confirm") {
                        if let ingredient = ingredientToDelete {
                            // Remove ingredient from the list
                            list.removeIngredient(ingredient)
                            ingredientToDelete = nil
                            
                            // If adding to pantry, clear fetched recipes so SearchView can fetch again
                            if list.id == 0 {
                                recipeStore[0].setFetchedRecipes(recipes: [], context: context)
                            }
                        }
                    }
                    // Closes the alert and keeps everything as is
                    Button("Cancel") {}
                    // Shows which ingredient to will be removed
                } message: {
                    Text("Remove \(ingredientToDelete?.name ?? "") from list?")
                }
                // Shows picker to move ingredient to different list or remove entirely
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
