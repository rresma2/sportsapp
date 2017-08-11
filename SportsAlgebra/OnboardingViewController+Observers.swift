//
//  OnboardingViewController+Observers.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/20/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

extension OnboardingViewController {
    func configureObservers() {
        if self.isSignupViewShowing() {
            self.signupView.addObservers()
            self.loginView.removeObservers()
        } else {
            self.loginView.addObservers()
            self.signupView.removeObservers()
        }
    }
    
    func dismissKeyboardFor(responders: [UIResponder]) {
        for responder in responders {
            responder.resignFirstResponder()
        }
    }
    
    func keyboardFrameWillChange(note: Notification) {
        adjustViewsFor(note: note)
    }
    
    fileprivate func adjustViewsFor(note: Notification) {
        guard let keyboardHeight = note.keyboardHeight() else {
            return
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: note.keyboardAnimationDuration(), animations: {
                self.buttonBottom.constant = note.isKeyboardDismissing() ? 0.0 : keyboardHeight
            })
        }
    }
}
