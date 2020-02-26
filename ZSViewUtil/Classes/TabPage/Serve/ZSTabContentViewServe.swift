//
//  ZSTabContentViewServe.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/14.
//

import UIKit

open class ZSTabContentViewServe: NSObject, UITableViewDelegate, UITableViewDataSource, ZSTabViewServeDelegate, ZSPageViewScrollDelegate {

    public weak var contentView: ZSTabContentView?
    
    public var tabViewServe = ZSTabViewServe()
    
    public var pageServe = ZSPageViewServe()
    
    private var isDecelerating: Bool = false
    private var isShouldBaseScroll: Bool = true
    private var isShouldContentScroll: Bool = false
    
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
        pageServe.zs_buildView(contentView.pageView)
        pageServe.scrollDelegate = self
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
    
    // TODO: ZSPageViewScrollDelegate
    open func vserve_tabPageViewDidScroll(_ scrollView: UIScrollView, page: Int) {
        
        if selectIndex != page && page < tabCount {
            selectIndex = page
        }
        
        guard scrollView.contentSize != .zero else { return }
        
        if scrollView.contentOffset.x >= 0 && isDecelerating {
            isShouldContentScroll = !isShouldBaseScroll
            contentView?.tableView.isScrollEnabled = false
            return
        }
    }
    
    open func vserve_tabPageViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isDecelerating = true
    }
    
    open func vserve_tabPageViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDecelerating = false
        contentView?.tableView.isScrollEnabled = true
    }
    
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
    
    // TODO: ZSTabViewServeDelegate
    open func vserve_tabViewDidSelected(at index: Int) {
        contentView?.pageView.beginScrollToIndex(index, isAnimation: true)
    }
}
