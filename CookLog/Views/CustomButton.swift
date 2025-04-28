//
//  CustomButton.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/28/25.
//

import SwiftUI

struct CustomButton: View {
    
    @Binding var selectedButton: String
    var buttonType: String

    var body: some View {
        Button {
            selectedButton = buttonType // tap to select THIS button
        } label: {
            Text(buttonType)
                .fontWeight(.bold)
                .foregroundStyle(selectedButton == buttonType ? Color("unpressed_button") : Color("button"))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(selectedButton == buttonType ? Color("button") : Color("unpressed_button"))
                    .clipShape(Capsule())
            }
            .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CustomButton(selectedButton: .constant("All"), buttonType: "All")
}
