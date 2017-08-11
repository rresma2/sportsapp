//
//  OnboardingViewModelTests.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/11/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import XCTest
@testable import SportsAlgebra

class OnboardingViewModelTests: XCTestCase {
    var sut: OnboardingViewModel!
    
    override func setUp() {
        super.setUp()
        
        sut = OnboardingViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Return User
    
    func testValidateReturnUserInformable_initWithMockInformableWithValidFields_returnsNil() {
        XCTAssertNil(sut.validate(informable: MockReturnUserInformable(username: "username123",
                                                                       password: "password123")))
    }
    
    func testValidateReturnUserInformable_initWithMockInformableWithInvalidUsername_returnsNotNil() {
        XCTAssertNotNil(sut.validate(informable: MockReturnUserInformable(username: "",
                                                                          password: "password")))
        XCTAssertNotNil(sut.validate(informable: MockReturnUserInformable(username: "---...",
                                                                          password: "password")))
    }
    
    func testValidateReturnUserInformable_initWithMockInformableWithInvalidPassword_returnsNotNil() {
        XCTAssertNotNil(sut.validate(informable: MockReturnUserInformable(username: "username",
                                                                          password: "")))
        XCTAssertNil(sut.validate(informable: MockReturnUserInformable(username: "username",
                                                                          password: "--asdf-")))
    }
    
    // New User
    
    func testValidateNewUserInformable_initWithMockInformableWithValidFields_returnsNotNil() {
        XCTAssertNil(sut.validate(informable: MockNewUserInformable(email: "leave@me.alone",
                                                                    username: "username123",
                                                                    password: "password123")).1)
    }
    
    func testValidateNewUserInformable_initWithMockInformableWithInvalidUsername_returnsNotNil() {
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "leave@me.alone",
                                                                       username: "",
                                                                       password: "password")))
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "leave@me.alone",
                                                                       username: "---...",
                                                                       password: "password")).1)
    }
    
    func testValidateNewUserInformable_initWithMockInformableWithInvalidPassword_returnsNotNil() {
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "leave@me.alone",
                                                                       username: "username",
                                                                       password: "")))
    }

    func testValidateNewUserInformable_initWithMockInformableWithInvalidEmail_returnsNotNil() {
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "",
                                                                       username: "username",
                                                                       password: "password")).1)
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: ".",
                                                                       username: "username",
                                                                       password: "password")).1)
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "@",
                                                                       username: "username",
                                                                       password: "password")).1)
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "@me.alone",
                                                                       username: "username",
                                                                       password: "password")).1)
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "leave@",
                                                                       username: "username",
                                                                       password: "password")))
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "leave@2@l.s",
                                                                       username: "username",
                                                                       password: "password")))
        XCTAssertNotNil(sut.validate(informable: MockNewUserInformable(email: "leave@2ls",
                                                                       username: "username",
                                                                       password: "password")))
    }
}

class MockReturnUserInformable: ReturnUserInformable {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

class MockNewUserInformable: NewUserInformable {
    var email: String
    var username: String
    var password: String
    
    init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
    }
}
