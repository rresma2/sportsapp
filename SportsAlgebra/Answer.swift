//
//  Answer.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 6/30/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

class Answer: NSObject {
    
    // MARK: Properties
    
    var isSelectedChange = Event<Bool>()
    var isSelected: Bool = false {
        didSet {
            isSelectedChange.raise(data: isSelected)
        }
    }
    var textChange = Event<String>()
    var text: String! {
        didSet {
            textChange.raise(data: text)
        }
    }
    
    var label: String?
    
    // MARK: Computed Properties
    
    var dictionary: [String: String] {
        var result = [String: String]()
        result["label"] = label ?? ""
        result["text"] = text ?? ""
        return result
    }
    
    // MARK: Init
    
    init(text: String, label: String? = nil) {
        self.text = text
        self.label = label
    }
    
    init(int: Int) {
        self.text = "\(int)"
    }
    
    init(questionResponse: QuestionResponse) {
        self.text = questionResponse.userAnswers.first?["text"] ?? ""
        self.label = questionResponse.userAnswers.first?["label"] ?? ""
    }
    
    // MARK: Equatable
    
    override func isEqual(_ object: Any?) -> Bool {
        return super.isEqual(object) || text == (object as? Answer)?.text
    }
}

extension Answer {
    class func basketball(label: String? = nil) -> Answer {
        return Answer(text: Sports.basketball.rawValue,
                      label: label)
    }
    
    class func soccer(label: String? = nil) -> Answer {
        return Answer(text: Sports.soccer.rawValue,
                      label: label)
    }
    
    class func baseball(label: String? = nil) -> Answer {
        return Answer(text: Sports.baseball.rawValue,
                      label: label)
    }
    
    class func football(label: String? = nil) -> Answer {
        return Answer(text: Sports.football.rawValue,
                      label: label)
    }
    
    class func hockey(label: String? = nil) -> Answer {
        return Answer(text: Sports.hockey.rawValue,
                      label: label)
    }
}
