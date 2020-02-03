//
//  ZSDragImageItemView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/3.
//

import Foundation

open class ZSDragImageItemView: UICollectionViewCell {
    
    public var itemGestureRecognizerHandle: ((_ gestureRecognizer: UIGestureRecognizer)->Void)?
    
    public var itemEditHandle: ((_ cell: ZSDragImageItemView)->Void)?
    
    private lazy var backView: UIView = {
        
        let backView = UIView()
        backView.backgroundColor = .clear
        configGestureRecognizer()
        contentView.addSubview(backView)
        return backView
    }()
    
    public lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        backView.addSubview(imageView)
        return imageView
    }()
    
    public lazy var editBtn: UIButton = {
        
        let editBtn = UIButton(type: .system)
        editBtn.tintColor = .clear
        editBtn.isHidden = true
        editBtn.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        backView.addSubview(editBtn)
        return editBtn
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        backView.frame = contentView.bounds
        imageView.frame = backView.bounds
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        itemGestureRecognizerHandle = nil
        itemEditHandle = nil
    }
    
    open func configGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerAction(_:)))
        addGestureRecognizer(pan)
    }
    
    @objc open func gestureRecognizerAction(_ gestureRecognizer: UIGestureRecognizer) {
     
        guard itemGestureRecognizerHandle != nil else { return }
        itemGestureRecognizerHandle!(gestureRecognizer)
    }
    
    @objc open func editAction() {
        
        guard itemEditHandle != nil else { return }
        itemEditHandle!(self)
    }
}
