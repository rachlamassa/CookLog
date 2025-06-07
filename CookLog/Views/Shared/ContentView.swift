//
//  ContentView.swift
//  CookLog
//
//  selected tab shows respective view

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Tab = .home

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .thisWeek:
                        ThisWeekView()
                    case .groceries:
                        GroceriesView()
                    }
                }
                CustomTabBar(selectedTab: $selectedTab)
            }
            .background(Color("background_beige"))
        }
    }
}

// tab types
enum Tab {
    case home
    case thisWeek
    case groceries
}
