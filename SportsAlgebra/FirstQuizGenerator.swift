//
//  FirstQuizGenerator.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

class FirstQuizGenerator: QuizGenerator {
    class var firstQuiz: Quiz {
        let generator = FirstQuizGenerator()
        return Quiz(questions: [generator.generateHowManySportsDoYouPlayQuestion(),
                                generator.generateFavoriteTeamSportQuestion(),
                                generator.generateFavoriteTeamQuestion(),
                                generator.generateFavoriteTeamPlayerQuestion()
            ])
    }
    
    func generateHowManySportsDoYouPlayQuestion() -> Question {
        return Question(text: "How many team sports do you play?",
                        answers: (1...4).map({ return Answer(int: $0) }) + [Answer(text: "5 or more")],
                        questionType: .multipleChoice,
                        questionSubject: .firstQuiz,
                        timeLimit: nil)
    }
    
    func generateFavoriteTeamSportQuestion() -> Question {
        return Question(text: "What's your favorite team sport?",
                        answers: [.basketball(label: "a"),
                                  .soccer(label: "b"),
                                  .baseball(label: "c"),
                                  .football(label: "d"),
                                  .hockey(label: "e")],
                        questionType: .multipleChoice,
                        questionSubject: .firstQuiz,
                        timeLimit: nil)
    }
    
    func generateFavoriteTeamQuestion() -> Question {
        return Question(text: "What's your favorite team?",
                        answers: [Answer(text: "")],
                        questionType: .input,
                        questionSubject: .firstQuiz,
                        timeLimit: nil)
    }
    
    func generateFavoriteTeamPlayerQuestion() -> Question {
        return Question(text: "Who's your favorite team player?",
                        answers: [Answer(text: "")],
                        questionType: .input,
                        questionSubject: .firstQuiz,
                        timeLimit: nil)
    }
}
