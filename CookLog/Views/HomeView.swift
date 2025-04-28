//
//  HomeView.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/27/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var recipeName: String = ""
    @State private var selectedButton: String = "All"
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Text("Your Recipes")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 8)
                        .foregroundColor(Color("normal_text"))
                    TextField("Search recipes...", text: $recipeName, prompt: Text("Search recipes...").foregroundColor(Color("accent_text")))
                        .padding([.top, .bottom], 10.0)
                        .background(.white)
                }
                .background(.white)
                .cornerRadius(10.0)
                ScrollView(.horizontal) {
                    HStack (spacing: 15){
                        CustomButton(selectedButton: $selectedButton, buttonType: "All")
                        CustomButton(selectedButton: $selectedButton, buttonType: "Breakfast")
                        CustomButton(selectedButton: $selectedButton, buttonType: "Lunch")
                        CustomButton(selectedButton: $selectedButton, buttonType: "Dinner")
                        CustomButton(selectedButton: $selectedButton, buttonType: "Snack")
                    }
                    .padding(.bottom, 15.0)
                }
                Spacer()
                AddRecipeButton()
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
