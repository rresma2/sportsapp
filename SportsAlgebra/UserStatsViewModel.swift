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
 2. ***** total number of questions answered
 3. ***** total # of seconds spent answering questions
 4. ***** average # of seconds spent per question
 5. ***** number of quizzes taken
 6. ***** average number of questions per day
 */

class UserStatsViewModel {
    
    // MARK: Properties
    
    var daysSinceAccountCreation: Int
    var dataSource: [QuizResults]
    var questions: [Question]
    var totalScore: Int
    var totalNumberOfSeconds: TimeInterval
    var totalNumberOfQuestionsAnswered: Int
    var user: PFUser
    
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
    
    // MARK: Display String Getters
    
    var averageTestScoreString: String {
        guard let averageTestScore = averageTestScore else {
            return "-"
        }
        
        return "\(Int(averageTestScore))"
    }
    
    var averageNumberOfSecondsPerQuestionString: String {
        guard let averageNumberOfSecondsPerQuestion = averageNumberOfSecondsPerQuestion else {
            return "-"
        }
        
        return averageNumberOfSecondsPerQuestion.timeString
    }
    
    var averageNumberOfQuestionsPerDayString: String {
        guard let averageNumberOfQuestionsPerDay = averageNumberOfQuestionsPerDay else {
            return "-"
        }
        
        return averageNumberOfQuestionsPerDay.abbreviatedString
    }
    
    var totalNumberOfQuestionsString: String {
        return totalNumberOfQuestionsAnswered.abbreviatedString
    }
    
    var totalNumberOfQuizzesString: String {
        return dataSource.count.abbreviatedString
    }
    
    var totalNumberOfSecondsString: String {
        return totalNumberOfSeconds.timeString
    }
    
    // MARK: Init
    
    init(daysSinceAccountCreation: Int, dataSource: [QuizResults], user: PFUser) {
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
        
        self.user = user
    }
    
    // MARK: UserStatsViewModel
    
    func configure(viewController: UserStatsViewController) {
        viewController.averageTestScoreValueLabel.text = averageTestScoreString
        viewController.averageNumberOfSecondsPerQuestionValueLabel.text = averageNumberOfSecondsPerQuestionString
        viewController.averageNumberOfQuestionsPerDayValueLabel.text = averageNumberOfQuestionsPerDayString
        viewController.numberQuestionsAnsweredValueLabel.text = totalNumberOfQuestionsString
        viewController.numberOfQuizzesTakenValueLabel.text = totalNumberOfQuizzesString
        viewController.totalNumberOfSecondsValueLabel.text = totalNumberOfSecondsString
    }
}
