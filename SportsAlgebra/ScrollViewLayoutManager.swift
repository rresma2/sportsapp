//
//  ScrollViewLayoutManager.swift
//  SportsAlgebra
//
//  Created by Rob Resma on 7/10/17.
//  Copyright © 2017 rresma. All rights reserved.
//

import UIKit

enum PaginatorLayoutType {
    case horizontal
    case vertical
}

class PaginatorLayoutManager {
    // MARK: Layout
    
    var layoutType: PaginatorLayoutType
    
    // MARK: Scrollview Properties
    
    var scrollView: UIScrollView
    var scrollViewWidth: CGFloat
    var scrollViewHeight: CGFloat
    
    // MARK: Dynamic Dimensions
    
    var currentWidth: CGFloat = 0.0
    var currentHeight: CGFloat = 0.0
    var currentX: CGFloat = 0.0
    var currentY: CGFloat = 0.0
    
    // MARK: Init
    
    init(scrollView: UIScrollView, layoutType: PaginatorLayoutType) {
        self.scrollView = scrollView
        self.layoutType = layoutType
        self.scrollViewWidth = self.scrollView.frame.width
        self.scrollViewHeight = self.scrollView.frame.height
    }
    
    // MARK: PaginatorLayoutManager
    
    func addSubview(_ view: UIView) {
        let currentFrame = CGRect(x: self.currentWidth,
                                  y: self.currentHeight,
                                  width: scrollViewWidth,
                                  height: scrollViewHeight)
        
        if layoutType == .horizontal {
            self.currentWidth += scrollViewWidth
        } else {
            self.currentHeight += scrollViewHeight
        }
        
        view.frame = currentFrame
        scrollView.addSubview(view)
    }
    
    func updateContentSize() {
        if layoutType == .horizontal {
            self.scrollView.contentSize = CGSize(width: currentWidth,
                                                 height: scrollView.frame.height)
        } else {
            self.scrollView.contentSize = CGSize(width: scrollView.frame.width,
                                                 height: currentHeight)
        }
    }
}
