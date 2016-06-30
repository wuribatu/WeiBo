//
//  VisitorView.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/23.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

protocol VisitorViewDelegate: NSObjectProtocol {
    func loginBtnWillClick()
    func registerBtnWillClick()
}

class VisitorView: UIView {
    
    weak var delegate: VisitorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)

        iconView.xmg_AlignInner(type: XMG_AlignType.center, referView: self, size: nil)
        homeIcon.xmg_AlignInner(type: XMG_AlignType.center, referView: self, size: nil)
        
        messageLabel.xmg_AlignHorizontal(type: XMG_AlignType.bottomCenter, referView: iconView, size: nil)
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 224)
        messageLabel.addConstraint(widthCons)
        
        registerButton.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30), offset:CGPoint(x: 0, y: 20))
        loginButton.xmg_AlignVertical(type: XMG_AlignType.bottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30), offset:CGPoint(x: 0, y: 20))
        maskBGView.xmg_Fill(maskBGView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVisitorInfo(_ isHome: Bool, imageName: String, message: String) {
        iconView.isHidden   = !isHome
        homeIcon.image    = UIImage(named: imageName)
        messageLabel.text = message
        
        if isHome {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        //不移除动画
        anim.isRemovedOnCompletion = false
        
        iconView.layer.add(anim, forKey: nil)
    }
    
    // MARK: -按钮点击
    func loginBtnClick() {
        delegate?.loginBtnWillClick()
    }
    
    func registerBtnClick() {
        delegate?.registerBtnWillClick()
    }
    
    // MARK: - 懒加载控件
    /// 转盘
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        
        return iv
    }()
    
    // 图标
    private lazy var homeIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        
        return iv
    }()
    
    // 文本
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "23242dfffffffsafadfasdfsdfewrwerwerwerwe423242dfffffffsafadfasdfsdfewrwerwerwerwe4"
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray()
        
        return label
    }()
    
    // 登陆按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登陆", for: UIControlState())
        btn.setTitleColor(UIColor.darkGray(), for: UIControlState())
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState())
        btn.addTarget(self, action: #selector(VisitorView.loginBtnClick), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    // 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orange(), for: UIControlState())
        btn.setTitle("注册", for: UIControlState())
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControlState())
        btn.addTarget(self, action: #selector(VisitorView.registerBtnClick), for: UIControlEvents.touchUpInside)

        return btn
    }()
    
    // 挡板
    private lazy var maskBGView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return iv
    }()
}
