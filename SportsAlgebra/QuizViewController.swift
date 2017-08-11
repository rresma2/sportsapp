//
//  QuizViewController.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: Properties
    
    var currentQuizIndexHandler: Disposable?
    var viewModel: QuizViewModel! {
        willSet {
            currentQuizIndexHandler = newValue.currentQuestionIndexChanged.addHandler(target: self, handler: QuizViewController.questionIndexDidChange)
        }
    }
    
    func questionIndexDidChange(intValue: Int) {
        questionLabel.text = "Question \(intValue + 1) of \(viewModel.quiz.questions.count)"
        if let currentQuestion = viewModel.quiz.questionFor(index: intValue) {
            skipButton.isHidden = currentQuestion.isRequired
            timerProgressBarWrapper.isHidden = currentQuestion.timeLimit == nil
            if let timeLimit = currentQuestion.timeLimit {
                self.context.timePerQuestion = timeLimit
            }
        }
    }
    
    var quizFinishedHandler: Disposable?
    var context: QuizContext! {
        willSet {
            quizFinishedHandler = newValue.quizFinishedEvent.addHandler(target: self, handler: QuizViewController.quizFinished)
        }
    }
    
    func quizFinished(quiz: Quiz) {
        if context.isFirstQuiz {
            SAUserDefaults.sharedInstance.set(bool: true, for: .hasUserTakenFirstQuiz)
            // TODO: SAVE TO PARSE
        }
        // TODO: Show Home View Controller
        SAStoryboardFactory().presentHomeViewController(in: self.navigationController)
    }
    
    // MARK: Subviews
    
    @IBOutlet weak var quizTopBar: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timerWrapper: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerProgressBarWrapper: UIView!
    @IBOutlet weak var questionTableView: UITableView! {
        willSet {
            newValue.delegate = viewModel
            newValue.dataSource = viewModel
            viewModel.configure(tableView: newValue)
        }
    }
    @IBOutlet weak var nextButton: UIButton!
    var timerView: SAElapsedTimeView!
    
    // MARK: Constraints
    
    @IBOutlet weak var nextButtonBottom: NSLayoutConstraint!
    
    // MARK: IBAction
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        viewModel.submitAnswers()
    }
    
    @IBAction func skipButton(_ sender: Any) {
        viewModel.skipQuestion()
    }
    
    // MARK: UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timerView.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        questionIndexDidChange(intValue: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timerView: SAElapsedTimeView = .fromNib()
        timerView.frame.size = .init(width: timerProgressBarWrapper.frame.size.width,
                                     height: timerProgressBarWrapper.frame.size.height)
        timerView.context = self.context
        self.timerView = timerView
        self.timerProgressBarWrapper.addSubview(timerView)
        
        self.configureObservers()
    }
}
