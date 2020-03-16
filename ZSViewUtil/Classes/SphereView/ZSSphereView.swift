//
//  ZSSphereView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/13.
//

import UIKit

@objcMembers open class ZSSphereView: UIView {
    
    /// 是否开启自动滚动，默认为 true
    public var isAutoRotate: Bool = true
    
    /// 自动滚动的速度，默认是 6 度 / 秒，惯性的大小和速度影响手指拖拽时滚动的速度
    public var autoRotateSpeed: CGFloat = 6
    
    /// 是否开启滚动惯性，默认为 true
    public var isInertiaRotate: Bool = true
    
    /// 惯性的初始大小，默认为 20，惯性的大小和速度影响手指拖拽时滚动的速度
    public var inertiaRotatePower: CGFloat = 20
    
    /// 是否开启翻转手势，defult：true
    public var isRotationGesture: Bool = true
    
    /// 是否开启拖动手势，defult：true
    public var isPanGesture: Bool = true
    
    var property = Property()
    
    struct Property {
        
        var intervalRotatePoint: CGPoint = CGPoint(x: 1, y: 1)
        
        var fps: CGFloat = 60
        
        var displayLink: ZSSphereDisplayLink?
        
        var inertiaDisplayLink: ZSSphereDisplayLink?
        
        var items: [UIView] = []
        
        var itemPoints: [PFPoint] = []
        
        var previousLocationInView: CGPoint = .zero
        
        var originalLocationInView: CGPoint = .zero
        
        var lastXAxisDirection: PFAxisDirection = PFAxisDirectionNone
        
        var lastYAxisDirection: PFAxisDirection = PFAxisDirectionNone
        
        var inertiaRotatePower: CGFloat = 0
        
        var lastSphereRotationAngle: CGFloat = 1
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGestureRecognizer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        stopDisplay()
        stopInertiaDisplay()
    }
    
    open func zs_setSphere(_ items: [UIView]) {
        
        guard items.count > 0 else { return }
        property.items = Array(items)
        
        let inc = Double.pi * (3 - sqrt(5))
        let offset = 2 / Double(items.count)
        
        for (index, item) in items.enumerated() {
            
            let y = Double(index) * offset - 1 + (offset * 0.5)
            let r = sqrt(1 - pow(y, 2))
            let phi = Double(index) * inc
            
            let point = PFPoint(x: CGFloat(cos(phi)*r), y: CGFloat(y), z: CGFloat(sin(phi)*r))
            property.itemPoints.append(point)
            addSubview(item)
        }
        
        if isAutoRotate {
            startDisplay()
        } else {
            runDisplayLink()
        }
    }
}
