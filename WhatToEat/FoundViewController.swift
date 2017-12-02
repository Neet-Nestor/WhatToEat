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

        // Do any additional setup after loading the view.
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        // loginButton.center = CGPoint(x: view.center.x,y:750)
        let shareContent = LinkShareContent(url: URL(string:"https://newsroom.fb.com/")!)
        let FBShareBtn = ShareButton<LinkShareContent>()
        FBShareBtn.content = shareContent
        FBShareBtn.center = CGPoint(x: 150,y:650)
        // loginButton.frame.size = CGSize(width: 80, height:FBShareBtn.frame.height)
        // self.view.addSubview(loginButton)
        self.view.addSubview(FBShareBtn)
        self.view.addSubview(logInButton)
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
 
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
