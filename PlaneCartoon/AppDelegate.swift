//
//  AppDelegate.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isDid = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        KingfisherManager.shared.downloader.trustedHosts = ["smp.yoedge.com"]


        let screen:UIScreen = UIScreen.main
        window = UIWindow(frame:screen.bounds)
        window?.rootViewController = MyMainTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        isDid = true
        MyNewSwift.shared().ArchiverAnArray()
    }
    func applicationWillTerminate(_ application: UIApplication) { // 杀死程序
        isDid = true
        MyNewSwift.shared().ArchiverAnArray()
    }
    func applicationDidBecomeActive(_ application: UIApplication) { // 从后台切换到前台
        if isDid{
            MyNewSwift.shared().listOfObjectModel()
        }
    }
}

