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
    func zs_loopCubeView(_ loopCubeView: ZSLoopCubeView) -> UIView
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


@objcMembers open class ZSLoopCubeView: UIView, CAAnimationDelegate {
    
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
        
        refreshItemUI(cubeCount)
    }
    
    @objc func didSelectedCube() {
        delegate?.zs_loopCubeView(self, didSelectedItemFor: index)
    }
    
    func viewWithIndex(_ index: Int) -> UIView? {
        
        if let view = viewWithTag(101) {
            return view
        }
        
        guard let view = dataSource?.zs_loopCubeView(self) else { return nil }
        view.tag = 101
        view.frame = bounds
        contentView.addSubview(view)
        return view
    }
    
    func refreshItemUI(_ pageCount: Int) {
        
        guard pageCount > 0 else { return }
        
        beginAutoLoopCube()
    }
    
    @objc func beginAutoLoopCube() {
        
        guard let view = viewWithIndex(101) else { return }
        
        guard isAutoScroll else { return }
        
        if isLoopCube {
            index = index >= cubeCount ? 0 : index
        }
        
        guard index < cubeCount else { return }
        
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = CATransitionType(rawValue: "cube")
        animation.delegate = self
        
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
        
        delegate?.zs_loopCubeFinishView(self, index: index)
        view.layer.add(animation, forKey: "animation")
        index += 1
        perform(#selector(beginAutoLoopCube), with: nil, afterDelay: interval + 0.5)
    }
    
    /// 刷新数据源
    public func reloadDataSource() {
        
        layoutSubviews()
    }
    
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
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
