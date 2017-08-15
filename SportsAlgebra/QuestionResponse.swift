//
//  QuestionResponse.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/27/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum QuestionResponseKey {
    static let timeToAnswer = "timeToAnswer"
    static let userAnswers = "userAnswers"
}

class QuestionResponse {
    var timeToAnswer: TimeInterval!
    var userAnswers: [[String: String]]!
    
    init(question: Question) {
        self.userAnswers = question.userAnswers.map({ $0.dictionary })
        self.timeToAnswer = question.timeToAnswer
    }
    
    init(dictionary: [String: AnyObject]) {
        self.userAnswers = dictionary[QuestionResponseKey.userAnswers] as? [[String: String]]
        self.timeToAnswer = dictionary[QuestionResponseKey.timeToAnswer] as? TimeInterval
    }
    
    var dictionary: [String: AnyObject]! {
        var response = [String: AnyObject]()
        if let timeToAnswer = timeToAnswer {
            response[QuestionResponseKey.timeToAnswer] = timeToAnswer as AnyObject
        }
        if let userAnswers = userAnswers {
            response[QuestionResponseKey.userAnswers] = userAnswers as AnyObject
        }
        return response
    }
}
