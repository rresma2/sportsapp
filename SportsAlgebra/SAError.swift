//
//  SAError.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/9/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum ErrorCode: Int {
    case unknown = -1
    case invalidSignup = 4201
    case invalidLogin = 4202
    case parseSerializationError = 4203
    case parseDeserializationError = 4204
}

class SAError {
    let code: Int
    let message: String
    var domain: String?
    
    init(error: NSError) {
        self.code = error.code
        
        if let userInfo = error.userInfo as? [String: AnyObject],
            let message = userInfo["error"] as? String {
                self.message = message
        } else {
            self.message = error.localizedDescription
        }
        
        self.domain = error.domain
    }
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}
