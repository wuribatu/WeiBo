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
        
        addChildViewController(HomeTableViewController(),     title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(),  title: "消息", imageName: "tabbar_message_center")
        addChildViewController(DiscoverTableViewController(), title: "广场", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(),  title: "我",   imageName: "tabbar_profile")
    }
    
    private func addChildViewController(childController: UIViewController, title: String, imageName: String) {

        let nav  = UINavigationController(rootViewController: childController)
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        addChildViewController(nav)
    }
}
