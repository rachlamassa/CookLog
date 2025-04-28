//
//  CustomTabBar.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/27/25.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            CustomTabButton(selectedTab: $selectedTab, buttonImage: "house.lodge.fill", buttonText: "Home", tab: .home)
            CustomTabButton(selectedTab: $selectedTab, buttonImage: "fork.knife", buttonText: "This Week", tab: .thisWeek)
            CustomTabButton(selectedTab: $selectedTab, buttonImage: "carrot.fill", buttonText: "Groceries", tab: .groceries)
            CustomTabButton(selectedTab: $selectedTab, buttonImage: "person.fill", buttonText: "Profile", tab: .profile)
        }
        .background(Color("background_beige"))
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
