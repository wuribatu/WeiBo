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

        self.collectionView!.register(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewfeatureCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.red()
        cell.imageIndex = (indexPath as NSIndexPath).item
        
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems().last!
        if (path as NSIndexPath).item == (pageCount - 1) {
            let cell = collectionView.cellForItem(at: path) as! NewfeatureCell
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
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        startButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 2.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransform.identity
            }, completion: { (_) -> Void in
                self.startButton.isUserInteractionEnabled = true
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
        startButton.xmg_AlignInner(type: XMG_AlignType.bottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    private lazy var iconView = UIImageView()
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), for: UIControlState())
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), for: .highlighted)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(NewfeatureCell.startBtnClick), for: .touchUpInside)
        
        return btn
    }()
    
    func startBtnClick() {
        NotificationCenter.default().post(name: Notification.Name(rawValue: XMGSwitchRootViewControllerKey), object: true)
    }
}

private class NewfeatureLayout: UICollectionViewFlowLayout {
    
    // 准备布局
    // 什么时候调用? 1.先调用一个有多少行cell 2.调用准备布局 3.调用返回cell
    override func prepare()
    {
        // 1.设置layout布局
        itemSize = UIScreen.main().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // 2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}
