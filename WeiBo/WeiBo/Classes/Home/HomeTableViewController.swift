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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: BTPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: BTPopoverAnimatorWillDismiss, object: nil)
        
        
        if !userLogin {
            visitorView.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        tableView.registerClass(StatusNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 添加下拉刷新控件
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
        
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
    
    private func showNewStatusConut(count: Int) {
        newStatusLabel.hidden = false
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
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
            }) { (_) -> Void in
                UIView.animateWithDuration(2, animations: { () -> Void in
                    self.newStatusLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.newStatusLabel.hidden = true
                })
        }
    }
    
    func change() {
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.selected = !titleButton.selected
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: -设置导航栏
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("乌日巴图 ", forState: .Normal)
        titleBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        titleBtn.sizeToFit()
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(titleBtn: TitleButton) {
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        vc?.transitioningDelegate = popoverAnimator
        vc?.modalPresentationStyle = .Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
        
    func leftBtnClick() {
        print(#function)
    }
    
    func rightBtnClick() {
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    private lazy var popoverAnimator: PopoverAnimator = {
        let po = PopoverAnimator()
        po.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return po
    }()
    
    private lazy var newStatusLabel :UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.orangeColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        
        let height: CGFloat = 44
        label.frame = CGRect(x: 0, y: 0  * height, width: UIScreen.mainScreen().bounds.size.width, height: height)
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        label.hidden = true
        
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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! StatusTableViewCell
        
        cell.status = status
        
        let count = statuses?.count ?? 0
        if indexPath.row == count - 1 {
//            print("加载更多");
            pullupRefreshFlag = true
            loadData()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        
        if let height = rowCache[status.id] {
//            print("从缓存获取")
            return height
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! StatusTableViewCell
       
    
        let rowHeight = cell.rowHeight(status)
        rowCache[status.id] = rowHeight
//        print("重新计算")
        return rowHeight
    }
}
