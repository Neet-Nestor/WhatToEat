//
//  FoundViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import MapKit
import FBSDKCoreKit
import FacebookLogin
import FacebookShare
import TwitterKit

class FoundViewController: UIViewController {

    @IBOutlet weak var tweetBtn: UIButton!
    var resultRest: Restaurant?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (resultRest != nil) {
            self.nameLabel.text = resultRest?.getName()
            let point = MKPointAnnotation()
            let latitude = resultRest?.getCoordinate().getLatitude()
            let longitude = resultRest?.getCoordinate().getLongitude()
            point.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.addAnnotation(point)
            self.mapView.setRegion(region, animated: true)
        }
        self.nameLabel.sizeToFit()
        let shareContent = LinkShareContent(url: URL(string:"http://students.washington.edu/qiny8")!)
        let FBShareBtn = ShareButton<LinkShareContent>()
        FBShareBtn.content = shareContent
        FBShareBtn.center = CGPoint(x: view.center.x,y:view.center.y + 150)
        self.view.addSubview(FBShareBtn)
        let TwilogInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        self.view.addSubview(FBShareBtn)
        //self.view.addSubview(loginButton)
        //FBShareBtn.leadingAnchor.
        //FBShareBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 15).isActive = true
        //FBShareBtn.trailingAnchor.constraint(equalTo: self.tweetBtn.leadingAnchor, constant: 15).isActive = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is FinishViewController) {
            let finishVC = segue.destination as! FinishViewController
            finishVC.restName = resultRest!.getName()
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
