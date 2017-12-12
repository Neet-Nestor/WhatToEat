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
import SocketIO

struct FbResponse: GraphRequestProtocol {
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, picture, friends, email"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
    
    struct Response: GraphResponseProtocol {
        var name: String?
        var id: String?
        var friends: Dictionary<String, Any>?
        var email: String?
        var profilePictureUrl: String?
        
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            guard let response = rawResponse as? Dictionary<String, Any> else {
                return
            }
            
            if let name = response["name"] as? String {
                self.name = name
            }
            
            if let id = response["id"] as? String {
                self.id = id
            }
            
            if let friends = response["friends"] as? Dictionary<String, Any> {
                self.friends = friends
            }
            
            if let email = response["email"] as? String {
                self.email = email
            }
            
            if let picture = response["picture"] as? Dictionary<String, Any> {
                
                if let data = picture["data"] as? Dictionary<String, Any> {
                    if let url = data["url"] as? String {
                        self.profilePictureUrl = url
                    }
                }
            }
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
//
//    }
//
//    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
//
//    }
    
    

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Add any custom logic here.
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //WeiboSDK.enableDebugMode(true)
        //WeiboSDK.registerApp("521970512")
        Twitter.sharedInstance().start(withConsumerKey: "ILt3tj0pk4MUk5Qne45GHRjlD", consumerSecret: "sldP0IAMcqLzgwCAtKvcN3hKgMnTmhF4CCWu7kosQ7aVJFF7zY")

        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    // let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    // Add any custom logic here.
        var handled = false
        if (url.scheme == "fb690304267826071") {
            handled = SDKApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return handled
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.scheme == "twitterkit-ILt3tj0pk4MUk5Qne45GHRjlD") {
            return Twitter.sharedInstance().application(app, open: url, options: options)
        }
        return false
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

