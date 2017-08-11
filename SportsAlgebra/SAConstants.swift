//
//  SAConstants.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/9/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case head = "HEAD"
}

enum HTTPHeaderField: String {
    case authorization = "Authorization"
}

enum HTTPQueryKey {
    enum SportsAPI {
        static let date = "fordate"
    }
}

enum TransitionType {
    case presenting
    case dismissing
}

enum Sports: String {
    case basketball = "Basketball"
    case soccer = "Soccer"
    case baseball = "Baseball"
    case football = "Football"
    case hockey = "Hockey"
}

protocol SAResponseType {
    
}
