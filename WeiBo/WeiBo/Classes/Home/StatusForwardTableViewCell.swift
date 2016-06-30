//
//  StatusForwardTableViewCell.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/2/18.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class StatusForwardTableViewCell: StatusTableViewCell {

    // 重写父类的didSet 不会对父类的操作造成影响
    // 只需要重写方法 做想做的事
    // 注意：如果父类是didSet 之类也必须是didSet
    override var status: Status? {
        didSet {
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            forwardLabel.text = name + ":" + text
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        contentView.insertSubview(forwardButton, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardButton)
        
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardButton.xmg_AlignVertical(type: XMG_AlignType.topRight, referView: footerView, size: nil)
        forwardLabel.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: forwardButton, size: nil, offset: CGPoint(x: 10, y: 10))
         
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: forwardLabel, size: CGSize.zero, offset: CGPoint(x: 0, y: 10))
        pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.width)
        pictureHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.height)
        pictureTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.top)
    }
    
    private lazy var forwardLabel: UILabel = {
        let label = UILabel.createLabel(UIColor.darkGray(), fontSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main().bounds.width - 20
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()
}
