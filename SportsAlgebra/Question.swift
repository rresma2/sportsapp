//
//  Question.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 6/30/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

enum QuestionType: Int {
    case multipleChoice = 1
    case input = 2
    case numericInput = 3
    
    var isInput: Bool {
        return self == .numericInput || self == .input
    }
}

enum QuestionSubject: Int {
    case game = 1
    case player = 2
    case firstQuiz = 3
}

class Question {
    
    // MARK: Object Properties
    
    var text: String!
    var answers: [Answer]
    var correctAnswers: [Answer]?
    var isRequired: Bool
    var timeLimit: TimeInterval?
    var questionType: QuestionType
    var questionSubject: QuestionSubject
    
    // MARK: User Properties
    
    var userAnswers: [Answer]
    var timeToAnswer: TimeInterval? = nil
    var gameId: String?
    
    // MARK: Computer Properties
    
    var userInput: String? {
        get {
            return userAnswers.first?.text
        }
        set {
            guard let newValue = newValue else {
                return
            }
            
            if let firstAnswer = userAnswers.first {
                firstAnswer.text = newValue
            } else {
                let firstAnswer = Answer(text: newValue)
                userAnswers.append(firstAnswer)
            }
        }
    }
    
    var selectedAnswers: [Answer] {
        get {
            if !questionType.isInput {
                return answers.filter({ $0.isSelected })
            } else {
                return userAnswers
            }
        }
    }
    
    var correctAnswersDictionary: [String]? {
        guard let correctAnswers = correctAnswers else {
            return nil
        }
        return correctAnswers.flatMap({ $0.text })
    }
    
    // MARK: Init
    
    init(text: String, answers: [Answer],
         questionType: QuestionType, questionSubject: QuestionSubject,
         userAnswers: [Answer] = [], isRequired: Bool = true,
         timeLimit: TimeInterval? = 120.0) {
        self.text = text
        self.answers = answers
        self.questionType = questionType
        self.questionSubject = questionSubject
        self.userAnswers = userAnswers
        self.isRequired = isRequired
        self.timeLimit = timeLimit
    }
    
    init?(questionDTO: QuestionDTO) throws {
        self.text = questionDTO.text
        self.answers = try questionDTO.getAnswerList()
        
        if let questionType = QuestionType(rawValue: questionDTO.questionType.intValue) {
            self.questionType = questionType
        } else {
            throw QuestionDTOError.invalidQuestionType
        }
        
        if let questionSubject = QuestionSubject(rawValue: questionDTO.questionSubject.intValue) {
            self.questionSubject = questionSubject
        } else {
            throw QuestionDTOError.invalidQuestionSubject
        }
        
        self.gameId = questionDTO.gameId ?? nil
        self.userAnswers = []
        self.isRequired = questionDTO.isRequired.boolValue
        self.timeLimit = questionDTO.timeLimit?.doubleValue
        self.correctAnswers = questionDTO.getCorrectAnswerList()
    }
    
    // MARK: Helper Methods
    
    func answerFor(index: Int) -> Answer? {
        guard index < answers.count else {
            return nil
        }
        
        return answers[index]
    }
    
    func checkAnswers() -> Bool {
        var allCorrect = true
        for userAnswer in userAnswers {
            allCorrect = allCorrect && (correctAnswers?.contains(userAnswer) == true)
        }
        return allCorrect
    }
    
    var hasCorrectAnswer: Bool {
        return (correctAnswers?.count ?? 0) > 0
    }
}
