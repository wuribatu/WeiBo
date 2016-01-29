//
//  StatusTableViewCell.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/30.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    var status: Status? {
        didSet {
            iconView.sd_setImageWithURL(NSURL(string: (status!.user!.profile_image_url)!))
            nameLabel.text = status?.user?.name
            timeLabel.text = "刚刚"
            sourceLabel.text = "来自: 小霸王学习机"
            contentLabel.text = status?.text

        }
    }
    
    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        footerView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset:CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y:0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
//        contentLabel.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        let width = UIScreen.mainScreen().bounds.width
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
        footerView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        return iv
    }()
    /// 认证图标
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    /// 昵称
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    /// 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    /// 时间
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    /// 来源
    private lazy var sourceLabel: UILabel =
    {
        let label = UILabel()
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    /// 正文
    private lazy var contentLabel: UILabel =
    {
        let label = UILabel()
        label.textColor = UIColor.darkGrayColor()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        label.font = UIFont.systemFontOfSize(14)
        
        return label
    }()
    /// 底部工具条
    private lazy var footerView: StatusFooterView = StatusFooterView()
    
}

class StatusFooterView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    private func setupUI() {
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        xmg_HorizontalTile([retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private lazy var retweetBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_retweet"), forState: UIControlState.Normal)
        btn.setTitle("转发", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        return btn
    }()
    
    private lazy var unlikeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_unlike"), forState: UIControlState.Normal)
        btn.setTitle("赞", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        return btn
    }()
    
    private lazy var commonBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_comment"), forState: UIControlState.Normal)
        btn.setTitle("评论", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
