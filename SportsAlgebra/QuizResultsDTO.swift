//
//  QuizResultsDTO.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/12/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizResultsDTO: PFObject {
    @NSManaged var quiz: QuizDTO!
    @NSManaged var quizId: String!
    @NSManaged var questionResponses: [[String: AnyObject]]!
    @NSManaged var user: PFUser!
    @NSManaged var totalTimeToAnswer: NSNumber!
    @NSManaged var totalNumberOfQuestions: NSNumber!
    @NSManaged var numberCorrect: NSNumber!
    @NSManaged var dateTaken: Date!
    @NSManaged var title: String!
    
    override init() {
        super.init()
    }
    
    init(quizResults: QuizResults) throws {
        super.init()
        
        self.quiz = try QuizDTO(quiz: quizResults.quiz)
        self.quizId = self.quiz.objectId
        self.title = self.quiz.title
        self.questionResponses = quizResults.questionResponses.map({ $0.dictionary })
        self.user = quizResults.user
        self.totalTimeToAnswer = NSNumber(floatLiteral: quizResults.totalTimeToAnswer)
        self.totalNumberOfQuestions = NSNumber(integerLiteral: quizResults.totalNumberOfQuestions)
        self.numberCorrect = NSNumber(integerLiteral: quizResults.numberCorrect)
        self.dateTaken = quizResults.dateTaken
    }
    
}

extension QuizResultsDTO: PFSubclassing {
    static func parseClassName() -> String {
        return "QuizResults"
    }
}
