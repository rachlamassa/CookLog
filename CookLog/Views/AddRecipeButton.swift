//
//  AddRecipeButton.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/28/25.
//

import SwiftUI

struct AddRecipeButton: View {
    var body: some View {
        Button {
            print("Add Recipe")
        } label: {
            Text("+ Add Recipe")
                .fontWeight(.bold)
                .foregroundStyle(Color("unpressed_button"))
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
                .background(Color("button"))
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    AddRecipeButton()
}
