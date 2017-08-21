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
            guard !self.previewMode, let newValue = newValue else {
                return
            }
            
            selectedAnswerChanged.raise(data: newValue)
        }
    }
    
    var progressChanged = Event<(Double, Double)>()
    var progress: TimeInterval = 0.0 {
        willSet {
            guard !self.previewMode else {
                return
            }
            
            progressChanged.raise(data: (newValue, timePerQuestion))
        }
    }
    
    var correctAnswerEvent = Event<[Answer]>()
    func userGotCorrect(answers: [Answer]) {
        guard !self.previewMode else {
            return
        }
        
        correctAnswerEvent.raise(data: answers)
    }
    
    var incorrectAnswerEvent = Event<([Answer], [Answer])>()
    func userGotIncorrectAnswers(userAnswers: [Answer], correctAnswers: [Answer]) {
        guard !self.previewMode else {
            return
        }
        
        incorrectAnswerEvent.raise(data: (userAnswers, correctAnswers))
    }
    
    var quizFinishedEvent = Event<Quiz>()
    func userFinished(quiz: Quiz) {
        guard !self.previewMode else {
            return
        }
        
        quiz.printResults()
        quizFinishedEvent.raise(data: quiz)
    }
    
    func record(answeredQuestion: Question) {
        guard !self.previewMode else {
            return
        }
        
        answeredQuestion.timeToAnswer = progress
    }
    
    var timer: Timer?
    let step: TimeInterval = 1.0
    var timePerQuestion: TimeInterval
    var previewMode: Bool
    var isFirstQuiz = false
    
    init(timePerQuestion: TimeInterval, previewMode: Bool = false) {
        self.timePerQuestion = timePerQuestion
        self.previewMode = previewMode
    }
    
    func restart() {
        guard !self.previewMode else {
            return
        }
        
        self.stop()
        self.progress = 0.0
        self.start()
    }
    
    func start() {
        guard !self.previewMode else {
            return
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: step,
                                          target: self,
                                          selector: #selector(tick),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    func stop() {
        guard !self.previewMode else {
            return
        }
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func tick() {
        guard !self.previewMode, progress <= timePerQuestion else {
            stop()
            return
        }
        
        progress += step
    }
}
