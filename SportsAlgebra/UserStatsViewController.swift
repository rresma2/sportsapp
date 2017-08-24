//
//  UserStatsViewController.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/18/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class UserStatsViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: UserStatsViewModel!
    
    // MARK: IBOutlet
    
    @IBOutlet weak var homeHeaderView: HomeHeaderView!
    @IBOutlet weak var averageTestScoreTitleLabel: UILabel!
    @IBOutlet weak var averageTestScoreValueLabel: UILabel!
    @IBOutlet weak var averageNumberOfSecondsPerQuestionTitleLabel: UILabel!
    @IBOutlet weak var averageNumberOfSecondsPerQuestionValueLabel: UILabel!
    @IBOutlet weak var averageNumberOfQuestionsPerDayTitleLabel: UILabel!
    @IBOutlet weak var averageNumberOfQuestionsPerDayValueLabel: UILabel!
    @IBOutlet weak var numberQuestionsAnsweredTitleLabel: UILabel!
    @IBOutlet weak var numberQuestionsAnsweredValueLabel: UILabel!
    @IBOutlet weak var numberOfQuizzesTakenTitleLabel: UILabel!
    @IBOutlet weak var numberOfQuizzesTakenValueLabel: UILabel!
    @IBOutlet weak var totalNumberOfSecondsTitleLabel: UILabel!
    @IBOutlet weak var totalNumberOfSecondsValueLabel: UILabel!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle(labels: [averageTestScoreTitleLabel,
                                averageNumberOfQuestionsPerDayTitleLabel,
                                averageNumberOfSecondsPerQuestionTitleLabel,
                                numberQuestionsAnsweredTitleLabel,
                                numberOfQuizzesTakenTitleLabel,
                                totalNumberOfSecondsTitleLabel])
        
        configureValue(labels: [averageTestScoreValueLabel,
                                averageNumberOfQuestionsPerDayValueLabel,
                                averageNumberOfSecondsPerQuestionValueLabel,
                                numberQuestionsAnsweredValueLabel,
                                numberOfQuizzesTakenValueLabel,
                                totalNumberOfSecondsValueLabel])
        
        homeHeaderView.configure(user: PFUser.current(), delegate: self)
        viewModel.configure(viewController: self)
    }
    
    func configureTitle(labels: [UILabel?]) {
        for label in labels.flatMap({ $0 }) {
            label.font = SAThemeService.shared.primaryFont(size: .primary)
            label.textColor = .white
        }
    }
    
    func configureValue(labels: [UILabel?]) {
        for label in labels.flatMap({ $0 }) {
            label.font = SAThemeService.shared.boldFont(size: .title)
            label.textColor = .white
        }
    }
}

extension UserStatsViewController: HomeHeaderViewDelegate {
    func homeHeaderView(_ headerView: HomeHeaderView, leftButtonTapped button: UIButton) {
        self.dismiss(animated: true)
    }
    
    func homeHeaderView(_ headerView: HomeHeaderView, rightButtonTapped button: UIButton) {
        if let emailToSave = headerView.emailTextField?.text,
            emailToSave != headerView.originalEmail {
            
            viewModel.user.email = emailToSave
            homeHeaderView.originalEmail = emailToSave
        }
        if let homeTownToSave = headerView.homeTownTextField?.text,
            homeTownToSave != headerView.originalHomeTown {
            
            viewModel.user.homeTown = homeTownToSave
            homeHeaderView.originalHomeTown = homeTownToSave
        }
        
        viewModel.user.saveInBackground()
        homeHeaderView.rightButton.alpha = 0.4
        homeHeaderView.rightButton.isUserInteractionEnabled = false
    }
}
