//
//  TabPageDemoController.swift
//  ZSViewUtil
//
//  Created by zhangsen093725 on 01/14/2020.
//  Copyright (c) 2020 zhangsen093725. All rights reserved.
//

import UIKit
import ZSViewUtil

class TabPageDemoController: UIViewController, ZSPageViewServeDelegate {
    
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

        contentView.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

