//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/22.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import SVProgressHUD

let HomeIdentifier = "HomeIdentifier"
class HomeTableViewController: BaseTableViewController {
    
    var isPresented: Bool = false //没有打开菜单
    var statuses: [Status]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default().addObserver(self, selector: #selector(HomeTableViewController.change), name: BTPopoverAnimatorWillShow, object: nil)
        NotificationCenter.default().addObserver(self, selector: #selector(HomeTableViewController.change), name: BTPopoverAnimatorWillDismiss, object: nil)
        
        
        if !userLogin {
            visitorView.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        tableView.register(StatusNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.register(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // 添加下拉刷新控件
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), for: UIControlEvents.valueChanged)
        
        setupNav()
        
//        加载微博数据
        loadData()
    }
    
    /// 下拉标记
    var pullupRefreshFlag = false
    /**
     获取微博数据
     如果想调用一个私有的方法:
     1.去掉private
     2.@objc, 当做OC方法来处理
     */
    func loadData() {
        
        // 1.默认是上拉
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        // 2.判断是否是上拉
        if pullupRefreshFlag {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        Status.loadStatuses(since_id, max_id :max_id) {(models, error) -> () in
            
            if error != nil {
                return
            }
            
            if since_id > 0 { // 下拉刷新
                self.statuses = models! + self.statuses!
                self.showNewStatusConut(models?.count ?? 0)
            } else if max_id > 0 {
                self.statuses = self.statuses! + models!
            } else {
                self.statuses = models
            }
            
            self.refreshControl?.endRefreshing()
//            self.statuses = models
        }
    }
    
    private func showNewStatusConut(_ count: Int) {
        newStatusLabel.isHidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到微博" : "刷新到\(count)条微博数据"
        
        /*
        let rect = newStatusLabel.frame
        UIView.animateWithDuration(2, animations: { () -> Void in
            UIView.setAnimationRepeatAutoreverses(true)
            self.newStatusLabel.frame = CGRectOffset(rect, 0, 3 * rect.height)
            }) { (_) -> Void in
                self.newStatusLabel.frame = rect
        }
        */
        UIView.animate(withDuration: 2, animations: { () -> Void in
            self.newStatusLabel.transform = CGAffineTransform(translationX: 0, y: self.newStatusLabel.frame.height)
            }) { (_) -> Void in
                UIView.animate(withDuration: 2, animations: { () -> Void in
                    self.newStatusLabel.transform = CGAffineTransform.identity
                    }, completion: { (_) -> Void in
                        self.newStatusLabel.isHidden = true
                })
        }
    }
    
    func change() {
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.isSelected = !titleButton.isSelected
    }
    
    deinit {
        NotificationCenter.default().removeObserver(self)
    }
    
    // MARK: -设置导航栏
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("乌日巴图 ", for: UIControlState())
        titleBtn.setTitleColor(UIColor.darkGray(), for: UIControlState())
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControlState())
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        titleBtn.sizeToFit()
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(_ titleBtn: TitleButton) {
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        vc?.transitioningDelegate = popoverAnimator
        vc?.modalPresentationStyle = .custom
        present(vc!, animated: true, completion: nil)
    }
        
    func leftBtnClick() {
        print(#function)
    }
    
    func rightBtnClick() {
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        present(vc!, animated: true, completion: nil)
    }
    
    private lazy var popoverAnimator: PopoverAnimator = {
        let po = PopoverAnimator()
        po.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return po
    }()
    
    private lazy var newStatusLabel :UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orange()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white()
        
        let height: CGFloat = 44
        label.frame = CGRect(x: 0, y: 0  * height, width: UIScreen.main().bounds.size.width, height: height)
        self.navigationController?.navigationBar.insertSubview(label, at: 0)
        label.isHidden = true
        
        return label;
    }()
    
    // 缓存行高
    var rowCache = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
    }
}

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let status = statuses![(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTableViewCellIdentifier.cellID(status), for: indexPath) as! StatusTableViewCell
        
        cell.status = status
        
        let count = statuses?.count ?? 0
        if (indexPath as NSIndexPath).row == count - 1 {
//            print("加载更多");
            pullupRefreshFlag = true
            loadData()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let status = statuses![(indexPath as NSIndexPath).row]
        
        if let height = rowCache[status.id] {
//            print("从缓存获取")
            return height
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTableViewCellIdentifier.cellID(status)) as! StatusTableViewCell
       
    
        let rowHeight = cell.rowHeight(status)
        rowCache[status.id] = rowHeight
//        print("重新计算")
        return rowHeight
    }
}
