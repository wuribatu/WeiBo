//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/22.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin {
            visitorView.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        setupNav()
    }
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: "rightBtnClick")
    }
        
    func leftBtnClick() {
        print(__FUNCTION__)
    }
    
    func rightBtnClick() {
        print(__FUNCTION__)
    }
}
