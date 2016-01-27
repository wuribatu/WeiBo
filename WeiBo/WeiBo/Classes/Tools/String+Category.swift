//
//  String+Category.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/10.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

extension String{
    /**
    将当前字符串拼接到cache目录后面
    */
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!  as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
    将当前字符串拼接到doc目录后面
    */
    func docDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!  as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
    将当前字符串拼接到tmp目录后面
    */
    func tmpDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
}