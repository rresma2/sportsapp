//
//  OnboardingViewController.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/11/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    // MARK: Properties
    
    var viewModel: OnboardingViewModel!
    
    // MARK: Subviews
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var onboardingButton: UIButton!
    
    var signupView: SignupView!
    var loginView: LoginView!
    
    // MARK: Constraints
    
    @IBOutlet weak var buttonBottom: NSLayoutConstraint!
    
    
    // MARK: IBActions
    
    func isSignupViewShowing() -> Bool {
        return self.scrollView.contentOffset.x == 0.0
    }
    
    @IBAction func onboardingButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                self.onboardingButton.setTitle(self.isSignupViewShowing() ? "New Member?" : "Already a member?",
                                               for: .normal)
                self.scrollView.setContentOffset(.init(x: self.isSignupViewShowing() ? self.scrollView.frame.size.width : 0.0,
                                                       y: self.scrollView.contentOffset.y),
                                                 animated: true)
                self.leftArrow.alpha = self.isSignupViewShowing() ? 1.0 : 0.0
                self.rightArrow.alpha = self.isSignupViewShowing() ? 0.0 : 1.0
            })
        }
    }
    
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.view.frame.width,
                                       height:self.view.frame.height)
        self.scrollView.isScrollEnabled = false
        self.scrollView.delegate = self
        let layoutManager = PaginatorLayoutManager(scrollView: scrollView,
                                                   layoutType: .horizontal)
        let signupView: SignupView = .fromNib()
        signupView.delegate = viewModel
        self.signupView = signupView
        
        let loginView: LoginView = .fromNib()
        loginView.delegate = viewModel
        self.loginView = loginView
        
        layoutManager.addSubview(signupView)
        layoutManager.addSubview(loginView)
        layoutManager.updateContentSize()
        
        onboardingButton.titleLabel?.font = SAThemeService.shared.primaryFont(size: .primary)
        
        self.viewModel.loginCompletionHandler = self.provisioningAPICallCompletionHandler(provisioningType: .login)
        self.viewModel.facebookLoginCompletionHandler = self.provisioningAPICallCompletionHandler(provisioningType: .fbLogin)
        self.viewModel.signupCompletionHandler = self.provisioningAPICallCompletionHandler(provisioningType: .signup)
        self.viewModel.facebookSignupCompletionHandler = self.provisioningAPICallCompletionHandler(provisioningType: .fbSignup)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    func provisioningAPICallCompletionHandler(provisioningType: SAProvisioningType) -> (PFUser?, SAError?) -> Void {
        return { [weak self] (user: PFUser?, error: SAError?) in
            guard let `self` = self else {
                return
            }
            
            if let error = error {
                self.handle(error: error, provisioningType: provisioningType)
            } else {
                SAUserDefaults.sharedInstance.set(bool: true, for: .isLoggedIn)
                self.presentNextViewController(provisioningType: provisioningType)
            }
        }
    }
    
    func presentNextViewController(provisioningType: SAProvisioningType) {
        if SAUserDefaults.sharedInstance.boolFor(key: .hasUserTakenFirstQuiz) == false || provisioningType == .signup {
            SAStoryboardFactory().presentFirstQuizViewController(in: self.navigationController)
        } else {
            SAStoryboardFactory().presentHomeViewController(in: self.navigationController)
        }
    }
    
    func handle(error: SAError, provisioningType: SAProvisioningType) {
        if provisioningType == .fbLogin || provisioningType == .fbSignup {
            SCLAlertView().showError(provisioningType.errorTitle, subTitle: "Failed to log in through Facebook. Please try again.")
        } else {
            SCLAlertView().showError(provisioningType.errorTitle, subTitle: error.message)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configureObservers()
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.dismissKeyboardFor(responders: allTextFields)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.configureObservers()
    }
    
    var allTextFields: [UITextField] {
        return [signupView.usernameTextField,
                signupView.emailTextField,
                signupView.passwordTextField,
                loginView.usernameTextField,
                loginView.passwordTextField,
                ].flatMap({ return $0 })
    }
}
