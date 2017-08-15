//
//  QuizPrefaceViewController.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/15/17.
//  Copyright © 2017 rresma. All rights 

import UIKit

/*
 
 1. Hello, competitor. You are about to take a quiz.
 2. This quiz has {num} questions.
 3. At the end of the quiz, you will be scored based on the time it takes to finish each question and the number of questions you get correct
 4. If you are the top scoring competitor, you may be eligible for a prize!
 5. When you're ready, press the Start button below
 
 */

class QuizPrefaceViewController: UIViewController {
    
    // MARK: Properties
    
    let buttonTitle = "Start"
    var quiz: Quiz!
    var messages: [String] {
        guard let name = PFUser.current()?.name else {
            return []
        }
        
        return [
            "Hello, {NAME}. You are about to take a quiz.".replacingOccurrences(of: "{NAME}", with: name),
            "This quiz has {NUM} questions.".replacingOccurrences(of: "{NUM}", with: "\(quiz.questions.count)"),
            "At the end of the quiz, you will be scored based on the time it takes to finish each question and the number of questions you get correct.",
            "If you are the top scoring competitor,\nyou may be eligible for a prize!",
            "When you're ready, press\nthe '\(buttonTitle)' button below"
        ]
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var prefaceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: IBAction
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(kTitleFont: SAThemeService.shared.primaryFont(size: .primary),
                                                    kTextFont: SAThemeService.shared.primaryFont(size: .secondary),
                                                    kButtonFont: SAThemeService.shared.primaryFont(size: .secondary),
                                                    showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        
        alertView.addButton("Yes", target: self, selector: #selector(QuizPrefaceViewController.beginQuiz))
        alertView.addButton("Never mind", target: self, selector: #selector(QuizPrefaceViewController.goHome))
        alertView.showNotice("Are you ready to begin?", subTitle: "", circleIconImage: #imageLiteral(resourceName: "ic_priority_high_white"))
    }
    
    func beginQuiz() {
        SAStoryboardFactory().presentQuizViewController(in: self.navigationController, with: quiz)
    }
    
    func goHome() {
        self.navigationController?.goHome()
    }
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefaceLabel.font = SAThemeService.shared.mediumFont(size: .primary)
        startButton.titleLabel?.font = SAThemeService.shared.primaryFont(size: .primary)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TextFadeAnimator(words: messages, label: prefaceLabel).beginAnimation()
    }
}
