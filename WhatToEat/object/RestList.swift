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
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let list = aDecoder.decodeObject(forKey: "list") as? [Restaurant] else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let data = aDecoder.decodeObject(forKey: "data") as? [String:Int] else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(name: name, list: list, data: data)
    }
    
    // MARK: Fields
    public var name:String
    public var list:[Restaurant]
    private var data:[String: Int]
    private var kill:String?
    
    // MARK: Initializers
    init(json: [String:Any], name: String) {
        self.name = name;
        self.list = []
        self.data = [:]
        let data = json["businesses"] as! [Any]
        for rest in data {
            var rest = Restaurant(json: rest as! [String:Any])
            list.append(rest)
            self.data[rest.getId()] = rest.getRating() * 4
        }
    }
    
    init(name: String, list: [Restaurant], data: [String:Int]) {
        self.name = name
        self.list = list
        self.data = data
    }
    
    // MARK: Functions
    
    // Returns a boolean if the restaurant is in list
    public func contains(_ rest: Restaurant) -> Bool {
        let target = rest.getId()
        for item in self.list {
            if target == item.getId() {
                return true
            }
        }
        return false
    }
    
    // Add an object into list
    public func add(_ rest: Restaurant) {
        if (!self.contains(rest)) {
            self.list.append(rest);
        }
    }
    
    // Get the index of an Restaurant object
    public func getIndex(_ rest: Restaurant) -> Int {
        let target = rest.getId()
        if (self.contains(rest)) {
            var result = 0
            for item in list {
                if item.getId() == target {
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
        for item in self.list {
            if item.getId() == withid {
                return item
            }
        }
        return nil
    }
    
    // Remove the Restaurant object in list
    public func remove(_ rest: Restaurant) {
        if (self.contains(rest)) {
            self.list.remove(at: self.getIndex(rest))
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
        for item in data.keys {
            total = total + data[item]!
        }
        var rand:Int = Int(arc4random_uniform(UInt32(total)))
        var cur:Int = 0
        for item in data.keys {
            cur = cur + data[item]!
            if (cur > rand) {
                return item
            }
        }
        
        return nil
    }
    
    // Read the RestList stored in the given directory
    public static func read(url: String) -> RestList?  {
//        RestList.DocumentsDirectory.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: url) as? RestList
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    

}
