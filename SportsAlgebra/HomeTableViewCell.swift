//
//  HomeTableViewCell.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/12/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var questionsCorrectLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var dateTakenLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    // MARK: UITableViewCell
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: HomeTableViewCell
    
    func commonInit() {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.borderView.layer.cornerRadius = self.borderView.frame.size.width / 2
    }
    
    func configure(quizResults: QuizResults) {
        
    }

    class var nib: UINib? {
        return UINib(nibName: String(describing: HomeTableViewCell.self), bundle: Bundle.main)
    }
    
    class var defaultHeight: CGFloat {
        return 120.0
    }
}
