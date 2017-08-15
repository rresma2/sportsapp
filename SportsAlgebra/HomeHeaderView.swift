//
//  HomeHeaderView.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/10/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var rewardsButton: UIButton!
    
    // MARK: Properties
    
    var user: PFUser?
    
    // MARK: IBAction
    
    @IBAction func leftButtonTapped(_ sender: Any) {
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
    }
    
    // MARK: UIView
    
    override func awakeFromNib() {
        headerLabel.font = SAThemeService.shared.mediumFont(size: .primary)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let user = user, user.profileImageView != nil {
            self.profileImageView.layer.cornerRadius = 0.0
        } else {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        }
    }
    
    // MARK: HomeHeaderView
    
    func configure(user: PFUser?) {
        self.user = user
        
        self.configureProfileImageFor(user: user)
    }
    
    func configureProfileImageFor(user: PFUser?) {
        self.placeholderImageView.isHidden = user?.profileImageView != nil
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.masksToBounds = true
        self.rewardsButton.isUserInteractionEnabled = false
        self.rewardsButton.alpha = 0.4
        self.statsButton.isUserInteractionEnabled = false
        self.statsButton.alpha = 0.4
    }
}
