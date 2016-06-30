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
        
        refreshView.xmg_AlignInner(type: XMG_AlignType.center, referView: self, size: CGSize(width: 170, height: 60))
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    /// 定义变量记录是否需要旋转监听
    private var rotationTipFlag = false
    
    /// 记录圈圈是否需要增加动画
    private var loadingViewAnimFlag = false
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
//         print(frame.origin.y)
        
        if frame.origin.y >= 0 {
            return
        }
        
        if isRefreshing && !loadingViewAnimFlag {
            
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
    func rotaionArrowIcon(_ flag: Bool) {
        var angle = M_PI
        angle += flag ? 0.01 : -0.01
        
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.arrowIcon.transform = self.arrowIcon.transform.rotate(CGFloat(angle))
        }
    }
    
    func startLoadingViewAnim() {
        tipView.isHidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        anim.isRemovedOnCompletion = false
        loadingView.layer.add(anim, forKey: nil)
    }
    
    func stopLoadingViewAnim() {
        
        tipView.isHidden = false
        
        loadingView.layer.removeAllAnimations()
    }
    
    class func refreshView() -> HomeRefreshView {
        return Bundle.main().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }
}
