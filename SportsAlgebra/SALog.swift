//
//  SALog.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/11/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

func SALog<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + String(reflecting: value))
    #endif
}
