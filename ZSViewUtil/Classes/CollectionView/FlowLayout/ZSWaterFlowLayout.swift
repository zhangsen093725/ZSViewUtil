//
//  ZSWaterFlowLayout.swift
//  Kingfisher
//
//  Created by Josh on 2020/7/14.
//

import UIKit

@objcMembers class ZSWaterFlowLayout: UICollectionViewFlowLayout {
    
    public var columnCount: Int = 2
    
    /// 存放attribute的数组
    private var attributes: [UICollectionViewLayoutAttributes] = []
    
    /// 存放每个section中各个列的最后一个高度
    private var columnHeights: [Int : CGFloat] = [:]
    
    /// collectionView的contentSize的高度
    private var contentHeight: CGFloat = 0
    
    /// 记录上个section高度最高一列的高度
    private var lastContentHeight: CGFloat = 0
    
    private var minHeightColumn: Int {
        
        var min = CGFloat(MAXFLOAT)
        var column = 0
        
        for (key, vaule) in columnHeights
        {
            if min > vaule
            {
                min = vaule
                column = key
            }
        }
        return column
    }
    
    open override func prepare() {
        super.prepare()
        
        contentHeight = sectionInset.top
        lastContentHeight = 0
        
        columnHeights.removeAll()
        attributes.removeAll()
        
        let sectionCount = collectionView?.numberOfSections ?? 0
        
        // 遍历section
        for section in 0..<sectionCount
        {
            let sectionIndexPath = IndexPath(item: 0, section: section)
            
            // 生成header
            if let header = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: sectionIndexPath)
            {
                attributes.append(header)
                columnHeights.removeAll()
            }
            
            lastContentHeight = contentHeight
            
            // 初始化区 y值
            for column in 0..<columnCount
            {
                columnHeights[column] = contentHeight
            }
            
            let itemCount = collectionView?.numberOfItems(inSection: section) ?? 0
            for item in 0..<itemCount
            {
                let cellIndexPath = IndexPath(item: item, section: section)
                if let cell = layoutAttributesForItem(at: cellIndexPath)
                {
                    attributes.append(cell)
                }
            }
            
            // 初始化footer
            if let footer = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: sectionIndexPath)
            {
                attributes.append(footer)
            }
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // 获得super已经计算好的布局的属性
        let origins = super.layoutAttributesForElements(in: rect) ?? []
        let attributes: [UICollectionViewLayoutAttributes] = origins.map({$0.copy() as! UICollectionViewLayoutAttributes})
        
        // 计算collectionView最中心点的值
        if scrollDirection == .horizontal
        {
            
        }
        else
        {
            for attribute in attributes
            {
//                attribute.indexPath
            }
        }
        
        return attributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let cell = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let weight = (collectionView?.frame.size.width ?? 0 ) - sectionInset.left - sectionInset.right - minimumInteritemSpacing
        
        let cellWeight = weight / CGFloat(columnCount)
        let cellHeight = itemSize.height
        
        let cellX = sectionInset.left + CGFloat(minHeightColumn) * (cellWeight + minimumInteritemSpacing)
        
        let minColumnHeight = columnHeights[minHeightColumn] ?? 0
        
        var cellY: CGFloat = minColumnHeight
        
        if cellY != self.lastContentHeight
        {
            cellY += minimumLineSpacing
        }
        
        if contentHeight < minColumnHeight
        {
            contentHeight = minColumnHeight
        }
        
        cell.frame = CGRect(x: cellX, y: cellY, width: cellWeight, height: cellHeight)
        
        columnHeights[minHeightColumn] = cell.frame.maxY
        
        //取最大的
        for (_, vaule) in columnHeights
        {
            if contentHeight < vaule
            {
                contentHeight = vaule
            }
        }
        
        return cell
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let supplementaryView = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            
            contentHeight += sectionInset.top
            
            supplementaryView.frame = CGRect(x: 0, y: contentHeight, width: headerReferenceSize.width, height: headerReferenceSize.height)
            contentHeight += headerReferenceSize.height
            contentHeight += sectionInset.top
            
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            
            contentHeight += sectionInset.bottom
            supplementaryView.frame = CGRect(x: 0, y: contentHeight, width: footerReferenceSize.width, height: footerReferenceSize.height)
            self.contentHeight += footerReferenceSize.height
        }
        return supplementaryView
    }
    
    open override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView!.frame.size.width, height: self.contentHeight)
    }
}
