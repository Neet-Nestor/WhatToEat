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

    @IBOutlet weak var tweetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }

        // let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        // loginButton.center = CGPoint(x: view.center.x,y:750)
        let shareContent = LinkShareContent(url: URL(string:"https://newsroom.fb.com/")!)
        let FBShareBtn = ShareButton<LinkShareContent>()
        FBShareBtn.content = shareContent
        //FBShareBtn.frame.origin = CGPoint(x: tweetBtn.frame.minX - FBShareBtn.frame.width - 15, y: tweetBtn.frame.minY)
        FBShareBtn.frame.origin = CGPoint(x: tweetBtn.frame.origin.x - FBShareBtn.frame.width - 15, y: tweetBtn.frame.origin.y)
        FBShareBtn.frame.size = CGSize(width: FBShareBtn.frame.width, height: tweetBtn.frame.height)

        // loginButton.frame.size = CGSize(width: 80, height:FBShareBtn.frame.height)
        // self.view.addSubview(loginButton)
        /*
        let TwilogInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        TwilogInButton.center = CGPoint(x: view.center.x,y:UIScreen.main.bounds.height - TwilogInButton.frame.height - 50)
        self.view.addSubview(TwilogInButton)
        */

        self.view.addSubview(FBShareBtn)
        //self.view.addSubview(loginButton)
        //FBShareBtn.leadingAnchor.
        //FBShareBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 15).isActive = true
       // FBShareBtn.trailingAnchor.constraint(equalTo: self.tweetBtn.leadingAnchor, constant: 15).isActive = true
        //TwilogInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        //let twiXConstraint = NSLayoutConstraint(item: TwilogInButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        //TwilogInButton.addConstraint(twiXConstraint)
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
 
    @IBAction func tweet(_ sender: Any) {
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            let composer = TWTRComposerViewController.emptyComposer()
            present(composer, animated: true, completion: nil)
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().logIn { session, error in
                if session != nil { // Log in succeeded
                    let composer = TWTRComposerViewController.emptyComposer()
                    self.present(composer, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
    /*
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
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
