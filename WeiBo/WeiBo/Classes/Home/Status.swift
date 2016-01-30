//
//  Status.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/29.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class Status: NSObject {
    /// 微博创建时间
    var created_at: String? {
        didSet {
//            created_at = "Sat Jan 1 21:37:09 +0800 2016"
            // 1.将字符串转换为时间
            let createdDate = NSDate.dateWithString(created_at!)
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
                    let starLocation = (str as NSString).rangeOfString(">").location + 1
                    let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - starLocation
                    source = "来自:" + (str as NSString).substringWithRange(NSMakeRange(starLocation, length))
                }
            }
        }
    }
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? 
    /// 用户信息
    var user: User?
    
    class func loadStatuses(finished: (models: [Status]?, error: NSError?)->()) ->() {
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token": UserAccount.loadAccount()!.access_token!]
        NetworkTools.shareNetwordTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            
//            print(JSON)
            let models = dict2Model(JSON!["statuses"] as! [[String: AnyObject]])
            
            //缓存配图数组
            
//            print(models)
            finished(models: models, error: nil)
            }) { (_, error) -> Void in
//                print(error)
                finished(models: nil, error: error)
        }
    }
    
    class func dict2Model(list: [[String: AnyObject]]) -> [Status] {
        var models = [Status]()
        for dict in list {
            models.append(Status(dict: dict))
        }
        
        return models
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if "user" == key {
            user = User(dict: value as! [String : AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    let properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
