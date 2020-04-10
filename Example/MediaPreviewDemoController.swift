//
//  MediaPreviewDemoController.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/4/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil
import SDWebImage
import Kingfisher

class MediaPreviewDemoController: UIViewController, ZSMediaPreviewLoadDelegate {
 
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMediaPreview))
        imageView.addGestureRecognizer(tap)
        
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var previewServe: ZSMediaPreviewServe = {
       
        let previewServe = ZSMediaPreviewServe()
        previewServe.loadDelegate = self
        previewServe.mediaPreview.setterCustomView { () -> UIView? in
            
            return nil
        }
        return previewServe
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        
        let data = try? Data(contentsOf: URL(string: "http://ww1.sinaimg.cn/large/b02ee545gy1gdmhz2191mj205603rt8j.jpg")!)
        
        imageView.image = UIImage(data: data!)
        
        
        let model = ZSMediaPreviewModel()
        model.mediaFile = "http://ww1.sinaimg.cn/large/b02ee545gy1gdmhz2191mj205603rt8j.jpg"
        // "http://ww1.sinaimg.cn/large/b02ee545gy1gdnhcee791j2048097dfs.jpg"
        // "http://ww1.sinaimg.cn/large/b02ee545gy1gdmhz2191mj205603rt8j.jpg"
        
        previewServe.medias = [model, model]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.frame = CGRect(x: 100, y: 200, width: 120, height: 120)
    }

    
    @objc func openMediaPreview() {
        previewServe.mediaPreview.beginPreview(from: imageView, to: 0)
    }
    
    func zs_imageView(_ imageView: UIImageView, load imageURL: URL) {
        
        imageView.sd_setImage(with: imageURL, completed: nil)
        
    }
}
