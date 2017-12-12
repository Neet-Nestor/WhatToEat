//
//  EditListViewController.swift
//  WhatToEat
//
//  Created by Nestor Qin on 12/9/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class EditListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    //var restList: RestList?
    var lists: [RestList]?
    var listName:String?
    var selectedList: RestList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        let dao = RestListDAO()
        lists = dao.read()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let dao = RestListDAO()
        lists = dao.read()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let cell = table.cellForRow(at: indexPath) as! AddToListTableViewCell
            let listName = cell.listNameLabel.text!
            let dao = RestListDAO()
//            let list = dao.getList(listName!)
//            list?.remove(restName)
//            list?.save()
            dao.remove(listName)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dao = RestListDAO()
        let cell = table.cellForRow(at: indexPath) as! AddToListTableViewCell
        self.selectedList = dao.getList("\(cell.listNameLabel!.text)")!
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (lists != nil) {
            return lists!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! AddToListTableViewCell
        let list = lists![indexPath.row]
        cell.listNameLabel.text = list.name
        // Configure the cell...
//        let rest = restList?.list[indexPath.row]
//        cell.nameLabel.text = rest?.getName()
//        cell.miniImage.image = (rest?.getImage())!
//        //cell.stars[0].image = UIImage(named: "filledStar_2x")
//        if let star = rest?.getRating() {
//            for index in 0...(star - 1) {
//                cell.stars[index].image = UIImage(named: "filledStar_2x")
//            }
//        }
//        cell.tags.text = rest?.getTags().joined(separator: ", ")
//        cell.address.text = rest?.getAddr().toString()
//
//        let restLocation = rest?.getCoordinate()
//        let myLocation = restList?.getLocation()
//        let dis = rest?.getCoordinate()
//            .getKmDistance(other: (restList?.getLocation())!)
//
//        cell.distance.text = "\(dis ?? 0) km"
//        cell.cost.text = rest?.getDollarSign()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EditRestViewController {
            if (self.selectedList != nil) {
                dest.restList = self.selectedList
            }
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
