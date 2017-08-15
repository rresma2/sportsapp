//
//  QuizWebService.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/24/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizWebService {
    func save(quiz: Quiz, for user: PFUser, completion: @escaping (Bool, SAError?) -> Void) {
        guard let quizId = quiz.serverId else {
            completion(false, SAError(code: -1, message: "Quiz doesn't have an objectId"))
            return
        }
        
        if user.hasTaken(quiz: quizId) {
            self.update(quiz: quiz,
                        for: user,
                        completion: completion)
        } else {
            self.createAndSave(quiz: quiz,
                               for: user,
                               completion: completion)
        }
    }
    
    func update(quiz: Quiz, for user: PFUser, completion: @escaping (Bool, SAError?) -> Void) {
        guard let quizId = quiz.serverId else {
            completion(false, SAError(code: -1, message: "Quiz doesn't have an objectId"))
            return
        }
        
        let query = PFQuery(className: "QuizResults")
        query.includeKey("user")
        query.includeKey("quiz")
        query.getObjectInBackground(withId: quizId) { (object, error) in
            if error != nil {
                self.createAndSave(quiz: quiz,
                                   for: user,
                                   completion: completion)
            } else if let quizResults = object as? QuizResultsDTO {
                quizResults.questionResponses = quiz.questionResponses.map({ $0.dictionary })
                quizResults.totalTimeToAnswer = NSNumber(floatLiteral: quiz.questionResponses.flatMap({ $0.timeToAnswer }).reduce(0, +))
                quizResults.numberCorrect = NSNumber(integerLiteral: quiz.numberCorrect)
                quizResults.dateTaken = Date()
            }
        }
    }
    
    func createAndSave(quiz: Quiz, for user: PFUser, completion: @escaping (Bool, SAError?) -> Void) {
        guard let quizId = quiz.serverId else {
            completion(false, SAError(code: -1, message: "Quiz doesn't have an objectId"))
            return
        }
        // Update the current user to make sure he doesn't take the same quiz again
        
        PFUser.current()?.record(quizId: quizId)
        
        // Create a quiz results object
        
        let quizResults = QuizResults(quiz: quiz,
                                      user: user,
                                      dateTaken: Date())
        
        guard let quizResultsDTO = try? QuizResultsDTO(quizResults: quizResults) else {
            let message = "Failed to serialize parse class: \(QuestionDTO.parseClassName())"
            SALog(message)
            completion(false, SAError(code: ErrorCode.parseSerializationError.rawValue, message: message))
            return
        }
        
        // Save to parse
        
        quizResultsDTO.saveInBackground(block: { (success, error) in
            if let error = error {
                let nserror = error as NSError
                completion(false, SAError(error: nserror))
            } else {
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if let error = error {
                        let nserror = error as NSError
                        SALog("Failed to update current user with error: \(nserror)")
                    }
                    
                    completion(success, nil)
                })
            }
        })
    }
    
    func chooseQuiz(completion: @escaping (Quiz?, SAError?) -> Void) {
        let query1 = PFQuery(className: "Quiz")
        query1.includeKey("questions")
        let quizzesTakenList = PFUser.current()?.quizzesTaken ?? []
        
        if !quizzesTakenList.isEmpty {
            query1.whereKey("objectId", notContainedIn: quizzesTakenList)
        }
        
        query1.findObjectsInBackground { (objects, error) in
            if let error = error {
                let nserror = error as NSError
                completion(nil, SAError(error: nserror))
                SALog("Server error: \(error.localizedDescription)")
            } else if let quizzes = objects as? [QuizDTO] {
                var chosenQuiz: Quiz?
                for quiz in quizzes {
                    if let validatedQuiz = self.validated(quiz: quiz) {
                        chosenQuiz = validatedQuiz
                    }
                }
                
                if let chosenQuiz = chosenQuiz {
                    SALog("Found a quiz the user hasn't taken yet! Passing it through")
                    completion(chosenQuiz, nil)
                } else {
                    SALog("User has taken all the quizzes he can take. Creating a new one")
                    self.createQuiz(completion: completion)
                }
            }
        }
    }
    
    func validated(quiz: QuizDTO) -> Quiz? {
        do {
            return try Quiz(quizDTO: quiz)
        } catch {
            SALog("Failed to deserialize question with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createQuiz(completion: @escaping (Quiz?, SAError?) -> Void) {
        let query1 = PFQuery(className: "Question")
        query1.getFirstObjectInBackground { (object, error) in
            if let error = error {
                let nserror = error as NSError
                completion(nil, SAError(error: nserror))
            } else if let questionDTO = object as? QuestionDTO {
                if let gameId = questionDTO.gameId {
                    self.createGameQuiz(gameId: gameId, completion: completion)
                }
                // TODO: create one for players
            }
        }
    }
    
    func createGameQuiz(gameId: String, completion: @escaping (Quiz?, SAError?) -> Void) {
        createQuizWith(key: "gameId", value: gameId, completion: completion)
    }
    
    func createQuizWith(key: String, value: String, completion: @escaping (Quiz?, SAError?) -> Void) {
        let query1 = PFQuery(className: "Question")
        query1.whereKey(key, equalTo: value)
        query1.limit = 10
        query1.skip = Int(arc4random_uniform(5) * 10)
        query1.findObjectsInBackground { (objects, error) in
            if let error = error {
                let nserror = error as NSError
                completion(nil, SAError(error: nserror))
                SALog("Server error: \(error.localizedDescription)")
            } else if let questionDTOList = objects as? [QuestionDTO] {
                do {
                    let currentQuiz = try Quiz(questions: questionDTOList.map({ try Question.init(questionDTO: $0) }))
                    let quizDTO = try QuizDTO(quiz: currentQuiz)
                    quizDTO.saveInBackground(block: { (success, error) in
                        completion(currentQuiz, nil)
                    })
                } catch is QuestionDTOError {
                    completion(nil, SAError(code: ErrorCode.parseDeserializationError.rawValue, message: "Failed to serialize parse class: \(QuestionDTO.parseClassName())"))
                } catch {
                    completion(nil, SAError(code: ErrorCode.parseDeserializationError.rawValue, message: "Something went wrong."))
                }
            }
        }
    }
}
