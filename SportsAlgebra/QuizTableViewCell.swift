//
//  QuizTableViewCell.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    // MARK: Properties
    
    var context: QuizContext?
    var textFieldDelegate: UITextFieldDelegate?
    var questionChangeListener: Disposable?
    var shouldResignResponderOnNextQuestion: Bool = false
    
    // MARK: IBOutlets
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var iconWrapperView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var correctionStateImageView: UIImageView!
    @IBOutlet weak var correctionStateBackground: UIView! // The checkmark icon doesn't have a filled center, so I'm making my own
    
    // MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconWrapperView.layer.cornerRadius = self.iconWrapperView.frame.size.width / 2
        self.iconView.layer.cornerRadius = self.iconView.frame.size.width / 2
    }
    
    // MARK: UITableViewCell
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.backgroundColor = UIColor(r: 100,
                                           g: 100,
                                           b: 100,
                                           a: 0.2)
            self.iconWrapperView.isHidden = false
        } else {
            self.backgroundColor = .black
            self.iconWrapperView.isHidden = true
        }
    }
    
    // MARK: QuizTableViewCell
    
    func configure(answer: Answer, questionType: QuestionType, context: QuizContext, textFieldDelegate: UITextFieldDelegate, userAnswer: Answer?, correctAnswer: Answer?) {
        self.context = context
        self.backgroundColor = .black
        
        answerLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        answerLabel.text = answer.text
        answerLabel.isHidden = questionType.isInput
        
        answerTextField.isHidden = !questionType.isInput
        answerTextField.keyboardType = questionType == .numericInput ? .decimalPad : .default
        answerTextField.reloadInputViews()
        answerTextField.text = userAnswer?.text ?? answer.text
        answerTextField.isUserInteractionEnabled = userAnswer == nil
        answerTextField.delegate = textFieldDelegate
        answerTextField.backgroundColor = questionType.isInput ? self.backgroundColor : .clear
        answerTextField.attributedPlaceholder = NSAttributedString(string: "Your answer", attributes: [NSForegroundColorAttributeName: UIColor(r: 250, g: 250, b: 250, a: 0.2)])
        answerTextField.textColor = .white
        answerTextField.font = SAThemeService.shared.primaryFont(size: .primary)
        
        if !answerTextField.isHidden, userAnswer == nil {
            answerTextField.becomeFirstResponder()
        } else {
            answerTextField.resignFirstResponder()
        }
        
        iconWrapperView.isHidden = questionType.isInput || userAnswer != nil ? true : !answer.isSelected
        correctionStateImageView.isHidden = userAnswer == nil
        correctionStateBackground.isHidden = userAnswer == nil
        
        if let userAnswer = userAnswer,
            let correctAnswer = correctAnswer {
                correctionStateImageView.image = userAnswer == correctAnswer ? #imageLiteral(resourceName: "correct_icon") : #imageLiteral(resourceName: "incorrect_icon")
        } else {
            correctionStateImageView.image = nil
        }
    }
    
    func configureForNext(question: Question) {
        //shouldResignResponderOnNextQuestion = !question.questionType.isInput
    }
    
    func questionIndexDidChange(intValue: Int) {
        /*
        if shouldResignResponderOnNextQuestion {
            answerTextField?.resignFirstResponder()
        } else {
            
        }
        */
    }
    
    class var nib: UINib? {
        return UINib(nibName: String(describing: QuizTableViewCell.self), bundle: Bundle.main)
    }
    
    class var defaultHeight: CGFloat {
        return 54.0
    }
}
