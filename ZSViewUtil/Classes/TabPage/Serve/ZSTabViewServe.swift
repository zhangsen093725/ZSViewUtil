//
//  ZSTabPageViewServe.swift
//  JadeToB
//
//  Created by 张森 on 2020/1/13.
//  Copyright © 2020 张森. All rights reserved.
//

import UIKit

@objc public protocol ZSTabViewServeDelegate {
    func vserve_tabViewDidSelected(at index: Int)
}

@objc public protocol ZSTabViewServeDataSource {
    @objc optional func vserve_tabViewText(at index: Int) -> String?
}

@objcMembers open class ZSTabViewServe: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public weak var tabView: ZSTabView?
    
    public weak var delegate: ZSTabViewServeDelegate?
    
    public weak var dataSource: ZSTabViewServeDataSource?
    
    /// tab count
    public var tabCount: Int = 0 {
        didSet {
            tabView?.collectionView.reloadData()
        }
    }
    
    /// 当前选择的 tab 索引
    public var selectIndex: Int = 0 {
        didSet {
            zs_scrollToIndex()
        }
    }
    
    /// tab 之间的间隙
    public var minimumLineSpacing: CGFloat = 8 {
        didSet {
            tabView?.collectionView.reloadData()
        }
    }
    
    /// tab insert
    public var tabViewInsert: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) {
        didSet {
            tabView?.collectionView.reloadData()
        }
    }
}


/**
 * 1. TabViewServe 提供外部重写的方法
 * 2. 需要自定义每个Tab的样式，可重新以下的方法达到目的
 */
@objc extension ZSTabViewServe {
    
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
        cell.titleLabel.text = (dataSource?.vserve_tabViewText?(at: indexPath.item)) ?? "标题\(indexPath.item)"
        
        return cell
    }
    
    open func zs_configTabCellWidth(sizeForItemAt index: Int) -> CGFloat {

        return 100
    }
    
    open func zs_scrollToIndex() {
        
        var sliderX: CGFloat = tabViewInsert.left
        var sliderW: CGFloat = 0
        
        for index in (0..<tabCount) {
            
            if index == selectIndex {
                sliderW = zs_configTabCellWidth(sizeForItemAt: index)
                break
            }
            
            sliderX += zs_configTabCellWidth(sizeForItemAt: index) + minimumLineSpacing
        }
        
        tabView?.beginScrollToIndex(selectIndex, sliderX: sliderX, textWidth: sliderW, isAnimation: true)
    }
}



/**
 * 1. UICollectionView 的代理
 * 2. 可根据需求进行重写
 */
@objc extension ZSTabViewServe {
    
    // TODO: UICollectionViewDataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tabCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        return zs_configTabCell(collectionView, cellForItemAt: indexPath)
    }
    
    // TODO: UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = zs_configTabCellWidth(sizeForItemAt: indexPath.item)

        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return tabViewInsert
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return minimumLineSpacing
    }
    
    // TODO: UICollectionViewDelegate
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectIndex = indexPath.item
        delegate?.vserve_tabViewDidSelected(at: indexPath.item)
    }
}
