//
//  QuizResults.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/26/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizResults {
    
    // MARK: Properties
    
    var quiz: Quiz!
    var quizId: String?
    var title: String?
    var questionResponses: [QuestionResponse]
    var user: PFUser!
    var totalTimeToAnswer: TimeInterval
    var totalNumberOfQuestions: Int
    var numberCorrect: Int
    var dateTaken: Date?
    
    // MARK: Computed Properties
    
    var score: Int {
        return Int(Double(numberCorrect) / Double(totalNumberOfQuestions) * 100)
    }
    var scoreString: String {
        return "\(score)"
    }
    
    // MARK: Init
    
    init(quiz: Quiz, user: PFUser, dateTaken: Date?) {
        self.quiz = quiz
        self.quizId = quiz.serverId
        self.questionResponses = quiz.questionResponses
        self.user = user
        self.title = quiz.title
        
        self.totalTimeToAnswer = quiz.questionResponses.flatMap({ $0.timeToAnswer }).reduce(0, +)
        self.totalNumberOfQuestions = quiz.questions.count
        self.numberCorrect = quiz.numberCorrect
        self.dateTaken = dateTaken
    }
    
    init(quizResults: QuizResultsDTO) throws {
        self.quiz = try Quiz(quizDTO: quizResults.quiz)
        self.quizId = quiz.serverId
        self.questionResponses = quizResults.questionResponses.map({ QuestionResponse(dictionary: $0) })
        self.user = quizResults.user
        self.totalTimeToAnswer = quizResults.totalTimeToAnswer.doubleValue
        self.totalNumberOfQuestions = quizResults.totalNumberOfQuestions.intValue
        self.numberCorrect = quizResults.numberCorrect.intValue
        self.dateTaken = quizResults.dateTaken
        self.title = quizResults.title
    }
    
    // MARK: QuizResults
    
    func questionFor(index: Int) -> Question? {
        return quiz?.questionFor(index: index)
    }
    
    func questionResponseFor(index: Int) -> QuestionResponse? {
        guard index < self.questionResponses.count else {
            return nil
        }
        
        return self.questionResponses[index]
    }
}
