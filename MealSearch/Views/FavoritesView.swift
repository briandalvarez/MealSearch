//
//  FavoritesView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        ZStack {
            Color("BackgroundCream")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                Text("No Favorites Saved")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 24)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray.opacity(0.7))
                
                Text("Let's get cooking!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    FavoritesView()
}
