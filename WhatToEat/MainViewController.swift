//
//  MainViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/27/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var matchBtn: UIButton!
    @IBOutlet weak var listPicker: UIPickerView!
    var lists = ["Nearby"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        matchBtn.layer.borderWidth = 2
        matchBtn.layer.borderColor = UIColor.black.cgColor
        matchBtn.layer.cornerRadius = matchBtn.frame.width / 2.0
        matchBtn.clipsToBounds = true
        listPicker.delegate = self
        listPicker.dataSource = self
        let dao = RestListDAO.getDAO()
        if dao != nil {
            self.lists = []
            for restList in dao!.read() {
                lists.append(restList.name)
//                if restList.name == "baseOnLocation" && self.lists.contains("Match Nearby"){
//                    self.lists.remove(at: self.lists.index(of: "Match Nearby")!)
//                }
            }
            if self.lists == [] {
                self.lists.append("Nearby")
            }
            print(lists)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dao = RestListDAO.getDAO()
        if dao != nil {
            self.lists = []
            for restList in dao!.read() {
                lists.append(restList.name)
                //                if restList.name == "baseOnLocation" && self.lists.contains("Match Nearby"){
                //                    self.lists.remove(at: self.lists.index(of: "Match Nearby")!)
                //                }
            }
            if self.lists == [] {
                self.lists.append("Nearby")
            }
            print(lists)
        }
        self.listPicker.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lists[row]
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is PreviewListViewController) {
            let previewVC = segue.destination as! PreviewListViewController
            let dao = RestListDAO.getDAO()

            let test = listPicker.selectedRow(inComponent: 0)
            previewVC.restList = dao!.getList("Nearby")!

            var name = self.lists[listPicker.selectedRow(inComponent: 0)]
            previewVC.restList = dao!.getList(name)!
        }
    }
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
