//
//  ZSTabPageView.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

open class ZSTabPageView: UIView {
    
    private var _waitLayoutScrollToIndex_: Int = 0
    
    private var _waitLayoutScrollAnimation_: Bool = true
    
    open lazy var tabView: ZSTabView = {
        
        let tabView = ZSTabView()
        addSubview(tabView)
        return tabView
    }()
    
    public lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        return collectionView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        tabView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        collectionView.frame = CGRect(x: 0, y: tabView.frame.maxY, width: bounds.width, height: bounds.height - tabView.frame.maxY)
        
        if _waitLayoutScrollToIndex_ > 0 {
            beginScrollToIndex(_waitLayoutScrollToIndex_, isAnimation: _waitLayoutScrollAnimation_)
        }
    }
    
    // TODO: 动画处理
    open func beginScrollToIndex(_ index: Int,
                                 isAnimation: Bool) {
        
        if collectionView.frame == .zero {
            _waitLayoutScrollToIndex_ = index
            _waitLayoutScrollAnimation_ = isAnimation
            return
        }
        
        collectionView.reloadData()
        
        _waitLayoutScrollToIndex_ = 0
        _waitLayoutScrollAnimation_ = isAnimation
        
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: isAnimation)
    }
}
