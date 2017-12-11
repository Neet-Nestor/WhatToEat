
//
//  WhatToEatCompleteRestList.swift
//  ObjectTest
//
//  Created by Andrew Liu on 12/10/17.
//  Copyright © 2017 Andrew Liu. All rights reserved.
//

import Foundation
import os.log

class WhatToEatCompleteRestList: NSObject, NSCoding {
    // MARK: Encoding and Decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(list, forKey: "list")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let list = aDecoder.decodeObject(forKey: "list") as? [Restaurant] else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(list: list)
    }
    
    // MARK: Fields
    public var list:[Restaurant]
    
    // MARK: Initializers
    init(list: [Restaurant]) {

        self.list = list

    }
    
    override init() {
        self.list = [];
    }
    
    // MARK: Functions
    
    // Returns a boolean if the restaurant is in list
//    public func contains(_ rest: Restaurant) -> Bool {
//        let target = rest.getId()
//        for item in self.list {
//            if target == item.getId() {
//                return true
//            }
//        }
//        return false
//    }
    
    public func contains(_ rest: Restaurant) -> Bool {
        return self.contains(rest.getId())
    }
    
    public func contains(_ rest: String) -> Bool {
        for item in self.list {
            if rest == item.getId() {
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
        self.save()
    }
    
    public func add(_ rest: [Restaurant]) {
        for item in rest {
            add(item);
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
        self.save()
    }
    
    public func clear() {
        self.list = []
        self.save()
    }
    
    // Save this object
    public func save() {

        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: WhatToEatCompleteRestList.ArchiveURL)
        if isSuccessfulSave {
            os_log("successfully saved what to eat list.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }
    
    // Read the RestList stored in the given directory
    public static func read() -> WhatToEatCompleteRestList?  {
        //        RestList.DocumentsDirectory.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: WhatToEatCompleteRestList.ArchiveURL) as? WhatToEatCompleteRestList
    }
    
    // MARK: Archiving Paths
    static let ArchiveURL = RestList.DocumentsDirectory.appendingPathComponent("WhatToEatCompleteRestList").path;
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
}
