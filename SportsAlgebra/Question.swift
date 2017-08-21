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
    var serverId: String?
    
    // MARK: User Properties
    
    var userAnswers: [Answer]
    var timeToAnswer: TimeInterval? = nil
    var gameId: String?
    var gameTitle: String?
    var gameLocation: String?
    var gameDate: String?
    
    // MARK: Computer Properties
    
    func setUser(input: String) {
        if let firstAnswer = userAnswers.first {
            firstAnswer.text = input
        } else {
            let firstAnswer = Answer(text: input)
            userAnswers.append(firstAnswer)
        }
    }
    var userInput: String? {
        get {
            return userAnswers.first?.text
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
    
    var tokens: [String] {
        var result = [String]()
        if let text = text {
            result += text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        }
        
        for answerText in answers.flatMap({ $0 }).flatMap({ $0.text }) {
            result.append(answerText)
        }
        
        return result
    }
    
    var isCorrect: Bool {
        guard let correctAnswers = correctAnswers else {
            return true // No correct answers
        }
        
        for answer in self.userAnswers.map({ $0.text }) {
            var found = false
            for correctAnswer in correctAnswers.map({ $0.text }) {
                if answer == correctAnswer {
                    found = true
                }
            }
            
            if !found {
                return false
            }
        }
        return true
    }
    
    var quizTitle: String? {
        switch self.questionSubject {
        case .firstQuiz:
            return "My First Quiz"
        case .game:
            return self.gameTitle
        default:
            return nil
        }
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
    
    init(questionDTO: QuestionDTO) throws {
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
        self.gameDate = questionDTO.gameDate ?? nil
        self.gameLocation = questionDTO.gameLocation ?? nil
        self.gameDate = questionDTO.gameDate ?? nil
        self.gameTitle = questionDTO.gameTitle ?? nil
        
        self.userAnswers = []
        self.isRequired = questionDTO.isRequired.boolValue
        self.timeLimit = questionDTO.timeLimit?.doubleValue
        self.correctAnswers = questionDTO.getCorrectAnswerList()
        self.serverId = questionDTO.objectId
    }
    
    // MARK: Helper Methods
    
    func answerFor(index: Int) -> Answer? {
        guard index < answers.count else {
            return nil
        }
        
        return answers[index]
    }
    
    func userAnswerFor(index: Int) -> Answer? {
        guard index < userAnswers.count else {
            return nil
        }
        
        return userAnswers[index]
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
