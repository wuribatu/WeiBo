
//
//  StatusNormalTableViewCell.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/2/18.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class StatusNormalTableViewCell: StatusTableViewCell {

    override func setupUI() {
        super.setupUI()
    
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
}
