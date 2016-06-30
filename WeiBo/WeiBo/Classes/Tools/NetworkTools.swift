//
//  NetworkTools.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/26.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {
    
    static let tools: NetworkTools = {
        let baseUrl = URL(string: "https://api.weibo.com/")
        let ts = NetworkTools(baseURL: baseUrl)
        ts.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        
        return ts
    }()
    
    class func shareNetwordTools() -> NetworkTools {
        return tools
    }
}
