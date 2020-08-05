//
//  DragViewDemoController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class DragViewDemoController: UIViewController, ZSDragStaticCollectionServeDataSource, ZSDragStaticCollectionServeDelegate {
    
    lazy var dragView: ZSDragCollectionView = {
        
        let dragView = ZSDragCollectionView()
        dragView.backgroundColor = .orange
        view.addSubview(dragView)
        return dragView
    }()
    
    lazy var dragViewServe: ZSDragStaticShakeViewServe = {
        
        let dragViewServe = ZSDragStaticShakeViewServe()
        dragViewServe.dataSource = self
        dragViewServe.delegate = self
        return dragViewServe
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        dragViewServe.zs_bindCollectionView(dragView.collectionView)
        dragViewServe.itemCount = 100
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dragView.zs_margin = UIEdgeInsets(top: 100.zs_px, left: 10.zs_px, bottom: 30.zs_px, right: 10.zs_px)
//        dragView.frame = CGRect(x: 30.px, y: 100.px, width: 300.px, height: 300.px)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: ZSDragStaticCollectionServeDataSource
    func zs_dragStaticCollectionView(layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80.zs_px, height: 80.zs_px)
    }
    
    func zs_dragStaticCollectionView(_ cell: ZSDragStaticItemView, forItemAt indexPath: IndexPath) {
        
    }
    
    // TODO: ZSDragStaticCollectionServeDelegate
    func zs_dragStaticCollectionView(didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func zs_dragStaticCollectionView(removeDataSourceAt indexPath: IndexPath) {
        
    }
    
    func zs_dragStaticCollectionView(insertDataSourceAt indexPath: IndexPath) {
        
    }
}
