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
        let dao = RestListDAO.getDAO()
        lists = dao?.read()
        self.navigationItem.title = "Edit Lists"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let dao = RestListDAO.getDAO()
        lists = dao?.read()
    }
    
    @IBAction func newList(_ sender: UIBarButtonItem) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add new list", message: "Please enter a list name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Delicious list!"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            var dao = RestListDAO.getDAO()
            if (textField?.text != nil && textField?.text != "") {
                if dao != nil && !dao!.contains(textField!.text!) {
                    let rest = RestList(textField!.text!)
                    dao?.savelist(rest)
                    dao?.save()
                    self.lists = RestListDAO.getDAO()!.read()
                    self.table.reloadData()
                    let sucAlert = UIAlertController(title: "Success", message: "You successfully add a new list!", preferredStyle: .alert)
                    sucAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                    }))
                    self.present(sucAlert, animated: true, completion: nil)
                } else {
                    let dupAlert = UIAlertController(title: "Error", message: "You already have this list!", preferredStyle: .alert)
                    dupAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                    }))
                    
                    self.present(dupAlert, animated: true, completion: nil)
                }
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (lists![indexPath.row].name == "Nearby") {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let cell = table.cellForRow(at: indexPath) as! AddToListTableViewCell
            let listName = cell.listNameLabel.text!
            let dao = RestListDAO.getDAO()
//            let list = dao.getList(listName!)
//            list?.remove(restName)
//            list?.save()
            dao?.remove(listName)
            
            lists = dao?.read()
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dao = RestListDAO.getDAO()
        let cell = table.cellForRow(at: indexPath) as! AddToListTableViewCell
        self.selectedList = dao?.getList("\(cell.listNameLabel!.text!)")!
        self.performSegue(withIdentifier: "EditListToEditRest", sender: nil)
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
