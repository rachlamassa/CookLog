//
//  RecipeCard.swift
//  CookLog
//
// displays a summary of the recipe data

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe

    var body: some View {
        VStack(spacing: 0) {
            recipeImage
                .frame(height: 120)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(Color("normal_text"))
                Text(formattedCookTime(from: recipe.cookTime))
                    .font(.caption)
                    .foregroundColor(Color("accent_text"))
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 4)
        .padding(.horizontal, 5)
    }

    private var recipeImage: some View {
        Group {
            if let data = recipe.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("default")
                    .resizable()
                    .scaledToFill()
            }
        }
    }

    private func formattedCookTime(from time: String) -> String {
        time.isEmpty ? "No cook time" : time
    }
}
