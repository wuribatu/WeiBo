//
//  PhotoBrowserViewController.swift
//  WeiBo
//
//  Created by Batu on 6/30/16.
//  Copyright © 2016 wuribatu. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {
    
    init(index: Int, urls: [URL]) {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = UIColor.cyan()
    }
    
    func setupUI() {
        view.addSubview(closeBtn)
        
        closeBtn.xmg_AlignInner(type: XMG_AlignType.bottomLeft, referView: view, size: CGSize(width: 100, height: 35), offset: CGPoint(x: 10, y: -10))
    }

    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -懒加载
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControlState())
        btn.setTitleColor(UIColor.white(), for: UIControlState())
        btn.backgroundColor = UIColor.gray()
        btn.addTarget(self, action: #selector(PhotoBrowserViewController.close), for: .touchUpInside)
        return btn
    }()
    
    
}
