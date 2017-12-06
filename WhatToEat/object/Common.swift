//
//  Common.swift
//  WhatToEat
//
//  Created by zichu zheng on 12/4/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation
import CoreLocation

class Common: NSObject, CLLocationManagerDelegate {

    public func getLocation() -> (Double?, Double?) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        let currentLocation = locManager.location
        print(currentLocation)
        return (currentLocation?.coordinate.latitude, currentLocation?.coordinate.longitude)
    }

}

