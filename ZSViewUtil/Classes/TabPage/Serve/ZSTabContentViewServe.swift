//
//  ZSTabContentViewServe.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/14.
//

import UIKit

@objcMembers open class ZSTabContentViewServe: NSObject, UITableViewDelegate, UITableViewDataSource, ZSTabViewServeDelegate, ZSPageViewScrollDelegate {
    
    public weak var contentView: ZSTabContentView?
    
    public var tabViewServe = ZSTabViewServe()
    
    public var pageViewServe = ZSPageViewServe()
    
    /// 是否开始拖拽
    private var isBeginDecelerating: Bool = false
    
    /// tabview 是否可以滚动
    private var isShouldBaseScroll: Bool = true
    
    /// tab content 是否可以滚动
    private var isShouldContentScroll: Bool = false
    
    public var tabCount: Int = 0 {
        didSet {
            tabViewServe.tabCount = tabCount
            pageViewServe.tabCount = tabCount
        }
    }
    
    public var selectIndex: Int = 0 {
        didSet {
            tabViewServe.selectIndex = selectIndex
            pageViewServe.selectIndex = selectIndex
        }
    }
}



/**
* 1. ZSTabContentViewServe 提供外部重写的方法
* 2. 需要自定义TabContentView的样式，可重新以下的方法达到目的
*/
@objc extension ZSTabContentViewServe {
    
    open func zs_buildView(_ contentView: ZSTabContentView) {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        self.contentView = contentView
        zs_configContentView(contentView)
        zs_configPageServe(contentView)
        zs_configTabViewServe(contentView)
    }
    
    open func zs_configContentView(_ contentView: ZSTabContentView) {
        
        contentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
    
    open func zs_configTabViewServe(_ contentView: ZSTabContentView) {
        tabViewServe.zs_buildTabView(contentView.tabView)
        tabViewServe.delegate = self
    }
    
    open func zs_configPageServe(_ contentView: ZSTabContentView) {
        pageViewServe.zs_buildView(contentView.pageView)
        pageViewServe.scrollDelegate = self
    }
    
    open func zs_pageContentViewDidScroll() -> (_ scrollView: UIScrollView, _ currentOffset: CGPoint) -> CGPoint {
        
        return { [weak self] (scrollView, currentOffset) in
            
            if self?.isShouldContentScroll == false {
                scrollView.contentOffset = currentOffset
                return currentOffset
            }
            
            if scrollView.contentOffset.y <= 0 {
                self?.isShouldBaseScroll = true
                self?.isShouldContentScroll = false
                scrollView.contentOffset = .zero
                return .zero
            }
            
            return scrollView.contentOffset
        }
    }
}



/**
 * 1. ZSPageViewScrollDelegate 和 ZSTabViewServeDelegate
 * 2. 可根据需求进行重写
 */
@objc extension ZSTabContentViewServe {
    
    // TODO: ZSPageViewScrollDelegate
    open func vserve_tabPageViewDidScroll(_ scrollView: UIScrollView, page: Int) {
        
        if selectIndex != page && page < tabCount {
            selectIndex = page
        }
        
        guard scrollView.contentSize != .zero else { return }
        
        if scrollView.contentOffset.x >= 0 && isBeginDecelerating {
            isShouldContentScroll = !isShouldBaseScroll
            contentView?.tableView.isScrollEnabled = false
            return
        }
    }
    
    open func vserve_tabPageViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isBeginDecelerating = true
    }
    
    open func vserve_tabPageViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isBeginDecelerating = false
        contentView?.tableView.isScrollEnabled = true
    }
    
    // TODO: ZSTabViewServeDelegate
    open func vserve_tabViewDidSelected(at index: Int) {
        contentView?.pageView.beginScrollToIndex(index, isAnimation: true)
    }
}



/**
 * 1. UITableView 的代理
 * 2. 可根据需求进行重写
 */
@objc extension ZSTabContentViewServe {
    
    // UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentSize != .zero else { return }
        
        let bottomOffset = scrollView.contentSize.height - scrollView.bounds.height
        
        if scrollView.contentOffset.y >= bottomOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: bottomOffset)
            if isShouldBaseScroll {
                isShouldBaseScroll = false
                isShouldContentScroll = true
            }
            return
        }
        
        if isShouldBaseScroll == false {
            scrollView.contentOffset = CGPoint(x: 0, y: bottomOffset)
            return
        }
    }
    
    // TODO: UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        
        cell.isExclusiveTouch = true
        
        for subView in cell.contentView.subviews {
            
            subView.removeFromSuperview()
        }
        
        guard let view = contentView?.pageView else {
            return cell
        }
        
        cell.contentView.addSubview(view)
        view.frame = cell.contentView.bounds
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 700
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = contentView?.tabView else { return nil }
        view.backgroundColor = .systemBlue
        return view
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
}

