//
//  UIBarButtonItem+Category.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/23.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func creatBarButtonItem(_ imageName: String, target: AnyObject?, action: Selector) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.sizeToFit()
        
        return UIBarButtonItem(customView: btn)
    }
}
