//
//  ZSTabContentView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/14.
//

import UIKit

open class ZSTabContentView: UIView {
    
    public lazy var tableView: ZSTabBaseTableView = {
        
        let tableView = ZSTabBaseTableView(frame: .zero, style: .plain)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        addSubview(tableView)
        return tableView
    }()
    
    public lazy var tabView: ZSTabView = {
        
        let tabView = ZSTabView()

        return tabView
    }()
    
    public lazy var pageView: ZSPageView = {
        
        let pageView = ZSPageView()

        return pageView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
}
