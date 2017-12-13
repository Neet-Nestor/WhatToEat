//
//  HistoryViewController.swift
//  WhatToEat
//
//  Created by Student User on 12/7/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var table: UITableView!
    public var historyList:History?
    public var totalList:WhatToEatCompleteRestList?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.historyList != nil) {
            return (historyList?.list.count)!
        } else {
            return 0
        }

    }
    
    @IBAction func clearButtonPress(_ sender: Any) {
        self.historyList?.clear()
        self.total.text = "\(self.historyList!.getTotalPrice())"
        self.table.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        let hist = self.historyList!.list[self.historyList!.list.count - 1 - indexPath.row]
        let rest = totalList?.getRest(hist.id)
        if rest != nil {
            cell.myImage.image = rest!.getImage()
            cell.myLabel.text = rest!.getName()
            if hist.price == nil {
                hist.price = rest!.getAvg$()
            }
            cell.myPrice.text = "$\(hist.price!)"
        } else {
            cell.myImage.image = nil
            cell.myLabel.text = nil
            cell.myPrice.text = "$0.00"
        }
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyList = History.read()
        self.totalList = WhatToEatCompleteRestList.read()
        self.table.dataSource = self
        self.table.delegate = self
        self.total.text = "Total Cost: $\((self.historyList?.getTotalPrice())!)"
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
