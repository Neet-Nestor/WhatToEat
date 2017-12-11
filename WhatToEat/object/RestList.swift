//
//  RestList.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation
import os.log

class RestList: NSObject, NSCoding {

    // MARK: Encoding and Decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(list, forKey: "list")
        aCoder.encode(data, forKey: "data")
        aCoder.encode(location, forKey: "location")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let list = aDecoder.decodeObject(forKey: "list") as? [String] else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let data = aDecoder.decodeObject(forKey: "data") as? [String:Int] else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let location = aDecoder.decodeObject(forKey: "location") as? Coordinate else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(name: name, list: list, data: data, location: location)
    }
    
    // MARK: Fields
    public var totalList:WhatToEatCompleteRestList
    public var name:String
    public var list:[String]
    private var data:[String: Int]
//    private var kill:String?
    private var location : Coordinate?
    
    // MARK: Initializers
    init(json: [String:Any], name: String, location : Coordinate? = nil) {
        var myList = WhatToEatCompleteRestList.read();
        if myList == nil {
            self.totalList = WhatToEatCompleteRestList()
            
        } else {
            self.totalList = myList!
        }
        self.name = name;
        self.list = []
        self.data = [:]
        let data = json["businesses"] as! [Any]
        for rest in data {
            let rest = Restaurant(json: rest as! [String:Any])
            self.list.append(rest.getId())
            totalList.add(rest)
            
            if location != nil {
                let dis = location!.getKmDistance(other: rest.getCoordinate())
                self.data[rest.getId()] = rest.getRating() * 4 - Int(dis * 8)
            } else {
                self.data[rest.getId()] = rest.getRating() * 4
            }
        }
        if (location != nil) {
            self.location = location!
        }
        totalList.save()
    }
    
    init(name: String, list: [String], data: [String:Int], location: Coordinate) {
        var myList = WhatToEatCompleteRestList.read();
        if myList == nil {
            self.totalList = WhatToEatCompleteRestList()
            
        } else {
            self.totalList = myList!
        }
        self.name = name
        self.list = list
        self.data = data
        self.location = location
    }
    
    // MARK: Functions
    
    // Returns a boolean if the restaurant is in list
    public func contains(_ rest: Restaurant) -> Bool {
        return self.contains(rest.getId())
    }
    
    public func contains(_ rest: String) -> Bool {
        for item in self.list {
            if rest == item {
                return true
            }
        }
        return false
    }
    
    public func getLocation() -> Coordinate {
        if let location = self.location {
            return location
        }
        return Common.defaultLocation
    }
    
    // Add an object into list
    public func add(_ rest: Restaurant) {
        if (!self.contains(rest)) {
            self.list.append(rest.getId())
            self.data[rest.getId()] = rest.getRating() * 4
            self.totalList.add(rest)
            totalList.save()
        }
    }
    
    // Get the index of an Restaurant object
    public func getIndex(_ rest: Restaurant) -> Int {
        let target = rest.getId()
        if (self.contains(rest)) {
            var result = 0
            for item in self.list {
                if item == target {
                    return result
                }
                result = result + 1
            }
            return -1
        } else {
            return -1
        }
    }
    
    // Get the Restaurant with given name
    public func getRest(_ withid:String) -> Restaurant? {
        if self.contains(withid) {
            return totalList.getRest(withid)
        }
        return nil
    }
    
    public func getRest(_ index: Int) -> Restaurant {
        return getRest(self.list[index])!
    }
    
    // Remove the Restaurant object in list
    public func remove(_ rest: Restaurant) {
        if (self.contains(rest)) {
            self.data.removeValue(forKey: rest.getId())
            self.list.remove(at: self.getIndex(rest))
//            self.list.remove(at: self.getIndex(rest))
        }
    }
    
    // Remove the Restaurant object with the given name in list
    public func remove(_ restName: String) {
        if (self.contains(restName)) {
            self.data.removeValue(forKey: restName)
            var result = 0
            for item in self.list {
                if item == restName {
                    break
                }
                result = result + 1
            }
            self.list.remove(at: result)
        }
    }
    
    // Save this object
    public func save() -> String {
        let ArchiveURL = RestList.DocumentsDirectory.appendingPathComponent(self.name).path;
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: ArchiveURL)
        if isSuccessfulSave {
            os_log("successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
        return ArchiveURL;
    }
    
    // Get a random restaurant object
    public func random() -> Restaurant? {
        var result = randomHelp()
        return getRest(result!)
    }
    
    private func randomHelp() -> String? {
        var total:Int = 0
        for item in self.list {
            total = total + data[item]!
        }
        var rand:Int = Int(arc4random_uniform(UInt32(total)))
        var cur:Int = 0
        for item in self.list {
            cur = cur + data[item]!
            if (cur > rand) {
                return item
            }
        }
        
        return nil
    }
    
    public func count() -> Int {
        return self.list.count
    }
    
    // Read the RestList stored in the given directory
    public static func read(url: String) -> RestList?  {
//        RestList.DocumentsDirectory.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: url) as? RestList
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    

}
