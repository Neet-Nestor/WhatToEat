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
    var location: Coordinate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dao = RestListDAO.getDAO()
        //restList = dao!.read()[0]
        restList = dao!.getList("Nearby")
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(RestaurantTableViewController.update), for: UIControlEvents.valueChanged)
        tableview.addSubview(refresher)
    }
    
    @objc func update(){
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
        return (restList != nil) ? restList!.count() : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantListCell
        cell.nameLabel.text = restList?.getRest(indexPath.row).getName()
        cell.miniImage.image = (restList?.getRest(indexPath.row).getImage())!
        //cell.stars[0].image = UIImage(named: "filledStar_2x")
        if let star = restList?.getRest(indexPath.row).getRating() {
            for index in 0...(star - 1) {
                cell.stars[index].image = UIImage(named: "filledStar_2x")
            }
        }
        cell.tags.text = restList?.getRest(indexPath.row).getTags().joined(separator: ", ")
        cell.address.text = restList?.getRest(indexPath.row).getAddr().toString()
        
        let restLocation = restList?.getRest(indexPath.row).getCoordinate()
        
        
        var dis = 0.0
        if (location != nil) {
            dis = (restList?.getRest(indexPath.row).getCoordinate()
                .getKmDistance(other: location!))!
        }
        cell.distance.text = "\(dis ?? 0) km"
        cell.cost.text = restList?.getRest(indexPath.row).getDollarSign()
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        location = Coordinate(latitude: locValue.latitude, longitude: locValue.longitude)
        Common.saveToRestList(latitude : locValue.latitude, longitude : locValue.longitude)
        let dao = RestListDAO.getDAO()
        restList = dao!.getList("Nearby")
        tableview.reloadData()
        refresher.endRefreshing()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        Common.saveToRestList(latitude : Common.defaultLocation.getLatitude()!,
                              longitude : Common.defaultLocation.getLongitude()!)
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
