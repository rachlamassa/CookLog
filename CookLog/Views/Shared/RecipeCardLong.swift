//
//  RecipeCardLong.swift
//  CookLog
//
// displays a summary of the recipe data in a longer view

import SwiftUI

struct RecipeCardLong: View {
    var recipe: Recipe

    var body: some View {
        HStack(spacing: 10) {
            recipeImage
                .frame(width: 100, height: 60)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("normal_text"))

                Text(formattedCookTime(from: recipe.cookTime))
                    .font(.caption)
                    .foregroundColor(Color("accent_text"))
            }

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
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
