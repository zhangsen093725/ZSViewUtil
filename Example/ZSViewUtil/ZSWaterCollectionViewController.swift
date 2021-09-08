//
//  ZSWaterCollectionViewController.swift
//  ZSViewUtil_Example
//
//  Created by Josh on 2020/8/6.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class ZSWaterCollectionViewController: UIViewController, ZSWaterFlowLayoutDelegate, UICollectionViewDataSource {

    public lazy var collectionView: ZSCollectionView = {
        
        let layout = ZSWaterFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = ZSCollectionView.init(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor(argb: "#6627C1F2")
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
        view.backgroundColor = .white
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
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath)
        
        cell.contentView.frame = cell.bounds

        for subView in cell.contentView.subviews
        {
            subView.removeFromSuperview()
        }
        
        let label = UILabel()
        
        label.text = "\(indexPath)"
        label.backgroundColor = .brown
        
        label.frame = cell.contentView.bounds
        cell.contentView.addSubview(label)
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
        return 10.zs_pt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
        return 10.zs_pt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        return .zero // UIEdgeInsets(top: 10.zs_pt, left: 10.zs_pt, bottom: 10.zs_pt, right: 10.zs_pt)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
     
        return .zero //CGSize(width: collectionView.zs_width, height: 64.zs_pt)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
       
        return .zero // CGSize(width: collectionView.zs_width, height: 44.zs_pt)
    }
    
    // TODO: ZSWaterFlowLayoutDelegate
    func zs_collectionView(_ collectionView: UICollectionView, layout: ZSWaterFlowLayout, columnNumberOf section: Int) -> Int {
        
        return 3
    }
    
    func zs_collectionView(_ collectionView: UICollectionView, layout: ZSWaterFlowLayout, insetForColumnAtIndex column: Int, columnCount: Int) -> UIEdgeInsets {
        
//        if columnCount == 1
//        {
//            return .zero
//        }
//        
//        if column == 0
//        {
//            return UIEdgeInsets(top: 0, left: 16.zs_pt, bottom: 0, right: 0)
//        }
//        
//        if column == columnCount - 1
//        {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16.zs_pt)
//        }
        
        return UIEdgeInsets(top: 0, left: 8.zs_pt, bottom: 0, right: 8.zs_pt)
    }
    
    func zs_collectionView(_ collectionView: UICollectionView, layout: ZSWaterFlowLayout, shouldBeyondSizeOf section: Int) -> Bool {
        
        return true //section % 2 == 0 ? true : false
    }
    
    func zs_collectionView(_ collectionView: UICollectionView, layout: ZSWaterFlowLayout, sectionSpacingFor section: Int) -> CGFloat {
        
        return 10.zs_pt
    }
    
    func zs_collectionView(_ collectionView: UICollectionView, layout: ZSWaterFlowLayout, minimumSize: CGSize, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        if layout.scrollDirection == .vertical
        {
            return CGSize(width: indexPath.item % 6 == 0 ? (collectionView.zs_width - 20.zs_pt - CGFloat((indexPath.item % 15) * 20)) : (minimumSize.width - CGFloat((indexPath.item % 6) * 20)), height: CGFloat((indexPath.item % 10 + 1) * 20).zs_pt)
//            CGSize(width: minimumSize.width - 16.zs_pt, height: CGFloat((indexPath.item % 10 + 1) * 20).zs_pt)
        }
        
        return CGSize(width: CGFloat((indexPath.item % 10 + 1) * 20).zs_pt, height: indexPath.item % 6 == 0 ? (collectionView.zs_height - 20.zs_pt - CGFloat((indexPath.item % 15) * 20)) : (minimumSize.height - CGFloat((indexPath.item % 6) * 20)))
    }
}
