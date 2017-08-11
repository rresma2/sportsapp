//
//  QuestionDTOTests.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/8/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import XCTest
@testable import SportsAlgebra

class QuestionDTOTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuestionDTOInitialization_initWithParseCall_correctlyInitializesObject() {
        let expectation = self.expectation(description: "Expecting questions to be found online")
        let query = PFQuery(className: "Question")
        query.findObjectsInBackground { (objects, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(objects)
            XCTAssertGreaterThan(objects!.count, 0)
            
            let dto = objects![0] as! QuestionDTO
            do {
                let _ = try Question(questionDTO: dto)
                XCTAssert(true)
                expectation.fulfill()
            } catch {
                XCTAssert(false, "Expected question to be initialized successfully...")
            }
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testQuestionDTOFirstQuiz_initWithParseCall_correctlyFindsFirstQuizQuestions() {
        let expectation = self.expectation(description: "Expecting questions to be found online")
        
        let quiz = FirstQuizGenerator.firstQuiz
        let query = PFQuery(className: "Question")
        query.whereKey("questionSubject", equalTo: QuestionSubject.firstQuiz.rawValue)
        query.order(byAscending: "createdAt")
        query.findObjectsInBackground { (objects, error) in
            XCTAssertNotNil(objects)
            XCTAssertNil(error)
            XCTAssertEqual(objects!.count, 4)
            
            for (i, object) in objects!.enumerated() {
                let observedQuestion = try! Question(questionDTO: object as! QuestionDTO)!
                let expectedQuestion = quiz.questions[i]
                XCTAssertEqual(expectedQuestion.text, observedQuestion.text)
                XCTAssertEqual(expectedQuestion.answers, observedQuestion.answers)
                XCTAssertEqual(expectedQuestion.questionSubject, observedQuestion.questionSubject)
                XCTAssertEqual(expectedQuestion.questionType, observedQuestion.questionType)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 50.0, handler: nil)
    }
    
}
