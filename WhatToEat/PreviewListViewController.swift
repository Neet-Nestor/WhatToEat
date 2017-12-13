//
//  PreviewListViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/27/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import CoreLocation

class PreviewListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var theNavigationItem: UINavigationItem!
    var restList: RestList?
    @IBOutlet weak var tableView: UITableView!
    var locationManager = CLLocationManager()
    var coordinate: Coordinate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        update()
        if (restList != nil) {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (coordinate == nil) {
            coordinate = Common.myLocation
        }
    }
    
    func update(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        } else {
            showLocationDisabledPopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.coordinate = Coordinate(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        showLocationDisabledPopUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (restList != nil) {
            return 1
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (restList != nil) {
            return self.restList!.count()
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewTableCell", for: indexPath) as! RestaurantListCell
        // Configure the cell...

        let rest = restList?.getRest(indexPath.row)
        cell.nameLabel.text = rest?.getName()
        cell.miniImage.image = (rest?.getImage())!
        //cell.stars[0].image = UIImage(named: "filledStar_2x")
        if let star = rest?.getRating() {
            for index in 0...(star - 1) {
                cell.stars[index].image = UIImage(named: "filledStar_2x")
            }
        }
        cell.tags.text = rest?.getTags().joined(separator: ", ")
        cell.address.text = rest?.getAddr().toString()
        
        var dis = 0.0
        if (coordinate != nil) {
            dis = (rest?.getCoordinate()
                .getKmDistance(other: coordinate!))!
        }
        
        cell.distance.text = "\(dis ?? 0) km"
        cell.cost.text = rest?.getDollarSign()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is FoundViewController) {
            let foundVC = segue.destination as! FoundViewController
            let randRest = restList?.random()
            foundVC.resultRest = randRest
            if (coordinate == nil) {
                coordinate = Common.myLocation
            }
            foundVC.distance = randRest?.getCoordinate()
                .getKmDistance(other: coordinate!)
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
