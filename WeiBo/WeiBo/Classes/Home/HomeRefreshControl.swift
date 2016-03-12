//
//  HomeRefreshControl.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/2/29.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        setupUI()
    }

    private func setupUI() {
        addSubview(refreshView)
        
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    /// 定义变量记录是否需要旋转监听
    private var rotationTip = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
         print(frame.origin.y)
        
        if frame.origin.y >= 0 {
            return
        }
        
        if frame.origin.y >= -50 && !rotationTip  {
            print("翻转")
            rotationTip = true
        } else if frame.origin.y < -50 && rotationTip {
            print("翻转回来")
            rotationTip = false
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    private lazy var refreshView: HomeRefreshView = HomeRefreshView.refreshView()
}

class HomeRefreshView: UIView {
    class func refreshView() -> HomeRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }
}