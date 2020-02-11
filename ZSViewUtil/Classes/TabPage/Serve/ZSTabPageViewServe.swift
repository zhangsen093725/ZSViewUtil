//
//  ZSTabPageViewServe.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

public protocol ZSTabPageViewServeDelegate: class {
    func vserve_tabPageView(at index: Int) -> UIView
    func vserve_tabPageViewWillDisappear(at index: Int)
    func vserve_tabPageViewWillAppear(at index: Int)
}

open class ZSTabPageViewServe: NSObject, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZSTabViewServeDelegate {
    
    public var tabViewServe = ZSTabViewServe()
    
    public weak var tabPageView: ZSTabPageView?
    
    public weak var delegate: ZSTabPageViewServeDelegate?
    
    public var tabCount: Int = 0 {
        didSet {
            tabViewServe.tabCount = tabCount
            tabPageView?.collectionView.reloadData()
        }
    }
    
    public var selectIndex: Int = 0 {
        didSet {
            tabViewServe.selectIndex = selectIndex
            tabPageView?.beginScrollToIndex(selectIndex, isAnimation: false)
        }
    }
    
    open var minimumLineSpacing: CGFloat = 0
    
    open var tabViewInsert: UIEdgeInsets = .zero
    
    open func zs_buildTabView(_ tabPageView: ZSTabPageView) {
        self.tabPageView = tabPageView
        zs_configTabViewServe(tabPageView)
        tabPageView.collectionView.delegate = self
        tabPageView.collectionView.dataSource = self
        zs_configTabPageView()
    }
    
    open func zs_configTabViewServe(_ tabPageView: ZSTabPageView) {
        tabViewServe.zs_buildTabView(tabPageView.tabView)
        tabViewServe.delegate = self
    }
    
    open func zs_configTabPageView() {
        tabPageView?.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
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
        
        cell.addSubview(view)
        view.frame = cell.contentView.bounds

        return cell
    }
    
    // TODO: ZSTabViewServeDelegate
    open func vserve_tabViewDidSelected(at index: Int) {
        tabPageView?.beginScrollToIndex(index, isAnimation: true)
    }
    
    // TODO: UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)

        if selectIndex != page && page < tabCount {
            
            delegate?.vserve_tabPageViewWillAppear(at: page)
            delegate?.vserve_tabPageViewWillDisappear(at: selectIndex)
            selectIndex = page
        }
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
