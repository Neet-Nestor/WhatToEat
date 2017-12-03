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
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var restList : RestList? = nil
    var refresher: UIRefreshControl!
    let locationManager = CLLocationManager()

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(RestaurantTableViewController.update), for: UIControlEvents.valueChanged)
        tableview.addSubview(refresher)
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            showLocationDisabledPopUp()
        }
    }
    
    // using current locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
        update()
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to get restaurants list we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func update() {
        let url = "https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=\(latitude)&longitude=\(longitude)"
        let tokenString = "Bearer XC28UCfVfPvioZMT3WdKcZSuf9KgrHeJtWcEyog3xNOkgGJCSFY_Lax7GC6KGwOA2qbFaOS-h9KlYWNP8ihIkrInjz-TcDKGHzrKGLXC89JZkmSkxbolzD6wqcIUWnYx"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(tokenString, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let tache = session.dataTask(with: request) { (data, response, error) -> Void in
            let responseParse = response as! HTTPURLResponse
            if (responseParse.statusCode == 200) {
                // save data to object
                let dict = try! JSONSerialization.jsonObject(with: data!, options: [])
                self.restList = RestList(json: dict as! [String : Any], name: "1")
            } else {
                //send alert when status code is not 200
                let alert = UIAlertController(title: "Alert", message: "statusCode: \(responseParse.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        tache.resume()
        tableview.reloadData()
        refresher.endRefreshing()
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
