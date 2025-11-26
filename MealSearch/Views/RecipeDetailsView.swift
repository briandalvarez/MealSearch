//
//  RecipeDetailsView.swift
//  MealSearch
//
//  Created by Brian Alvarez on 11/18/25.
//

import SwiftUI

struct RecipeDetailsView: View {
    let recipeSummary: RecipeModel
    
    @Binding var isTabBarHidden: Bool
    @State private var selectedPage = 0
    @State private var isFavorite = false
    
    @State private var details: RecipeDetailsModel = MockRecipeDetails.sample
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
                Text(details.title.isEmpty ? recipeSummary.title : details.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isFavorite.toggle()
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
            await loadDetails()
        }
    }
    

    
    private var overviewPage: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                AsyncImage(url: URL(string: details.image ?? "")) { phase in
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
                
                Text(details.title.isEmpty ? recipeSummary.title: details.title)
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
                
                if let healthScore = details.healthScore {
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
                
                if let summaryHTML = details.summary, !summaryHTML.isEmpty {
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
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                
                if !details.extendedIngredients.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(details.extendedIngredients) { ingredient in
                            HStack(alignment: .center, spacing: 16) {
                                
                                Text(ingredient.original.isEmpty ? ingredient.name : ingredient.original)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 14)
                                
                                // Placeholder for toggle buttons that will update ingredient count in My Pantry and Shopping List
                                Button {
                                    // Toggle logic will go here
                                } label: {
                                    Image(systemName: "circle")
                                        .font(.system(size: 40, weight: .regular))
                                        .foregroundColor(.red)
                                }
                                .frame(width: 54, height: 54, alignment: .center) 
                                .contentShape(Rectangle())
                            }
                            
                            Divider()
                        }
                    }
                } else  {
                    Text("No ingredient list available.")
                        .font(.body)
                        .foregroundColor(.gray.opacity(0.7))
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
                
                if !details.instructions.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(details.instructions.indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color(.secondaryPink).opacity(0.1))
                                        .frame(width: 24, height: 24)
                                    
                                    Text("\(index + 1)")
                                        .bold()
                                        .foregroundColor(.primaryRed)
                                }
                                Text(details.instructions[index])
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                } else {
                    Text("No instructions available.")
                        .foregroundColor(.gray.opacity(0.7))
                }
                
                Spacer(minLength: 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    private func loadDetails() async {
        isLoading = true
        errorMessage = nil
        
        let id = recipeSummary.id
        
        let fetchedDetails = await APIHandler.shared.fetchRecipeDetails(id: id)
        
        if let fetchedDetails = fetchedDetails {
            details = fetchedDetails
        } else {
            errorMessage = "Failed to load recipe details."
        }
        isLoading = false
    }
    
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
    }
}
