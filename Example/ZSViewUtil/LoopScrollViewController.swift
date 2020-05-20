//
//  LoopScrollViewController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/5/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class LoopScrollViewController: UIViewController, ZSLoopScrollViewDelegate, ZSLoopScrollViewDataSource {

    lazy var loopScroll: ZSLoopScrollView = {
        
        let loopScroll = ZSLoopScrollView()
        loopScroll.delegate = self
        loopScroll.dataSource = self
        view.addSubview(loopScroll)
        return loopScroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
       super.viewWillLayoutSubviews()
        loopScroll.frame = CGRect(x: 10, y: 150, width: view.zs_w - 20, height: 300)
    }
    
    func zs_numberOfItemLoopScrollView(_ loopScrollView: ZSLoopScrollView) -> Int {
        
        return 2
    }
    
    func zs_loopScrollViewDidScroll(_ loopScrollView: ZSLoopScrollView, index: Int) {
        
    }
    
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, itemAt index: Int) -> UIView {
        
        let view = UIView()
        view.backgroundColor = KColor(CGFloat(index * 125), CGFloat(index * 125), CGFloat(index * 125), 1)
        return view
    }
    
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, sizeAt index: Int) -> CGSize {
        
        return CGSize(width: view.zs_w - 20, height: 300)
    }
    
    func zs_loopScrollView(_ loopScrollView: ZSLoopScrollView, didSelectedItemFor index: Int) {
        
    }
}
