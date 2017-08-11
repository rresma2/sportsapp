//
//  SignupView.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/11/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

protocol SignupViewDelegate {
    func signup(view: SignupView, signupTapped: UIButton)
    func signup(view: SignupView, facebookTapped: UIButton)
}

class SignupView: UIView {
    
    // MARK: Properties
    
    var delegate: SignupViewDelegate?
    var originalCenter: CGFloat?
    
    // MARK: Constraints
    
    @IBOutlet weak var signupWrapperCenter: NSLayoutConstraint!
    
    // MARK: Subview
    
    @IBOutlet weak var signupWrapper: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var facebookButtonWrapper: UIButton!
    @IBOutlet weak var signupButtonLabel: UILabel!
    
    // MARK: IBAction
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        delegate?.signup(view: self, signupTapped: signupButton)
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        delegate?.signup(view: self, facebookTapped: facebookButtonWrapper)
    }
    
    // MARK: UIView
    
    override func awakeFromNib() {
        originalCenter = self.signupWrapperCenter.constant
        signupWrapper.layer.borderColor = UIColor.lightGray.cgColor
        signupWrapper.layer.borderWidth = 1.0
        
        headerLabel.font = SAThemeService.shared.mediumFont(size: .header)
        
        emailLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        emailTextField.font = SAThemeService.shared.primaryFont(size: .secondary)
        
        usernameLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        usernameTextField.font = SAThemeService.shared.primaryFont(size: .secondary)
        
        passwordLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        passwordTextField.font = SAThemeService.shared.primaryFont(size: .secondary)
        
        signupButton.titleLabel?.font = SAThemeService.shared.primaryFont(size: .primary)
        signupButtonLabel.font = SAThemeService.shared.primaryFont(size: .primary)
    }
}

extension SignupView: NewUserInformable {
    var username: String {
        return self.usernameTextField?.text ?? ""
    }
    
    var password: String {
        return self.passwordTextField?.text ?? ""
    }
    
    var email: String {
        return self.emailTextField?.text ?? ""
    }
}

extension SignupView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case usernameTextField:
            return usernameTextField.text?.characters.count ?? 0 + string.characters.count <= 24
        case passwordTextField:
            return passwordTextField.text?.characters.count ?? 0 + string.characters.count <= 40
        case emailTextField:
            return passwordTextField.text?.characters.count ?? 0 + string.characters.count <= 40
        default:
            return true
        }
    }
}

extension SignupView {
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardFrameWillChange(note: Notification) {
        adjustViewsFor(note: note)
    }
    
    var keyboardOffset: CGFloat {
        return 148.0
    }
    
    func adjustViewsFor(note: Notification) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: note.keyboardAnimationDuration(), animations: {
                self.signupWrapperCenter.constant = note.isKeyboardDismissing() ? 0.0 : -self.keyboardOffset
            })
        }
    }
    
    func getFirstResponderTop() -> CGFloat? {
        if usernameTextField.isFirstResponder {
            return usernameTextField.frame.origin.y
        } else if passwordTextField.isFirstResponder {
            return passwordTextField.frame.origin.y
        } else if emailTextField.isFirstResponder {
            return emailTextField.frame.origin.y
        }
        return nil
    }
}
