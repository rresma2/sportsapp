//
//  QuizResultsTableViewCell.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizResultsTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet

    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionInformationLabel: UILabel!
    @IBOutlet weak var correctionStateImageView: UIImageView!
    
    // MARK: UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.questionTitleLabel.font = SAThemeService.shared.mediumFont(size: .primary)
        self.questionInformationLabel.font = SAThemeService.shared.primaryFont(size: .secondary)
        self.correctionStateImageView.image = nil
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
    
    // MARK: QuizResultsTableViewCell
    
    func configure(indexPath: IndexPath, question: Question, questionResponse: QuestionResponse) {
        
        // Question Number
        
        self.questionTitleLabel.text = "Q\(indexPath.row + 1)."
        
        // Time To Answer 
        
        if let timeToAnswer = questionResponse.timeToAnswer {
            self.questionInformationLabel.text = "Your Time - \(timeToAnswer.timeString)"
        } else {
            self.questionInformationLabel.text = "Your response - \(questionResponse.userResponse)"
        }
        
        // Correct / Incorrect State
        
        if let correctAnswer = question.correctAnswers?.first {
            self.correctionStateImageView.image = correctAnswer.text == questionResponse.userResponse ? #imageLiteral(resourceName: "correct_icon") : #imageLiteral(resourceName: "incorrect_icon")
        } else {
            self.correctionStateImageView.image = nil
        }
    }
    
    class var nib: UINib? {
        return UINib(nibName: String(describing: QuizResultsTableViewCell.self), bundle: Bundle.main)
    }
    
    class var defaultHeight: CGFloat {
        return 54.0
    }

}
