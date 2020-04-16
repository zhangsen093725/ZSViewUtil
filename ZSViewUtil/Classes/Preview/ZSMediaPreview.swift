//
//  ZSMediaPreview.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/4/8.
//

import UIKit

@objcMembers open class ZSMediaPreview: UIView, ZSMediaPreviewCellDelegate {
    
    /// 缩放倍数
    fileprivate var panScale: CGFloat = 1
    
    /// 背景透明度
    fileprivate var panColorAlpha: CGFloat = 1
    
    /// 资源是否开启拖动
    fileprivate var isPanGestureEnalbe: Bool = false
    
    /// 是否关闭预览
    fileprivate var isEndPreview: Bool = false
    
    /// 屏幕截图视图
    fileprivate var fromViewSnapshotView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
        }
    }
    
    /// 屏幕截图视图
    fileprivate var mediaPreviewSnapshotView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
        }
    }
    
    /// 自定义的View
    fileprivate weak var customView: UIView?
    
    var previewLineSpacing: CGFloat = 0 {
        didSet {
            collectionView.frame.size.width = contentView.bounds.width + previewLineSpacing
        }
    }
    
    /// 动画最后需要返回到的frame
    var lastFrame: CGRect = .zero
    
    fileprivate lazy var contentView: UIView = {
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:)))
        contentView.addGestureRecognizer(pan)
        insertSubview(contentView, at: 0)
        return contentView
    }()
    
    public lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        contentView.insertSubview(collectionView, at: 0)
        return collectionView
    }()
    
    public func zs_setterCustomView(_ customViewHandle: (() -> UIView?)) {
        
        let _customView_ = customViewHandle()
        
        guard _customView_ != customView else { return }
        
        customView?.removeFromSuperview()
        
        if _customView_ != nil {
            contentView.addSubview(_customView_!)
        }
        customView = _customView_
    }
    
    public var zs_didEndPreview: (() -> Void)?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        collectionView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width + previewLineSpacing, height: contentView.bounds.height)
        customView?.frame = contentView.bounds
    }
    
    open func reset() {
        panScale = 1
        panColorAlpha = 1
        isPanGestureEnalbe = false
    }
    
    func refreshLastFrame(from view: UIView?) {
        
        guard view != nil else { return }
        
        lastFrame = self.convert(view!.frame, to: self)
    }
}



/**
 * ZSMediaPreview 动画
 */
@objc extension ZSMediaPreview {
    
    open func beginPreview(from view: UIView? = nil, to index: Int = 0) {
        
        frame = UIScreen.main.bounds
        
        var rootVC = UIApplication.shared.keyWindow?.rootViewController
        
        while ((rootVC?.presentedViewController) != nil && !(rootVC?.presentedViewController is UIAlertController)) {
            rootVC = rootVC?.presentedViewController
        }
        
        rootVC?.view.addSubview(self)
        
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        
        fromViewSnapshotView = view?.snapshotView(afterScreenUpdates: false)
        
        if fromViewSnapshotView == nil {
            backgroundColor = UIColor.black.withAlphaComponent(1)
            return
        }
        
        backgroundColor = UIColor.black.withAlphaComponent(0)
        collectionView.isHidden = true
        
        refreshLastFrame(from: view)
        fromViewSnapshotView?.frame = lastFrame
        insertSubview(fromViewSnapshotView!, at: 0)
        layoutIfNeeded()
        
        var _imageFrame_ = lastFrame
        _imageFrame_.size.width = frame.width
        _imageFrame_.size.height = frame.width * (lastFrame.height / lastFrame.width)
        _imageFrame_.origin.x = 0
        _imageFrame_.origin.y = (frame.height - _imageFrame_.height) * 0.5
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.backgroundColor = UIColor.black.withAlphaComponent(1)
            self?.fromViewSnapshotView?.frame = _imageFrame_
            
        }) { [weak self] (finished) in
            
            self?.collectionView.isHidden = false
            self?.fromViewSnapshotView?.isHidden = true
        }
    }
    
    open func endPreview() {
        
        mediaPreviewSnapshotView?.removeFromSuperview()
        
        if lastFrame == .zero {
            
            let keyAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            keyAnimation.duration = 0.3
            keyAnimation.values = [0.56, 0.4, 0.2, 0.1, 0]
            keyAnimation.isCumulative = false
            keyAnimation.isRemovedOnCompletion = false
            layer.add(keyAnimation, forKey: "Scale")
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.alpha = 0
            }) { [weak self] (finished) in
                self?.removeFromSuperview()
                self?.layer.removeAllAnimations()
                self?.zs_didEndPreview?()
            }
            return
        }
        
        fromViewSnapshotView?.isHidden = false
        collectionView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.backgroundColor = UIColor.black.withAlphaComponent(0)
            self?.fromViewSnapshotView?.frame = self?.lastFrame ?? .zero
            
        }) { [weak self] (finished) in
            
            self?.fromViewSnapshotView?.removeFromSuperview()
            self?.fromViewSnapshotView = nil
            self?.removeFromSuperview()
            self?.zs_didEndPreview?()
        }
    }
    
    open func getMediaPreviewSnapshotView() -> UIView {
        
        guard mediaPreviewSnapshotView == nil else { return mediaPreviewSnapshotView! }
        
        mediaPreviewSnapshotView = contentView.snapshotView(afterScreenUpdates: false)
        mediaPreviewSnapshotView?.frame = contentView.bounds
        contentView.addSubview(mediaPreviewSnapshotView!)
        collectionView.isHidden = true
        customView?.isHidden = true
        
        return mediaPreviewSnapshotView!
    }
}


/**
 * 手势
 */
@objc extension ZSMediaPreview {
    
    open func endPanGestureRecognizer() {

        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.contentView.transform = CGAffineTransform.identity
            self?.mediaPreviewSnapshotView?.transform = CGAffineTransform.identity
            self?.backgroundColor = self?.backgroundColor?.withAlphaComponent(1)
        }) { [weak self] (finished) in
            self?.reset()
            self?.collectionView.isHidden = false
            self?.customView?.isHidden = false
            self?.mediaPreviewSnapshotView = nil
        }
    }
    
    @objc open func panGestureRecognizer(_ panGestureRecognizer : UIPanGestureRecognizer) {
        
        let currentPoint = panGestureRecognizer.translation(in: panGestureRecognizer.view)
        
        let _mediaPreviewSnaphotView_ = getMediaPreviewSnapshotView()
        
        if abs(currentPoint.y) > abs(currentPoint.x) {
            
            let offset: CGFloat = sqrt(pow(currentPoint.x, 2) + pow(currentPoint.y, 2)) / sqrt(pow(frame.width, 2) + pow(frame.height, 2))
            panColorAlpha = (currentPoint.y < 0 ? (1 + offset) : (1 - offset)) * panColorAlpha
            panColorAlpha = panColorAlpha > 1 ? 1 : panColorAlpha
            panScale = currentPoint.y < 0 ? (1 + offset) : (1 - offset)
            
            isEndPreview = currentPoint.y > 0
            
            let isShouldScale = currentPoint.y >= 0 || (currentPoint.y < 0 && (_mediaPreviewSnaphotView_.transform.d < 1 || _mediaPreviewSnaphotView_.transform.a < 1))
            
            if isShouldScale {
                _mediaPreviewSnaphotView_.transform = _mediaPreviewSnaphotView_.transform.scaledBy(x: panScale, y: panScale)
            }
            
            if currentPoint.y >= 0 {
                isPanGestureEnalbe = true
            }
            
            backgroundColor = backgroundColor?.withAlphaComponent(panColorAlpha)
        }
        
        if isPanGestureEnalbe {
            _mediaPreviewSnaphotView_.transform = _mediaPreviewSnaphotView_.transform.translatedBy(x: currentPoint.x, y: currentPoint.y)
        }
        
        if panGestureRecognizer.state == .ended {
            
            isEndPreview ? endPreview() : endPanGestureRecognizer()
        }
        
        panGestureRecognizer.setTranslation(.zero, in: panGestureRecognizer.view)
    }
}



@objc extension ZSMediaPreview {
        
    open func zs_mediaPreviewCellScrollViewDidSingleTap() {
        endPreview()
    }
    
    open func zs_mediaPreviewCellMediaLoadFail(_ error: Error) {
        
    }
    
    open func zs_mediaPreviewCellMediaDidChangePlay(status: ZSPlayerStatus) {
        
        
    }
    
    open func zs_mediaPreviewCellMediaDidiChangePlayTime(second: TimeInterval) {
        
    }
    
    open func zs_mediaPreviewCellScrollViewDidLongPress(_ collectionCell: UICollectionViewCell) {
        
    }
    
    public func zs_mediaPreviewCellMediaLoadingView() -> UIView? {
        
        return nil
    }
}
