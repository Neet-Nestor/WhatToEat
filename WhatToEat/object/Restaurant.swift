//
//  File.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/27/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation
import UIKit

class Restaurant {
    /* To Do:
    address object
 */
    // Restaurant Fields
    private var id:String
    private var name:String
    private var image_url:String
    private var url:String
    private var yelp_rating:Double
    private var my_rating:Int?
    private var tags:[String]
    private var coordinate: Coordinate
//    private var latitude:Double
//    private var longitude:Double
    private var address: Address
    private var phone:String
    private var avg_price:Double
    private var my_price:[Double]?
    
    // Json Initializer
    init(json: [String:Any]) {
        self.id = json["id"] as! String
        self.name = json["name"] as! String
        self.image_url = json["image_url"] as! String
        self.url = json["url"] as! String
        self.yelp_rating = json["rating"] as! Double
        self.tags = []
        for dict in json["categories"] as! [[String:String]] {
            self.tags.append(dict["title"]!)
        }
        let coordinates = json["coordinates"] as! [String:Double]
        self.coordinate = Coordinate(latitude: coordinates["latitude"]!, longitude: coordinates["longitude"]!)
//        self.latitude = coordinates["latitude"]!
//        self.longitude = coordinates["longitude"]!
        self.address = Address((json["location"] as! [String:Any])["display_address"] as! [String])
        self.phone = json["display_phone"] as! String
        let price = json["price"] as! String
        if (price == "$") {
            self.avg_price = 10.0
        } else if (price == "$$") {
            self.avg_price = 20.0
        } else {
            self.avg_price = 50.0
        }
    }
    
    // Getters
    public func getId() -> String {
        return self.id
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getImage() -> UIImage? {
        let url = URL(string: self.image_url)
        var image:UIImage? = nil
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        if (data != nil) {
            image = UIImage(data: data!)
        }
        return image
    }
    
    public func getURL() -> String {
        return self.url
    }
    
    public func getYelp_Rating() -> Double {
        return self.yelp_rating
    }
    
    public func getMy_Rating() -> Int {
        if self.my_rating != nil {
            return self.my_rating!
        } else {
            return 0
        }
    }
    
    public func getRating() -> Int {
        if self.my_rating != nil {
            return self.my_rating!
        } else {
            return Int(self.yelp_rating)
        }
    }
    
    public func getTags() -> [String] {
        return self.tags
    }
    
    public func getCoordinate() -> Coordinate {
        return self.coordinate
    }
    
    public func getAddr() -> Address {
        return self.address
    }
    
    public func getPhone() -> String {
        return self.phone
    }
    
    public func getAvg$() -> Double {
        if my_price == nil {
            return self.avg_price
        } else {
            var result = 0.0;
            for price in my_price! {
                result = result + price
            }
            return result / Double(my_price!.count)
        }
    }
    
    // Setters
    public func addTag(_ aTag: String) {
        self.tags.append(aTag)
    }
    
    public func removeTag(_ aTag: String) {
        if self.tags.contains(aTag) {
            self.tags.remove(at: self.tags.index(of: aTag)!)
        }
    }
    
    public func rate(_ rating: Int) {
        self.my_rating = rating
    }
    
    public func updateAverage(_ price: Double) {
        if my_price == nil {
            my_price = [price]
        } else {
            my_price!.append(price)
        }
    }
}
