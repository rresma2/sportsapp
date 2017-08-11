//
//  QuizContext.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/18/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizContext: NSObject {
    var selectedAnswerChanged = Event<Answer>()
    var selectedAnswer: Answer? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            
            selectedAnswerChanged.raise(data: newValue)
        }
    }
    
    var progressChanged = Event<(Double, Double)>()
    var progress: TimeInterval = 0.0 {
        willSet {
            progressChanged.raise(data: (newValue, timePerQuestion))
        }
    }
    
    var correctAnswerEvent = Event<[Answer]>()
    func userGotCorrect(answers: [Answer]) {
        correctAnswerEvent.raise(data: answers)
    }
    
    var incorrectAnswerEvent = Event<([Answer], [Answer])>()
    func userGotIncorrectAnswers(userAnswers: [Answer], correctAnswers: [Answer]) {
        incorrectAnswerEvent.raise(data: (userAnswers, correctAnswers))
    }
    
    var quizFinishedEvent = Event<Quiz>()
    func userFinished(quiz: Quiz) {
        quiz.printResults()
        quizFinishedEvent.raise(data: quiz)
    }
    
    func record(answeredQuestion: Question) {
        answeredQuestion.timeToAnswer = progress
    }
    
    var timer: Timer?
    let step: TimeInterval = 1.0
    var timePerQuestion: TimeInterval
    var isFirstQuiz = false
    init(timePerQuestion: TimeInterval) {
        self.timePerQuestion = timePerQuestion
    }
    
    func restart() {
        self.stop()
        self.progress = 0.0
        self.start()
    }
    
    func start() {
        self.timer = Timer.scheduledTimer(timeInterval: step,
                                          target: self,
                                          selector: #selector(tick),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func tick() {
        guard progress <= timePerQuestion else {
            stop()
            return
        }
        
        progress += step
    }
}
