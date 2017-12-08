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
    var refresher: UIRefreshControl!
    let locationManager = CLLocationManager()
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dao = RestListDAO.getDAO()
        //restList = dao!.read()[0]
        restList = dao!.getList("baseOnLocation")
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(RestaurantTableViewController.update), for: UIControlEvents.valueChanged)
        tableview.addSubview(refresher)
    }
    
    @objc func update() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        } else {
            showLocationDisabledPopUp()
        }
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
        cell.tags.text = restList?.list[indexPath.row].getTags().joined(separator: ", ")
        cell.address.text = restList?.list[indexPath.row].getAddr().toString()
        
    //todo
        let dis = restList?.list[indexPath.row].getCoordinate()
                                                .getKmDistance(other:
                                                Coordinate(latitude: 37, longitude: -122))
        cell.distance.text = "\(dis ?? 0) km"
        cell.cost.text = "$"//restList?.list[indexPath.row].getDollarSign()
        return cell
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Location Access Disabled",
                                                message: "In order to get restaurants list we need your location",
                                                preferredStyle: .alert)
        
        //        let cancelAction = UIAlertAction(title: "Use without location", style: .cancel, handler: nil)
        let cancelAction = UIAlertAction(title: "Open without location", style: .cancel)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Common.saveToRestList(latitude : locValue.latitude, longitude : locValue.longitude)
        let dao = RestListDAO.getDAO()
        restList = dao!.getList("baseOnLocation")
        tableview.reloadData()
        refresher.endRefreshing()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        Common.saveToRestList(latitude : 37.785834, longitude : -122.406417)
        showLocationDisabledPopUp()
        tableview.reloadData()
        refresher.endRefreshing()
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
