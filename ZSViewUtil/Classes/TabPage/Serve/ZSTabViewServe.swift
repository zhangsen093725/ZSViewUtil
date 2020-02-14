//
//  ZSTabPageViewServe.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

public protocol ZSTabViewServeDelegate: class {
    func vserve_tabViewDidSelected(at index: Int)
}

open class ZSTabViewServe: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public weak var tabView: ZSTabView?
    
    public weak var delegate: ZSTabViewServeDelegate?
    
    public var tabTexts: [String] = [] {
        didSet {
            tabView?.collectionView.reloadData()
        }
    }
    
    public var tabCount: Int = 0 {
        didSet {
            tabView?.collectionView.reloadData()
        }
    }
    
    public var selectIndex: Int = 0 {
        didSet {
            zs_scrollToIndex()
        }
    }
    
    public var minimumLineSpacing: CGFloat = 8 {
        didSet {
            tabView?.collectionView.reloadData()
        }
    }
    
    public var tabViewInsert: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) {
        didSet {
            tabView?.collectionView.reloadData()
        }
    }
    
    open func zs_scrollToIndex() {
        
        var sliderX: CGFloat = tabViewInsert.left
        var sliderW: CGFloat = 0
        
        for (index, _) in tabTexts.enumerated() {
            
            if index == selectIndex {
                sliderW = zs_configTabTextSize(sizeForItemAt: index)
                break
            }
            
            sliderX += zs_configTabTextSize(sizeForItemAt: index) + minimumLineSpacing
        }
        
        tabView?.beginScrollToIndex(selectIndex, sliderX: sliderX, textWidth: sliderW, isAnimation: true)
    }
    
    open func zs_buildTabView(_ tabView: ZSTabView) {
        self.tabView = tabView
        tabView.collectionView.delegate = self
        tabView.collectionView.dataSource = self
        zs_configTabView()
    }
    
    open func zs_configTabView() {
        tabView?.collectionView.register(ZSTabTextCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZSTabTextCell.self))
    }
    
    open func zs_configTabCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZSTabTextCell.self), for: indexPath) as! ZSTabTextCell
        
        let isSelected: Bool = (indexPath.item == selectIndex)
        
        let normalTextColor: UIColor = .systemGray
        let selectedTextColor: UIColor = .black
        
        let normalTextFont: UIFont = .systemFont(ofSize: 16)
        let selectedTextFont: UIFont = .boldSystemFont(ofSize: 16)
        
        cell.titleLabel.textColor = isSelected ? selectedTextColor : normalTextColor
        cell.titleLabel.font = isSelected ? selectedTextFont : normalTextFont
        cell.titleLabel.text = tabTexts[indexPath.row]
        
        return cell
    }
    
    open func zs_configTabTextSize(sizeForItemAt index: Int) -> CGFloat {

        return 100
    }
    
    // TODO: UICollectionViewDataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tabCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return zs_configTabCell(collectionView, cellForItemAt: indexPath)
    }
    
    // TODO: UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = zs_configTabTextSize(sizeForItemAt: indexPath.item)

        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return tabViewInsert
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return minimumLineSpacing
    }
    
    // TODO: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectIndex = indexPath.item
        delegate?.vserve_tabViewDidSelected(at: indexPath.item)
    }
}
