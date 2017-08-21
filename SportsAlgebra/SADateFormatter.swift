//
//  SADateFormatter.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/18/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum MonthFormat: String {
    case full = "MMMM"
    case partial = "MMM"
}

class SADateFormatter {
    static let shared = SADateFormatter()
    var dateFormatter: DateFormatter
    
    init() {
        self.dateFormatter = DateFormatter()
    }
    
    func formatStringFor(monthFormat: MonthFormat, includeDay: Bool) -> String {
        if includeDay {
            return "\(monthFormat.rawValue) d, yyyy"
        } else {
            return "\(monthFormat.rawValue) yyyy"
        }
    }
    
    func dateStringFor(date: Date, monthFormat: MonthFormat, includeDay: Bool) -> String {
        self.dateFormatter.dateFormat = self.formatStringFor(monthFormat: monthFormat, includeDay: includeDay)
        return self.dateFormatter.string(from: date)
    }
}
