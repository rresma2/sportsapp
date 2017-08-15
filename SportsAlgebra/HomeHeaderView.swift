//
//  HomeHeaderView.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 8/10/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

class HomeHeaderView: UITableViewHeaderFooterView {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var rewardsButton: UIButton!
    
    // MARK: IBAction
    
    @IBAction func leftButtonTapped(_ sender: Any) {
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
    }
    
    // MARK: Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: HomeHeaderView
    
    func configure(user: PFUser) {
        
    }
    
    class var nib: UINib? {
        return UINib(nibName: String(describing: HomeHeaderView.self), bundle: Bundle.main)
    }
    
    class var defaultHeight: CGFloat {
        return 104.0
    }
}
