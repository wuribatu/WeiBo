//
//  NewfeatureCollectionViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/28.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class NewfeatureCollectionViewController: UICollectionViewController {
    
    private let pageCount = 4
    private var layout: UICollectionViewFlowLayout = NewfeatureLayout()
    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.redColor()
        cell.imageIndex = indexPath.item
        
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems().last!
        if path.item == (pageCount - 1) {
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            cell.startAnimation()
        }
    }
}

class NewfeatureCell: UICollectionViewCell {
    
    private var imageIndex: Int? {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    private func startAnimation() {
        startButton.hidden = false
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        startButton.userInteractionEnabled = false
        
        UIView.animateWithDuration(2.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                self.startButton.userInteractionEnabled = true
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        iconView.xmg_Fill(contentView)
        startButton.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPointMake(0, -160))
    }
    
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: .Highlighted)
        btn.hidden = true
        btn.addTarget(self, action: "startBtnClick", forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    func startBtnClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(XMGSwitchRootViewControllerKey, object: true)
    }
}

private class NewfeatureLayout: UICollectionViewFlowLayout {
    
    // 准备布局
    // 什么时候调用? 1.先调用一个有多少行cell 2.调用准备布局 3.调用返回cell
    override func prepareLayout()
    {
        // 1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}
