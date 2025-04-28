//
//  CustomTabButton.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/27/25.
//

import SwiftUI

struct CustomTabButton: View {
    
    @Binding var selectedTab: Tab
    
    var buttonImage: String
    var buttonText: String
    var tab: Tab
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack (alignment: .center){
                
                if selectedTab == tab {
                    Image(systemName: buttonImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color("selected_tab"))
                    Text(buttonText)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("selected_tab"))
                } else {
                    Image(systemName: buttonImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color("unselected_tab"))
                    Text(buttonText)
                        .font(.system(size: 14))
                        .foregroundStyle(Color("unselected_tab"))
                }
                
                    
            }
            .frame(height: 50)
        }
        .padding(.horizontal)
    }
    
}

#Preview {
    CustomTabButton(selectedTab: .constant(.home), buttonImage: "house.lodge.fill", buttonText: "This Week", tab: .home)
}
