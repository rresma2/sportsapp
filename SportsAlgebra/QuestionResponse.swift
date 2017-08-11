//
//  QuestionResponse.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/27/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuestionResponse {
    var timeToAnswer: TimeInterval!
    var userAnswers: [[String: String]]!
    
    init(question: Question) {
        self.userAnswers = question.userAnswers.map({ $0.dictionary })
        self.timeToAnswer = question.timeToAnswer
    }
}
