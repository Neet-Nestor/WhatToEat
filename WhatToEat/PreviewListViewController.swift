//
//  PreviewListViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/27/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class PreviewListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var theNavigationItem: UINavigationItem!
    var restList: RestList?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        if (restList != nil) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (restList != nil) {
            return 1
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (restList != nil) {
            return self.restList!.count()
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewTableCell", for: indexPath) as! RestaurantListCell
        // Configure the cell...

        let rest = restList?.getRest(indexPath.row)
        cell.nameLabel.text = rest?.getName()
        cell.miniImage.image = (rest?.getImage())!
        //cell.stars[0].image = UIImage(named: "filledStar_2x")
        if let star = rest?.getRating() {
            for index in 0...(star - 1) {
                cell.stars[index].image = UIImage(named: "filledStar_2x")
            }
        }
        cell.tags.text = rest?.getTags().joined(separator: ", ")
        cell.address.text = rest?.getAddr().toString()
        
        let restLocation = rest?.getCoordinate()
        let myLocation = restList?.getLocation()
        let dis = rest?.getCoordinate()
            .getKmDistance(other: (restList?.getLocation())!)
        
        cell.distance.text = "\(dis ?? 0) km"
        cell.cost.text = rest?.getDollarSign()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is FoundViewController) {
            let foundVC = segue.destination as! FoundViewController
            foundVC.resultRest = restList?.random()
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
