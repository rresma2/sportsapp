//
//  DoubleExtensionsTests.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import XCTest
@testable import SportsAlgebra

class DoubleExtensionsTests: XCTestCase {
    
    func testStringByRoundingNumberOfPlaces_initWith5PointOneOneOnePassingIn1_returnsFivePointOne() {
        XCTAssertEqual("5.1", 5.111.stringByRoundingBy(numberOfPlaces: 1))
    }
    
    func testStringByRoundingNumberOfPlaces_initWith5PointOneOneOnePassingIn0_returnsOriginalValue() {
        XCTAssertEqual("5.111", 5.111.stringByRoundingBy(numberOfPlaces: 0))
    }
    
    func testStringByRoundingNumberOfPlaces_initWith5PointOneOneOneOnePassingIn0_returnsOriginalValueWithTrailingZeros() {
        XCTAssertEqual("5.11110", 5.1111.stringByRoundingBy(numberOfPlaces: 5))
    }
    
}
