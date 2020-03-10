//
//  ZSDragImageView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/3.
//

import UIKit

@objcMembers open class ZSDragImageView: UIView {
    
    public lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        addSubview(collectionView)
        return collectionView
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}
