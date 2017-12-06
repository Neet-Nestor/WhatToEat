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
    
    public var name:String
    public var list:[Restaurant]
    private var data:[String: Int]
    
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
    
    // functions
    public func contains(_ rest: Restaurant) -> Bool {
        let target = rest.getId()
        for item in self.list {
            if target == item.getId() {
                return true
            }
        }
        return false
    }
    
    public func add(_ rest: Restaurant) {
        if (!self.contains(rest)) {
            self.list.append(rest);
        }
    }
    
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
    
    public func remove(_ rest: Restaurant) {
        if (self.contains(rest)) {
            self.list.remove(at: self.getIndex(rest))
        }
    }
    
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
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(list, forKey: "list")
        aCoder.encode(data, forKey: "data")
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    public static func read(url: String) -> RestList?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: url) as? RestList
    }
}
