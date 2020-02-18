//
//  ZSLayerUtil.swift
//  Pods-ZSViewUtil_Example
//
//  Created by 张森 on 2020/2/18.
//

import UIKit

public extension CAGradientLayer {

    /// 初始化渐变Layer
    /// - Parameters:
    ///   - locationColors: [渐变的位置，区间在[0,1] : 对应的渐变位置的颜色]
    ///   - startPointX: 渐变的水平起点，区间在[0,1]，默认为 0
    ///   - endPointX: 渐变的水平终点，区间在[0,1]，默认为 1
    ///   - startPointY: 渐变的垂直起点，区间在[0,1]，默认为 0
    ///   - endPointY: 渐变的垂直终点，区间在[0,1]，默认为 1
    class func zs_init(_ locationColors: [NSNumber : UIColor],
                       horizontal startPointX: CGFloat = 0,
                       to endPointX: CGFloat = 1,
                       vertical startPointY: CGFloat = 0,
                       to endPointY: CGFloat = 1) -> CAGradientLayer {
        
        var _startPointX_ = startPointX > 1 ? 1 : startPointX
        _startPointX_ = startPointX < 0 ? 0 : startPointX
        
        var _endPointX_ = endPointX > 1 ? 1 : endPointX
        _endPointX_ = endPointX < 0 ? 0 : endPointX
        
        var _startPointY_ = startPointY > 1 ? 1 : startPointY
        _startPointY_ = startPointY < 0 ? 0 : startPointY
        
        var _endPointY_ = endPointY > 1 ? 1 : endPointY
        _endPointY_ = endPointY < 0 ? 0 : endPointY
        
        var locations: [NSNumber] = []
        var colors: [CGColor] = []
        for (key, value) in locationColors {
            locations.append(key)
            colors.append(value.cgColor)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: _startPointX_, y: _startPointY_)
        gradientLayer.endPoint = CGPoint(x: _endPointX_, y: _endPointY_)
        return gradientLayer
    }
    
    
}
