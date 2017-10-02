//
//  AppDelegate.swift
//  mga
//
//  Created by Shaheen Ghiassy on 9/30/17.
//  Copyright © 2017 Shaheen Ghiassy. All rights reserved.
//

import UIKit
import carousel
import carousel_light
import AirGap

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        let url = userActivity.webpageURL
        let path = url?.path ?? "/unknown"
        let query = url?.query ?? "?blank"
        let _ = ViewController(path: path, query: query)
//        self.nav?.pushViewController(initialViewController, animated: true)
        
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Hide the Status Bar
        UIApplication.shared.isStatusBarHidden = true
        
        // Setup Browser Configuration
        Browser.setConfig(DNS.loadConfigForDomain("carousel")!, CarouselViewController.self) // In the future you won't have to pass in the VC. Just cheating for now
        Browser.setConfig(DNS.loadConfigForDomain("carousel-light")!, CarouselLightViewController.self)
        Browser.frame = UIScreen.main.bounds
        
        // Init Application's Main Window and Show
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = Browser.rootViewController
        self.window?.makeKeyAndVisible()
        
        Browser.goto("carousel-light.groupon.com")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

