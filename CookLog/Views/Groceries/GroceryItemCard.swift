//
//  GroceryItemCard.swift
//  CookLog
//

import SwiftUI
import SwiftData

struct GroceryItemCard: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var grocery: Groceries    // binding so the groceries check status can change
    @State private var isExpanded = false   // when card is expanded the ingredients amount appears

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                // checkbox button (tint depends on checked status)
                Button {
                    withAnimation {
                        grocery.isChecked.toggle()
                        if grocery.isChecked {
                            isExpanded = false
                        }
                    }
                } label: {
                    Image(systemName: grocery.isChecked ? "checkmark.square" : "square")
                        .foregroundStyle(Color("accent_text"))
                }

                // grocery name with strikethrough if it is checked
                Text(grocery.name)
                    .foregroundStyle(grocery.isChecked ? Color("accent_text") : Color("normal_text"))
                    .strikethrough(grocery.isChecked, color: Color("accent_text"))

                Spacer()

                // expand/collapse arrow
                if !grocery.isChecked {
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(Color("accent_text"))
                            .imageScale(.medium)
                    }
                    .buttonStyle(.plain)
                }
            }

            // expandable measurement list (only if not checked)
            if isExpanded && !grocery.isChecked {
                ForEach(grocery.amount.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }, id: \.self) { amt in
                    Text(amt)
                        .font(.subheadline)
                        .foregroundStyle(Color("accent_text"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
    }
}
