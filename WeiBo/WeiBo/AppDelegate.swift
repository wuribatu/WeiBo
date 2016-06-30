//
//  AppDelegate.swift
//  WeiBo
//
//  Created by 乌日巴图 on 16/1/22.
//  Copyright © 2016年 wuribatu. All rights reserved.
//

import UIKit

// 切换控制器通知
let XMGSwitchRootViewControllerKey = "XMGSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 注册一个通知
        NotificationCenter.default().addObserver(self, selector: "switchRootViewController:", name: XMGSwitchRootViewControllerKey, object: nil)
        
        UINavigationBar.appearance().tintColor = UIColor.orange()
        UITabBar.appearance().tintColor        = UIColor.orange()
        
        window = UIWindow(frame: UIScreen.main().bounds)
        window?.backgroundColor    = UIColor.white()
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
    
//        print(isNewupdate())
        
        return true
    }
    
    func switchRootViewController(_ notify: Notification) {
//        print(notify.object)
        if notify.object as! Bool {
            window?.rootViewController = MainViewController()
        } else {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    deinit {
        NotificationCenter.default().removeObserver(self)
    }
    
    private func defaultController() -> UIViewController {
        
        if UserAccount.userLogin() {
            return isNewupdate() ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    private func isNewupdate() -> Bool {
        let currentVersion = Bundle.main().infoDictionary!["CFBundleShortVersionString"] as! String
        let sandboxVersion = UserDefaults.standard().object(forKey: "CFBundleShortVersionString") as? String ?? ""
        if currentVersion.compare(sandboxVersion) == ComparisonResult.orderedDescending {
            UserDefaults.standard().set(currentVersion, forKey: "CFBundleShortVersionString")
            
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

