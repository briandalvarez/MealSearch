//
//  RecipeDetailsView.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/18/25.
//

import SwiftUI
import SwiftData

struct RecipeDetailsView: View {
    @Environment(\.modelContext) private var context
    @Query private var recipeStore: [RecipeStore]
    
    @EnvironmentObject var favoriteStore: FavoriteStore
    
    let recipeSummary: RecipeModel
    
    @Binding var isTabBarHidden: Bool
    @State private var selectedPage = 0
    
    var isFavorite: Bool {
        favoriteStore.contains(recipeSummary)
    }
    
//    @State private var details: RecipeDetailsModel = MockRecipeDetails.sample
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading recipe...")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 140)
            } else if let errorMessage = errorMessage {
                VStack(spacing: 12) {
                    Text("Something went wrong")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(errorMessage)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 140)
            } else {
                TabView(selection: $selectedPage) {
                    overviewPage
                        .tag(0)
                    
                    ingredientsPage
                        .tag(1)
                    
                    instructionsPage
                        .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(recipeSummary.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    favoriteStore.toggle(recipeSummary, recipeStore: recipeStore[0], context: context)
                } label: {
                    Image(systemName: isFavorite ? "star.circle.fill" : "star.circle")
                        .font(.system(size: 25, weight: .light))
                        .foregroundColor(isFavorite ? .starYellow : .white)
                        .opacity(1.0)
                }
            }
        }
        .toolbarBackground(Color(.primaryRed), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            isTabBarHidden = true
        }
        .onDisappear {
            isTabBarHidden = false
        }
        .task {
//            await loadDetails()
        }
    }
    

    
    private var overviewPage: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                AsyncImage(url: URL(string: recipeSummary.image ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        placeholder
                    }
                }
                .frame(height: 220)
                .clipped()
                .cornerRadius(16)
                
                Text(recipeSummary.title)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text("\(recipeSummary.readyInMinutes ?? 0) min")
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                        let servings = recipeSummary.servings ?? 0
                        Text("\(servings) " + (servings == 1 ? "serving" : "servings"))
                    }
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                if let healthScore = recipeSummary.healthScore {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Health score: \(Int(healthScore.rounded()))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ProgressView(value: healthScore, total: 100)
                            .progressViewStyle(.linear)
                            .tint(healthBarColor(for:healthScore))
                            .frame(width: 200, height: 8)
                    }
                }
                
                if let summaryHTML = recipeSummary.summary, !summaryHTML.isEmpty {
                    Text(
                        summaryHTML
                            .replacingOccurrences(of: "<[^>]+>",
                                                  with: "",
                                                  options: .regularExpression)
                    )
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                } else {
                    Text("No description available for this recipe.")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    private var ingredientsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Ingredients")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 12)
                
                if !recipeSummary.extendedIngredients.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(recipeSummary.extendedIngredients.indices, id: \.self) { index in
                            let ingredient = recipeSummary.extendedIngredients[index]
                            HStack(alignment: .center, spacing: 16) {
                                
                                Text(ingredient.original.isEmpty ? ingredient.name : ingredient.original)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 14)
                            }
                            
                            Divider()
                        }
                    }
                    IngredientWheelView(matchFraction: recipeSummary.matchRatio, showsLabel: true, lineWidth: 12)
                        .frame(width: 140, height: 140)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                } else  {
                    Text("No ingredient list available for this recipe.")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 140)
                }
                
                Spacer(minLength: 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }

    
    private var instructionsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Instructions")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 12)
                
                if !recipeSummary.analyzedInstructions.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // Lists re-sorted due to SwiftData not preserving order
                        ForEach(
                            recipeSummary.analyzedInstructions.sorted(by: {
                                ($0.steps.first?.number ?? 0) < ($1.steps.first?.number ?? 0)
                            }),
                            id: \.self
                        ) {
                            instruction in
                            
                            Text(instruction.name ?? "")
                            
                            ForEach(
                                instruction.steps.sorted(by: { $0.number < $1.number }),
                                id: \.self
                            ) {
                                step in
                                
                                HStack(alignment: .top, spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.secondaryPink).opacity(0.1))
                                            .frame(width: 24, height: 24)
                                        
                                        Text("\(step.number)")
                                            .bold()
                                            .foregroundColor(.primaryRed)
                                    }
                                    Text(step.step)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                } else {
                    Text("No instructions available for this recipe.")
                        .foregroundColor(.gray.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 140)
                }
                
                Spacer(minLength: 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
//    private func loadDetails() async {
//        isLoading = true
//        errorMessage = nil
//
//        let id = recipeSummary.id
//
//        let fetchedDetails = await APIHandler.shared.fetchRecipeDetails(id: id)
//
//        if let fetchedDetails = fetchedDetails {
//            details = fetchedDetails
//        } else {
//            errorMessage = "Failed to load recipe details."
//        }
//        isLoading = false
//    }
    
    // Helper function for image placeholder for when a recipe does not have an image
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.15))
            
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.6))
        }
    }
}
    
    // Helper function for health score bar colors
private func healthBarColor(for healthScore: Double) -> Color {
    switch healthScore {
    case ..<40: return .red
    case 40..<70: return .yellow
    default: return .green
    }
}


#Preview {
    NavigationStack {
        RecipeDetailsView(
            recipeSummary: MockRecipes.all.first!,
            isTabBarHidden: .constant(false)
        )
        .environmentObject(FavoriteStore())
    }
}
