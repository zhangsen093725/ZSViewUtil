//
//  SphereViewController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/13.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class SphereViewController: UIViewController {

    lazy var sphereView: ZSSphereView = {
        
        let sphereView = ZSSphereView()
        sphereView.backgroundColor = .blue
        view.addSubview(sphereView)
        return sphereView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        sphereView.zs_setSphere(itemsFromLabel())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sphereView.frame = CGRect(x: 0, y: (view.frame.height - view.frame.width) * 0.5, width: view.frame.width, height: view.frame.width)
        sphereView.zs_beginAnimation()
    }
    
    func itemsFromLabel() -> [UILabel] {
        
        var labels: [UILabel] = []
        for index in 0..<200 {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            label.text = "\(index)"
            label.textColor = .white
            label.textAlignment = .center
            label.backgroundColor = .black
            labels.append(label)
        }
        
        return labels
    }
}


class ZSTabViewServe_: ZSTabViewServe {
    
    override func zs_configTabView() {
        super.zs_configTabView()
    }
    
    
}