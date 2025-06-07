//
//  AddRecipeButton.swift
//  CookLog
//
//  custom add recipe button that executes whatever functionality is passed upon call

import SwiftUI

struct AddRecipeButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("+ Add Recipe")
                .fontWeight(.semibold)
                .foregroundStyle(Color("unpressed_button"))
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color("button"))
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
