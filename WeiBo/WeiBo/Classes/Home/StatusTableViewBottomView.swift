//
//  StatusTableViewBottomView.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/2/8.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class StatusTableViewBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        xmg_HorizontalTile([retweetBtn, unlikeBtn, commonBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private lazy var retweetBtn: UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")
    private lazy var unlikeBtn:  UIButton = UIButton.createButton("timeline_icon_unlike",  title: "赞")
    private lazy var commonBtn:  UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
