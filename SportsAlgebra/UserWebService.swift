//
//  UserWebService.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/24/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class UserWebService {
    func getUserQuizResults(user: PFUser, limit: Int, page: Int, completion: @escaping ([QuizResults]?, SAError?) -> Void) {
        let query = PFQuery(className: "QuizResults")
        query.limit = limit
        query.skip = page * limit
        query.whereKey("user", equalTo: user)
        query.includeKey("user")
        query.includeKey("quiz")
        
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                let nserror = error as NSError
                completion(nil, SAError(error: nserror))
            } else if let quizResultsDTOList = objects as? [QuizResultsDTO] {
                do {
                    completion(try quizResultsDTOList.map({ try QuizResults(quizResults: $0) }), nil)
                } catch {
                    completion(nil, SAError(code: ErrorCode.parseDeserializationError.rawValue, message: "Failed to parse server response"))
                }
            }
        }
    }
}
