//
//  ViewController.swift
//  ZSViewUtil
//
//  Created by zhangsen093725 on 01/14/2020.
//  Copyright (c) 2020 zhangsen093725. All rights reserved.
//

import UIKit
import ZSViewUtil

class ViewController: UIViewController, ZSPageViewServeDelegate {
    
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
        collectionView.shouldMultipleGestureRecognize = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var headerView: UIView = {
        
        let headerView = UIView()
        headerView.backgroundColor = .red
        collectionView.collectionViewTopView = headerView
        return headerView
    }()
    
    lazy var collectionViewServe: ZSPlainFlowLayoutServe = {
        
        let collectionViewServe = ZSPlainFlowLayoutServe()
        return collectionViewServe
    }()
    
    lazy var contentView: ZSTabContentView = {
        
        let contentView = ZSTabContentView()
        view.addSubview(contentView)
        return contentView
    }()
    
    lazy var contentServe: ZSTabContentViewServe = {
       
        let contentServe = ZSTabContentViewServe()
        contentServe.pageServe.delegate = self
        return contentServe
    }()
    
    
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
        //        ZSIndicatorTextView.startAnimation("哈说丹深爱的")
//        collectionViewServe.setterCollectionView(collectionView)
        
        contentServe.zs_buildView(contentView)
        contentServe.tabViewServe.tabTexts = ["ad", "ap", "lol"]
        contentServe.tabCount = 3
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        textFiled.frame = CGRect(x: 30 * KWidthUnit, y: 100 * KHeightUnit, width: 200 * KWidthUnit, height: 45 * KHeightUnit)
        //        button.frame = CGRect(x: 30 * KWidthUnit, y: 150 * KHeightUnit, width: 200 * KWidthUnit, height: 45 * KHeightUnit)
//        collectionView.frame = view.bounds
//        headerView.frame = CGRect(x: 0, y: 0, width: collectionView.zs_w, height: 180)
        
//        contentView.frame = view.bounds
        shapeView.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        shapeLayer.frame = shapeView.bounds
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

    var tabPageControllers: [TableViewController] = [TableViewController(), TableViewController(), TableViewController()]
    
    // TODO: ZSPageViewServeDelegate
    func vserve_tabPageView(at index: Int) -> UIView {
        
        var controller: TableViewController!
        if (index < tabPageControllers.count) {
            controller = tabPageControllers[index]
        }
        controller.scrollToTop = contentServe.zs_pageContentViewDidScroll()
        controller.didMove(toParentViewController: self)
        return controller.view
    }
    
    func vserve_tabPageViewWillDisappear(at index: Int) {
        
        print(index)
    }
    
    func vserve_tabPageViewWillAppear(at index: Int) {
        
        
    }
    
}

