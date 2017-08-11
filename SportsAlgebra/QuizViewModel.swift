//
//  QuizViewModel.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/15/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizViewModel: NSObject {
    
    var quiz: Quiz
    var context: QuizContext
    var tableView: UITableView!
    
    var currentQuestionIndexChanged = Event<Int>()
    var currentQuestionIndex = 0 {
        willSet {
            currentQuestionIndexChanged.raise(data: newValue)
        }
        
        didSet {
            if let question = quiz.questionFor(index: currentQuestionIndex) {
                context.restart()
                
                if let lastQuestion = quiz.questionFor(index: currentQuestionIndex - 1),
                    lastQuestion.questionType.isInput,
                    question.questionType.isInput,
                    let answer = question.answerFor(index: 0),
                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? QuizTableViewCell {
                    
                    // we don't want to reload the entire table view because that dismisses the keyboard
                    
                    cell.configure(answer: answer,
                                   questionType: question.questionType,
                                   context: context,
                                   textFieldDelegate: self)
                } else {
                    tableView.reloadData()
                }
            }
        }
    }
    
    init(quiz: Quiz, context: QuizContext) {
        self.quiz = quiz
        self.context = context
    }
    
    func configure(tableView: UITableView) {
        tableView.register(QuizTableViewCell.nib,
                           forCellReuseIdentifier: String(describing: QuizTableViewCell.self))
        tableView.register(QuizHeaderView.nib,
                           forHeaderFooterViewReuseIdentifier: String(describing: QuizHeaderView.self))
        tableView.backgroundColor = .black
        tableView.isScrollEnabled = false
        self.tableView = tableView
    }
    
    func submitAnswers() {
        guard let currentQuestion = quiz.questionFor(index: currentQuestionIndex) else {
            SALog("Current question index is out of bounds")
            return
        }
        
        if let correctAnswers = currentQuestion.correctAnswers {
            if currentQuestion.checkAnswers() {
                context.userGotCorrect(answers: correctAnswers)
            } else {
                context.userGotIncorrectAnswers(userAnswers: currentQuestion.userAnswers,
                                                correctAnswers: correctAnswers)
            }
        }
        context.record(answeredQuestion: currentQuestion)
        
        advanceQuestionIndexIfNecessary()
    }
    
    var numberOfQuestionsRemaining: UInt {
        return UInt(quiz.questions.count - currentQuestionIndex)
    }
    
    func skipQuestion() {
        advanceQuestionIndexIfNecessary()
    }
    
    func advanceQuestionIndexIfNecessary() {
        guard quiz.questionFor(index: currentQuestionIndex + 1) != nil else {
            SALog("No more questions. Finishing Quiz")
            context.userFinished(quiz: quiz)
            return
        }
        
        currentQuestionIndex += 1
    }
}

extension QuizViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let question = quiz.questionFor(index: currentQuestionIndex) {
            if !question.questionType.isInput {
                self.didSelectMultipleChoiceAnswerAt(indexPath: indexPath,
                                                     for: question)
            } else {
                self.didSelectInputCellAt(indexPath: indexPath,
                                          for: question)
            }
        }
    }
    
    func didSelectMultipleChoiceAnswerAt(indexPath: IndexPath, for question: Question) {
        if let answer = question.answerFor(index: indexPath.row) {
            answer.isSelected = !answer.isSelected
        }
        
        question.userAnswers = question.selectedAnswers
    }
    
    func didSelectInputCellAt(indexPath: IndexPath, for question: Question) {
        (tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as? QuizTableViewCell)?.answerTextField.becomeFirstResponder()
    }
}

extension QuizViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizTableViewCell.self),
                                                 for: indexPath) as! QuizTableViewCell
        cell.selectionStyle = .none
        
        if let question = quiz.questionFor(index: currentQuestionIndex),
            let answer = question.answerFor(index: indexPath.row) {
                cell.configure(answer: answer,
                               questionType: question.questionType,
                               context: context,
                               textFieldDelegate: self)
            cell.questionChangeListener = self.currentQuestionIndexChanged.addHandler(target: cell, handler: QuizTableViewCell.questionIndexDidChange)
        }
        
        if let nextQuestion = quiz.questionFor(index: currentQuestionIndex + 1) {
            cell.configureForNext(question: nextQuestion)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: QuizHeaderView.self)) as! QuizHeaderView
        if let question = quiz.questionFor(index: currentQuestionIndex) {
            header.configureFor(question: question,
                                context: context)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let question = quiz.questionFor(index: currentQuestionIndex) {
            if question.questionType.isInput {
                return 1
            }
            return question.answers.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuizTableViewCell.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return QuizHeaderView.defaultHeight
    }
}

extension QuizViewModel: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return true
        }
        let result = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        guard result.characters.count <= 40 else {
            return false
        }
        
        if let question = quiz.questionFor(index: currentQuestionIndex),
            let result = textField.text {
                question.userInput = result
        }
        return true
    }
}
