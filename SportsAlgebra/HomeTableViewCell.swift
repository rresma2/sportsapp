//
//  HomeTableViewCell.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/12/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var retryQuizBlock: ((Quiz) -> Void)?
    var quizResults: QuizResults?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var questionsCorrectLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var dateTakenLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: IBAction
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        guard let quiz = quizResults?.quiz, let retry = self.retryQuizBlock else {
            SAAlertManager().showGenericError()
            return
        }
        
        SAAlertManager().showRetryQuizPrompt(alertAction: {
            retry(quiz)
        })
    }
    
    
    // MARK: UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderView.layer.cornerRadius = self.borderView.frame.size.width / 2
    }
    
    // MARK: UITableViewCell
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.backgroundColor = UIColor(r: 100,
                                           g: 100,
                                           b: 100,
                                           a: 0.2)
        } else {
            self.backgroundColor = .black
        }
    }
    
    // MARK: HomeTableViewCell
    
    func commonInit() {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .black
    }
    
    func configure(quizResults: QuizResults) {
        self.quizResults = quizResults
        
        homeTitleLabel.text = quizResults.questionFor(index: 0)?.quizTitle
        homeTitleLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        
        questionsCorrectLabel.text = self.questionsCorrectText(quizResults: quizResults)
        questionsCorrectLabel.font = SAThemeService.shared.primaryFont(size: .secondary)
        
        timeDurationLabel.text = self.timeDurationLabelText(quizResults: quizResults)
        timeDurationLabel.font = SAThemeService.shared.primaryFont(size: .secondary)
        
        dateTakenLabel.text = dateTakenText(quizResults: quizResults)
        dateTakenLabel.font = SAThemeService.shared.primaryFont(size: .tiny)
        
        scoreLabel.text = scoreLabelText(quizResults: quizResults)
        scoreLabel.font = SAThemeService.shared.mediumFont(size: .primary)
    }
    
    func questionsCorrectText(quizResults: QuizResults) -> String {
        return "• You got \(quizResults.numberCorrect) out of \(quizResults.totalNumberOfQuestions) questions correct."
    }
    
    func timeDurationLabelText(quizResults: QuizResults) -> String {
        return "• It took you \(quizResults.totalTimeToAnswer.timeString) to finish"
    }
    
    func dateTakenText(quizResults: QuizResults) -> String {
        guard let dateTaken = quizResults.dateTaken else {
            SALog("Warning: Quiz Results doesn't have a date taken...")
            return ""
        }
        let dateTakenString = SADateFormatter.shared.dateStringFor(date: dateTaken,
                                                                   monthFormat: .full,
                                                                   includeDay: true)
        return "Completed on: \(dateTakenString)"
    }
    
    func scoreLabelText(quizResults: QuizResults) -> String {
        return quizResults.scoreString
    }

    class var nib: UINib? {
        return UINib(nibName: String(describing: HomeTableViewCell.self), bundle: Bundle.main)
    }
    
    class var defaultHeight: CGFloat {
        return 120.0
    }
}
