//
//  HistoryViewController.swift
//  WhatToEat
//
//  Created by Student User on 12/7/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.historyList != nil) {
            return (historyList?.list.count)!
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        let hist = self.historyList!.list[self.historyList!.list.count - 1 - indexPath.row]
        let rest = totalList?.getRest(hist.name)
        if rest != nil {
            cell.myImage.image = rest!.getImage()
            cell.myLabel.text = rest!.getName()
            if hist.price == nil {
                hist.price = totalList?.getRest(hist.name)?.getAvg$()
            }
            cell.myPrice.text = "$\(hist.price!)"
        } else {
            cell.myImage.image = nil
            cell.myLabel.text = nil
            cell.myPrice.text = "$0.00)"
        }
        return cell
    }
    
    
    public var historyList:History?
    public var totalList:WhatToEatCompleteRestList?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyList = History.read()
        self.totalList = WhatToEatCompleteRestList.read()
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
