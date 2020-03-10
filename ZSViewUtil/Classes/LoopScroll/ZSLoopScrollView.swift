//
//  ZSLoopScrollView.swift
//  Pods-ZSBaseUtil_Example
//
//  Created by 张森 on 2019/11/30.
//

import UIKit

@objc public protocol ZSLoopScrollViewDataSource {
    
    /// 滚动视图的总数
    /// - Parameter loopScrollView: loopScrollView
    func zs_numberOfItemLoopScrollView(_ loopScrollView: ZSLoopScrollView) -> Int
    
    /// 滚动到的视图
    /// - Parameters:
    ///   - loopScrollView: loopScrollView
    ///   - index: 当前的index
    ///   - isFirst: 当前视图是否是第一个，只在 isLoopScroll = true 时有效
    ///   - isLast: 当前视图是否是最后一个，只在 isLoopScroll = true 时有效
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, itemAt index: Int, isFirst: Bool, isLast: Bool) -> UIView
    
    /// 滚动到的视图的Size
    /// - Parameters:
    ///   - loopScrollView: loopScrollView
    ///   - index: 当前的index
    ///   - isFirst: 当前视图是否是第一个，只在 isLoopScroll = true 时有效
    ///   - isLast: 当前视图是否是最后一个，只在 isLoopScroll = true 时有效
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, sizeAt index: Int, isFirst: Bool, isLast: Bool) -> CGSize
}

@objc public protocol ZSLoopScrollViewDelegate {
    
    /// 滚动视图Item的点击
    /// - Parameters:
    ///   - loopScrollView: loopScrollView
    ///   - index: 当前的index
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, didSelectedItemFor index: Int)
}

@objcMembers public class ZSLoopScrollView: UIView, UIScrollViewDelegate {
    
    /// scrollView
    public var scrollView: UIScrollView {
        
        return _scrollView_
    }
    
    /// 标记 page 的Control
    public var pageControl: UIPageControl {
        
        return _pageControl_
    }
    
    lazy var _scrollView_: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        insertSubview(scrollView, at: 0)
        return scrollView
    }()
    
    lazy var _pageControl_: UIPageControl = {
        
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        addSubview(pageControl)
        return pageControl
    }()
    
    var timer: Timer?
    var _pageCount_: Int = 0
    var _loopPageCount_: Int = 0
    
    /// 滚动视图的数据配置
    public weak var dataSource: ZSLoopScrollViewDataSource?
    
    /// 滚动视图的交互
    public weak var delegate: ZSLoopScrollViewDelegate?
    
    /// 是否开启自动滚动，默认为 true
    public var isAutoScroll: Bool = true
    
    /// 自动滚动的间隔时长，默认是 3 秒
    public var interval: TimeInterval = 3
    
    /// 是否开启循环滚动，默认是true
    public var isLoopScroll: Bool = true
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        
        _pageCount_ = dataSource?.zs_numberOfItemLoopScrollView(self) ?? 0
        
        isLoopScroll = isLoopScroll ? _pageCount_ > 1 : isLoopScroll
        
        _loopPageCount_ = (isLoopScroll ? _pageCount_ + 2 : _pageCount_)
        
        scrollView.contentSize = CGSize(width: CGFloat(_loopPageCount_) * frame.width, height: 0)
        scrollView.contentOffset = CGPoint(x: isLoopScroll ? frame.width : 0, y: 0)
        pageControl.frame = CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20)
        
        refreshItemUI(_loopPageCount_)
    }
    
    /// 获取复用的同一视图的方法
    /// - Parameter index: 当前的index
    public func viewWithIndex<ResultValue: UIView>(_ index: Int) -> ResultValue? {
        
        return view(with: index) as? ResultValue
    }
    
    public func view(with index: Int) -> UIView? {
        
        return scrollView.viewWithTag(index + 101)
    }
    
    /// 刷新数据源
    public func reloadDataSource() {
        
        layoutSubviews()
    }
    
    func getContentView(for index: Int) -> UIButton {
        
        var contentView: UIButton? = viewWithIndex(index)
        
        if contentView == nil {
            
            contentView = UIButton(type: .custom)
            contentView?.removeTarget(self, action: #selector(didSelected(_:)), for: .touchUpInside)
            contentView?.addTarget(self, action: #selector(didSelected(_:)), for: .touchUpInside)
        }
        scrollView.addSubview(contentView!)
        
        return contentView!
    }
    
    
    func refreshItemUI(_ pageCount: Int) {
        
        guard pageCount > 0 else { return }
        
        pageControl.numberOfPages = _pageCount_
        pageControl.isHidden = pageCount == 1
        
        for page in 0..<pageCount {
            
            let isFirst = isLoopScroll && page == pageCount - 1
            let isLast = isLoopScroll && page == 0
            let index = isLoopScroll ? page - 1 : page
            
            let size = dataSource?.zs_loopScrollView(self, sizeAt: index, isFirst: isFirst, isLast: isLast) ?? .zero
            
            guard size.width > 0 && size.height > 0 else { continue }
            
            guard let view = dataSource?.zs_loopScrollView(self, itemAt: index, isFirst: isFirst, isLast: isLast) else { continue }
            
            let contentView = getContentView(for: index)
            
            var subFrame: CGRect = CGRect(x: (scrollView.frame.width - size.width) * 0.5 + scrollView.frame.width * CGFloat(page), y: (scrollView.frame.height - size.height) * 0.5, width: size.width, height: size.height)
            
            var subTag = 101 + index
            
            if isFirst {
                
                subFrame = CGRect(x: (scrollView.frame.width - size.width) * 0.5 + scrollView.frame.width * CGFloat(page), y: (scrollView.frame.height - size.height) * 0.5, width: size.width, height: size.height)
                subTag = 101
                
            }else if isLast {
                
                subFrame = CGRect(x: (scrollView.frame.width - size.width) * 0.5 + scrollView.frame.width * CGFloat(page), y: (scrollView.frame.height - size.height) * 0.5, width: size.width, height: size.height)
                
                subTag = 101 + index
            }
            
            contentView.frame = subFrame
            view.frame = contentView.bounds
            
            if contentView.tag == 0 {
                contentView.addSubview(view)
            }
            
            contentView.tag = subTag
        }
        
        beginAutoLoopScroll()
    }
    
    func beginAutoLoopScroll() {
        
        guard isAutoScroll else { return }
        
        guard timer == nil else { return }
        
        timer = Timer.loopScroll_supportiOS_10EarlierTimer(interval, repeats: true, block: { [weak self] (timer) in
            
            self?.autoLoopScroll()
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func endAutoLoopScroll() {
        
        timer?.invalidate()
        timer = nil
    }
    
    func autoLoopScroll() {
        
        let page = Int(scrollView.contentOffset.x / frame.width)
        
        guard page < _loopPageCount_ - 1 else { return }
        
        let offsetX = CGFloat(page) * scrollView.frame.width + scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    // TODO: Action
    @objc func didSelected(_ sender: UIButton) {
        
        let index = sender.tag - 101
        delegate?.zs_loopScrollView(self, didSelectedItemFor: index)
    }
    
    
    // TODO: UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard isLoopScroll else {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
            return
        }
        
        if scrollView.contentOffset.x <= 0 {
            
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(_pageCount_), y: 0), animated: false)
            
        } else if scrollView.contentOffset.x >= scrollView.frame.width * CGFloat(_loopPageCount_ - 1) {
            
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width, y: 0), animated: false)
        }
        
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width - 1)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endAutoLoopScroll()
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        beginAutoLoopScroll()
    }
}



extension Timer {
    
    class func loopScroll_supportiOS_10EarlierTimer(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        
        if #available(iOS 10.0, *) {
            return Timer.init(timeInterval: interval, repeats: repeats, block: block)
        } else {
            return Timer.init(timeInterval: interval, target: self, selector: #selector(loopScrollRunTimer(_:)), userInfo: block, repeats: repeats)
        }
    }
    
    @objc private class func loopScrollRunTimer(_ timer: Timer) -> Void {
        
        guard let block: ((Timer) -> Void) = timer.userInfo as? ((Timer) -> Void) else { return }
        
        block(timer)
    }
}
