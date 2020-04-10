//
//  ZSImagePreviewCell.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/4/8.
//

import UIKit

@objcMembers open class ZSImagePreviewCell: ZSMediaPreviewCell {
    
    public lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
            imageView.addObserver(self, forKeyPath: "image", options: .new, context: nil)
        zoomScrollView.addSubview(imageView)
        return imageView
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let width = zoomScrollView.frame.width
        
        let heightInt = Int(imageView.image == nil ? contentView.frame.height : (width / imageView.image!.size.width * imageView.image!.size.height))
        var h = heightInt % 16
        h = h == 0 ? 0 : 16 - h
        
        let height = CGFloat(heightInt - h)
        
        let x = abs(width - zoomScrollView.frame.width) * 0.5
        let y = (height - zoomScrollView.frame.height) > 0 ? 0 : abs(height - zoomScrollView.frame.height) * 0.5
        
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        zoomScrollView.contentSize = CGSize(width: width, height: height)
    }
}


@objc extension ZSImagePreviewCell {
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "image" {
            layoutSubviews()
        }
    }
}



@objc extension ZSImagePreviewCell {
    
    open override func refreshMediaViewCenter(from point: CGPoint) {
        imageView.center = point
    }
}



@objc extension ZSImagePreviewCell {
    
    open override func longPress(_ longPressGesture: UILongPressGestureRecognizer) {
        
    }
    
    open override func enlargeImage(from point: CGPoint) {
        
        guard imageView.frame.contains(point) else { return }
        
        super.enlargeImage(from: point)
    }
}



@objc extension ZSImagePreviewCell {

    open override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
