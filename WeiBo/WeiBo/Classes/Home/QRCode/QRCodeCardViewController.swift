//
//  QRCodeCardViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/25.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class QRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        title = "我的名片"
        view.addSubview(iconView)
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        let grcodeImage = creatQRCodeImage()
        iconView.image = grcodeImage
    }
    
    private func creatQRCodeImage() -> UIImage {
        //1. 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //2. 还原滤镜的默认属性
        filter?.setDefaults()
        
        //3. 设置需要生成的二维码数据
        filter?.setValue("乌日巴图".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")

        //4. 从滤镜取出生成好的图片
        let ciImage = filter?.outputImage
        
        let newImage = creatImage(createNonInterpolatedUIImageFormCIImage(ciImage!, size: 300), iconImage: UIImage(named: "nange")!)
        
        return newImage
    }
    
    private func creatImage(bgImage: UIImage, iconImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(bgImage.size)
        
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        
        let width: CGFloat = 50
        let height = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
    
    private lazy var iconView: UIImageView = UIImageView()
}
