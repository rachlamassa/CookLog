//
//  CustomTabBar.swift
//  CookLog
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            Spacer()
            CustomTabButton(selectedTab: $selectedTab, buttonImage: "house.lodge.fill", buttonText: "Home", tab: .home)
            Spacer()
            CustomTabButton(selectedTab: $selectedTab, buttonImage: "fork.knife", buttonText: "This Week", tab: .thisWeek)
            Spacer()
            CustomTabButton(selectedTab: $selectedTab, buttonImage: "carrot.fill", buttonText: "Groceries", tab: .groceries)
            Spacer()
        }
        .background(Color("background_beige"))
    }
}
