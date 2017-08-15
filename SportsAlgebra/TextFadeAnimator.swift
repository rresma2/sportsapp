//
//  TextFadeAnimator.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class TextFadeAnimator {
    var words: [String]
    var label: UILabel
    var currentIndex = 0
    
    init(words: [String], label: UILabel) {
        self.words = words
        self.label = label
    }
    
    func beginAnimation() {
        self.fadeInMessageAt(index: 0)
    }
    
    func fadeInMessageAt(index: Int) {
        guard index < words.count else {
            SALog("Index is out of bounds.")
            return
        }
        
        let message = words[index]
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                self.label.alpha = 0.0
            }, completion: { completed in
                self.label.text = message
                UIView.animate(withDuration: 0.4, animations: {
                    self.label.alpha = 1.0
                }, completion: { completed in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                        self.fadeInMessageAt(index: index + 1)
                    })
                })
            })
        }
    }
}
