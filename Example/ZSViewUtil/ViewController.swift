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
    
    lazy var dragView: ZSDragImageView = {
        
        let dragView = ZSDragImageView()
        dragView.backgroundColor = .orange
        view.addSubview(dragView)
        return dragView
    }()
    
    lazy var dragViewServe: ZSLongPressDragImageViewServe = {
        
        let dragViewServe = ZSLongPressDragImageViewServe()
        return dragViewServe
    }()
    
    public lazy var collectionView: ZSCollectionView = {
        
        let layout = ZSPlainFlowLayout()
        layout.plainOffset = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        
        let collectionView = ZSCollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false

        view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var headerView: UIView = {
        
        let headerView = UIView()
        headerView.backgroundColor = .red
        collectionView.collectionViewBottomView = headerView
        return headerView
    }()
    
    lazy var collectionViewServe: ZSPlainFlowLayoutServe = {
        
        let collectionViewServe = ZSPlainFlowLayoutServe()
        return collectionViewServe
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        //        ZSIndicatorTextView.startAnimation("哈说丹深爱的")
        collectionViewServe.setterCollectionView(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        textFiled.frame = CGRect(x: 30 * KWidthUnit, y: 100 * KHeightUnit, width: 200 * KWidthUnit, height: 45 * KHeightUnit)
        //        button.frame = CGRect(x: 30 * KWidthUnit, y: 150 * KHeightUnit, width: 200 * KWidthUnit, height: 45 * KHeightUnit)
        collectionView.frame = view.bounds
        headerView.frame = CGRect(x: 0, y: 0, width: collectionView.zs_w, height: 180)
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

