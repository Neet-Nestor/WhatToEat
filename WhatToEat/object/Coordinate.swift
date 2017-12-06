//
//  File.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation

class Coordinate :NSObject, NSCoding {
    // MARK: encoding and decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? Double
    }
    
    // MARK: fields
    private var latitude:Double?
    private var longitude:Double?
    
    // MARK: initializer
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: getter
    public func getLatitude() -> Double? {
        return self.latitude
    }
    
    public func getLongitude() -> Double? {
        return self.longitude
    }
    
    // MARK: Functions
    
    // Get Distance in KM
    public func getKmDistance(other: Coordinate) -> Double{
        if (self.latitude == nil || self.longitude == nil || other.longitude == nil || other.latitude == nil) {
            return 0.0
        }
        return getDistanceFromLatLonInKm(lat1: self.latitude!, lon1: self.longitude!, lat2: other.getLatitude()!, lon2: other.getLongitude()!)
    }
    
    // helper function for getKMDistance
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
    
    // helper function for getKMDistance
    func deg2rad(_ deg: Double) -> Double {
        return deg * (M_PI/180)
    }
    
}
