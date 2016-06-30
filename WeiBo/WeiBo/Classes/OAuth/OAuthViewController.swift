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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.close))
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = URL(string: urlStr)
        let requset = URLRequest(url: url!)
        webView.loadRequest(requset)
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()
}

extension OAuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url?.absoluteString)
        
        // absoluteString 请求头
        let urlStr = request.url!.absoluteString
        if !(urlStr?.hasPrefix(WB_redirect_uri))! {
            return true
        }
        
        let codeStr = "code="
        // query 参数
        if request.url!.query!.hasPrefix(codeStr) {
            let code = request.url?.query?.substring(from: codeStr.endIndex)
            print(code)
            
            loadAccessToken(code!)
        } else {
            print("取消授权")
            close()
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.showInfo(withStatus: "正在加载...", maskType: .black)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func loadAccessToken(_ code: String) {
        let path = "oauth2/access_token"
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_redirect_uri]
        NetworkTools.shareNetwordTools().post(path, parameters: params, success: { (_, JSON) -> Void in
//            2.00rwEKWCRXkScC3c0b82201aaROmVB
            let account = UserAccount(dict: JSON as! [String: AnyObject])
            
            // 获取用户信息
            account.loadUserinfo({ (account, error) -> () in
                if account != nil {
                    account?.saveAccount()
                    NotificationCenter.default().post(name: NSNotification.Name(rawValue: XMGSwitchRootViewControllerKey), object: false)
                    return
                }
                SVProgressHUD.showInfo(withStatus: "网络不给力...", maskType: .black)
            })
            // 归档模型
//            account.saveAccount()
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
}
