//
//  ShapeDemoController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class ShapeDemoController: UIViewController {
    
    lazy var shapeView: UIView = {
        
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .red
        self.view.addSubview(view)
        return view
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer.zs_init(roundingCorners: [.topLeft, .bottomLeft], cornerRadius: 10, to: shapeView.layer)
        
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        shapeView.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        shapeLayer.frame = shapeView.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

