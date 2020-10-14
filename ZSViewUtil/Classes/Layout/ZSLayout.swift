//
//  ZSLayout.swift
//  ZSViewUtil
//
//  Created by Josh on 2020/8/5.
//

import Foundation

public enum KDevice {
    
    // MARK: - 屏幕宽高、frame
    static public let width: CGFloat = UIScreen.main.bounds.width
    static public let height: CGFloat = UIScreen.main.bounds.height
    static public let bounds: CGRect = UIScreen.main.bounds
    
    // MARK: - 关于刘海屏幕适配
    static public let tabbarHeight: CGFloat = KDevice.isBangs ? 83 : 49
    static public let safeBottom: CGFloat = KDevice.isBangs ? 34 : 0
    static public let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    static public let navigationHeight: CGFloat = 44 + statusBarHeight
    
    // MARK: - 设备类型
    static public let isPhone: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
    static public let isPad: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    static public let isBangs: Bool = (String(format: "%.2f", 9.0 / 19.5) == String(format: "%.2f", KDevice.width / KDevice.height))
}

// MARK: - iPhone以375 * 667为基础机型的比例系数，iPad以768 * 1024为基础机型的比例系数
public extension CGFloat {
    
    var zs_pt: CGFloat { return CGFloat(Double(String(format: "%.3f", self * KDevice.width / 375.0)) ?? 0) }
    
    var zs_width_ratio: CGFloat { return self * ( KDevice.isPad ?  768.0 / 1024.0 : 375.0 / 667.0 ) }
    
    var zs_height_ratio: CGFloat { return self * ( KDevice.isPad ?  1024.0 / 768.0 : 667.0 / 375.0 ) }
}

public extension Int {
    
    var zs_pt: CGFloat { return CGFloat(self).zs_pt }
    
    var zs_width_ratio: CGFloat { return CGFloat(self).zs_width_ratio }
    
    var zs_height_ratio: CGFloat { return CGFloat(self).zs_height_ratio }
}

public extension Float {
    
    var zs_pt: CGFloat { return CGFloat(self).zs_pt }
    
    var zs_width_ratio: CGFloat { return CGFloat(self).zs_width_ratio }
    
    var zs_height_ratio: CGFloat { return CGFloat(self).zs_height_ratio }
}

public extension Double {
    
    var zs_pt: CGFloat { return CGFloat(self).zs_pt }
    
    var zs_width_ratio: CGFloat { return CGFloat(self).zs_width_ratio }
    
    var zs_height_ratio: CGFloat { return CGFloat(self).zs_height_ratio }
}


// MARK: - UIView 扩展
@objc public extension UIView {
    
    func zs_margin(top: CGFloat = CGFloat(MAXFLOAT),
                   left: CGFloat = CGFloat(MAXFLOAT),
                   bottom: CGFloat = CGFloat(MAXFLOAT),
                   right: CGFloat = CGFloat(MAXFLOAT)) {
        
        zs_margin = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    var zs_margin: UIEdgeInsets {
        set
        {
            let top = newValue.top == CGFloat(MAXFLOAT) ? zs_top : newValue.top
            let left = newValue.left == CGFloat(MAXFLOAT) ? zs_left : newValue.left
            let bottom = newValue.bottom == CGFloat(MAXFLOAT) ? zs_bottom : newValue.bottom
            let right = newValue.right == CGFloat(MAXFLOAT) ? zs_right : newValue.right
            
            zs_left = left
            zs_top = top
            zs_right = right
            zs_bottom = bottom
        }
        get
        {
            return UIEdgeInsets(top: zs_top,
                                left: zs_left,
                                bottom: zs_bottom,
                                right: zs_right)
        }
    }
    
    var zs_top: CGFloat {
        set
        {
            frame.origin.y = newValue
        }
        get
        {
            return frame.minY
        }
    }
    
    var zs_left: CGFloat {
        set
        {
            frame.origin.x = newValue
        }
        get
        {
            return frame.minX
        }
    }
    
    var zs_bottom: CGFloat {
        
        set
        {
            let bottom = newValue == CGFloat(MAXFLOAT) ? zs_bottom : newValue

            let superheight = (superview?.frame.height ?? 0)
            
            zs_height = superheight > 0 ? superheight - zs_top - bottom : 0
        }
        get
        {
            let superheight = (superview?.frame.height ?? 0)
            
            return zs_maxY > 0 ? superheight - zs_maxY : zs_maxY
        }
    }
    
    var zs_right: CGFloat {
        
        set
        {
            let right = newValue == CGFloat(MAXFLOAT) ? zs_right : newValue

            let superwidth = (superview?.frame.width ?? 0)
            
            zs_width = superwidth > 0 ? superwidth - zs_left - right : 0
        }
        get
        {
            let superwidth = (superview?.frame.width ?? 0)
            
            return zs_maxX > 0 ? superwidth - zs_maxX : zs_maxX
        }
    }
    
    var zs_centerX: CGFloat {
        set
        {
            center.x = newValue
        }
        get
        {
            return center.x
        }
    }
    
    var zs_centerY: CGFloat {
        set
        {
            center.y = newValue
        }
        get
        {
            return center.y
        }
    }
    
    var zs_width: CGFloat {
        set
        {
            frame.size.width = newValue
        }
        get
        {
            return frame.width
        }
    }
    
    var zs_height: CGFloat {
        set
        {
            frame.size.height = newValue
        }
        get
        {
            return frame.height
        }
    }
    
    var zs_maxX: CGFloat { return frame.maxX }
    
    var zs_maxY: CGFloat { return frame.maxY }
}

// MARK: - UIColor扩展
@objc extension UIColor {
    
    class func hexString(hexCode: String) -> String {
        
        var hexString: String = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hexString.hasPrefix("#"))
        {
            hexString.remove(at: hexString.startIndex)
        }
        
        if (hexString.hasPrefix("0X"))
        {
            hexString = String(hexString[hexString.index(hexString.startIndex, offsetBy: 2)..<hexString.endIndex])
        }
        
        return hexString
    }
    
    public convenience init(rgb hexCode: String, alpha: CGFloat = 1) {
        
        let cString = Self.hexString(hexCode: hexCode)
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        if cString.count == 6
        {
            
            self.init(r: CGFloat((rgbValue & 0x00FF0000) >> 16),
                      g: CGFloat((rgbValue & 0x0000FF00) >> 8),
                      b: CGFloat(rgbValue & 0x000000FF),
                      a: alpha)
            return
        }
        
        self.init(r: 255,
                  g: 255,
                  b: 255,
                  a: 1)
    }
    
    public convenience init(argb hexCode: String, alpha: CGFloat = 1) {
        
        let cString = Self.hexString(hexCode: hexCode)
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        if cString.count == 8
        {
            
            self.init(r: CGFloat((rgbValue & 0x00FF0000) >> 16),
                      g: CGFloat((rgbValue & 0x0000FF00) >> 8),
                      b: CGFloat(rgbValue & 0x000000FF),
                      a: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0)
            return
        }
        
        self.init(r: 255,
                  g: 255,
                  b: 255,
                  a: 1)
    }
    
    public convenience init(rgba hexCode: String, alpha: CGFloat = 1) {
        
        let cString = Self.hexString(hexCode: hexCode)
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        if cString.count == 8
        {
            
            self.init(r: CGFloat((rgbValue & 0xFF000000) >> 24),
                      g: CGFloat((rgbValue & 0x00FF0000) >> 16),
                      b: CGFloat((rgbValue & 0x0000FF00) >> 8),
                      a: CGFloat(rgbValue & 0x000000FF) / 255.0)
            return
        }
        
        self.init(r: 255,
                  g: 255,
                  b: 255,
                  a: 1)
    }
    
    public convenience init(r red: CGFloat,
                            g green: CGFloat,
                            b blue: CGFloat,
                            a alpha: CGFloat = 1) {
        
        self.init(red: red / 255.0,
                  green: green / 255.0,
                  blue: blue / 255.0,
                  alpha: alpha)
    }
    
    @available(iOS 13.0, *)
    public convenience init(lightR: CGFloat, darkR: CGFloat,
                            lightG: CGFloat, darkG: CGFloat,
                            lightB: CGFloat, darkB: CGFloat,
                            lightA: CGFloat, darkA: CGFloat) {
        
        self.init { (traitCollection) -> UIColor in
            
            switch traitCollection.userInterfaceStyle {
            case .light:
                return UIColor(r: lightR, g: lightG, b: lightB, a: lightA)
            case .dark:
                return UIColor(r: darkR, g: darkG, b: darkB, a: darkA)
            default:
                fatalError()
            }
        }
    }
    
    @available(iOS 13.0, *)
    public func dark(r red: CGFloat, g green: CGFloat, b blue: CGFloat, a alpha: CGFloat = 1) -> UIColor {
        
        return dark(UIColor(r: red/255.0, g: green/255.0, b: blue/255.0, a: alpha))
    }
    
    @available(iOS 13.0, *)
    public func dark(rgb hexCode: String) -> UIColor {
        
        return dark(UIColor(rgb: hexCode))
    }
    
    @available(iOS 13.0, *)
    public func dark(argb hexCode: String) -> UIColor {
        
        return dark(UIColor(argb: hexCode))
    }
    
    @available(iOS 13.0, *)
    public func dark(rgba hexCode: String) -> UIColor {
        
        return dark(UIColor(rgba: hexCode))
    }
    
    @available(iOS 13.0, *)
    public func dark(_ color: UIColor) -> UIColor {
        
        return UIColor { (traitCollection) -> UIColor in
            
            switch traitCollection.userInterfaceStyle {
            case .light:
                return self
            case .dark:
                return color
            default:
                fatalError()
            }
        }
    }
}
