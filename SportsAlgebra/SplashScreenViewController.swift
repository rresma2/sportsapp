//
//  SplashScreenViewController.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/8/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            if SAUserDefaults.sharedInstance.boolFor(key: .isLoggedIn) == false {
                SAStoryboardFactory().presentOnboarding(in: self.navigationController)
            } else if SAUserDefaults.sharedInstance.boolFor(key: .hasUserTakenFirstQuiz) == false {
                SAStoryboardFactory().presentFirstQuizViewController(in: self.navigationController)
            } else {
                SAStoryboardFactory().presentHomeViewController(in: self.navigationController)
            }
        }
    }
}
