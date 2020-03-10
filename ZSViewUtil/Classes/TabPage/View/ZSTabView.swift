//
//  ZSTabView.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

@objcMembers open class ZSTabView: UIView {
    
    public var isSliderHidden: Bool = false
    
    public var isScrollEnable: Bool = false {
        didSet {
            collectionView.isScrollEnabled = isScrollEnable
        }
    }
    
    public var sliderWidth: CGFloat = 0
    
    public var sliderHeight: CGFloat = 2
    
    struct WaitLayout {
        
        lazy var scroll: Scroll = {
            return Scroll()
        }()
        
        lazy var slider: Slider = {
            return Slider()
        }()
        
        struct Scroll {
            var index: Int = 0
            var isAnimation: Bool = true
        }
        
        struct Slider {
            var x: CGFloat = 0
            var width: CGFloat = 0
        }
    }
    
    private lazy var waitLayout: WaitLayout = {
        
        return WaitLayout()
    }()
    
    public lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        return collectionView
    }()
    
    public lazy var sliderView: UIView = {
        
        let sliderView = UIView()
        sliderView.isHidden = true
        collectionView.addSubview(sliderView)
        return sliderView
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        beginScrollToIndex(waitLayout.scroll.index, sliderX: waitLayout.slider.x, textWidth: waitLayout.slider.width, isAnimation: waitLayout.scroll.isAnimation)
    }
    
    // TODO: 动画处理
    open func beginScrollToIndex(_ index: Int,
                                 sliderX: CGFloat,
                                 textWidth: CGFloat,
                                 isAnimation: Bool) {
        
        waitLayout.scroll.index = index
        waitLayout.scroll.isAnimation = isAnimation
        waitLayout.slider.x = sliderX
        waitLayout.slider.width = textWidth
        
        guard collectionView.frame != .zero else { return }
        
        collectionView.reloadData()
        
        collectionView.isUserInteractionEnabled = false
        let _sliderWidth_ = sliderWidth > 0 ? sliderWidth : textWidth
        
        beginSliderAnimation(sliderX, sliderWidth: _sliderWidth_, textWidth: textWidth, isAnimation: isAnimation)
    }
    
    func beginSliderAnimation(_ sliderX: CGFloat,
                              sliderWidth: CGFloat = 0,
                              textWidth: CGFloat = 0,
                              isAnimation: Bool) {
        
        let contentSize = collectionView.contentSize
        
        let sliderLimitWidth = contentSize.width > 0 ? contentSize.width : frame.width
        let beginSliderOffsetX = collectionView.frame.width * 0.5
        
        var contentOffsetX: CGFloat = 0
        
        if (sliderLimitWidth - sliderX) < beginSliderOffsetX {
            
            contentOffsetX = sliderLimitWidth - collectionView.frame.width
            
        } else if (sliderX > beginSliderOffsetX) {
            
            contentOffsetX = sliderX - beginSliderOffsetX
            
        } else if (collectionView.contentOffset.x >= 0) {
            
            contentOffsetX = 0
        }
        
        let sliderFrame = CGRect(x: (textWidth - sliderWidth) * 0.5 + sliderX, y: collectionView.frame.height - sliderHeight, width: sliderWidth, height: sliderHeight)
        
        sliderView.isHidden = isSliderHidden
        
        if isAnimation && sliderView.frame != .zero {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                
                if contentOffsetX >= 0 {
                    self?.collectionView.contentOffset = CGPoint(x: contentOffsetX, y: 0)
                }
                self?.sliderView.frame = sliderFrame
                
            }) { [weak self] (finished) in
                
                self?.collectionView.isUserInteractionEnabled = true
            }
        } else {
            
            collectionView.contentOffset = CGPoint(x: contentOffsetX, y: 0)
            sliderView.frame = sliderFrame
        }
    }
}
