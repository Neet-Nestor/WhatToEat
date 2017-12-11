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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (lists != nil) {
            return lists!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! RestaurantListCell
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
                chosenList?.add(WhatToEatCompleteRestList.read()!.getRest(self.restName!)!)
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
