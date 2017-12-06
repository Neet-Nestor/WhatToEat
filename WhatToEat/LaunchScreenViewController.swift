//
//  LaunchScreenViewController.swift
//  WhatToEat
//
//  Created by zichu zheng on 12/3/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import CoreLocation

class LaunchScreenViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let locationManager = CLLocationManager()
    
//    @IBAction func btnPress(_ sender: Any) {
//        showMain()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        } else {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to get restaurants list we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Use without location", style: .cancel, handler: nil)
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
        saveToRestList(latitude : locValue.latitude, longitude : locValue.longitude)
        showMain()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        saveToRestList(latitude : 37.785834, longitude : -122.406417)
        showLocationDisabledPopUp()
    }
    
    private func saveToRestList(latitude : Double, longitude : Double) {
        let url = "https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=\(latitude)&longitude=\(longitude)"
        let tokenString = "Bearer XC28UCfVfPvioZMT3WdKcZSuf9KgrHeJtWcEyog3xNOkgGJCSFY_Lax7GC6KGwOA2qbFaOS-h9KlYWNP8ihIkrInjz-TcDKGHzrKGLXC89JZkmSkxbolzD6wqcIUWnYx"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(tokenString, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let tache = session.dataTask(with: request) { (data, response, error) -> Void in
//            if (error != nil) {
//                return
//            }
            let responseParse = response as! HTTPURLResponse
            if (responseParse.statusCode == 200) {
                // save data to object
                let dict = try! JSONSerialization.jsonObject(with: data!, options: [])
                let restList = RestList(json: dict as! [String : Any], name: "baseOnLocation")
                let dao = RestListDAO()
                dao.savelist(restList)
                dao.save()
            } else {
                //send alert when status code is not 200
                let alert = UIAlertController(title: "Alert", message: "statusCode: \(responseParse.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        tache.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMain() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
        self.show(vc as! UITabBarController, sender: vc)
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
