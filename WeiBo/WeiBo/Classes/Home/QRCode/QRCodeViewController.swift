//
//  QRCodeViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/24.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, UITabBarDelegate {

    /// 扫描容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    @IBOutlet weak var customTabBar: UITabBar!
    /// 扫描之后显示数据
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabBar.selectedItem  = customTabBar.items! [0]
        customTabBar.delegate = self
    }
    
    // 名片点击
    @IBAction func myCardBtnClick(_ sender: AnyObject) {
        navigationController?.pushViewController(QRCodeCardViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 1.开始冲击波动画
        startAnimation()
    }
    
    private func startScan() {
        
        //1.判断能否将输入设备加入会话
        if !session.canAddInput(deviceInput) {
            return
        }
        
        //2. 判断能否将输出设备加入会话
        if !session.canAddOutput(output) {
            return
        }
        
        //3.将输入、输出添加到会话中
        session.addOutput(output)
        session.addInput(deviceInput)
        
        //4.设置输出能够解析的类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        //5.设置代理 解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 如果想实现扫描一张图片 设定区域
//        output.rectOfInterest = CGRectMake(0.0, 0.0, 1.0, 1.0)
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.addSublayer(darwLayer)
        //6.告诉session开始扫描
        session.startRunning()
    }
    
    // 执行动画
    private func startAnimation()
    {
        // 让约束从顶部开始
        self.scanLineCons.constant = -self.containerHeightCons.constant
        self.containerView.layoutIfNeeded()
        
        // 执行冲击波动画
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            // 1.修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
//            self.scanLineCons.constant = 0
            // 设置动画指定的次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // 2.强制更新界面
            self.containerView.layoutIfNeeded()
        })
    }
    
    // MARK: - UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 1.修改容器的高度
        if item.tag == 100 {
            //            print("二维码")
            self.containerHeightCons.constant = 300
        }else{
            print("条形码")
            self.containerHeightCons.constant = 150
        }
        
        // 2.停止动画
        self.scanLineView.layer.removeAllAnimations()
        
        // 3.重新开始动画
        startAnimation()
    }

    @IBAction func closeBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 会话
    // 懒加载
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 拿到输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        // 拿到摄像头
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // 创建输入对象
        do {
            let input = try AVCaptureDeviceInput(device: device)
            return input
        } catch {
            print(error)
            return nil
        }
    }()
    
    ///  输出设备
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    ///  预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let lay = AVCaptureVideoPreviewLayer(session: self.session)
        lay?.frame = UIScreen.main().bounds
        return lay!
    }()
    
    // 绘制图层
    private lazy var darwLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.main().bounds
        return layer
    }()
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    //只要解析到数据就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, from connection: AVCaptureConnection!) {
        resultLabel.text = metadataObjects.last?.stringValue
        
        clearConers()
        
        // 转换坐标系
        for object in metadataObjects {
            // 判断数据是否是当前设备可识别类型
            if object is AVMetadataMachineReadableCodeObject {
                let codeObject = previewLayer.transformedMetadataObject(for: object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                
                drawCorners(codeObject)
            }
        }
    }
    
    // 绘制图形 codeObject: 坐标系对象
    private func drawCorners(_ codeObject: AVMetadataMachineReadableCodeObject) {
        
        if codeObject.corners.isEmpty {
            return
        }
        
        // 创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.red().cgColor
        layer.fillColor   = UIColor.clear().cgColor
        
        // 路径
        layer.path = UIBezierPath(rect: CGRect(x: 100, y: 100, width: 100, height: 100)).cgPath
        
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index: Int = 0
        
        index += 1;
        point.makeWithDictionaryRepresentation(codeObject.corners[index] as! CFDictionary)
        path.move(to: point)
        
        while index < codeObject.corners.count {
            point.makeWithDictionaryRepresentation(codeObject.corners[index] as! CFDictionary)
            path.addLine(to: point)
        }
        
        path.close()
        
        // 绘制路径
        layer.path = path.cgPath
        
        
        // 添加
        darwLayer.addSublayer(layer)
    }
    
    /// 清空图层
    private func clearConers() {
        if darwLayer.sublayers?.count == 0 || darwLayer.sublayers == nil {
            return
        }
        
        //移除所以子视图
        for subLayer in darwLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}
