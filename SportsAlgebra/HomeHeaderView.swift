//
//  HomeHeaderView.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/10/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

protocol HomeHeaderViewDelegate {
    func homeHeaderView(_ headerView: HomeHeaderView, leftButtonTapped button: UIButton)
    func homeHeaderView(_ headerView: HomeHeaderView, rightButtonTapped button: UIButton)
}

class HomeHeaderView: UIView {
    
    // MARK: Properties
    
    var user: PFUser?
    var delegate: HomeHeaderViewDelegate?
    var originalHomeTown: String?
    var originalEmail: String?
    
    // MARK: IBOutlet
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var homeTownTextField: UITextField?
    @IBOutlet weak var emailTextField: UITextField?
    
    // MARK: IBAction
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        delegate?.homeHeaderView(self, leftButtonTapped: leftButton)
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        delegate?.homeHeaderView(self, rightButtonTapped: rightButton)
    }
    
    // MARK: UIView
    
    override func awakeFromNib() {
        headerLabel.font = SAThemeService.shared.mediumFont(size: .primary)
        emailTextField?.font = SAThemeService.shared.primaryFont(size: .primary)
        homeTownTextField?.font = SAThemeService.shared.primaryFont(size: .primary)
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
    
    var placeholderTextAttributes: [String: Any] {
        return [NSForegroundColorAttributeName: UIColor.init(r: 255, g: 255, b: 255, a: 0.4),
                NSFontAttributeName: SAThemeService.shared.primaryFont(size: .primary)]
    }
    
    var textFieldAttributes: [String: Any] {
        return [NSForegroundColorAttributeName: UIColor.init(r: 255, g: 255, b: 255, a: 1.0),
                NSFontAttributeName: SAThemeService.shared.primaryFont(size: .primary)]
    }
    
    func configure(user: PFUser?, delegate: HomeHeaderViewDelegate?) {
        self.user = user
        self.delegate = delegate
        
        self.originalHomeTown = user?.homeTown
        self.originalEmail = user?.email
        
        // Right Button
        
        self.rightButton.isUserInteractionEnabled = false
        self.rightButton.alpha = 0.4
        
        // Profile Pic
        
        self.placeholderImageView.isHidden = user?.profileImageView != nil
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.masksToBounds = true
        
        // Header Label
        
        self.headerLabel.text = user?.name
        
        // Email Address
        
        self.emailTextField?.text = nil
        self.emailTextField?.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: placeholderTextAttributes)
        if let email = user?.email {
            self.emailTextField?.attributedText = NSAttributedString(string: email, attributes: textFieldAttributes)
        } else {
            self.emailTextField?.attributedText = nil
        }
        self.emailTextField?.delegate = self
        
        // Home Town
        
        self.homeTownTextField?.text = nil
        self.homeTownTextField?.attributedPlaceholder = NSAttributedString(string: "Home Town", attributes: placeholderTextAttributes)
        if let homeTown = user?.homeTown {
            self.homeTownTextField?.attributedText = NSAttributedString(string: homeTown, attributes: textFieldAttributes)
        } else {
            self.homeTownTextField?.attributedText = nil
        }
        self.homeTownTextField?.delegate = self
    }
}

extension HomeHeaderView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return true
        }
        
        let result = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        let valueToCompare = textField == homeTownTextField ? (originalHomeTown ?? "") : (textField == emailTextField ? (originalEmail ?? "") : "")
        let currentValuesDeviateFromOriginal = result != valueToCompare
        rightButton.isUserInteractionEnabled = currentValuesDeviateFromOriginal
        rightButton.alpha = currentValuesDeviateFromOriginal ? 1.0 : 0.4
        return true
    }
}
