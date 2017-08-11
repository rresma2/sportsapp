//
//  FadeAnimator.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/9/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval
    var isPresenting: Bool
    
    init(duration: TimeInterval, transitionType: TransitionType) {
        self.duration = duration
        self.isPresenting = transitionType == .presenting
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func setStartStateFor(fromViewController: UIViewController) {
        guard let fromView = fromViewController.view else {
            return
        }
        
        fromView.alpha = 1.0
    }
    
    func setStartStateFor(toViewController: UIViewController) {
        guard let toView = toViewController.view else {
            return
        }
        for view in toView.subviews {
            view.alpha = 0.0
        }
    }
    
    func performAnimationsFor(fromViewController: UIViewController) {
        guard let fromView = fromViewController.view else {
            return
        }
        
        fromView.alpha = 0.0
    }
    
    func performAnimationsFor(toViewController: UIViewController) {
        guard let toView = toViewController.view else {
            return
        }
        
        for view in toView.subviews {
            view.alpha = 1.0
        }
    }
    
    func concludeTransition(fromViewController: UIViewController, toViewController: UIViewController) {
        guard let fromView = fromViewController.view else {
            return
        }
        
        fromView.alpha = 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let fromView = fromViewController.view else {
                return
        }
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let toView = toViewController.view else {
                return
        }

        if isPresenting {
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
        } else {
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
        }
        
        setStartStateFor(fromViewController: fromViewController)
        setStartStateFor(toViewController: toViewController)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveLinear, animations: {
                self.performAnimationsFor(fromViewController: fromViewController)
            }, completion: { completed in
                UIView.animate(withDuration: self.duration, delay: self.duration, options: .curveLinear, animations: {
                    self.performAnimationsFor(toViewController: toViewController)
                }, completion: { completed in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    self.concludeTransition(fromViewController: fromViewController, toViewController: toViewController)
                })
            })
        }
    }
}
