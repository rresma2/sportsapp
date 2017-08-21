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
    
    var user: PFUser
    var dataSource: [QuizResults]
    
    // MARK: Aggregation Properties
    
    var averageTestScore: Double? {
        guard dataSource.count > 0 else {
            return nil
        }
        
        var totalScore = 0
        for result in dataSource {
            totalScore += result.score
        }
        
        return Double(totalScore) / Double(dataSource.count)
    }
    
    var averageNumberOfSecondsPerQuestion: TimeInterval? {
        let questions = dataSource.flatMap({ $0.quiz.questions })
        guard questions.count > 0 else {
            return nil
        }
        
        var totalNumberOfSeconds = 0.0
        for result in dataSource {
            totalNumberOfSeconds += result.totalTimeToAnswer
        }
        
        return totalNumberOfSeconds / Double(questions.count)
    }
    
    var averageNumberOfQuestionsPerDay: Double? {
        let questions = dataSource.flatMap({ $0.quiz.questions })
        guard questions.count > 0,
            let numDays = user.daysSinceAccountCreation else {
                return nil
        }
        
        return Double(questions.count) / Double(numDays)
    }
    
    var averageNumberOfQuizzesPerDay: Double? {
        guard dataSource.count > 0,
            let numDays = user.daysSinceAccountCreation else {
                return nil
        }
        
        return Double(dataSource.count) / Double(numDays)
    }
    
    var numberOfQuizzesTaken: Int {
        return self.dataSource.count
    }
    
    var totalNumberOfQuestionsAnswered: Int {
        var total = 0
        for result in dataSource {
            total += result.quiz.questions.count
        }
        return total
    }
    
    var totalNumberOfSeconds: TimeInterval {
        var total = 0.0
        for result in dataSource {
            total += result.totalTimeToAnswer
        }
        return total
    }
    
    // MARK: Init
    
    init(user: PFUser, dataSource: [QuizResults]) {
        self.user = user
        self.dataSource = dataSource
    }
}
