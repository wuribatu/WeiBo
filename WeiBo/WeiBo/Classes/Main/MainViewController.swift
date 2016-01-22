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
        
        addChildViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupComposeBtn()
    }
    
    // MARK: - 添加中间加号按钮
    private func setupComposeBtn() {
        tabBar.addSubview(composeBtn)
        
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect  = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame = CGRectOffset(rect, width * 2, 0)
    }
    
    func composeBtnClick() {
        print(__FUNCTION__)
    }
    
    // MARK: - 添加所有子控制器
    private func addChildViewControllers() {
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do {//有可能发生异常的代码放到这里
                //try  发生异常会调到catch中继续执行
                //try! 发生异常直接崩溃
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                for dict in dictArr as! [[String: String]]{
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
                
            } catch {
                print(error)
                addChildViewController("HomeTableViewController",     title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController",  title: "消息", imageName: "tabbar_message_center")
                addChildViewController("NullTableViewController",  title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController",  title: "我",   imageName: "tabbar_profile")
            }
        }
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
    
    // MARK: - 懒加载
    private lazy var composeBtn: UIButton = {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: "composeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
}
