//
//  ZSPageViewServe.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/14.
//

import UIKit

public protocol ZSPageViewServeDelegate: class {
    func vserve_tabPageView(at index: Int) -> UIView
    func vserve_tabPageViewWillDisappear(at index: Int)
    func vserve_tabPageViewWillAppear(at index: Int)
}

public protocol ZSPageViewScrollDelegate: class {
    func vserve_tabPageViewDidScroll(_ scrollView: UIScrollView, page: Int)
    func vserve_tabPageViewDidEndDecelerating(_ scrollView: UIScrollView)
}

open class ZSPageViewServe: NSObject, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public weak var pageView: ZSPageView?
    
    public weak var delegate: ZSPageViewServeDelegate?
    
    public weak var scrollDelegate: ZSPageViewScrollDelegate?
    
    public var tabCount: Int = 0 {
        didSet {
            pageView?.collectionView.reloadData()
        }
    }
    
    public var selectIndex: Int = 0
    
    open var minimumLineSpacing: CGFloat = 0
    
    open var tabViewInsert: UIEdgeInsets = .zero
    
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
    
    // TODO: ZSTabViewServeDelegate
    open func vserve_tabViewDidSelected(at index: Int) {
        pageView?.beginScrollToIndex(index, isAnimation: true)
    }
    
    // TODO: UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        
        scrollDelegate?.vserve_tabPageViewDidScroll(scrollView, page: page)
        
        if selectIndex != page && page < tabCount {
            
            delegate?.vserve_tabPageViewWillAppear(at: page)
            delegate?.vserve_tabPageViewWillDisappear(at: selectIndex)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
