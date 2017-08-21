//
//  SAAlertManager.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

typealias SCLAlertAction = () -> Void

class SAAlertManager {
    func showIncorrectAnswerAlert(alertAction: @escaping SCLAlertAction,
                                  correctAnswer: Answer?,
                                  userAnswer: Answer?) {
        
        let alertView = SCLAlertView(appearance: .default)
        alertView.addButton("OK", action: alertAction)
        if let userAnswerText = userAnswer?.text, let correctAnswerText = correctAnswer?.text {
            let subtitle = "\(userAnswerText) isn't correct. The correct answer is: \(correctAnswerText). Nice try, though!"
            alertView.showError("Oops!", subTitle: subtitle)
        } else {
            alertView.showError("Oops!", subTitle: "Your answer wasn't correct :( Nice try, though!")
        }
    }
    
    func showCorrectAnswerAlert(alertAction: @escaping SCLAlertAction,
                                timeToAnswer: TimeInterval?) {
        
        let alertView = SCLAlertView(appearance: .default)
        alertView.addButton("Awesome!", action: alertAction)
        
        if let timeToAnswerString = timeToAnswer?.stringByRoundingBy(numberOfPlaces: 1) {
            alertView.showSuccess("Nice job!", subTitle: "Your answer was correct! It took you \(timeToAnswerString) seconds to solve the problem.")
        } else {
            alertView.showSuccess("Nice job!", subTitle: "Your answer was correct!")
        }
    }
    
    func showRetryQuizPrompt(alertAction: @escaping SCLAlertAction) {
        let alertView = SCLAlertView(appearance: .default)
        alertView.addButton("OK", action: alertAction)
        alertView.addButton("Cancel", action: {})
        alertView.showNotice("You are about to retake this quiz. Are you ready?", subTitle: "", circleIconImage: #imageLiteral(resourceName: "ic_priority_high_white"))
    }
    
    func showGenericError(alertAction: @escaping SCLAlertAction = {_ in}) {
        let alertView = SCLAlertView(appearance: .default)
        alertView.addButton("OK", action: alertAction)
        alertView.showError("Uh oh.", subTitle: "Something went wrong. Please try again later")
    }
    
    func failedToRetrieveQuizError(alertAction: @escaping SCLAlertAction = {_ in}) {
        let alertView = SCLAlertView(appearance: .default)
        alertView.addButton("OK", action: alertAction)
        alertView.showError("Error", subTitle: "We failed to retrieve your quiz. Please try again later.")
    }
    
    func showExitQuizAlert(alertAction: @escaping SCLAlertAction) {
        let alertView = SCLAlertView(appearance: .default)
        alertView.addButton("Back to Home", action: alertAction)
        alertView.addButton("Keep Going", action: {})
        alertView.showNotice("Are you sure you want to exit? Your progress will not be saved.", subTitle: "", circleIconImage: #imageLiteral(resourceName: "ic_priority_high_white"))
    }
}

extension SCLAlertView.SCLAppearance {
    static var `default`: SCLAlertView.SCLAppearance {
        return SCLAlertView.SCLAppearance(kTitleFont: SAThemeService.shared.primaryFont(size: .primary),
                                          kTextFont: SAThemeService.shared.primaryFont(size: .secondary),
                                          kButtonFont: SAThemeService.shared.primaryFont(size: .secondary),
                                          showCloseButton: false)
    }
}
