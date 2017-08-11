//
//  OnboardingViewModel.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/11/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

protocol ReturnUserInformable {
    var username: String { get }
    var password: String { get }
}

protocol NewUserInformable {
    var username: String { get }
    var password: String { get }
    var email: String { get }
}

enum OnboardingMessage {
    static let emptyUsername = "Please enter one or more characters for your username."
    static let nonAlphanumericUsername = "Please enter only alphanumeric characters for your username."
    static let emptyPassword = "Please enter one or more characters for your password."
    static let invalidEmail = "Invalid email address specified. Please try again."
}

typealias SAProvisioningCompletionHandler = ((PFUser?, SAError?) -> Void)

class OnboardingViewModel {
    var provisioning = SAProvisioning.shared
    var loginCompletionHandler: SAProvisioningCompletionHandler?
    var facebookLoginCompletionHandler: SAProvisioningCompletionHandler?
    var signupCompletionHandler: SAProvisioningCompletionHandler?
    var facebookSignupCompletionHandler: SAProvisioningCompletionHandler?
    
    func loginWithFacebook(provisioningType: SAProvisioningType, completion: @escaping (PFUser?, SAError?) -> Void) {
        provisioning.loginWithFacebook(provisioningType: provisioningType, completion: completion)
    }
    
    func login(informable: ReturnUserInformable, completion: @escaping (PFUser?, SAError?) -> Void) {
        let errorMessage = validate(informable: informable)
        guard errorMessage == nil else {
            completion(nil, SAError(code: ErrorCode.invalidLogin.rawValue,
                                    message: errorMessage ?? "Login Failed"))
            return
        }
        
        provisioning.login(username: informable.username.stripAndLower(),
                           password: informable.password.stripAndLower(),
                           completion: completion)
    }
    
    func validate(informable: ReturnUserInformable) -> String? {
        if let usernameError = validate(username: informable.username) {
            SALog(usernameError)
            return usernameError
        } else if let passwordError = validate(password: informable.password) {
            SALog(passwordError)
            return passwordError
        }
        return nil
    }
    
    func signup(informable: NewUserInformable, completion: @escaping (PFUser?, SAError?) -> Void) {
        let (user, errorMessage) = validate(informable: informable)
        guard let validatedUser = user else {
            completion(nil, SAError(code: ErrorCode.invalidSignup.rawValue,
                                    message: errorMessage ?? "Signup Failed"))
            return
        }
        
        provisioning.signup(user: validatedUser,
                            completion: completion)
    }
    
    func validate(informable: NewUserInformable) -> (PFUser?, String?) {
        if let emailError = validate(email: informable.email) {
            SALog(emailError)
            return (nil, emailError)
        } else if let usernameError = validate(username: informable.username) {
            SALog(usernameError)
            return (nil, usernameError)
        } else if let passwordError = validate(password: informable.password) {
            SALog(passwordError)
            return (nil, passwordError)
        }
        
        return (user(for: informable), nil)
    }
    
    func validate(username: String) -> String? {
        let name = username.stripAndLower()
        guard name.characters.count > 0 else {
            return OnboardingMessage.emptyUsername
        }
        guard name.isAlphanumeric else {
            return OnboardingMessage.nonAlphanumericUsername
        }
        return nil
    }
    
    func validate(password: String) -> String? {
        guard password.characters.count > 0 else {
            return OnboardingMessage.emptyPassword
        }
        return nil
    }
    
    func validate(email: String) -> String? {
        guard email.contains("@") else {
            SALog("No @ sign found...")
            return OnboardingMessage.invalidEmail
        }
        let splitArr = email.components(separatedBy: "@")
        
        guard splitArr.count == 2 else {
            SALog("malformed email. More than one @ sign")
            return OnboardingMessage.invalidEmail
        }
        
        guard splitArr[0].stripAndLower().characters.count > 0 else {
            SALog("no text before the @ sign")
            return OnboardingMessage.invalidEmail
        }
        
        guard splitArr[1].stripAndLower().characters.count > 0 else {
            SALog("no characters after the @ sign")
            return OnboardingMessage.invalidEmail
        }
        
        guard splitArr[1].contains(".") else {
            SALog("email doesn't contain a domain")
            return OnboardingMessage.invalidEmail
        }
        
        return nil
    }
    
    func user(for informable: NewUserInformable) -> PFUser {
        let user = PFUser()
        user.username = informable.username.stripAndLower()
        user.password = informable.password.stripAndLower()
        user.email = informable.email.stripAndLower()
        return user
    }
}

extension OnboardingViewModel: LoginViewDelegate {
    func login(view: LoginView, loginTapped: UIButton) {
        guard let completion = loginCompletionHandler else {
            SALog("Login button action failed. Did you remember to register a 'loginCompletionHandler'?")
            return
        }
        
        login(informable: view, completion: completion)
    }
    
    func login(view: LoginView, facebookTapped: UIButton) {
        guard let completion = facebookLoginCompletionHandler else {
            SALog("Facebook Login button action failed. Did you remember to register a 'facebookLoginCompletionHandler'?")
            return
        }
        
        loginWithFacebook(provisioningType: .fbLogin, completion: completion)
    }
}

extension OnboardingViewModel: SignupViewDelegate {
    func signup(view: SignupView, signupTapped: UIButton) {
        guard let completion = signupCompletionHandler else {
            SALog("Signup button action failed. Did you remember to register a 'signupCompletionHandler'?")
            return
        }
        
        signup(informable: view, completion: completion)
    }
    
    func signup(view: SignupView, facebookTapped: UIButton) {
        guard let completion = facebookSignupCompletionHandler else {
            SALog("Facebook Signup button action failed. Did you remember to register a 'facebookSignupCompletionHandler'?")
            return
        }
        
        loginWithFacebook(provisioningType: .fbSignup, completion: completion)
    }
}
