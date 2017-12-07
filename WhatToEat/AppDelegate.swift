//
//  AppDelegate.swift
//  WhatToEat
//
//  Created by Student User on 11/6/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookCore
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        
    }
    

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Add any custom logic here.
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //WeiboSDK.enableDebugMode(true)
        //WeiboSDK.registerApp("521970512")
        Twitter.sharedInstance().start(withConsumerKey: "fgu8UmO7uQ9TX4ivyzCNZOa8S", consumerSecret: "7sdPZL7MEKlTJ7akP8uQ8Ir8Y4YdzTrvVt7QjhkFybzWhjoBov")
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        // Add any custom logic here.
        /*
        if (url.scheme == "wb521970512") {
            let weiboHandled = WeiboSDK.handleOpen(url, delegate: self)
            return weiboHandled
        } else
        if (url.scheme == "fb690304267826071") {*/
            return SDKApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        /*} else if (url.scheme == "twitterkit-fgu8UmO7uQ9TX4ivyzCNZOa8S") {
            return Twitter.sharedInstance().application(application, open: url, options: options)
        }*/
        
        //return false
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        /*if (url.scheme == "fb690304267826071") {
            return SDKApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        } else if (url.scheme == "twitterkit-fgu8UmO7uQ9TX4ivyzCNZOa8S") {
            */return Twitter.sharedInstance().application(app, open: url, options: options)
        //}
    }
    
    /*
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
     */

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

