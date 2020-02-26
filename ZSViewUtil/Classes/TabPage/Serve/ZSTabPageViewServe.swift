//
//  ZSTabPageViewServe.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

open class ZSTabPageViewServe: NSObject, ZSTabViewServeDelegate, ZSPageViewScrollDelegate {
    
    public var tabViewServe = ZSTabViewServe()
    
    public var pageServe = ZSPageViewServe()
    
    public weak var tabPageView: ZSTabPageView?
    
    public var tabCount: Int = 0 {
        didSet {
            tabViewServe.tabCount = tabCount
            pageServe.tabCount = tabCount
        }
    }
    
    public var selectIndex: Int = 0 {
        didSet {
            tabViewServe.selectIndex = selectIndex
            pageServe.selectIndex = selectIndex
        }
    }
    
    open func zs_buildTabView(_ tabPageView: ZSTabPageView) {
        self.tabPageView = tabPageView
        zs_configTabViewServe(tabPageView)
        zs_configPageServe(tabPageView)
    }
    
    open func zs_configTabViewServe(_ tabPageView: ZSTabPageView) {
        tabViewServe.zs_buildTabView(tabPageView.tabView)
        tabViewServe.delegate = self
    }
    
    open func zs_configPageServe(_ tabPageView: ZSTabPageView) {
        pageServe.zs_buildView(tabPageView.pageView)
        pageServe.scrollDelegate = self
    }
    
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
        tabPageView?.beginScrollToIndex(index, isAnimation: true)
    }
}
