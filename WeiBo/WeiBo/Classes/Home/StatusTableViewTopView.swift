//
//  StatusTableViewTopView.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/2/8.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class StatusTableViewTopView: UIView {
    var status: Status? {
        didSet {
            nameLabel.text = status?.user?.name

            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            sourceLabel.text = status?.source
            verifiedView.image = status?.user?.verifiedImage
            vipView.image = status?.user?.mbrankImage
            timeLabel.text = status?.created_at
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    private func setupUI() {
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset:CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y:0))
    }

    /// 头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        return iv
    }()
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 14)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
