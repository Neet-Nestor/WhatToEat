//
//  FoundViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FacebookLogin
import FacebookShare
import TwitterKit

class FoundViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }

        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        // loginButton.center = CGPoint(x: view.center.x,y:750)
        let shareContent = LinkShareContent(url: URL(string:"https://newsroom.fb.com/")!)
        let FBShareBtn = ShareButton<LinkShareContent>()
        FBShareBtn.content = shareContent
        FBShareBtn.center = self.view.center
        // loginButton.frame.size = CGSize(width: 80, height:FBShareBtn.frame.height)
        // self.view.addSubview(loginButton)
        let TwilogInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        TwilogInButton.center = CGPoint(x: 150,y:500)
        self.view.addSubview(TwilogInButton)
        self.view.addSubview(FBShareBtn)
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Congratulation!"
    }

    @IBAction func shareToFB(_ sender: UIButton) {
        var content = LinkShareContent(url: URL(string:"https://newsroom.fb.com/")!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        shareDialog.content
        
        try? shareDialog.show()
    }
 
    
    @IBAction func weibo(_ sender: Any) {
        do {
            let WBRequest = try WBAuthorizeRequest()
            try WBRequest.redirectURI = "https://api.weibo.com/oauth2/default.html"
            try WBRequest.scope = "all"
            try WeiboSDK.send(WBRequest)
            
        }
        catch (let error) {
            NSLog("\(error)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
