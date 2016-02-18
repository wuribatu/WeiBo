//
//  StatusTableViewCell.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/30.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import SDWebImage

let PictureViewCellReuseIdentifier = "PictureViewCellReuseIdentifier"

class StatusTableViewCell: UITableViewCell {
    
    var pictureWidthCons: NSLayoutConstraint?
    var pictureHeightCons: NSLayoutConstraint?
    var pictureTopCons: NSLayoutConstraint?
    
    var status: Status? {
        didSet {
            topView.status = status
            contentLabel.text = status?.text
                       
            // 设置配图的尺寸
            // 1.1根据模型计算配图的尺寸
            pictureView.status = status
            let size = pictureView.calculateImageSize()
            // 1.2设置配图的尺寸
            pictureWidthCons?.constant = size.width
            pictureHeightCons?.constant = size.height
            pictureTopCons?.constant = size.height == 0 ? 0 : 10
        }
    }

    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        setupUI()
    }
    
    func setupUI(){
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(footerView)
        contentView.addSubview(pictureView)
        
        let width = UIScreen.mainScreen().bounds.width
        
        topView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
                
        footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
    }
    
    func rowHeight(status:Status) -> CGFloat {
        self.status = status
        self.layoutIfNeeded()
        return CGRectGetMaxY(footerView.frame)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    private lazy var topView: StatusTableViewTopView = StatusTableViewTopView()
    /// 正文
    lazy var contentLabel: UILabel =
    {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        
        return label
    }()
    /// 底部工具条
    lazy var footerView: StatusTableViewBottomView = StatusTableViewBottomView()

    /// 配图
    lazy var pictureView: StatusPictureView = StatusPictureView()
}

