//
//  QuizDTO.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/12/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizDTO: PFObject {
    @NSManaged var questions: [PFObject]
    @NSManaged var title: String!
    
    // MARK: Optimization
    
    @NSManaged var questionIds: [String]!
    @NSManaged var tokens: [String]!
    @NSManaged var isRequiredList: [NSNumber]!
    @NSManaged var timeLimits: [NSNumber]!
    @NSManaged var questionTypes: [NSNumber]!
    
    override init() {
        super.init()
    }
    
    init(quiz: Quiz) throws {
        super.init()
        
        questions = try quiz.questions.flatMap({ try QuestionDTO(objectId: $0.serverId) })
        title = quiz.title
        questionIds = quiz.questions.flatMap({ $0.serverId })
        tokens = quiz.questions.map({ $0.tokens }).flatMap({ $0 })
        isRequiredList = quiz.questions.map({ NSNumber(booleanLiteral: $0.isRequired) })
        timeLimits = quiz.questions.flatMap({ $0.timeLimit }).map({ NSNumber(floatLiteral: $0) })
        questionTypes = quiz.questions.map({ NSNumber(integerLiteral: $0.questionType.rawValue) })
    }
}

extension QuizDTO: PFSubclassing {
    static func parseClassName() -> String {
        return "Quiz"
    }
}
