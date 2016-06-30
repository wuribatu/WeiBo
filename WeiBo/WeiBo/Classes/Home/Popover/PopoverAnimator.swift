//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/24.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

let BTPopoverAnimatorWillShow    = "BTPopoverAnimatorWillShow"
let BTPopoverAnimatorWillDismiss = "BTPopoverAnimatorWillDismiss"

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    var isPresented = false
    var presentFrame = CGRect.zero
    
    /// 告诉系统谁负责转场动画
    func presentationController(forPresentedViewController presented: UIViewController, presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        let po = PopoverPresentationController(presentedViewController: presented, presenting: presenting!)
        po.presentFrame = presentFrame
        
        return po
    }
    
    /// 告诉系统谁负责展现动画
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        NotificationCenter.default().post(name: Notification.Name(rawValue: BTPopoverAnimatorWillShow), object: self)
        
        return self
    }
    
    /// 告诉系统谁负责消失动画
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        NotificationCenter.default().post(name: Notification.Name(rawValue: BTPopoverAnimatorWillDismiss), object: self)
        
        return self
    }
    
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 如何开始动画 开始 消失 都会调用该方法
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            ///拿到展示视图
            let toView = transitionContext.view(forKey: UITransitionContextToViewKey)
            transitionContext.containerView().addSubview(toView!)
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            
            // 设置锚点
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: transitionDuration(transitionContext), animations: { () -> Void in
                // 清空transform
                toView?.transform = CGAffineTransform.identity
                }) { (_) -> Void in
                    // 动画结束 一定要告诉系统
                    // 如果不写 导致未知cuowu
                    transitionContext.completeTransition(true)
            }
            print("展开")
        } else {
            let fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)
            
            UIView.animate(withDuration: transitionDuration(transitionContext), animations: { () -> Void in
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
                }, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
            })
            print("关闭")
        }
    }
}
