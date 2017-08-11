//
//  SAProvisioning.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/9/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum SAProvisioningType {
    case login
    case signup
    case fbLogin
    case fbSignup
    
    var errorTitle: String {
        switch self {
        case .login:
            return "Error Logging in"
        case .fbLogin:
            return "Facebook Login Error"
        case .fbSignup:
            return "Facebook Login Error"
        case .signup:
            return "Error Signing Up"
        }
    }
}

class SAProvisioning {
    static let shared = SAProvisioning()
    
    func isUserLoggedInOnFacebook() -> Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func isUserLoggedIn() -> Bool {
        return PFUser.current() != nil
    }
    
    func loginWithFacebook(provisioningType: SAProvisioningType, completion: @escaping (PFUser?, SAError?) -> Void) {
        let permissions = ["user_about_me", "user_relationships",
                           "user_birthday", "user_location"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions, block: { (user, error) in
            self.execute(completion: completion,
                         with: user,
                         error: error,
                         provisioningType: provisioningType)
        })
    }
    
    func login(username: String, password: String, completion: @escaping (PFUser?, SAError?) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
            self.execute(completion: completion,
                         with: user,
                         error: error,
                         provisioningType: .login)
        })
    }
    
    func signup(user: PFUser, completion: @escaping (PFUser?, SAError?) -> Void) {
        user.signUpInBackground(block: { (success, error) in
            self.execute(completion: completion,
                         with: success ? (PFUser.current() ?? nil) : nil,
                         error: !success ? (error ?? nil) : nil,
                         provisioningType: .signup)
        })
    }
    
    func execute(completion: @escaping (PFUser?, SAError?) -> Void,
                 with user: PFUser?,
                 error: Error?,
                 provisioningType: SAProvisioningType) {
        if let user = user {
            completion(user, nil)
        } else if let error = error {
            completion(nil, SAError(error: error as NSError))
        } else {
            completion(nil, SAError(code: -1, message: "Unexpectedly found neither an error nor a user"))
        }
    }
}
