//
//  QuestionDTO.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/27/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum QuestionDTOError: Error {
    case invalidQuestionType
    case invalidQuestionSubject
    case invalidAnswerFormat
}

class QuestionDTO: PFObject {
    @NSManaged var text: String!
    @NSManaged var answers: [[String: String]]!
    @NSManaged var correctAnswers: [String]?
    @NSManaged var isRequired: NSNumber
    @NSManaged var timeLimit: NSNumber?
    @NSManaged var questionType: NSNumber
    @NSManaged var questionSubject: NSNumber
    @NSManaged var gameId: String!
    
    override init() {
        super.init()
    }
    
    init(question: Question) {
        super.init()
        
        self.text = question.text
        self.answers = question.answers.map({ $0.dictionary })
        self.correctAnswers = question.correctAnswersDictionary
        self.isRequired = NSNumber(booleanLiteral: question.isRequired)
        
        if let timeLimit = question.timeLimit {
            self.timeLimit = NSNumber(floatLiteral: timeLimit)
        }
        
        self.questionType = NSNumber(integerLiteral: question.questionType.rawValue)
        self.questionSubject = NSNumber(integerLiteral: question.questionSubject.rawValue)
        self.gameId = question.gameId
    }
    
    func getAnswerList() throws -> [Answer] {
        guard self.answers != nil else {
            return [Answer(text: "")]
        }
        
        var answerObjects = [Answer]()
        for answer in answers {
            let answerObject = Answer(text: "")
            if let text = answer["text"] {
                answerObject.text = text
            } else {
                throw QuestionDTOError.invalidAnswerFormat
            }
            
            if let label = answer["label"] {
                answerObject.label = label
            }
            
            answerObjects.append(answerObject)
        }
        
        return answerObjects
    }
    
    func getCorrectAnswerList() -> [Answer] {
        guard let answers = self.correctAnswers else {
            return []
        }
        return answers.map({ Answer(text: $0) })
    }
}

extension QuestionDTO: PFSubclassing {
    /**
     The name of the class as seen in the REST API.
     */
    static func parseClassName() -> String {
        return "Question"
    }
}
