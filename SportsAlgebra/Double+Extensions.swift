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
}
