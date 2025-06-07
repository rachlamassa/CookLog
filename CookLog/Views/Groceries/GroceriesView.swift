//
//  GroceriesView.swift
//  CookLog
//

import SwiftUI
import SwiftData

struct GroceriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var dailyMeals: [WeeklyMeals]    // for ingredient amount
    @Query var groceries: [Groceries]
    @State private var viewModel = GroceriesViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // header
            HStack {
                Image(systemName: "carrot.fill")
                Text("Groceries")
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(Color("normal_text"))
            
            // date Range
            if let week = Calendar.current.startEndOfWeek() {
                Text("\(Calendar.current.formatDate(week.start)) – \(Calendar.current.formatDate(week.end))")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("normal_text"))
            }

            // grocery List
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if !groceries.isEmpty {
                        ForEach(groceries) { item in
                            GroceryItemCard(grocery: item)
                        }
                    } else {
                        Text("Schedule meals in your week to start your grocery list!")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(Color("accent_text"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .onAppear {
            // should update groceries if recipe in weekly plan is taken off, edited, or deleted
            viewModel.updateGroceries(from: dailyMeals, groceries: groceries, context: modelContext)
        }
    }
}
