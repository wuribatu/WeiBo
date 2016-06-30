//
//  StatusPictureView.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/2/17.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import SDWebImage

class StatusPictureView: UICollectionView {
    var status: Status? {
        didSet {
        
            reloadData()
        }
    }
    
    private var pictureLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    init(){
        super.init(frame: CGRect.zero, collectionViewLayout: pictureLayout)
        
        register(PictureViewCell.self, forCellWithReuseIdentifier: PictureViewCellReuseIdentifier)
        dataSource = self
        delegate = self
        pictureLayout.minimumInteritemSpacing = 10
        pictureLayout.minimumLineSpacing = 10
        backgroundColor = UIColor.white()
    }

    private class PictureViewCell: UICollectionViewCell {
        var imageURL: URL? {
            didSet {
                iconImageView.sd_setImage(with: imageURL)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        private func setupUI() {
            contentView.addSubview(iconImageView)
            iconImageView.xmg_Fill(contentView)
        }
        
        private lazy var iconImageView: UIImageView = UIImageView()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    /**
     计算配图的尺寸
     */
    func calculateImageSize() -> CGSize
    {
        // 1.取出配图个数
        let count = status?.storedPicURLS?.count
        // 2.如果没有配图zero
        if count == 0 || count == nil
        {
            return CGSize.zero
        }
        // 3.如果只有一张配图, 返回图片的实际大小
        if count == 1
        {
            // 3.1取出缓存的图片
            let key = status?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key!)
            
            pictureLayout.itemSize = (image?.size)!
            // 3.2返回缓存图片的尺寸
            return image! .size
        }
        // 4.如果有4张配图, 计算田字格的大小
        let width = 90
        let margin = 10
        pictureLayout.itemSize = CGSize(width: width, height: width)
        
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return (CGSize(width: viewWidth, height: viewWidth))
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        /*
        2/3
        5/6
        7/8/9
        */
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        //               (8 - 1) / 3 + 1
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return (CGSize(width: viewWidth, height: viewHeight))
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLS?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureViewCellReuseIdentifier, for: indexPath) as! PictureViewCell
        cell.backgroundColor = UIColor.yellow()
        cell.imageURL = status?.storedPicURLS![(indexPath as NSIndexPath).row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
        print(status?.storedLargePicURLS![(indexPath as NSIndexPath).item])
    }
}

