//
//  SAElapsedTimeView.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class SAElapsedTimeView: UIView {
    var progressHandler: Disposable?
    var context: QuizContext! {
        willSet {
            progressHandler = newValue.progressChanged.addHandler(target: self, handler: SAElapsedTimeView.progressChanged)
        }
    }
    
    let progressBarWidth: CGFloat = 100.0
    let progressBarHeight: CGFloat = 8.0
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerWrapper: UIView!
    @IBOutlet weak var timerInnerWrapper: UIProgressView!
    
    var progressBar: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    init() {
        super.init(frame: .zero)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        self.timerInnerWrapper.progressTintColor = .white
        self.timerInnerWrapper.trackTintColor = SAThemeService.shared.primaryThemeColor()
        self.timerInnerWrapper.backgroundColor = .black
        self.timerInnerWrapper.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.timerInnerWrapper.progress = 1.0
    }
    
    override func awakeFromNib() {
        commonInit()
    }
    
    func restart() {
        self.context.stop()
        self.context.start()
    }
    
    func start() {
        self.context.start()
    }
    
    func stop() {
        self.context.stop()
    }
    
    func progressChanged(progress: Double, total: Double) {
        let currentProgress = CGFloat(((total - min(progress, total)) / total))
        let elapsedTimeRemaining = total - min(progress, total)
        let minutesRemaining = Int(elapsedTimeRemaining / 60)
        let secondsRemaining = max(0, Int(elapsedTimeRemaining) - (minutesRemaining * 60))
        let secondsString = secondsRemaining < 10 ? "0\(secondsRemaining)" : "\(secondsRemaining)"
        
        DispatchQueue.main.async {
            self.timerInnerWrapper.progress = Float(currentProgress)
            self.timerLabel.text = "\(minutesRemaining):\(secondsString)"
        }
    }
}
