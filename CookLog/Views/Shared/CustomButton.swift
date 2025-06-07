//
//  CustomButton.swift
//  CookLog
//
//  these buttons are for filtering

import SwiftUI

struct CustomButton: View {
    @Binding var selectedButtons: [String]
    let buttonType: String
    
    var isSelected: Bool {
        selectedButtons.contains(buttonType)
    }

    var body: some View {
        Button {
            if selectedButtons.contains(buttonType) {
                    selectedButtons.removeAll { $0 == buttonType }
                if selectedButtons.isEmpty {
                    selectedButtons = ["All"]
                }
            } else {
                if buttonType == "All" {
                    selectedButtons = ["All"]
                } else {
                    selectedButtons.removeAll { $0 == "All" }
                    selectedButtons.append(buttonType)
                }
            }
        } label: {
            Text(buttonType)
                .fontWeight(.semibold)
                .foregroundStyle(isSelected ? Color("unpressed_button") : Color("button"))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color("button") : Color("unpressed_button"))
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
