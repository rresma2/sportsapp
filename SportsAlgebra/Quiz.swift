//
//  Quiz.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 6/30/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

class Quiz {
    
    // MARK: Quiz Properties
    
    var questions: [Question]
    var serverId: String?
    var createdAt: Date?
    var title: String?
    
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
    
    var numberCorrect: Int {
        var count = 0
        for question in questions {
            if question.isCorrect {
                count += 1
            }
        }
        return count
    }
    
    // MARK: Init
    
    init(questions: [Question]) {
        self.questions = questions
        self.title = questions.first?.quizTitle
    }
    
    init(quizDTO: QuizDTO) throws {
        self.questions = try quizDTO.questions.flatMap({ ($0 as? QuestionDTO) }).map({ try Question(questionDTO: $0) })
        self.createdAt = quizDTO.createdAt
        self.title = self.questions.first?.quizTitle
        self.serverId = quizDTO.objectId
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
