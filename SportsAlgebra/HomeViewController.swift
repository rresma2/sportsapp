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
        homeHeaderView.configure(user: PFUser.current())
        viewModel.didSelectBlock = didSelectBlock()
        viewModel.retryQuizBlock = retryQuizBlock()
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
