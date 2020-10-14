//
//  TextFieldDemoController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class TextFieldDemoController: UIViewController {
    
    lazy var textFiled: ZSNumberField = {
        
        let textFiled = ZSNumberField()
        textFiled.replaceVisibleText = "-"
        textFiled.isVisibleText = false
        textFiled.backgroundColor = .gray
        view.addSubview(textFiled)
        return textFiled
    }()
    
    lazy var button: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("切换", for: .normal)
        button.setTitle("切换", for: .selected)
        button.addTarget(self, action: #selector(change), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textFiled.zs_margin(top: 100.zs_pt, left: 30.zs_pt, right: 30.zs_pt)
        textFiled.zs_height = 45.zs_pt
        
        button.zs_margin(top: textFiled.zs_bottom + 20.zs_pt, left: 30.zs_pt, right: 30.zs_pt)
        button.zs_height = 45.zs_pt
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func change() {
        textFiled.isVisibleText = !textFiled.isVisibleText
        textFiled.replaceVisibleText = "&"
    }
    
}
