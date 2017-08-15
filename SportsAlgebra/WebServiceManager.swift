//
//  WebServiceManager.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 6/30/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class WebServiceManager {
    static let shared = WebServiceManager()
    
    let quizWebService = QuizWebService()
    let userWebService = UserWebService()
}
