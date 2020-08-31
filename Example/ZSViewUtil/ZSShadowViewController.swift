//
//  ZSShadowViewController.swift
//  ZSViewUtil_Example
//
//  Created by Josh on 2020/8/31.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class ZSShadowViewController: UIViewController {

    lazy var shadowView: ZSShadowView = {
    
        let shadowView = ZSShadowView()
        shadowView.backgroundColor = UIColor.white
        shadowView.clipsToBounds = true
        view.addSubview(shadowView)
        return shadowView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        shadowView.frame = CGRect(x: 0, y: 60, width: 96 + 32, height: 48 + 32)
        shadowView.radius = 24
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3, animations: {
                self.shadowView.frame = CGRect(x: 0, y: 60, width: 48 + 32, height: 48 + 32)
            }) { (finished) in
                self.shadowView.setNeedsDisplay()
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
}
