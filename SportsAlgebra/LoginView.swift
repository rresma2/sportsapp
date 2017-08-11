//
//  LoginView.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/11/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

protocol LoginViewDelegate {
    func login(view: LoginView, loginTapped: UIButton)
    func login(view: LoginView, facebookTapped: UIButton)
}

class LoginView: UIView {
    
    // MARK: Properties
    
    var delegate: LoginViewDelegate?
    
    // MARK: Constraints
    
    @IBOutlet weak var loginWrapperCenter: NSLayoutConstraint!
    
    // MARK: Subviews
    
    @IBOutlet weak var loginWrapper: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButtonWrapper: UIButton!
    @IBOutlet weak var loginButtonTitle: UILabel!
    
    // MARK: IBAction
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        delegate?.login(view: self, loginTapped: loginButton)
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        delegate?.login(view: self, facebookTapped: facebookButtonWrapper)
    }
    
    // MARK: UIView
    
    override func awakeFromNib() {
        loginWrapper.layer.borderColor = UIColor.lightGray.cgColor
        loginWrapper.layer.borderWidth = 1.0
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        headerLabel.font = SAThemeService.shared.mediumFont(size: .header)
        usernameLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        usernameTextField.font = SAThemeService.shared.primaryFont(size: .secondary)
        
        passwordLabel.font = SAThemeService.shared.primaryFont(size: .primary)
        passwordTextField.font = SAThemeService.shared.primaryFont(size: .secondary)
        
        loginButton.titleLabel?.font = SAThemeService.shared.primaryFont(size: .primary)
        loginButtonTitle.font = SAThemeService.shared.primaryFont(size: .primary)
    }
}

extension LoginView: ReturnUserInformable {
    var username: String {
        return self.usernameTextField?.text ?? ""
    }
    var password: String {
        return self.passwordTextField?.text ?? ""
    }
}

extension LoginView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case usernameTextField:
            return usernameTextField.text?.characters.count ?? 0 + string.characters.count <= 24
        case passwordTextField:
            return passwordTextField.text?.characters.count ?? 0 + string.characters.count <= 40
        default:
            return true
        }
    }
}

extension LoginView {
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
        return 100.0
    }
    
    func adjustViewsFor(note: Notification) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: note.keyboardAnimationDuration(), animations: {
                self.loginWrapperCenter.constant = note.isKeyboardDismissing() ? 0.0 : -self.keyboardOffset
            })
        }
    }
}
