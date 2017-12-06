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
    
    @IBAction func btnPress(_ sender: Any) {
        showMain()
    }
    
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        showMain()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        //locations = 37.785834 -122.406417
        showMain()
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
