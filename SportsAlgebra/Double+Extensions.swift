//
//  Double+Extensions.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

extension Double {
    func stringByRoundingBy(numberOfPlaces i: Int) -> String {
        return i >= 0 ? String(format: "%.\(i)f", self) : "\(self)"
    }
    
    var timeString: String {
        if self < 1 { // (-Inf, 0]
            return "< 1 sec"
        } else if self > 120 { // (120, Inf)
            return "> 2 min"
        } else if self < 60 { // (0, 60)
            return "\(Int(self)) sec"
        } else { // [60, 120]
            let minutes = Int(self / 60)
            let seconds = Int(self) - minutes * 60
            return "\(minutes) min \(seconds) sec"
        }
    }
}
