//
//  ShapeDemoController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/3/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class ShapeDemoController: UIViewController, ZSLoopCubeViewDelegate, ZSLoopCubeViewDataSource {
  
    let videoFile = ["https://img.jinsom.cn/user_files/13470/publish/file/file-2018-12-29-21-15-15.mp4",
                           "/280443.mp4",
                           "/276982.mp4",
                           "/276984.mp4",
                           "/276985.mp4",
                           "/276986.mp4",
                           "/276987.mp4",
                           "/276988.mp4",
                           "/276989.mp4",
                           "/276990.mp4",
                           "/276991.mp4",
                           "/276992.mp4",
                           "/276993.mp4",
                           "/276994.mp4",
                           "/276996.mp4",
                           "/276998.mp4",
                           "/277000.mp4",
                           "/277001.mp4",
                           "/277002.mp4",
                           "/277003.mp4",
                           "/277004.mp4"]
    
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
    
    lazy var cubLabel: UILabel = {
        
        let label = UILabel()
        
        return label
    }()
    
    lazy var loopCub: ZSLoopCubeView = {
        
        let view = ZSLoopCubeView()
        view.delegate = self
        view.dataSource = self
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

//        shapeView.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
//        shapeLayer.frame = shapeView.bounds
        loopCub.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zs_loopCubeView(_ loopCubeView: ZSLoopCubeView, didSelectedItemFor index: Int) {
        
    }
    
    func zs_loopCubeFinishView(_ loopCubeView: ZSLoopCubeView, index: Int) {
        
        cubLabel.text = videoFile[index]
    }
    
    func zs_numberOfItemLoopCubeView(_ loopCubeView: ZSLoopCubeView) -> Int {
        
        return videoFile.count
    }
    
    func zs_loopCubeView(_ loopCubeView: ZSLoopCubeView) -> UIView {
        
        cubLabel.text = videoFile.first
        
        return cubLabel
    }
}

