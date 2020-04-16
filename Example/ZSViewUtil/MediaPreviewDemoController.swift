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

class MediaPreviewDemoController: UIViewController, ZSMediaPreviewLoadServeDelegate {
    
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
        previewServe.mediaPreview?.zs_setterCustomView { () -> UIView? in
            
            return nil
        }
        return previewServe
    }()
    
    func getModels() -> [ZSMediaPreviewModel] {
        
        var models: [ZSMediaPreviewModel] = []
        
        let imageFiles = ["http://ww1.sinaimg.cn/large/b02ee545gy1gdmhz2191mj205603rt8j.jpg",
                          "http://ww1.sinaimg.cn/large/b02ee545gy1gdnhcee791j2048097dfs.jpg"]
        
        let audioFile = ["http://up_mp4.t57.cn/2018/1/03m/13/396131202109.m4a",
                         "http://up_mp4.t57.cn/2016/1/12m/08/205081602470.m4a",
                         "http://up_mp4.t57.cn/2016/1/12m/07/205072202084.m4a",
                         "http://up_mp4.t57.cn/2016/3/12m/04/205041609064.m4a",
                         "http://up_mp4.t57.cn/2016/1/12m/04/205041601432.m4a",
                         "http://up_mp4.t57.cn/2016/1/12m/04/205041600000.m4a"]
        
        let videoFile = ["https://img.jinsom.cn/user_files/13470/publish/file/file-2018-12-29-21-15-15.mp4",
                         "https://v-cdn.zjol.com.cn/280443.mp4",
                         "https://v-cdn.zjol.com.cn/276982.mp4",
                         "https://v-cdn.zjol.com.cn/276984.mp4",
                         "https://v-cdn.zjol.com.cn/276985.mp4",
                         "https://v-cdn.zjol.com.cn/276986.mp4",
                         "https://v-cdn.zjol.com.cn/276987.mp4",
                         "https://v-cdn.zjol.com.cn/276988.mp4",
                         "https://v-cdn.zjol.com.cn/276989.mp4",
                         "https://v-cdn.zjol.com.cn/276990.mp4",
                         "https://v-cdn.zjol.com.cn/276991.mp4",
                         "https://v-cdn.zjol.com.cn/276992.mp4",
                         "https://v-cdn.zjol.com.cn/276993.mp4",
                         "https://v-cdn.zjol.com.cn/276994.mp4",
                         "https://v-cdn.zjol.com.cn/276996.mp4",
                         "https://v-cdn.zjol.com.cn/276998.mp4",
                         "https://v-cdn.zjol.com.cn/277000.mp4",
                         "https://v-cdn.zjol.com.cn/277001.mp4",
                         "https://v-cdn.zjol.com.cn/277002.mp4",
                         "https://v-cdn.zjol.com.cn/277003.mp4",
                         "https://v-cdn.zjol.com.cn/277004.mp4"]
        
        for file in imageFiles {
            let model = ZSMediaPreviewModel()
            model.mediaFile = file
            model.mediaType = .Image
            models.append(model)
        }
        
        for file in audioFile {
            let model = ZSMediaPreviewModel()
            model.mediaFile = file
            model.mediaType = .Audio
            models.append(model)
        }
        
        for file in videoFile {
            let model = ZSMediaPreviewModel()
            model.mediaFile = file
            model.thumbImage = "http://ww1.sinaimg.cn/large/b02ee545gy1gdmhz2191mj205603rt8j.jpg"
            model.mediaType = .Video
            models.append(model)
        }
        
        return models
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemGray
        
        let data = try? Data(contentsOf: URL(string: "http://ww1.sinaimg.cn/large/b02ee545gy1gdmhz2191mj205603rt8j.jpg")!)
        
        imageView.image = UIImage(data: data!)
        
        previewServe.medias = getModels()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.frame = CGRect(x: 100, y: 200, width: 120, height: 120)
    }
    
    
    @objc func openMediaPreview() {
        previewServe.mediaPreview?.beginPreview(from: imageView, to: 0)
    }
    
    func zs_imageView(_ imageView: UIImageView, load imageURL: URL) {
        
        imageView.sd_setImage(with: imageURL, completed: nil)
        
    }
}
