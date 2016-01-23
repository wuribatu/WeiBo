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
    var presentFrame = CGRectZero
    
    /// 告诉系统谁负责转场动画
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let po = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        po.presentFrame = presentFrame
        
        return po
    }
    
    /// 告诉系统谁负责展现动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        NSNotificationCenter.defaultCenter().postNotificationName(BTPopoverAnimatorWillShow, object: self)
        
        return self
    }
    
    /// 告诉系统谁负责消失动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        NSNotificationCenter.defaultCenter().postNotificationName(BTPopoverAnimatorWillDismiss, object: self)
        
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /// 如何开始动画 开始 消失 都会调用该方法
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            ///拿到展示视图
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            transitionContext.containerView()?.addSubview(toView!)
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
            
            // 设置锚点
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                // 清空transform
                toView?.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    // 动画结束 一定要告诉系统
                    // 如果不写 导致未知cuowu
                    transitionContext.completeTransition(true)
            }
            print("展开")
        } else {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
            })
            print("关闭")
        }
    }
}