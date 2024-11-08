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
}
