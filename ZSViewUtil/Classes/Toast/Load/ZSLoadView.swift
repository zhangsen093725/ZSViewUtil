//
//  ZSLoadView.swift
//  ZSToastView
//
//  Created by 张森 on 2019/8/14.
//  Copyright © 2019 张森. All rights reserved.
//

import UIKit

// MARK: - ZSLoadingView
@objcMembers public class ZSLoadingView: UIView {
    
    private static let `defult` = ZSLoadingView()
    
    private var startRatio: Double = 0.1 {
        willSet {
            setNeedsDisplay()
        }
    }
    
    private var endRatio: Double = 1.9 {
        willSet {
            setNeedsDisplay()
        }
    }
    
    private var timer: Timer?
    
    override public func draw(_ rect: CGRect) {
        
        let lineWidth: CGFloat = 2
        
        let bezierWidth: CGFloat = rect.width - 20
        let bezierHeight: CGFloat = rect.height - 20
        
        let radius = (min(bezierWidth, bezierHeight) - lineWidth) * 0.5
        
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = lineWidth
        UIColor.white.set()
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
        
        bezierPath.addArc(withCenter: CGPoint(x: rect.width * 0.5, y: rect.height * 0.5), radius: radius, startAngle: CGFloat(Double.pi * (1.5 + startRatio)), endAngle: CGFloat(Double.pi * (1.5 + endRatio)), clockwise: true)
        
        bezierPath.stroke()
    }
    
    func startTimer() {
        guard timer == nil else { return }
        
        timer = Timer.supportiOS_10EarlierTimer(0.025, repeats: true, block: { [unowned self] (timer) in
            
            if self.startRatio >= 2.1 {
                self.startRatio = 0.1
                self.endRatio = 1.9
            }
            
            self.endRatio += 0.05
            self.startRatio += 0.05
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    open func configLoadView() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    open func startAnimation(to view: UIView? = nil,
                                size: CGSize,
                                backgroundColor: UIColor) {
        
        stopTimer()
        
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
        setNeedsDisplay()
        
        startTimer()
    }
    
    open func stopAnimation() {
        
        stopTimer()
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
        }
    }
    
    
    public class func startAnimation(
        to view: UIView? = nil,
        size: CGSize = CGSize(width: 80, height: 80),
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.7)) -> ZSLoadingView {
        
        ZSLoadingView.defult.startAnimation(to: view, size: size, backgroundColor: backgroundColor)
        return ZSLoadingView.defult
    }
    
    public class func stopAnimation() {
        ZSLoadingView.defult.stopAnimation()
    }
}


private extension Timer {
    
    class func supportiOS_10EarlierTimer(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        
        if #available(iOS 10.0, *) {
            return Timer.init(timeInterval: interval, repeats: repeats, block: block)
        } else {
            return Timer.init(timeInterval: interval, target: self, selector: #selector(loadRunTimer(_:)), userInfo: block, repeats: repeats)
        }
    }
    
    @objc private class func loadRunTimer(_ timer: Timer) -> Void {
        
        guard let block: ((Timer) -> Void) = timer.userInfo as? ((Timer) -> Void) else { return }
        
        block(timer)
    }
}
