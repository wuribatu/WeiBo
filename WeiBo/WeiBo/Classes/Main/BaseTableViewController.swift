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
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 创建未登陆界面
    private func setupVisitorView () {
        let custView = VisitorView()
        view = custView
    }
}
