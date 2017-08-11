//
//  Notification+Extensions.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

extension Notification {
    var defaultAnimationDuration: TimeInterval {
        return 0.4
    }
    
    func isKeyboardDismissing() -> Bool {
        guard let endFrame = self.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return false
        }
        return endFrame.origin.y == UIScreen.main.bounds.height
    }
    
    func keyboardHeight() -> CGFloat? {
        guard let endFrame = self.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return nil
        }
        
        return endFrame.size.height
    }
    
    func keyboardAnimationDuration() -> TimeInterval {
        return self.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? defaultAnimationDuration
    }
}
