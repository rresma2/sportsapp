//
//  SAThemeService.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 6/30/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    case tiny = 8.0
    case secondary = 12.0
    case primary = 16.0
    case header = 24.0
    case title = 32.0
    case large = 48.0
}

class SAThemeService {
    static let primaryThemeColorKey = "primaryThemeColor"
    static let secondaryThemeColorKey = "secondaryThemeColor"
    static let primaryFontKey = "primaryFont"
    static let mediumFontKey = "mediumFont"
    static let boldFontKey = "boldFont"
    static let lightGrayKey = "lightGray"
    static let blackRedKey = "blackRed"
    
    static let shared = SAThemeService()
    var info: [String: AnyObject]!
    
    init() {
        if let bundle = Bundle.main.path(forResource: "Theme", ofType: "plist"),
            let info = NSDictionary(contentsOfFile: bundle) as? [String: AnyObject] {
            self.info = info
        }
    }
    
    func primaryThemeColor() -> UIColor {
        return UIColor.colorFrom(hex: info[SAThemeService.primaryThemeColorKey] as! String)
    }
    
    func secondaryThemeColor() -> UIColor {
        return UIColor.colorFrom(hex: info[SAThemeService.secondaryThemeColorKey] as! String)
    }
    
    func primaryFont(size: FontSize) -> UIFont {
        return UIFont(name: info[SAThemeService.primaryFontKey] as! String, size: size.rawValue)!
    }
    
    func lightGray() -> UIColor {
        return UIColor.colorFrom(hex: info[SAThemeService.lightGrayKey] as! String)
    }
    
    func mediumFont(size: FontSize) -> UIFont {
        return UIFont(name: info[SAThemeService.mediumFontKey] as! String, size: size.rawValue)!
    }
    
    func boldFont(size: FontSize) -> UIFont {
        return UIFont(name: info[SAThemeService.boldFontKey] as! String, size: size.rawValue)!
    }
    
    func blackRed() -> UIColor {
        return UIColor.colorFrom(hex: info[SAThemeService.blackRedKey] as! String)
    }
}
