//
//  QuizResultsViewModel.swift
//  SportsAlgebra
//
//  Created by Resma, Rob on 8/17/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class QuizResultsViewModel: NSObject {
    
}

extension QuizResultsViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension QuizResultsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuizTableViewCell.self),
                                                 for: indexPath) as! QuizResultsTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // TODO: Implement This
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Implement This
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Implement This
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuizResultsTableViewCell.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return QuizHeaderView.defaultHeight
    }
}
