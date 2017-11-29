//
//  File.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation

class Coordinate {
    private var latitude:Double
    private var longitude:Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // getter
    public func getLatitude() -> Double {
        return self.latitude
    }
    
    public func getLongitude() -> Double {
        return self.longitude
    }
    
    // Functions
    
    // Get Distance in KM
    public func getKmDistance(other: Coordinate) -> Double{
        return getDistanceFromLatLonInKm(lat1: self.latitude, lon1: self.longitude, lat2: other.getLatitude(), lon2: other.getLongitude())
    }

    private func getDistanceFromLatLonInKm(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double{
        var R = 6371.0; // Radius of the earth in km
        var dLat = deg2rad(lat2-lat1);  // deg2rad below
        var dLon = deg2rad(lon2-lon1);
        var a =
        sin(dLat/2) * sin(dLat/2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) *
        sin(dLon/2) * sin(dLon/2)
        ;
        
        var c = 2 * atan2(sqrt(a), sqrt(1-a));
        var d = R * c; // Distance in km
        return d;
        
    }
    
    func deg2rad(_ deg: Double) -> Double {
        return deg * (M_PI/180)
    }
    
}
