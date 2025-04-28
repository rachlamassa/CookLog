//
//  ContentView.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab: Tab = .home
    
    var body: some View {
        VStack {
            switch selectedTab {
                case .home:
                    HomeView()
                case .thisWeek:
                    HomeView()
                case .groceries:
                    HomeView()
                case .profile:
                    ProfileView()
            }
            CustomTabBar(selectedTab: $selectedTab)
        }
        .background(Color("background_beige"))
    }
}

enum Tab {
    case home
    case thisWeek
    case groceries
    case profile
}

#Preview {
    ContentView()
}
