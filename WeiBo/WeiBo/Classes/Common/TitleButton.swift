//
//  TitleButton.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/23.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x  = titleLabel!.frame.size.width
    }
}
