//
//  UserStatsViewModel.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/18/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

/*
 Aggregations:
 
 1. ***** average test score
 2. ***** total number of questions answer
 3. ***** total # of seconds spent answering questions
 4. ***** average # of seconds spent per question
 5. ***** number of quizzes taken
 6. ***** average number of questions per day
 7. ***** average number of quizzes per day
 */

class UserStatsViewModel {
    
    // MARK: Properties
    
    var daysSinceAccountCreation: Int
    var dataSource: [QuizResults]
    var questions: [Question]
    var totalScore: Int
    var totalNumberOfSeconds: TimeInterval
    var totalNumberOfQuestionsAnswered: Int
    
    // MARK: Aggregation Properties
    
    var averageTestScore: Double? {
        guard dataSource.count > 0 else {
            return nil
        }
        
        return Double(totalScore) / Double(dataSource.count)
    }
    
    var averageNumberOfSecondsPerQuestion: TimeInterval? {
        guard questions.count > 0 else {
            return nil
        }
        
        return totalNumberOfSeconds / Double(questions.count)
    }
    
    var averageNumberOfQuestionsPerDay: Double? {
        guard daysSinceAccountCreation > 0 else {
            return nil
        }
        
        return Double(questions.count) / Double(daysSinceAccountCreation)
    }
    
    var averageNumberOfQuizzesPerDay: Double? {
        guard daysSinceAccountCreation > 0 else {
            return nil
        }
        
        return Double(dataSource.count) / Double(daysSinceAccountCreation)
    }
    
    var numberOfQuizzesTaken: Int {
        return self.dataSource.count
    }
    
    // MARK: Init
    
    init(daysSinceAccountCreation: Int, dataSource: [QuizResults]) {
        self.daysSinceAccountCreation = daysSinceAccountCreation
        self.dataSource = dataSource
        self.questions = dataSource.flatMap({ $0.quiz.questions })
        
        self.totalScore = 0
        for result in dataSource {
            self.totalScore += result.score
        }
        
        self.totalNumberOfSeconds = 0.0
        for result in dataSource {
            self.totalNumberOfSeconds += result.totalTimeToAnswer
        }
        
        self.totalNumberOfQuestionsAnswered = 0
        for result in dataSource {
            self.totalNumberOfQuestionsAnswered += result.quiz.questions.count
        }
        
    }
}
