//
//  VisitorView.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/23.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeView)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        homeView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        
        messageLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil)
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        messageLabel.addConstraint(widthCons)
        
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30), offset:CGPoint(x: 0, y: 20))
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30), offset:CGPoint(x: 0, y: 20))
        maskBGView.xmg_Fill(maskBGView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    // 转盘
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        
        return iv
    }()
    
    // 图标
    private lazy var homeView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        
        return iv
    }()
    
    // 文本
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "23242dfffffffsafadfasdfsdfewrwerwerwerwe423242dfffffffsafadfasdfsdfewrwerwerwerwe4"
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        
        return label
    }()
    
    // 登陆按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登陆", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        return btn
    }()
    
    // 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        return btn
    }()
    
    // 挡板
    private lazy var maskBGView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return iv
    }()
}
