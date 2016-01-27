 //
//  UserAccount.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/26.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    /// 采用OAuth授权方式为必填参数，OAuth授权后获得。
    var access_token: String?
    /// 寿命 单位秒
    var expires_in: NSNumber? {
        didSet { //有值就调用
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print(expires_Date)
        }
    }
    ///当前授权用户的uid
    var uid: String?
    var expires_Date: NSDate?
    var avatar_large: String? // 头像
    var screen_name: String? // 用户昵称
    
    init(dict:[String: AnyObject]) {
        super.init()
//        access_token = dict["access_token"] as? String
//        expires_in = dict["expires_in"] as? NSNumber
//        uid = dict["uid"] as? String
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    // 打印对象
    override var description: String {
        let properties = ["access_token", "expires_in", "uid", "avatar_large", "screen_name"]
        let dict = self.dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    
    func loadUserinfo(finished:(account: UserAccount?, error: NSError?) -> ()) {
        assert(access_token != nil, "没有授权")
        
        let path = "2/users/show.json"
        let params = ["access_token":access_token!, "uid":uid!]
        NetworkTools.shareNetwordTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            print(JSON)
            if let dict = JSON as? [String: AnyObject] {
                self.screen_name  = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                finished(account: self, error: nil)
                
                return
            }
            finished(account: nil, error: nil)
            }) { (_, error) -> Void in
                finished(account: nil, error: error)
        }
    }
    
    // MARK: - 保存和读取  Keyed
    /**
    保存授权模型
    */
    static let filePath = "account.plist".cacheDir()
    func saveAccount() {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    override init() {
        
    }
    
    /**
    返回用户是否登录
    */
    class func userLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    }
    
    /// 加载授权模型
    static var account: UserAccount?
    class func loadAccount() -> UserAccount? {
        
        // 1.判断是否已经加载过
        if account != nil  {
            return account
        }
        // 2.加载授权模型
        account =  NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
        
        // 3.判断授权信息是否过期
        // 2020-09-08 03:49:39                       2020-09-09 03:49:39
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            // 已经过期
            return nil
        }
        
        return account
    }

    // MARK: - NSCoding
    // 将对象写入到文件中
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    // 从文件中读取对象
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in   = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid          = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name  = aDecoder.decodeObjectForKey("screen_name")  as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large")  as? String
    }
}
