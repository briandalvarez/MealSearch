//
//  IngredientWheelView.swift
//  MealSearch
//

import SwiftUI

struct IngredientWheelView: View {
    // Variable with value 0.0 to 1.0 representing fraction of ingredients that match a recipe
    let matchFraction: Double
    
    // Text is shown in version under list of ingredients but not on recipe card
    var showsLabel: Bool = true
    
    var lineWidth: CGFloat = 14
    
    private var percentageText: String {
        let percent = Int((matchFraction * 100).rounded())
        return "\(percent)%"
        
    }
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.wheelRed), lineWidth: lineWidth)
            Circle()
                .trim(from: 0.0, to: max(0.0, min(matchFraction, 1.0)))
                .stroke(
                    Color(.wheelGreen),
                    style: StrokeStyle(lineWidth: lineWidth)
                )
                .rotationEffect(.degrees(-90))
            if showsLabel {
                VStack(spacing: 2) {
                    Text(percentageText)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text("match")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
            // Big labeled version
            IngredientWheelView(matchFraction: 0.92)
                .frame(width: 140, height: 140)
            
            // Small recipe card version
            IngredientWheelView(matchFraction: 0.82,
                                 showsLabel: false,
                                 lineWidth: 8)
                .frame(width: 36, height: 36)
        }
        .padding()
}
