//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/22.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    var isPresented: Bool = false //没有打开菜单

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: BTPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: BTPopoverAnimatorWillDismiss, object: nil)
        
        if !userLogin {
            visitorView.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        setupNav()
    }
    
    func change() {
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.selected = !titleButton.selected
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: -设置导航栏
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: "rightBtnClick")
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("乌日巴图 ", forState: .Normal)
        titleBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        titleBtn.sizeToFit()
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(titleBtn: TitleButton) {
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        vc?.transitioningDelegate = popoverAnimator
        vc?.modalPresentationStyle = .Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
        
    func leftBtnClick() {
        print(__FUNCTION__)
    }
    
    func rightBtnClick() {
        print(__FUNCTION__)
    }
    
    private lazy var popoverAnimator: PopoverAnimator = {
        let po = PopoverAnimator()
        po.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return po
    }()
}
