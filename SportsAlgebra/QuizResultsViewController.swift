//
//  QuizResultsViewController.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizResultsViewController: UIViewController {
    
    // MARK: Properties
    
    var viewModel: QuizResultsViewModel!
    
    // MARK: IBOutlet
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var questionResponseTableView: UITableView! {
        willSet {
            newValue.delegate = viewModel
            newValue.dataSource = viewModel
            viewModel.configure(tableView: newValue)
        }
    }
    
    // MARK: IBAction
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        self.navigationController?.goHome()
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.didSelectHandler = didSelectHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        questionResponseTableView.reloadData()
    }
    
    // MARK: QuizResultsViewController
    
    func didSelectHandler() -> (Quiz, Answer, Int) -> Void {
        return { (quiz, userAnswer, index) in
            SAStoryboardFactory().presentQuizPreviewController(in: self,
                                                               with: quiz,
                                                               previewIndex: index,
                                                               userAnswer: userAnswer)
        }
    }
}
