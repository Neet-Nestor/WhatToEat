//
//  AddContainerViewController.swift
//  WhatToEat
//
//  Created by Student User on 12/6/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import SocketIO

class AddContainerViewController: UIViewController {

    @IBOutlet weak var tableViewContainer: UIView!
    var addView: AddViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? AddViewController {
            self.addView = des
        }
        if let des = segue.destination as? MomentsViewController {
            if addView?.textField.text != nil {
                Common.socket.emit("pyqSend", ["user_id" : Common.myFacebookID,
                                               "user_name" : Common.myFacebookName,
                                               "content" : addView?.textField.text,
                                               "avator" : Common.myFacebookProfileImageURL])
            }
            des.refreshData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
