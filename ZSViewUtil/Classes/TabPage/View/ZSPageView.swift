//
//  ZSPageView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/14.
//

import UIKit

open class ZSPageView: UIView {
    
    private var _waitLayoutScrollToIndex_: Int = 0
    
    private var _waitLayoutScrollAnimation_: Bool = true
    
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        
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
