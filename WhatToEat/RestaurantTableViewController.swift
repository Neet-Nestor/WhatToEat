//
//  RestaurantTableViewController.swift
//  WhatToEat
//
//  Created by zichu zheng on 12/3/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var restList : RestList? = nil
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dao = RestListDAO.getDAO()
        restList = dao!.read()[0]
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (restList != nil) ? restList!.list.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantListCell
        cell.nameLabel.text = restList?.list[indexPath.row].getName()
        cell.miniImage.image = (restList?.list[indexPath.row].getImage())!
        //cell.stars[0].image = UIImage(named: "filledStar_2x")
        if let star = restList?.list[indexPath.row].getRating() {
            for index in 0...(star - 1) {
                cell.stars[index].image = UIImage(named: "filledStar_2x")
            }
        }
        return cell
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
