//
//  StatusForwardTableViewCell.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/2/18.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class StatusForwardTableViewCell: StatusTableViewCell {

    override func setupUI() {
        super.setupUI()
        
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: footerView, size: nil)
        forwardLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 10))
        forwardLabel.text = "算了可点击"
        
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: forwardLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }
    
    private lazy var forwardLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGrayColor(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()
}
