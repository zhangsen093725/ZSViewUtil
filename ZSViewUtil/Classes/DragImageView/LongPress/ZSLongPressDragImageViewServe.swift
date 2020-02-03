//
//  ZSLongPressDragImageViewServe.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/3.
//

import UIKit

open class ZSLongPressDragImageViewServe: ZSDragImageViewServe {
    
    public var isShaking: Bool = false
    
    private var displayLink: CADisplayLink?
    
    open var displayCount: Int = 5
    
    deinit {
        stopDisplay()
    }
    
    open override func configCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(ZSLongPressDragImageItemView.self, forCellWithReuseIdentifier: NSStringFromClass(ZSLongPressDragImageItemView.self))
    }
    
    func itemViewAnimation(isBegin: Bool) {
        
        for cell in collectionView?.visibleCells ?? [] {
            
            let longPressCell = cell as! ZSLongPressDragImageItemView
            
            isBegin ? longPressCell.beginShakeAnimation() : longPressCell.endShakeAnimation()
        }
    }
    
    // TODO: DisPlay
    public func startDisplay() {
        
        guard displayLink == nil else { return }
        
        displayLink = CADisplayLink(target: self, selector: #selector(runDisplayLink(_:)))
        
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = 1
        } else {
            displayLink?.frameInterval = 1
        }
        displayLink?.add(to: RunLoop.current, forMode: .default)
    }
    
    public func stopDisplay() {
        displayLink?.remove(from: RunLoop.current, forMode: .default)
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc public func runDisplayLink(_ displayLink: CADisplayLink) -> Void {
        print(displayLink)
        displayCount -= 1
        
        if displayCount <= 0 {
            isShaking = false
            itemViewAnimation(isBegin: false)
            stopDisplay()
        }
    }
    
    // TODO: GestureRecognizerAction
    open override func itemGestureRecognizerStateBegin(_ gestureRecognizer: UIGestureRecognizer) {
        
        super.itemGestureRecognizerStateBegin(gestureRecognizer)
        isShaking = true
        displayCount = 5
        stopDisplay()
        itemViewAnimation(isBegin: true)
    }
    
    open override func itemGestureRecognizerStateEnd(_ gestureRecognizer: UIGestureRecognizer) {
        
        super.itemGestureRecognizerStateEnd(gestureRecognizer)
        startDisplay()
    }
    
    // TODO: UICollectionViewDataSource
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ZSLongPressDragImageItemView = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZSLongPressDragImageItemView.self), for: indexPath) as! ZSLongPressDragImageItemView
        cell.imageView.backgroundColor = .brown
        cell.itemGestureRecognizerHandle = { [weak self] (gestureRecognizer) in
            self?.itemGestureRecognizer(gestureRecognizer)
        }
        return cell
    }
}
