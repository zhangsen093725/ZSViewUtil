//
//  DragViewDemoController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class DragViewDemoController: UIViewController {
    
    lazy var dragView: ZSDragCollectionView = {
        
        let dragView = ZSDragCollectionView()
        dragView.backgroundColor = .orange
        view.addSubview(dragView)
        return dragView
    }()
    
    lazy var dragViewServe: ZSDragStaticShakeViewServe = {
        
        let dragViewServe = ZSDragStaticShakeViewServe()
        return dragViewServe
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        dragViewServe.setterCollectionView(dragView.collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dragView.frame = CGRect(x: 30 * KWidthUnit, y: 100 * KHeightUnit, width: 300 * KWidthUnit, height: 300 * KHeightUnit)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
