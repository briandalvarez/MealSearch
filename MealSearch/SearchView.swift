//
//  SearchView.swift
//  MealSearch
//
//  Created by br-zee on 11/12/25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ZStack {
            Color("BackgroundCream")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                Text("No Recipes Found")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 24)
                
                Image(systemName: "exclamationmark.magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
    }
}

#Preview {
    SearchView()
}
