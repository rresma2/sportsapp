//
//  OnboardingFadeAnimator.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class OnboardingFadeAnimator: FadeAnimator {
    override func performAnimationsFor(toViewController: UIViewController) {
        guard let onboardingVC = toViewController as? OnboardingViewController,
            let toView = onboardingVC.view else {
                return
        }
        
        for view in toView.subviews {
            if view != onboardingVC.leftArrow {
                view.alpha = 1.0
            }
        }
    }
}
