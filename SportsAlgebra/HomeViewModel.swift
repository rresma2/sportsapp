//
//  HomeViewModel.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
    var tableView: UITableView!
    var dataSource = [QuizResults]()
    var page = 0
    var user: PFUser
    
    init(user: PFUser) {
        self.user = user
        
        super.init()
    }
    
    func fetchQuizResults() {
        guard let user = PFUser.current() else {
            // TODO: Log user out due to invalid session
            SALog("Current User is nil")
            return
        }
        
        WebServiceManager.shared.userWebService.getUserQuizResults(user: user, limit: 10, page: self.page) { (results, error) in
            if let error = error {
                SALog("Failed to fetch data with error: \(error.message)")
            } else if let quizResults = results {
                self.dataSource = quizResults
                self.tableView.reloadData()
            }
        }
    }
    
    func configure(tableView: UITableView) {
        tableView.register(HomeTableViewCell.nib,
                           forCellReuseIdentifier: String(describing: HomeTableViewCell.self))
        tableView.backgroundColor = .black
        self.tableView = tableView
    }
    
    func loadQuiz(completion: @escaping (Quiz?, SAError?) -> Void) {
        WebServiceManager.shared.quizWebService.chooseQuiz(completion: completion)
    }
}

extension HomeViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Implement
    }
}

extension HomeViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTableViewCell.self), for: indexPath) as! HomeTableViewCell
        cell.configure(quizResults: self.dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeTableViewCell.defaultHeight
    }
    
}
