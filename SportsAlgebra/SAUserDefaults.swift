//
//  SAUserDefaults.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/9/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum SAUserDefaultsKey: String {
    case isLoggedIn = "isLoggedIn"
}

class SAUserDefaults {
    static let sharedInstance = SAUserDefaults()
    let userDefaults = UserDefaults.standard
    
    func intFor(key: SAUserDefaultsKey) -> Int? {
        return userDefaults.integer(forKey: key.rawValue)
    }
    
    func set(int: Int, for key: SAUserDefaultsKey) {
        userDefaults.set(int, forKey: key.rawValue)
    }
    
    func stringFor(key: SAUserDefaultsKey) -> String? {
        return userDefaults.string(forKey: key.rawValue)
    }
    
    func set(string: String, for key: SAUserDefaultsKey) {
        userDefaults.set(string, forKey: key.rawValue)
    }
    
    func boolFor(key: SAUserDefaultsKey) -> Bool? {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    func set(bool: Bool, for key: SAUserDefaultsKey) {
        userDefaults.set(bool, forKey: key.rawValue)
    }
    
    func objectFor(key: SAUserDefaultsKey) -> AnyObject? {
        return userDefaults.object(forKey: key.rawValue) as AnyObject
    }
    
    func set(object: Any, for key: SAUserDefaultsKey) {
        userDefaults.set(object, forKey: key.rawValue)
    }
}
