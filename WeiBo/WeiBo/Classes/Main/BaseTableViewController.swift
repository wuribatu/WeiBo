//
//  BaseTableViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/23.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var userLogin = false
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
        
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtnWillClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "registerBtnWillClick")
    }
}

extension BaseTableViewController: VisitorViewDelegate {
    func loginBtnWillClick() {
        print(__FUNCTION__)
    }
    
    func registerBtnWillClick() {
        print(__FUNCTION__)
    }
}
