//
//  HomeViewController.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: HomeViewModel!
    func retryQuizBlock() -> (Quiz) -> Void {
        return { quiz in
            SAStoryboardFactory().presentQuizPrefaceViewController(in: self.navigationController, with: quiz)
        }
    }
    
    // MARK: Subviews
    
    @IBOutlet weak var homeHeaderView: HomeHeaderView!
    @IBOutlet weak var takeQuizButton: UIButton!
    @IBOutlet weak var homeTableView: UITableView! {
        willSet {
            newValue.delegate = viewModel
            newValue.dataSource = viewModel
            viewModel.configure(tableView: newValue)
        }
    }
    
    // MARK: IBAction
    
    @IBAction func takeQuizButtonTapped(_ sender: Any) {
        viewModel.loadQuiz(completion: { (quiz, error) in
            if let error = error {
                SALog(error.message)
            } else if let quiz = quiz {
                SAStoryboardFactory().presentQuizPrefaceViewController(in: self.navigationController, with: quiz)
            }
        })
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takeQuizButton.titleLabel?.font = SAThemeService.shared.primaryFont(size: .primary)
        
        viewModel.fetchQuizResults()
        viewModel.didSelectBlock = didSelectBlock()
        viewModel.retryQuizBlock = retryQuizBlock()
        
        homeHeaderView.configure(user: PFUser.current(), delegate: self)
        homeHeaderView.leftButton.isUserInteractionEnabled = PFUser.current() != nil
        homeHeaderView.leftButton.alpha = PFUser.current() != nil ? 1.0 : 0.4
        homeHeaderView.rightButton.isUserInteractionEnabled = false
        homeHeaderView.rightButton.alpha = 0.4
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchQuizResults()
    }
    
    // MARK: HomeViewController
    
    func didSelectBlock() -> (QuizResults) -> Void {
        return { results in
            SAStoryboardFactory().presentQuizResultsViewController(in: self.navigationController, with: results)
        }
    }
}

extension HomeViewController: HomeHeaderViewDelegate {
    func homeHeaderView(_ headerView: HomeHeaderView, leftButtonTapped button: UIButton) {
        guard let user = PFUser.current(), let daysSinceAccountCreation = user.daysSinceAccountCreation else {
            return
        }
        
        let vc: UserStatsViewController = SAStoryboardFactory().instantiateViewController()
        vc.viewModel = UserStatsViewModel(daysSinceAccountCreation: daysSinceAccountCreation,
                                          dataSource: viewModel.dataSource,
                                          user: user)
        present(vc, animated: true)
    }
    
    func homeHeaderView(_ headerView: HomeHeaderView, rightButtonTapped button: UIButton) {
        // TODO: When rewards come into play, instantiate a view controller to show here
    }
}
