//
//  QuizViewController+Observers.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/20/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

extension QuizViewController {
    func configureObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
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
                self.nextButtonBottom.constant = note.isKeyboardDismissing() ? 0.0 : -keyboardHeight
            })
        }
    }
}
