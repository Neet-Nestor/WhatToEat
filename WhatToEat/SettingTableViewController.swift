//
//  SettingTableViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var logInCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Handle clicks on the cell
        // logInCell.addTarget(self, action: @selector(self.loginButtonClicked) forControlEvents: .TouchUpInside)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0 && indexPath.section == 0) {
            let loginManager = LoginManager()
            //readPermissions: [ .publicProfile, .email, .userFriends ]
            loginManager.logIn(readPermissions:[.publicProfile, .email, .userFriends], viewController: self) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("Logged in!")

                    
                    let connection = GraphRequestConnection()
                    connection.add(FbResponse()) { response, result in
                        switch result {
                        case .success(let response):
                            print("Custom Graph Request Succeeded: \(response)")
                            print("My facebook id is \(response.id)")
                            print("My name is \(response.name)")
                            print("My picture is \(response.profilePictureUrl)")
                            var friendObjects = response.friends!["data"] as! [NSDictionary]
                            for friendObject in friendObjects {
                                print(friendObject["id"] as! NSString)
                            }
                            print("\(friendObjects.count)")
                            Common.myFacebookID = response.id
                            Common.myFacebookName = response.name
                            Common.myFacebookProfileImageURL = response.profilePictureUrl
                        case .failed(let error):
                            print("Custom Graph Request Failed: \(error)")
                        }
                    }
                    connection.start()
                    
//                    let params = ["fields": "id, first_name, last_name, name, email, picture"]
//                    let graphRequest = GraphRequestConnection(graphPath: "/me/friends", parameters: params)
//                    let connection = FBSDKGraphRequestConnection()
//                    connection.add(graphRequest, completionHandler: { (connection, result, error) in
//                        if error == nil {
//                            if let userData = result as? [String:Any] {
//                                print(userData)
//                            }
//                        } else {
//                            print("Error Getting Friends \(error)");
//                        }
//
//                    })
                    
                    connection.start()
                }
            }
        } /*else if (indexPath.row == 0 && indexPath.section == 2) {
            let historyVC = storyboard?.instantiateViewController(withIdentifier: "HistoryVC")
            present(historyVC!, animated: true, completion: nil)
        }*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is HistoryViewController) {
            segue.destination.navigationItem.title = "History"
        }
    }

}
