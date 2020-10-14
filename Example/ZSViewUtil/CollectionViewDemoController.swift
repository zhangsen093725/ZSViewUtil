//
//  CollectionViewDemoController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class CollectionViewDemoController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        collectionViewServe.setterCollectionView(collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
        headerView.frame = CGRect(x: 0, y: 0, width: collectionView.zs_width, height: 180.zs_pt)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

