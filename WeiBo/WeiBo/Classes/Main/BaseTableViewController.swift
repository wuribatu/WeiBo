//
//  BaseTableViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/23.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var userLogin = UserAccount.userLogin()
    var visitorView = VisitorView()
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 创建未登陆界面
    private func setupVisitorView () {
        let custView = VisitorView()
        view = custView
        visitorView = custView
        custView.delegate = self
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerBtnWillClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtnWillClick")
    }
}

extension BaseTableViewController: VisitorViewDelegate {
    func loginBtnWillClick() {
        let OAuthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: OAuthVC)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func registerBtnWillClick() {
//        print(__FUNCTION__)
//        print(NetworkTools.shareNetwordTools())
    }
}
