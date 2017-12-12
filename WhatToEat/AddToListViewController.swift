//
//  AddToListViewController.swift
//  WhatToEat
//
//  Created by Nestor Qin on 12/10/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class AddToListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var lists: [RestList]?
    var restName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.table.delegate = self
        self.table.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //let dao = RestListDAO()
        lists = RestListDAO.getDAO()!.read()
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add to list", message: "Do you sure you want to add the restaurant to this list?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let dao = RestListDAO()
            let cell = self.table.cellForRow(at: indexPath) as! AddToListTableViewCell
            let chosenList = dao.getList(cell.listNameLabel.text!)
            if (self.restName != nil) {
                var myList = WhatToEatCompleteRestList.read();
                if myList == nil {
                    myList = WhatToEatCompleteRestList()
                    
                }
                chosenList?.add(myList!.getRest(self.restName!)!)
                chosenList?.save()
            } else {
                let alert2 = UIAlertController(title: "Error", message: "Something", preferredStyle: .alert)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
