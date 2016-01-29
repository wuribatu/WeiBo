//
//  UILabel+Category.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/30.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

extension UILabel {
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}
