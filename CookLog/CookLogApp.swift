//
//  CookLogApp.swift
//  CookLog
//
//  Created by Rachael LaMassa on 4/26/25.
//

import SwiftUI
import SwiftData

@main
struct CookLogApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Recipe.self, WeeklyMeals.self, Groceries.self])
        }
    }
}
