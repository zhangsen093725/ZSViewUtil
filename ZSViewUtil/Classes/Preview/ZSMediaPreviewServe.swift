//
//  ZSMediaPreviewServe.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/4/8.
//

import UIKit

/// preview 交互
@objc public protocol ZSMediaPreviewServeDelegate: class {
    
    /// 长按的回调，用于处理长按事件，开启长按事件时有效
    /// - Parameters:
    ///   - mediaFile: 媒体文件
    ///   - type: 文件类型
    @objc optional func zs_previewLongPress(from mediaFile: Any?, type: ZSMediaType)
    
    /// 视图滚动的回调
    /// - Parameter index: 滚动视图的索引
    /// - 返回当前预览对应的View，主要用于做关闭预览时的对应回归动画
    @objc optional func zs_previewDidScroll(to index: Int) -> UIView?
}


/// preview 资源加载
@objc public protocol ZSMediaPreviewLoadServeDelegate: class {
    
    /// 加载 image URL
    /// - Parameters:
    ///   - imageView: 展示的imageView
    ///   - imageURL: image URL
    func zs_imageView(_ imageView: UIImageView, load imageURL: URL)
    
    /// 媒体加载失败
    /// - Parameter error: 错误信息
    @objc optional func zs_previewMediaLoadFail(_ error: Error)
}


@objcMembers open class ZSMediaPreviewServe: NSObject, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZSPlayerViewDelegate, ZSMediaPreviewCellDelegate {
    
    public weak var delegate: ZSMediaPreviewServeDelegate?
    public weak var loadDelegate: ZSMediaPreviewLoadServeDelegate?
    
    public var mediaPreview: ZSMediaPreview? {
        return getMediaPreview()
    }
    
    var _mediaPreview_: ZSMediaPreview?
    
    /// medias 为 ZSMediaPreviewModel
    public var medias: [ZSMediaPreviewModel] = []
    
    /// 是否开启长按事件，默认为 false
    public var longPressEnable: Bool = false
    
    /// 当前选择的 preview 索引
    public var currentIndex: Int = 0
    
    /// 媒体放大的最大倍数
    public var maximumZoomScale: CGFloat = 2
    
    /// 媒体缩小的最小倍数
    public var minimumZoomScale: CGFloat = 1
    
    /// item 之间的间隙
    public var minimumLineSpacing: CGFloat = 0 {
        didSet {
            mediaPreview?.collectionView.reloadData()
        }
    }
    /// preview 之间的间隙
    public var previewLineSpacing: CGFloat = 20 {
        didSet {
            mediaPreview?.previewLineSpacing = previewLineSpacing
            mediaPreview?.collectionView.reloadData()
        }
    }
    
    /// preview insert
    public var tabViewInsert: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            mediaPreview?.collectionView.reloadData()
        }
    }
    
    open func getMediaPreview() -> ZSMediaPreview {
        
        guard _mediaPreview_ == nil else { return _mediaPreview_! }
        
        _mediaPreview_ = ZSMediaPreview()
        zs_configPreviewItem()
        _mediaPreview_?.collectionView.delegate = self
        _mediaPreview_?.collectionView.dataSource = self
        _mediaPreview_?.previewLineSpacing = previewLineSpacing
        _mediaPreview_?.zs_didEndPreview = { [weak self] in
            self?._mediaPreview_?.removeFromSuperview()
            self?._mediaPreview_ = nil
        }
        return _mediaPreview_!
    }
    
    func zs_configTabPageCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = medias[indexPath.item]
        
        var cell: UICollectionViewCell?
        
        switch model.mediaType {
        case .Image:
            cell = zs_configTabPageImageCell(collectionView, cellForItemAt: indexPath, model: model)
            break
        case .Video:
            cell = zs_configTabPageVideoCell(collectionView, cellForItemAt: indexPath, model: model)
            break
        case .Audio:
            cell = zs_configTabPageAudioCell(collectionView, cellForItemAt: indexPath, model: model)
            break
        default:
            break
        }
        
        cell?.isExclusiveTouch = true
        
        if let mediaCell = cell as? ZSMediaPreviewCell {
            
            mediaCell.zoomScrollView.minimumZoomScale = minimumZoomScale
            mediaCell.zoomScrollView.maximumZoomScale = maximumZoomScale
            mediaCell.previewLineSpacing = previewLineSpacing
            mediaCell.delegate = self
        }
        return cell!
    }
}



/**
 * 1. ZSMediaPreviewServe 提供外部重写的方法
 * 2. 需要自定义每个Preview的样式，可重新以下的方法达到目的
 */
@objc extension ZSMediaPreviewServe {
    
    open func zs_configPreviewItem() {
        mediaPreview?.collectionView.register(ZSImagePreviewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZSImagePreviewCell.self))
        mediaPreview?.collectionView.register(ZSVideoPreviewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZSVideoPreviewCell.self))
        mediaPreview?.collectionView.register(ZSAudioPreviewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZSAudioPreviewCell.self))
    }
    
    open func zs_configTabPageImageCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, model: ZSMediaPreviewModel) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZSImagePreviewCell.self), for: indexPath) as? ZSImagePreviewCell
        
        if let image = model.mediaFile as? UIImage {
            cell?.imageView.image = image
        }
        
        if let mediaFile = model.mediaFile as? String {
            if let url = URL(string: mediaFile) {
                loadDelegate?.zs_imageView(cell!.imageView, load: url)
            }
        }
        
        let error: NSError = NSError.init(domain: NSURLErrorDomain, code: 10500, userInfo: [NSLocalizedDescriptionKey : "\(String(describing: model.mediaFile))\n无法识别的URL"])
        
        loadDelegate?.zs_previewMediaLoadFail?(error)
        
        return cell!
    }
    
    open func zs_configTabPageAudioCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, model: ZSMediaPreviewModel) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZSAudioPreviewCell.self), for: indexPath) as? ZSAudioPreviewCell
        cell?.playerView.urlString = model.mediaFile as? String
        return cell!
    }
    
    open func zs_configTabPageVideoCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, model: ZSMediaPreviewModel) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZSVideoPreviewCell.self), for: indexPath) as? ZSVideoPreviewCell
        
        if let image = model.thumbImage as? UIImage {
            cell?.imageView.image = image
        }
        
        if let mediaFile = model.thumbImage as? String {
            if let url = URL(string: mediaFile) {
                loadDelegate?.zs_imageView(cell!.imageView, load: url)
            }
        }
        
        cell?.playerView.urlString = model.mediaFile as? String
        
        return cell!
    }
}



/**
 * 1. UICollectionView 的代理
 * 2. 可根据需求进行重写
 */
@objc extension ZSMediaPreviewServe {
    
    // TODO: UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        
        page = page > medias.count ? medias.count - 1 : page
        
        guard currentIndex != page else { return }
        
        mediaPreview?.shouldPanGesture = true
        
        let cell = mediaPreview?.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ZSMediaPreviewCell
        
        cell?.zoomToOrigin()
        
        let model = medias[currentIndex]
        
        if model.mediaType != .Image {
            let playerCell = cell as? ZSPlayerPreviewCell
            playerCell?.stop()
        }
        
        currentIndex = page
        mediaPreview?.updateFrame(from: delegate?.zs_previewDidScroll?(to: page))
    }
    
    // TODO: UICollectionViewDataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return medias.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return zs_configTabPageCell(collectionView, cellForItemAt: indexPath)
    }
    
    // TODO: UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return tabViewInsert
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return minimumLineSpacing
    }
}




@objc extension ZSMediaPreviewServe {
    
    open func zs_mediaPreviewCellScrollViewDidSingleTap() {
        mediaPreview?.endPreview()
    }
    
    open func zs_mediaPreviewCellScrollViewShouldPanGestureRecognizer(_ enable: Bool) {
        mediaPreview?.shouldPanGesture = enable
        if mediaPreview?.shouldPanGesture == false {
            mediaPreview?.endPanGestureRecognizer()
        }
    }
    
    open func zs_mediaPreviewCellMediaLoadFail(_ error: Error) {
        loadDelegate?.zs_previewMediaLoadFail?(error)
    }
    
    open func zs_mediaPreviewCellScrollViewDidLongPress(_ collectionCell: UICollectionViewCell) {
        
        guard let indexPath = mediaPreview?.collectionView.indexPath(for: collectionCell) else { return }
        
        let model = medias[indexPath.item]
        
        delegate?.zs_previewLongPress?(from: model.mediaFile, type: model.mediaType)
    }
    
    open func zs_mediaPreviewCellMediaDidChangePlay(status: ZSPlayerStatus) {
        
        
    }
    
    open func zs_mediaPreviewCellMediaDidiChangePlayTime(second: TimeInterval) {
        
    }
    
    open func zs_mediaPreviewCellMediaLoadingView() -> UIView? {
        
        let loadingView = ZSLoadingView()
        loadingView.configLoadView()
        loadingView.backgroundColor = .clear
        loadingView.startAnimation()
        
        return loadingView
    }
}