//
//  QuizResultsViewModel.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizResultsViewModel: NSObject {
    var results: QuizResults
    var didSelectHandler: ((Quiz, Answer, Int) -> Void)?
    var tableView: UITableView!
    
    init(quizResults: QuizResults) {
        self.results = quizResults
    }
    
    func configure(tableView: UITableView) {
        tableView.register(QuizResultsTableViewCell.nib,
                           forCellReuseIdentifier: String(describing: QuizResultsTableViewCell.self))
        tableView.backgroundColor = .black
        self.tableView = tableView
    }
}

extension QuizResultsViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < results.quiz.questions.count,
            let questionResponse = results.questionResponseFor(index: indexPath.row) else {
                return
        }
        
        let userAnswer = Answer(questionResponse: questionResponse)
        self.didSelectHandler?(results.quiz, userAnswer, indexPath.row)
    }
}

extension QuizResultsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizResultsTableViewCell.self),
                                                 for: indexPath) as! QuizResultsTableViewCell
        cell.selectionStyle = .none
        if  let question = results.questionFor(index: indexPath.row),
            let questionResponse = results.questionResponseFor(index: indexPath.row) {
            
            cell.configure(indexPath: indexPath,
                           question: question,
                           questionResponse: questionResponse)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.quiz.questions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuizResultsTableViewCell.defaultHeight
    }
}
