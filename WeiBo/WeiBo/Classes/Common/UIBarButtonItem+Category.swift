//
//  UIBarButtonItem+Category.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/23.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func creatBarButtonItem(imageName: String, target: AnyObject?, action: Selector) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        btn.sizeToFit()
        
        return UIBarButtonItem(customView: btn)
    }
}
