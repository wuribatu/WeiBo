//
//  NSDate+Category.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/30.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

extension Date {

    static func dateWithString(_ time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        formatter.locale = Locale(localeIdentifier: "en")
        let createdDate = formatter.date(from: time)!
        
        return createdDate
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var descDate: String {
        let calendar = Calendar.current()
        // 1.判断是否是今天
        if calendar.isDateInToday(self) {
            let since = Int(Date().timeIntervalSince(self))
            
            if since < 60 {
                return "刚刚"
            }
            if since < 60 * 60 {
                return "\(since/60)分钟前"
            }
            return "\(since / (60 * 60))小时前"
        }
        
        var formatterStr = "HH:mm"
        if calendar.isDateInYesterday(self) {
            formatterStr = "昨天:" + formatterStr
        } else {
            formatterStr = "MM-dd " + formatterStr
            
            let coms = calendar.components(Calendar.Unit.year, from: self, to: Date(), options: Calendar.Options(rawValue: 0))
            if coms.year >= 1 {
                formatterStr = "yyyy-" + formatterStr
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        formatter.locale = Locale(localeIdentifier: "en")
        let createdDate = formatter.string(from: self)
        
        return createdDate
    }
}
