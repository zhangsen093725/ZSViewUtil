//
//  ZSMediaPreviewCell.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/4/8.
//

import UIKit

@objc public protocol ZSMediaPreviewCellDelegate: class {

    func zs_mediaPreviewCellScrollViewDidScroll(_ scrollView: UIScrollView)
    
}

@objcMembers open class ZSMediaPreviewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var previewLineSpacing: CGFloat = 0 {
        didSet {
            zoomScrollView.frame.size.width = contentView.frame.width - previewLineSpacing
        }
    }
    
    /// tabview 是否可以滚动
    fileprivate var isShouldBaseScroll: Bool = true
    
    /// tab content 是否可以滚动
    fileprivate var isShouldContentScroll: Bool = false
    
    var delegate: ZSMediaPreviewCellDelegate?
    
    public lazy var zoomScrollView: ZSMediaPreviewScrollView = {
        
        let scrollView = ZSMediaPreviewScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPress.minimumPressDuration = 0.5
        contentView.addGestureRecognizer(longPress)
        contentView.insertSubview(scrollView, at: 0)
        
        return scrollView
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        zoomScrollView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width - previewLineSpacing, height: contentView.frame.height)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
}



@objc extension ZSMediaPreviewCell {
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let touch = touches.first
        let touchPoint = touch?.location(in: self)
        
        if touch?.tapCount == 1 {
            perform(#selector(singleTap(_:)), with: touchPoint, afterDelay: 0.3)
        }
        
        if touch?.tapCount == 2 {
            enlargeImage(from: touchPoint ?? .zero)
        }
        
    }
    
    @objc open func singleTap(_ : Any) {
        
    }
    
    @objc open func longPress(_ longPressGesture: UILongPressGestureRecognizer) {
        
    }
}




@objc extension ZSMediaPreviewCell {
    
    open func zoomToOrigin() {
        guard zoomScrollView.zoomScale != 1 else { return }
        zoomScrollView.setZoomScale(1, animated: true)
    }
    
    open func enlargeImage(from point: CGPoint) {
        
        if zoomScrollView.zoomScale > zoomScrollView.minimumZoomScale {
            zoomScrollView.setZoomScale(zoomScrollView.minimumZoomScale, animated: true)
            return
        }
        
        let zoomScale = zoomScrollView.maximumZoomScale
        let x = self.frame.width / zoomScale
        let y = self.frame.height / zoomScale
        zoomScrollView.zoom(to: CGRect(x: point.x - x * 0.5, y: point.y - y * 0.5, width: x, height: y), animated: true)
    }
    
    open func refreshMediaViewCenter(from point: CGPoint) {
        
    }
}




@objc extension ZSMediaPreviewCell {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentSize != .zero else { return }
        
        guard scrollView.zoomScale == 1 else { return }
        
        delegate?.zs_mediaPreviewCellScrollViewDidScroll(scrollView)
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let offsetX = (scrollView.frame.width > scrollView.contentSize.width) ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0
        
        refreshMediaViewCenter(from: CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY))
    }
}







@objcMembers open class ZSMediaPreviewScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    // TODO: UIGestureRecognizerDelegate
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return !(otherGestureRecognizer.view is UICollectionView)
    }
}
