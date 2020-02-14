//
//  ZSCollectionView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/10.
//

import UIKit

open class ZSCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    public var shouldMultipleGestureRecognize: Bool = false
    
    open var collectionViewTopView: UIView? {
        
        didSet {
            guard oldValue != collectionViewTopView else { return }
            oldValue?.removeFromSuperview()
            guard collectionViewTopView != nil else { return }
            addSubview(collectionViewTopView!)
        }
    }
    
    open var collectionViewBottomView: UIView? {
        
        didSet {
            guard oldValue != collectionViewBottomView else { return }
            oldValue?.removeFromSuperview()
            guard collectionViewBottomView != nil else { return }
            addSubview(collectionViewBottomView!)
        }
    }
    
    open var collectionViewLeftView: UIView? {
        
        didSet {
            guard oldValue != collectionViewLeftView else { return }
            oldValue?.removeFromSuperview()
            guard collectionViewLeftView != nil else { return }
            addSubview(collectionViewLeftView!)
        }
    }
    
    open var collectionViewRightView: UIView? {
        
        didSet {
            guard oldValue != collectionViewRightView else { return }
            oldValue?.removeFromSuperview()
            guard collectionViewRightView != nil else { return }
            addSubview(collectionViewRightView!)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadTop()
        reloadBottom()
        reloadLeft()
        reloadRight()
    }
    
    open override func reloadData() {
        super.reloadData()
        
        reloadTop()
        reloadBottom()
        reloadLeft()
        reloadRight()
    }
    
    open func reloadTop() {
        if collectionViewTopView == nil {
            contentInset = UIEdgeInsets(top: 0, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
            return
        }
        
        collectionViewTopView?.frame = CGRect(x: 0, y: -collectionViewTopView!.frame.height, width: frame.width, height: collectionViewTopView!.frame.height)
        contentInset = UIEdgeInsets(top: collectionViewTopView!.frame.height, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
    }
    
    open func reloadBottom() {
        if collectionViewBottomView == nil {
            contentInset = UIEdgeInsets(top: contentInset.top, left: contentInset.left, bottom: 0, right: contentInset.right)
            return
        }
        
        collectionViewBottomView?.frame = CGRect(x: 0, y: contentSize.height, width: frame.width, height: collectionViewBottomView!.frame.height)
        contentInset = UIEdgeInsets(top: contentInset.top, left: contentInset.left, bottom: collectionViewBottomView!.frame.height, right: contentInset.right)
    }
    
    open func reloadLeft() {
        if collectionViewLeftView == nil {
            contentInset = UIEdgeInsets(top: contentInset.top, left: 0, bottom: contentInset.bottom, right: contentInset.right)
            return
        }
        
        collectionViewLeftView?.frame = CGRect(x: -collectionViewLeftView!.frame.width, y: 0, width: collectionViewLeftView!.frame.width, height: frame.height)
        contentInset = UIEdgeInsets(top: contentInset.top, left: collectionViewLeftView!.frame.width, bottom: contentInset.bottom, right: contentInset.right)
    }
    
    open func reloadRight() {
        if collectionViewRightView == nil {
            contentInset = UIEdgeInsets(top: contentInset.top, left: contentInset.left, bottom: contentInset.bottom, right: 0)
            return
        }
        
        collectionViewRightView?.frame = CGRect(x: contentSize.width, y: 0, width: collectionViewRightView!.frame.width, height: frame.height)
        collectionViewRightView?.frame.origin.x = contentSize.width
        contentInset = UIEdgeInsets(top: contentInset.top, left: contentInset.left, bottom: contentInset.bottom, right: collectionViewRightView!.frame.width)
    }
    
    // TODO: UIGestureRecognizerDelegate
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return shouldMultipleGestureRecognize
    }
}
