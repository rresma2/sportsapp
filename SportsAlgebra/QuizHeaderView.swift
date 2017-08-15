//
//  QuizHeaderView.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizHeaderView: UITableViewHeaderFooterView {
    var context: QuizContext?
    @IBOutlet weak var headerLabel: UILabel!
    
    func configureFor(question: Question, context: QuizContext) {
        self.headerLabel.text = question.text
        self.headerLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        self.contentView.backgroundColor = .black
        self.context = context
    }
    
    class var nib: UINib? {
        return UINib(nibName: String(describing: QuizHeaderView.self), bundle: Bundle.main)
    }
    
    class var defaultHeight: CGFloat {
        return 104.0
    }
}
