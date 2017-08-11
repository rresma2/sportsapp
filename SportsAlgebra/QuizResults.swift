//
//  QuizResults.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/26/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizResults: PFObject {
    var quiz: Quiz
    var quizId: String!
    var questionResponses: [QuestionResponse]
    
    init(quiz: Quiz) {
        self.quiz = quiz
        self.quizId = quiz.objectId
        self.questionResponses = quiz.questionResponses
        super.init()
    }
}

extension QuizResults: PFSubclassing {
    static func parseClassName() -> String {
        return "QuizResults"
    }
}
