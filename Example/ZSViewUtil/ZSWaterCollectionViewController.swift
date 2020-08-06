//
//  ZSWaterCollectionViewController.swift
//  ZSViewUtil_Example
//
//  Created by Josh on 2020/8/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class ZSWaterCollectionViewController: UIViewController, ZSWaterFlowLayoutDataSource, UICollectionViewDataSource {

    public lazy var collectionView: ZSCollectionView = {
        
        let layout = ZSWaterFlowLayout()
        layout.dataSource = self
        layout.scrollDirection = .horizontal
        
        let collectionView = ZSCollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.shouldMultipleGestureRecognize = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.self) + "Footer")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.self) + "Header")
        collectionView.dataSource = self
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(collectionView)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // TODO: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.brown
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.self) + "Footer", for: indexPath)
            footer.backgroundColor = .systemGray
            return footer
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.self) + "Header", for: indexPath)
            header.backgroundColor = .systemBlue
            return header
        }
        
        return UICollectionReusableView()
    }
    
    // TODO: ZSWaterFlowLayoutDataSource
    func zs_columnNumber(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, section: Int) -> Int {
        
        return 3
    }
    
    func zs_lineSpacing(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, section: Int) -> CGFloat {
        
        return 10.zs_px
    }
    
    func zs_interitemSpacing(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, section: Int) -> CGFloat {
        
        return 10.zs_px
    }
    
    func zs_sectionSpacing(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, section: Int) -> CGFloat {
        
        return 10.zs_px
    }
    
    func zs_insetForSection(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.zs_px, left: 10.zs_px, bottom: 10.zs_px, right: 10.zs_px)
    }

    func zs_heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        
        return CGFloat(indexPath.item % 5 * 10 + 100).zs_px
    }
    
    func zs_referenceSizeForHeader(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, section: Int) -> CGSize {
        
        return CGSize(width: collectionView.zs_width, height: 64.zs_px)
    }
    
    func zs_referenceSizeForFooter(collectionView collection: UICollectionView, layout: ZSWaterFlowLayout, section: Int) -> CGSize {
        
        return CGSize(width: collectionView.zs_width, height: 44.zs_px)
    }

}
