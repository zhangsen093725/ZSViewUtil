//
//  ViewController.swift
//  ZSViewUtil
//
//  Created by zhangsen093725 on 01/14/2020.
//  Copyright (c) 2020 zhangsen093725. All rights reserved.
//

import UIKit
import ZSViewUtil

class ViewController: UIViewController {

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
        button.addTarget(self, action: #selector(change), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        ZSIndicatorTextView.startAnimation("哈说丹深爱的")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textFiled.frame = CGRect(x: 30 * KWidthUnit, y: 100 * KHeightUnit, width: 200 * KWidthUnit, height: 45 * KHeightUnit)
        button.frame = CGRect(x: 30 * KWidthUnit, y: 150 * KHeightUnit, width: 200 * KWidthUnit, height: 45 * KHeightUnit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func change() {
        button.setTitle(textFiled.text, for: .normal)
        textFiled.isVisibleText = !textFiled.isVisibleText
        textFiled.replaceVisibleText = "&"
    }

}

