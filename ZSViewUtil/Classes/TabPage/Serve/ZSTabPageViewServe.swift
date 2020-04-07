//
//  ZSTabPageViewServe.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

@objcMembers open class ZSTabPageViewServe: NSObject, ZSTabViewServeDelegate, ZSPageViewScrollDelegate {
    
    /// tab view item 样式Serve
    public var tabViewServe = ZSTabViewServe()
    
    /// page view item 样式 Serve
    public var pageViewServe = ZSPageViewServe()
    
    public weak var tabPageView: ZSTabPageView?
    
    public var tabCount: Int = 0 {
        didSet {
            tabViewServe.tabCount = tabCount
            pageViewServe.tabCount = tabCount
        }
    }
    
    /// 当前选中的 TabPage 索引
    public var selectIndex: Int = 0 {
        didSet {
            tabViewServe.selectIndex = selectIndex
            pageViewServe.selectIndex = selectIndex
        }
    }
}



/**
* 1. ZSTabPageViewServe 提供外部重写的方法
* 2. 需要自定义Serve，可重新以下的方法达到目的
*/
@objc extension ZSTabPageViewServe {
    
    open func zs_buildTabView(_ tabPageView: ZSTabPageView) {
        self.tabPageView = tabPageView
        zs_configTabViewServe(tabPageView)
        zs_configPageViewServe(tabPageView)
    }
    
    open func zs_configTabViewServe(_ tabPageView: ZSTabPageView) {
        tabViewServe.zs_buildTabView(tabPageView.tabView)
        tabViewServe.delegate = self
    }
    
    open func zs_configPageViewServe(_ tabPageView: ZSTabPageView) {
        pageViewServe.zs_buildView(tabPageView.pageView)
        pageViewServe.scrollDelegate = self
    }
}


/**
* 1. ZSPageViewScrollDelegate 的代理
* 2. 可根据需求进行重写
*/
@objc extension ZSTabPageViewServe {
    
    // TODO: ZSPageViewScrollDelegate
    open func vserve_tabPageViewDidScroll(_ scrollView: UIScrollView, page: Int) {
        
        if selectIndex != page && page < tabCount {
            selectIndex = page
        }
    }
    
    open func vserve_tabPageViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    open func vserve_tabPageViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    // TODO: ZSTabViewServeDelegate
    open func vserve_tabViewDidSelected(at index: Int) {
        tabPageView?.pageView.beginScrollToIndex(index, isAnimation: true)
    }
}
