//
//  ZSLoopCubeView.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/5/13.
//

import UIKit

@objc public protocol ZSLoopCubeViewDataSource {
    
    /// 滚动视图的总数
    /// - Parameter loopCubeView: loopCubeView
    func zs_numberOfItemLoopCubeView(_ loopCubeView: ZSLoopCubeView) -> Int
    
    /// 滚动到的视图
    /// - Parameters:
    ///   - loopCubeView: loopCubeView
    func zs_loopCubeView(_ loopCubeView: ZSLoopCubeView, index: Int) -> UIView
}

@objc public protocol ZSLoopCubeViewDelegate {
    
    /// 滚动视图Item的点击
    /// - Parameters:
    ///   - loopScrollView: loopScrollView
    ///   - index: 当前view展示的index
    func zs_loopCubeView(_ loopCubeView: ZSLoopCubeView, didSelectedItemFor index: Int)
    
    /// 滚动到的视图
    /// - Parameters:
    ///   - loopCubeView: loopCubeView
    ///   - index: 当前view展示的index
    func zs_loopCubeFinishView(_ loopCubeView: ZSLoopCubeView, index: Int)
}


@objc public enum ZSTransitionCubFrom: Int {
    case top = 1, bottom = 2, left = 3, right = 4
}


@objcMembers open class ZSLoopCubeView: UIView {
    
    var timer: Timer?
    var cubeCount: Int = 0
    var index: Int = 0
    
    /// 滚动视图的数据配置
    public weak var dataSource: ZSLoopCubeViewDataSource?
    
    /// 滚动视图的交互
    public weak var delegate: ZSLoopCubeViewDelegate?
    
    /// 是否开启自动滚动，默认为 true
    public var isAutoScroll: Bool = true
    
    /// 自动滚动的间隔时长，默认是 3 秒
    public var interval: TimeInterval = 3
    
    /// cube动画时长，默认是 0.5 秒
    public var duration: TimeInterval = 0.5
    
    /// 是否开启循环滚动，默认是true
    public var isLoopCube: Bool = true
    
    /// 滚动的方向
    public var cubFrom: ZSTransitionCubFrom = .top
    
    lazy var contentView: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didSelectedCube), for: .touchUpInside)
        
        addSubview(button)
        return button
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        
        cubeCount = dataSource?.zs_numberOfItemLoopCubeView(self) ?? 0
        
        isLoopCube = isLoopCube ? cubeCount > 1 : isLoopCube
        
        viewWithIndex(101)?.frame = bounds
        
        beginAutoLoopCube()
    }
    
    @objc func didSelectedCube() {
        delegate?.zs_loopCubeView(self, didSelectedItemFor: index)
    }
    
    func viewWithIndex(_ tag: Int) -> UIView? {
        
        if let view = viewWithTag(tag) {
            return view
        }
        
        guard let view = dataSource?.zs_loopCubeView(self, index: index) else { return nil }
        view.tag = tag
        contentView.addSubview(view)
        
        return view
    }
    
    @objc func beginCubeAnimation() {
        
        guard let view = viewWithIndex(101) else { return }
        
        if isLoopCube {
            index = index >= cubeCount ? 0 : index
        }
        
        guard index < cubeCount - 1 else { return }
        
        view.layer.add(cubeAnimation, forKey: "animation")
        index += 1
        delegate?.zs_loopCubeFinishView(self, index: index)
    }
    
    open var cubeAnimation: CATransition {
        
        let animation = CATransition()
        animation.duration = duration
        animation.type = CATransitionType(rawValue: "cube")
        animation.isRemovedOnCompletion = true
        
        switch cubFrom {
        case .top:
            animation.subtype = .fromTop
            break
        case .bottom:
            animation.subtype = .fromBottom
            break
        case .left:
            animation.subtype = .fromLeft
            break
        case .right:
            animation.subtype = .fromRight
            break
        }
        return animation
    }
    
    func beginAutoLoopCube() {
        
        guard isAutoScroll else { return }
        
        guard timer == nil else { return }
        
        timer = Timer.loopCube_supportiOS_10EarlierTimer(interval + duration, repeats: true, block: { [weak self] (timer) in
            
            self?.autoLoopCube()
        })
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func endAutoLoopCube() {
        
        timer?.invalidate()
        timer = nil
    }
    
    func autoLoopCube() {
        beginCubeAnimation()
    }
    
    /// 刷新数据源
    public func reloadDataSource() {
        index = 0
        viewWithIndex(101)?.removeFromSuperview()
        layoutSubviews()
    }
    
    deinit {
        endAutoLoopCube()
    }
}




extension Timer {
    
    class func loopCube_supportiOS_10EarlierTimer(_ interval: TimeInterval, repeats: Bool, block: @escaping (_ timer: Timer) -> Void) -> Timer {
        
        if #available(iOS 10.0, *) {
            return Timer.init(timeInterval: interval, repeats: repeats, block: block)
        } else {
            return Timer.init(timeInterval: interval, target: self, selector: #selector(loopCubeRunTimer(_:)), userInfo: block, repeats: repeats)
        }
    }
    
    @objc private class func loopCubeRunTimer(_ timer: Timer) -> Void {
        
        guard let block: ((Timer) -> Void) = timer.userInfo as? ((Timer) -> Void) else { return }
        
        block(timer)
    }
}
