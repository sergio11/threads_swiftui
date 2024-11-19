//
//  Timestamp.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 6/8/24.
//

import Foundation

extension Date {
    func timestampString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self, to: Date()) ?? ""
    }
    
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: self, to: now)

        if let year = components.year, year >= 1 {
            return "\(year)y ago"
        }
        if let month = components.month, month >= 1 {
            return "\(month)m ago"
        }
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)w ago"
        }
        if let day = components.day, day >= 1 {
            return "\(day)d ago"
        }
        if let hour = components.hour, hour >= 1 {
            return "\(hour)h ago"
        }
        if let minute = components.minute, minute >= 1 {
            return "\(minute) minute\(minute > 1 ? "s" : "") ago"
        }
        return "Just now"
    }
}
