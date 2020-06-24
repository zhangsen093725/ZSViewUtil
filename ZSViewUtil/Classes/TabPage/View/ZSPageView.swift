//
//  ZSPageView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/14.
//

import UIKit

@objcMembers open class ZSPageView: UICollectionView {
    
    private var _waitLayoutScrollToIndex_: Int = 0
    
    private var _waitLayoutScrollAnimation_: Bool = true
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        isPagingEnabled = true
        
        if _waitLayoutScrollToIndex_ > 0 {
            beginScrollToIndex(_waitLayoutScrollToIndex_, isAnimation: _waitLayoutScrollAnimation_)
        }
    }
    
    // TODO: 动画处理
    open func beginScrollToIndex(_ index: Int,
                                 isAnimation: Bool) {
        
        if frame == .zero {
            _waitLayoutScrollToIndex_ = index
            _waitLayoutScrollAnimation_ = isAnimation
            return
        }
        
        reloadData()
        
        _waitLayoutScrollToIndex_ = 0
        _waitLayoutScrollAnimation_ = isAnimation
        
        scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: isAnimation)
    }
    
    
}
