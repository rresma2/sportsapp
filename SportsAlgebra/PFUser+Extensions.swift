//
//  PFUser+Extensions.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/12/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

extension PFUser {
    var hasTakenFirstQuiz: Bool {
        return [self.object(forKey: FirstQuiz.favoriteTeam),
                self.object(forKey: FirstQuiz.favoriteTeamPlayer),
                self.object(forKey: FirstQuiz.favoriteTeamSport),
                self.object(forKey: FirstQuiz.numSportsPlayed)].flatMap({ $0 }).isEmpty == false
    }
    
    var quizzesTaken: [String] {
        return self.object(forKey: "quizzesTaken") as? [String] ?? []
    }
    
    func hasTaken(quiz: String) -> Bool {
        return quizzesTaken.contains(quiz)
    }
    
    func record(quizId: String) {
        self.add(quizId, forKey: "quizzesTaken")
    }
    
    func recordAnswersFromFirst(quiz: Quiz) -> Bool {
        guard quiz.questions.count == 4 else {
            SALog("Incorrect number of questions from first quiz")
            return false
        }
        
        guard quiz.questions.map({ $0.questionSubject}).filter({ $0 == .firstQuiz }).count == 4 else {
            SALog("One or more question is not the correct question subject type")
            return false
        }
        
        let howManySportsDoYouPlayQuestion = quiz.questions[0]
        let favoriteTeamSportQuestion = quiz.questions[1]
        let favoriteTeamQuestion = quiz.questions[2]
        let favoriteTeamPlayerQuestion = quiz.questions[3]
        
        guard let howManySportsAnswer = howManySportsDoYouPlayQuestion.userAnswers.first else {
            SALog("User did not specify how many sports he/she played...")
            return false
        }
        
        guard let numSportsPlayed = Int(howManySportsAnswer.text) else {
            SALog("how many sports played response is not an Int")
            return false
        }
        
        guard let favoriteTeamSport = favoriteTeamSportQuestion.userAnswers.first?.text else {
            SALog("User did not specify favorite team sport")
            return false
        }
        
        guard let favoriteTeam = favoriteTeamQuestion.userAnswers.first?.text else {
            SALog("User did not specify favorite team question")
            return false
        }
        
        guard let favoriteTeamPlayer = favoriteTeamPlayerQuestion.userAnswers.first?.text else {
            SALog("User did not specify favorite team player")
            return false
        }
        
        self.setObject(numSportsPlayed, forKey: FirstQuiz.numSportsPlayed)
        self.setObject(favoriteTeam, forKey: FirstQuiz.favoriteTeam)
        self.setObject(favoriteTeamSport, forKey: FirstQuiz.favoriteTeamSport)
        self.setObject(favoriteTeamPlayer, forKey: FirstQuiz.favoriteTeamPlayer)
        
        return true
    }
    
    var profileImageView: PFFile? {
        return self.object(forKey: "profileImageView") as? PFFile
    }
    
    var name: String {
        return self.object(forKey: "fullName") as? String ?? self.username ?? ""
    }
    
    func saveProfile(image: UIImage, completion: @escaping (Bool, SAError?) -> Void) {
        
        // create image data
        
        guard let imageData = UIImagePNGRepresentation(image) else {
            completion(false, SAError(code: -1, message: "Failed to convert UIImage to Data."))
            return
        }
        
        // create parse file
        
        guard let profileImageFile = PFFile(data: imageData) else {
            completion(false, SAError(code: -1, message: "Failed to create PFFile from Data."))
            return
        }
        
        // save image on Parse
        
        profileImageFile.saveInBackground(block: { (success, error) in
            self.setObject(profileImageFile, forKey: "profileImage")
            self.saveInBackground(block: { (success, error) in
                if let error = error {
                    let nserror = error as NSError
                    completion(false, SAError(error: nserror))
                } else {
                    completion(success, nil)
                }
            })
        })
    }
}
