//
//  EditRestViewController.swift
//  WhatToEat
//
//  Created by Nestor Qin on 12/11/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class EditRestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var restList:RestList?
//    var restArray: [Restaurant]?
    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
//        self.restArray = restList?.getRestList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let cell = table.cellForRow(at: indexPath) as! RestaurantListCell
            let restName = cell.nameLabel.text!
            let dao = RestListDAO.getDAO()
//            dao.remove(listName)
            restList?.remove(restName)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restList!.getRestList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditRestTableCell", for: indexPath) as! RestaurantListCell
        let rest = restList?.getRestList()[indexPath.row]
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
        cell.cost.text = rest?.getDollarSign()
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
