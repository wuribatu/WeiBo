//
//  WelcomeViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/28.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    var bottomCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.添加子控件
        view.addSubview(bgIV)
        view.addSubview(iconView)
        view.addSubview(messageLabel)
        
        bgIV.xmg_Fill(view)

        let cons = iconView.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: view, size: CGSize(width: 100, height: 100), offset: CGPoint(x: 0, y: -150))
        // 拿到头像的底部约束
        bottomCons = iconView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 20))

        // 3.设置用户头像
        if let iconUrl = UserAccount.loadAccount()?.avatar_large {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImageWithURL(url)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.bottomCons?.constant = -UIScreen.mainScreen().bounds.height -  self.bottomCons!.constant
        // 3.执行动画
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 头像动画
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                
                // 文本动画
                UIView.animateWithDuration( 2.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.messageLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        print("OK")
                })
        }
    }
    
    // MARK: -懒加载
    private lazy var bgIV: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0.0
        return label
    }()
}
