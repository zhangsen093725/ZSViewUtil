//
//  ZSTextCollectionViewCell.swift
//  ZSViewUtil_Example
//
//  Created by 张森 on 2020/9/21.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class ZSTextCollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        
        let label = UILabel()
        self.contentView .addSubview(label)
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}
