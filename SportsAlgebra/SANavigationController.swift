//
//  SANavigationController.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/8/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class SANavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNavigationBarHidden = true
        self.delegate = self
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
}

extension SANavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {}
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNavigationBarHiddenIfNecessaryForShowing(viewController: viewController)
    }
    
    func setNavigationBarHiddenIfNecessaryForShowing(viewController: UIViewController) {
        let (isHidden, shouldAnimate) = navigationBarHiddenProperties(viewController: viewController)
        setNavigationBarHidden(isHidden, animated: shouldAnimate)
    }
    
    func navigationBarHiddenProperties(viewController: UIViewController) -> (Bool, Bool) {
        let shouldAnimate = isOnboarding(viewController: viewController)
                        || viewController is QuizViewController
                        || viewController is HomeViewController
        return (true, shouldAnimate)
    }
    
    func isOnboarding(viewController: UIViewController) -> Bool {
        return viewController is SplashScreenViewController
            || viewController is OnboardingViewController
    }
}

extension SANavigationController: UIViewControllerTransitioningDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is SplashScreenViewController && self.isOnboarding(viewController: toVC) {
            return OnboardingFadeAnimator(duration: 0.2, transitionType: .presenting)
        } else if fromVC is SplashScreenViewController && self.isOnboarding(viewController: toVC) {
            return OnboardingFadeAnimator(duration: 0.2, transitionType: .dismissing)
        }
        return nil
    }
}

extension UINavigationController {
    func goHome() {
        for controller in self.viewControllers {
            if controller is HomeViewController {
                self.popToViewController(controller, animated: true)
            }
        }
    }
}
