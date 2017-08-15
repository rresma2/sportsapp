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
    
    // MARK: Subviews
    
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
        viewModel.takeQuiz()
    }
}
