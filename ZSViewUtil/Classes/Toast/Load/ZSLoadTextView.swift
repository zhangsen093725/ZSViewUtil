//
//  ZSLoadTextView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/1/15.
//

import UIKit

open class ZSLoadTextView: UIView {
    
    private static let `defult` = ZSLoadTextView()
    
    public lazy var loadView: ZSLoadingView = {
        
        let loadView = ZSLoadingView()
        loadView.backgroundColor = .clear
        addSubview(loadView)
        return loadView
    }()
    
    public lazy var textLabel: UILabel = {
        
        let textLabel = UILabel()
        addSubview(textLabel)
        return textLabel
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open func configLoadView() {
        
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 15)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        textLabel.frame = CGRect(x: 0, y: bounds.height - 35, width: bounds.width, height: 20)
        loadView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: textLabel.frame.origin.y)
    }
    
    open func startAnimation(_ text: String,
                             to view: UIView?,
                             size: CGSize,
                             backgroundColor: UIColor) {
        
        loadView.stopTimer()
        
        if view == nil {
            
            frame = CGRect(x: (UIScreen.main.bounds.width - size.width) * 0.5, y: (UIScreen.main.bounds.height - size.height) * 0.5, width: size.width, height: size.height)
            
            var controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
            
            while (controller?.presentedViewController != nil && !(controller?.presentedViewController is UIAlertController)) {
                controller = controller?.presentedViewController
            }
            controller?.view.addSubview(self)
            
        }else{
            let viewWidth = view!.frame.width
            let viewHeight = view!.frame.height
            
            let width = viewWidth > 0 ? size.width : 0
            let height = viewHeight > 0 ? size.width : 0
            
            frame = CGRect(x: (viewWidth - width) * 0.5, y: (viewHeight - height) * 0.5, width: width, height: height)
            
            view?.addSubview(self)
        }
        
        alpha = 1
        self.backgroundColor = backgroundColor
        
        configLoadView()
        loadView.startTimer()
        textLabel.text = text
    }
    
    open func stopAnimation() {
        
        loadView.stopTimer()
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
        }
    }
    
    
    public class func startAnimation(
        _ text: String,
        to view: UIView? = nil,
        size: CGSize = CGSize(width: 140, height: 108),
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.7)) {
        
        ZSLoadTextView.defult.startAnimation(text, to: view, size: size, backgroundColor: backgroundColor)
    }
    
    public class func stopAnimation() {
        ZSLoadTextView.defult.stopAnimation()
    }
    
}
