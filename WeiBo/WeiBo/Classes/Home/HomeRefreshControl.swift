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
    private var rotationTipFlag = false
    
    /// 记录圈圈是否需要增加动画
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//         print(frame.origin.y)
        
        if frame.origin.y >= 0 {
            return
        }
        
        if refreshing && !loadingViewAnimFlag {
            
            loadingViewAnimFlag = true
            refreshView.startLoadingViewAnim()
            
            return
        }
        
        if frame.origin.y >= -50 && rotationTipFlag  {
//            print("翻转")
            refreshView.rotaionArrowIcon(rotationTipFlag)
            rotationTipFlag = false
        } else if frame.origin.y < -50 && !rotationTipFlag {
//            print("翻转回来")
            refreshView.rotaionArrowIcon(rotationTipFlag)
            rotationTipFlag = true
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingViewAnim()
        
        loadingViewAnimFlag = false
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
    @IBOutlet weak var arrowIcon: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var loadingView: UIImageView!
    
    /**
     旋转箭头
     */
    func rotaionArrowIcon(flag: Bool) {
        var angle = M_PI
        angle += flag ? 0.01 : -0.01
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    func startLoadingViewAnim() {
        tipView.hidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        anim.removedOnCompletion = false
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    func stopLoadingViewAnim() {
        
        tipView.hidden = false
        
        loadingView.layer.removeAllAnimations()
    }
    
    class func refreshView() -> HomeRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }
}