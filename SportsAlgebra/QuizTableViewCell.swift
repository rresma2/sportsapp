//
//  QuizTableViewCell.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var iconWrapperView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var answerTextField: UITextField!
    
    var context: QuizContext?
    var textFieldDelegate: UITextFieldDelegate?
    var questionChangeListener: Disposable?
    var shouldResignResponderOnNextQuestion: Bool = false
    
    // MARK: QuizTableViewCell
    
    func configure(answer: Answer, questionType: QuestionType, context: QuizContext, textFieldDelegate: UITextFieldDelegate) {
        self.context = context
        self.backgroundColor = .black
        
        answerLabel.text = answer.text
        answerLabel.isHidden = questionType.isInput
        answerTextField.isHidden = !questionType.isInput
        if !answerTextField.isHidden {
            answerTextField.becomeFirstResponder()
        } else {
            answerTextField.resignFirstResponder()
        }
        answerTextField.text = answer.text
        answerTextField.delegate = textFieldDelegate
        answerTextField.backgroundColor = questionType.isInput ? self.backgroundColor : .clear
        answerTextField.attributedPlaceholder = NSAttributedString(string: "Your answer", attributes: [NSForegroundColorAttributeName: UIColor(r: 250, g: 250, b: 250, a: 0.2)])
        answerTextField.textColor = .white
        
        iconWrapperView.isHidden = questionType.isInput ? true : !answer.isSelected
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconWrapperView.layer.cornerRadius = self.iconWrapperView.frame.size.width / 2
        self.iconView.layer.cornerRadius = self.iconView.frame.size.width / 2
    }
    
    class var nib: UINib? {
        return UINib(nibName: String(describing: QuizTableViewCell.self), bundle: Bundle.main)
    }
    
    class var defaultHeight: CGFloat {
        return 54.0
    }
}
