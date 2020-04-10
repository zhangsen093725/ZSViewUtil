//
//  ZSMediaPreviewServe.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/4/8.
//

import UIKit

/// preview 交互
@objc public protocol ZSMediaPreviewDelegate: class {
    
    /// 长按的回调，用于处理长按事件，开启长按事件时有效
    /// - Parameters:
    ///   - mediaFile: 媒体文件
    ///   - type: 文件类型
    @objc optional func zs_previewLongPress(from mediaFile: Any, type: ZSMediaType)
    
    /// 视图滚动的回调
    /// - Parameter index: 滚动视图的索引
    @objc optional func zs_previewDidScroll(to index: Int)
}


/// preview 资源加载
@objc public protocol ZSMediaPreviewLoadDelegate: class {
    
    /// 加载 image URL
    /// - Parameters:
    ///   - imageView: 展示的imageView
    ///   - imageURL: image URL
    func zs_imageView(_ imageView: UIImageView, load imageURL: URL)
    
    /// 媒体加载中
    @objc optional func zs_previewMediaLoading()
    
    /// 媒体加载完成
    @objc optional func zs_previewMediaLoadComplete()
    
    /// 媒体加载失败
    /// - Parameter error: 错误信息
    @objc optional func zs_previewMediaLoadFail(_ error: Error)
    
    /// 媒体开始播放会回调，只用于处理特殊要求，一般用不上，返回值确定是否要播放
    /// @return 返回值确定是否要播放
    @objc optional func zs_previewIsBeginPlay() -> Bool
}


@objcMembers open class ZSMediaPreviewServe: NSObject, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public weak var delegate: ZSMediaPreviewDelegate?
    public weak var loadDelegate: ZSMediaPreviewLoadDelegate?
    
    public override init() {
        super.init()
        zs_configTabPageView()
    }
    
    public lazy var mediaPreview: ZSMediaPreview = {
        
        let preview = ZSMediaPreview()
        preview.collectionView.delegate = self
        preview.collectionView.dataSource = self
        preview.previewLineSpacing = previewLineSpacing
        return preview
    }()
    
    /// 默认为单一媒体
    public var isSingleMedia: Bool = true
    
    /// medias 为 ZSMediaPreviewModel，只在 isSingleMedia = false 时，ZSMediaPreviewModel 中 mediaType 生效
    public var medias: [ZSMediaPreviewModel] = []
    
    /// 展示单一类型的媒体文件时，直接设置，默认为图片，只在 isSingleMedia = true 时有效，过滤类型不同的媒体
    public var mediaType: ZSMediaType = .Image
    
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
            mediaPreview.collectionView.reloadData()
        }
    }
    /// preview 之间的间隙
    public var previewLineSpacing: CGFloat = 20 {
        didSet {
            mediaPreview.previewLineSpacing = previewLineSpacing
            mediaPreview.collectionView.reloadData()
        }
    }
    
    /// preview insert
    public var tabViewInsert: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            mediaPreview.collectionView.reloadData()
        }
    }
}



/**
 * 1. ZSMediaPreviewServe 提供外部重写的方法
 * 2. 需要自定义每个Preview的样式，可重新以下的方法达到目的
 */
@objc extension ZSMediaPreviewServe {
    
    open func zs_configTabPageView() {
        mediaPreview.collectionView.register(ZSImagePreviewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZSImagePreviewCell.self))
        mediaPreview.collectionView.register(ZSVideoPreviewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZSVideoPreviewCell.self))
        mediaPreview.collectionView.register(ZSAudioPreviewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ZSAudioPreviewCell.self))
    }
    
    open func zs_configTabPageCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZSImagePreviewCell.self), for: indexPath) as? ZSImagePreviewCell
        
        cell?.isExclusiveTouch = true
        
        let model = medias[indexPath.item]
        
        loadDelegate?.zs_imageView(cell!.imageView, load: URL(string: model.mediaFile as! String)!)
        //        cell?.imageView.image = model.mediaFile as? UIImage
        cell?.zoomScrollView.minimumZoomScale = minimumZoomScale
        cell?.zoomScrollView.maximumZoomScale = maximumZoomScale
        cell?.previewLineSpacing = previewLineSpacing
        cell?.delegate = mediaPreview
        
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

        var page = Int(scrollView.contentOffset.x / (scrollView.frame.width + previewLineSpacing) + 0.5)
        
        page = page > medias.count ? medias.count - 1 : page
        
        guard currentIndex != page else { return }
        
        let cell = mediaPreview.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ZSMediaPreviewCell
        
        cell?.zoomToOrigin()
        
        let model = medias[currentIndex]
        
        let _mediaType_ = isSingleMedia ? mediaType : model.mediaType
        
        if _mediaType_ != .Image {
            let playerCell = cell as? ZSAudioPreviewCell
            //            playerCell.stop()
        }
        
        currentIndex = page
        delegate?.zs_previewDidScroll?(to: page)
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
