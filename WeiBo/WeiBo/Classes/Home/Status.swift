//
//  Status.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/29.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    /// 微博创建时间
    var created_at: String? {
        didSet {
//            created_at = "Sat Jan 1 21:37:09 +0800 2016"
            // 1.将字符串转换为时间
            let createdDate = Date.dateWithString(created_at!)
            // 2.获取格式化之后的时间字符串
            
            created_at = createdDate.descDate
        }
    }
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String? {
        didSet {
            if let str = source {
                if str != "" {
                    let starLocation = (str as NSString).range(of: ">").location + 1
                    let length = (str as NSString).range(of: "<", options: NSString.CompareOptions.backwardsSearch).location - starLocation
                    source = "来自:" + (str as NSString).substring(with: NSMakeRange(starLocation, length))
                }
            }
        }
    }
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            storedPicURLS = [URL]()
            storedLargePicURLS = [URL]()
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] as? String{
                    
                    // 1.将字符串转为URL保存在数组中
                    storedPicURLS?.append(URL(string: urlStr)!)
                    
                    // 2.处理大图
                    let largeURLStr = urlStr.replacingOccurrences(of: "thumbnail", with: "large")
                    storedLargePicURLS?.append(URL(string: largeURLStr)!)
                }
            }
        }
    }
    
    /// 缓存配图
    var storedPicURLS: [URL]?
    
    /// 缓存配图大图
    var storedLargePicURLS: [URL]?
    var pictureURLS: [URL]? {
        return retweeted_status != nil ? retweeted_status?.storedPicURLS : storedPicURLS
    }
    
    /// 定义一个计算属性 用于转发 原创 的配图大图
    var largePictureURLS: [URL]? {
        return retweeted_status != nil ? retweeted_status?.storedLargePicURLS : storedLargePicURLS
    }
    
    
    /// 用户信息
    var user: User?
    
    /// 转发微博
    var retweeted_status: Status?
    
    class func loadStatuses(_ since_id: Int,max_id: Int, finished: (models: [Status]?, error: NSError?)->()) ->() {
        let path = "2/statuses/home_timeline.json"
        var params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        // 下拉刷新
        if since_id > 0 {
            params["since_id"] = "\(since_id)"
        }
        
        // 上拉刷新
        if max_id > 0 {
            params["max_id"] = "\(max_id - 1)"
        }
        
        NetworkTools.shareNetwordTools().get(path, parameters: params, success: { (_, JSON) -> Void in
            
//            print(JSON)lo
            let models = dict2Model(JSON!["statuses"] as! [[String: AnyObject]])
            
            //缓存配图数组
            cacheStatusImages(models, finished: finished)
            
//            print(models)
//            finished(models: models, error: nil)
            }) { (_, error) -> Void in
//                print(error)
                finished(models: nil, error: error)
        }
    }
    
    class func cacheStatusImages(_ list: [Status], finished: (models: [Status]?, error: NSError?) ->()) {

        if list.count == 0 {
            finished(models: list, error: nil)
            
            return
        }
        
        let group = DispatchGroup()
        for status in list {
            // 判断当前是否有配图，没有跳过
//            if status.storedPicURLS == nil {
//                continue
//            }
            
            //Swift2.0新语法 如果status.storedPicURLS == nil 进入else
            guard let _ = status.pictureURLS else {
                print("来这了")
                continue
            }
            for url in status.pictureURLS! {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _)  -> Void in
//                    print("OK")
                    group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main, execute: { () -> Void in
            finished(models: list, error: nil)
        })
    }
    
    class func dict2Model(_ list: [[String: AnyObject]]) -> [Status] {
        var models = [Status]()
        for dict in list {
            models.append(Status(dict: dict))
        }
        
        return models
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: AnyObject?, forKey key: String) {
        if "user" == key {
            user = User(dict: value as! [String : AnyObject])
            return
        }
        
        // 判断是否是转发微博
        
        if "retweeted_status" == key {
            retweeted_status = Status(dict: value as! [String : AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }

    override func setValue(_ value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    let properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValues(forKeys: properties)
        return "\(dict)"
    }
}
