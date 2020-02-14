//
//  ZSTabPageView.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

open class ZSTabPageView: UIView {
    
    open lazy var tabView: ZSTabView = {
        
        let tabView = ZSTabView()
        addSubview(tabView)
        return tabView
    }()
    
    public lazy var pageView: ZSPageView = {
        
        let pageView = ZSPageView()
        addSubview(pageView)
        return pageView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        tabView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        pageView.frame = CGRect(x: 0, y: tabView.frame.maxY, width: bounds.width, height: bounds.height - tabView.frame.maxY)
    }
    
    // TODO: 动画处理
    open func beginScrollToIndex(_ index: Int,
                                 isAnimation: Bool) {
        
        pageView.beginScrollToIndex(index, isAnimation: isAnimation)
    }
}
