//
//  Date+Extensions.swift
//  CookLog
//

import Foundation

extension Calendar {
    
    // returns array of the current week dates
    func weekDates(for date: Date = Date()) -> [Date] {
        guard let weekInterval = self.dateInterval(of: .weekOfYear, for: date) else {
            return []
        }
        let startOfWeek = weekInterval.start
        // runs for each day of the week and adds a certain number of days to start of the week
        return (0..<7).compactMap { // guarantees 7 elements in the array
            self.date(byAdding: .day, value: $0, to: startOfWeek)   //
        }
    }
    
    // returns tuple of the start and end of the week
    func startEndOfWeek(for date: Date = Date()) -> (start: Date, end: Date)? {
        // gets the date interval (start and end) of the current week
        guard let weekInterval = self.dateInterval(of: .weekOfYear, for: date) else {
            return nil
        }
        // subtracts one second off of the last day
        return (start: weekInterval.start, end: weekInterval.end.addingTimeInterval(-1))
    }
    
    // converts date to formatted string, such as "Mon, Jun 3, 2025"
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
}
