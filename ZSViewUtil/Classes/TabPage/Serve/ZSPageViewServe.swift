//
//  ZSPageViewServe.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/14.
//

import UIKit

@objc public protocol ZSPageViewServeDelegate {
    func vserve_tabPageView(at index: Int) -> UIView
    func vserve_tabPageViewWillDisappear(at index: Int)
    func vserve_tabPageViewWillAppear(at index: Int)
}

@objc public protocol ZSPageViewScrollDelegate {
    func vserve_tabPageViewDidScroll(_ scrollView: UIScrollView, page: Int)
    func vserve_tabPageViewWillBeginDecelerating(_ scrollView: UIScrollView)
    func vserve_tabPageViewDidEndDecelerating(_ scrollView: UIScrollView)
}

@objcMembers open class ZSPageViewServe: NSObject, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate var isBeginDecelerating: Bool = false
    
    public weak var pageView: ZSPageView?
    
    public weak var delegate: ZSPageViewServeDelegate?
    
    public weak var scrollDelegate: ZSPageViewScrollDelegate?
    
    /// tab count
    public var tabCount: Int = 0 {
        didSet {
            pageView?.collectionView.reloadData()
        }
    }
    
    /// 当前选择的 tab 索引
    public var selectIndex: Int = 0 {
        didSet {
            guard isBeginDecelerating == false else { return }
            pageView?.beginScrollToIndex(selectIndex, isAnimation: false)
        }
    }
    
    /// tab 之间的间隙
    public var minimumLineSpacing: CGFloat = 8 {
        didSet {
            pageView?.collectionView.reloadData()
        }
    }
    
    /// tab insert
    public var tabViewInsert: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) {
        didSet {
            pageView?.collectionView.reloadData()
        }
    }
}



/**
* 1. ZSPageViewServe 提供外部重写的方法
* 2. 需要自定义每个Tab Page的样式，可重新以下的方法达到目的
*/
@objc extension ZSPageViewServe {
    
    open func zs_buildView(_ pageView: ZSPageView) {
           self.pageView = pageView
           pageView.collectionView.delegate = self
           pageView.collectionView.dataSource = self
           zs_configTabPageView()
       }
       
       open func zs_configTabPageView() {
           pageView?.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
       }
       
       open func zs_configTabPageCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
           
           cell.isExclusiveTouch = true
           
           for subView in cell.contentView.subviews {
               
               subView.removeFromSuperview()
           }
           
           guard let view = delegate?.vserve_tabPageView(at: indexPath.item) else {
               return cell
           }
           
           cell.contentView.addSubview(view)
           view.frame = cell.contentView.bounds
           
           return cell
       }
}



/**
* 1. UICollectionView 的代理
* 2. 可根据需求进行重写
*/
@objc extension ZSPageViewServe {
    
    // TODO: UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard isBeginDecelerating else { return }
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        
        scrollDelegate?.vserve_tabPageViewDidScroll(scrollView, page: page)
        
        if selectIndex != page && page < tabCount {
            
            delegate?.vserve_tabPageViewWillAppear(at: page)
            delegate?.vserve_tabPageViewWillDisappear(at: selectIndex)
        }
    }
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isBeginDecelerating = true
        scrollDelegate?.vserve_tabPageViewWillBeginDecelerating(scrollView)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isBeginDecelerating = false
        scrollDelegate?.vserve_tabPageViewDidEndDecelerating(scrollView)
    }
    
    // TODO: UICollectionViewDataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tabCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return zs_configTabPageCell(collectionView, cellForItemAt: indexPath)
    }
    
    // TODO: UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return tabViewInsert
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return minimumLineSpacing
    }
}
