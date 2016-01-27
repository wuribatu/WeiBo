//
//  OAuthViewController.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/26.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    let WB_App_Key    = "2398235223"
    let WB_App_Secret = "7621ff4ad3964b4d89ad913378850f75"
    let WB_redirect_uri = "http://www.wuribatu.com"
    
    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "图哥的微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: "close")
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let requset = NSURLRequest(URL: url!)
        webView.loadRequest(requset)
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()
}

extension OAuthViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.URL?.absoluteString)
        
        // absoluteString 请求头
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(WB_redirect_uri) {
            return true
        }
        
        let codeStr = "code="
        // query 参数
        if request.URL!.query!.hasPrefix(codeStr) {
            let code = request.URL?.query?.substringFromIndex(codeStr.endIndex)
            print(code)
            
            loadAccessToken(code!)
        } else {
            print("取消授权")
            close()
        }
        
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showInfoWithStatus("正在加载...", maskType: .Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func loadAccessToken(code: String) {
        let path = "oauth2/access_token"
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_redirect_uri]
        NetworkTools.shareNetwordTools().POST(path, parameters: params, success: { (_, JSON) -> Void in
//            2.00rwEKWCRXkScC3c0b82201aaROmVB
            let account = UserAccount(dict: JSON as! [String: AnyObject])
            
            // 获取用户信息
            account.loadUserinfo({ (account, error) -> () in
                if account != nil {
                    account?.saveAccount()
                    
                    return
                }
                SVProgressHUD.showInfoWithStatus("网络不给力...", maskType: .Black)
            })
            // 归档模型
//            account.saveAccount()
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
}
