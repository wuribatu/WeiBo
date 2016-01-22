//
//  MainViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/22.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orangeColor()
        
        addChildViewController("HomeTableViewController",     title: "首页", imageName: "tabbar_home")
        addChildViewController("MessageTableViewController",  title: "消息", imageName: "tabbar_message_center")
        addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
        addChildViewController("ProfileTableViewController",  title: "我",   imageName: "tabbar_profile")
    }
    
    private func addChildViewController(childControllerName: String, title: String, imageName: String) {

        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        let cls: AnyClass? = NSClassFromString(ns + "." + childControllerName)
        let vcCls = cls as! UIViewController.Type
        let vc = vcCls.init()
        
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
}
