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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupComposeBtn()
    }
    
    // MARK: - 添加中间加号按钮
    private func setupComposeBtn() {
        tabBar.addSubview(composeBtn)
        
        let width = UIScreen.main().bounds.size.width / CGFloat(viewControllers!.count)
        let rect  = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame = rect.offsetBy(dx: width * 2, dy: 0)
    }
    
    func composeBtnClick() {
        print(#function)
    }
    
    // MARK: - 添加所有子控制器
    private func addChildViewControllers() {
        let path = Bundle.main().pathForResource("MainVCSettings.json", ofType: nil)
        
        if let jsonPath = path {
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath))
            
            do {//有可能发生异常的代码放到这里
                //try  发生异常会调到catch中继续执行
                //try! 发生异常直接崩溃
                let dictArr = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers)
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
    
    private func addChildViewController(_ childControllerName: String, title: String, imageName: String) {

        let ns = Bundle.main().infoDictionary!["CFBundleExecutable"] as! String
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
        
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControlState())
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControlState())
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(self, action: "composeBtnClick", for: UIControlEvents.touchUpInside)
        
        return btn
    }()
}
