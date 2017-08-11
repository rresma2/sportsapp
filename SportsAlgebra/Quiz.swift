//
//  Quiz.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 6/30/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

class Quiz: PFObject {
    
    // MARK: Quiz Properties
    
    var questions: [Question]
    
    // MARK: Optimization
    
    var questionIds: [String]!
    var tokens: [String]!
    var isRequiredList: [Bool]!
    var timeLimits: [TimeInterval]!
    var questionTypes: [QuestionType]!
    
    // MARK: Computed Properties
    
    var questionResponses: [QuestionResponse] {
        return questions.map({ QuestionResponse(question: $0) })
    }
    
    // MARK: Init
    
    init(questions: [Question]) {
        self.questions = questions
        
        super.init()
    }
    
    func questionFor(index: Int) -> Question? {
        guard index < questions.count else {
            return nil
        }
        return questions[index]
    }
    
    func printResults() {
        for question in questions {
            SALog(question.userInput)
            SALog(question.userAnswers)
        }
    }
}

extension Quiz: PFSubclassing {
    /**
     The name of the class as seen in the REST API.
     */
    static func parseClassName() -> String {
        return "Quiz"
    }
}
