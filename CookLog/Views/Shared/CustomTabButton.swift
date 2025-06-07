//
//  CustomTabButton.swift
//  CookLog
//
//  tab button color is emphasized when active

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
                        .frame(width: 50, height: 25)
                    Text(buttonText)
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("selected_tab"))
                } else {
                    Image(systemName: buttonImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color("unselected_tab"))
                        .frame(width: 50, height: 25)
                    Text(buttonText)
                        .font(.system(size: 12))
                        .foregroundStyle(Color("unselected_tab"))
                }
                
                    
            }
            .frame(height: 50)
        }
        .padding(.horizontal)
    }
    
}
