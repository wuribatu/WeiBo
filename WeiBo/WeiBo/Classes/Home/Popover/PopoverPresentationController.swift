//
//  PopoverPresentationController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/24.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {

    var presentFrame = CGRectZero
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        if presentFrame == CGRectZero {
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        } else {
            presentedView()?.frame = presentFrame
        }
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    func close() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
