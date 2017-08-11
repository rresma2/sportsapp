//
//  String+Extensions.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/11/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

extension String {
    var isAlphanumeric: Bool {
        print(self)
        let range =  (self as NSString).rangeOfCharacter(from: CharacterSet.alphanumerics.inverted)
        return range.location == NSNotFound
    }
    
    func stripAndLower() -> String {
        return self.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
