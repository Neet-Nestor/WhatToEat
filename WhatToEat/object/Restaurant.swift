//
//  File.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/27/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation
import UIKit

class Restaurant: NSObject, NSCoding  {
    // MARK: Encoding and Decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(image_url, forKey: "image_url")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(yelp_rating, forKey: "yelp_rating")
        aCoder.encode(my_rating, forKey: "my_rating")
        aCoder.encode(tags, forKey: "tags")
        aCoder.encode(coordinate, forKey: "coordinate")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(avg_price, forKey: "avg_price")
        aCoder.encode(my_price, forKey: "my_price")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.image_url = aDecoder.decodeObject(forKey: "image_url") as! String
        self.url = aDecoder.decodeObject(forKey: "url") as! String
        self.yelp_rating = aDecoder.decodeObject(forKey: "yelp_rating") as? Double
        self.my_rating = aDecoder.decodeObject(forKey: "my_rating") as? Int
        self.tags = aDecoder.decodeObject(forKey: "tags") as! [String]
        self.coordinate = aDecoder.decodeObject(forKey: "coordinate") as! Coordinate
        self.address = aDecoder.decodeObject(forKey: "address") as! Address
        self.phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.avg_price = aDecoder.decodeObject(forKey: "avg_price") as? Double
        self.my_price = aDecoder.decodeObject(forKey: "my_price") as? [Double]
    }

    // MARK: Restaurant Fields
    private var id:String
    private var name:String
    private var image_url:String
    private var url:String
    private var yelp_rating:Double?
    private var my_rating:Int?
    private var tags:[String]
    private var coordinate: Coordinate
//    private var latitude:Double
//    private var longitude:Double
    private var address: Address
    private var phone:String
    private var avg_price:Double?
    private var my_price:[Double]?
    
    // MARK: Initializer
    
    // Json Initializer
    init(json: [String:Any]) {
        self.id = json["id"] as! String
        self.name = json["name"] as! String
        self.image_url = json["image_url"] as! String
        self.url = json["url"] as! String
        self.yelp_rating = json["rating"] as? Double
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
        self.avg_price = 0
        if let price = json["price"] as? String {
            if (price == "$") {
                self.avg_price = 10.0
            } else if (price == "$$") {
                self.avg_price = 20.0
            } else {
                self.avg_price = 50.0
            }
        }
    }
    
    // MARK: Getters
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
        if(self.yelp_rating == nil) {
            return 0.0
        } else {
            return self.yelp_rating!
        }
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
            return Int(self.getYelp_Rating())
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
            if self.avg_price == nil {
                0.0
            }
            return self.avg_price!
        } else {
            var result = 0.0;
            for price in my_price! {
                result = result + price
            }
            return result / Double(my_price!.count)
        }
    }
    
    // MARK: Setters
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
