//
//  history.swift
//  ObjectTest
//
//  Created by Andrew Liu on 12/9/17.
//  Copyright © 2017 Andrew Liu. All rights reserved.
//

import Foundation
import os.log

class History: NSObject, NSCoding {

    // MARK: Encoding and Decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(list, forKey: "list")
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let list = aDecoder.decodeObject(forKey: "list") as? [OneEat] else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(list: list)
    }
    
    // MARK: Fields
    public var totalList:WhatToEatCompleteRestList
//    public var list:[Restaurant]
    public var list:[OneEat]
    
    // MARK: Initializers
//    init(json: [String:Any], location : Coordinate? = nil) {
//        self.list = []
//        let data = json["businesses"] as! [Any]
//        for rest in data {
//            let rest = Restaurant(json: rest as! [String:Any])
//            list.append(rest)
//        }
//    }
    override init() {
        self.list = []
        var myList = WhatToEatCompleteRestList.read();
        if myList == nil {
            self.totalList = WhatToEatCompleteRestList()
            
        } else {
            self.totalList = myList!
        }
    }
    
    init(list: [OneEat]) {
        var myList = WhatToEatCompleteRestList.read();
        if myList == nil {
            self.totalList = WhatToEatCompleteRestList()
            
        } else {
            self.totalList = myList!
        }
        self.list = list

    }
    
    // MARK: Functions
    
    // Returns a boolean if the restaurant is in list
    public func contains(_ rest: Restaurant) -> Bool {
        return self.contains(rest.getId())
    }
    
    public func contains(_ rest: String) -> Bool {
        for item in self.list{
            if rest == item.name {
                return true
            }
        }
        return false
    }
    
    
    // Add an object into list
    public func add(_ rest: Restaurant) {
        self.list.append(OneEat(id: rest.getId(), name: rest.getName(), price: rest.getAvg$()))
//        if (!self.contains(rest)) {
////            self.list.append(rest.getId());
//            self.list[rest.getId()] = rest.getAvg$()
//        }
        totalList.add(rest)
        totalList.save()
        self.save()
    }
    
    // Get the index of an Restaurant object
//    public func getIndex(_ rest: Restaurant) -> Int {
//        let target = rest.getId()
//        if (self.contains(rest)) {
//            var result = 0
//            for item in list {
//                if item.getId() == target {
//                    return result
//                }
//                result = result + 1
//            }
//            return -1
//        } else {
//            return -1
//        }
//    }
    
    // Get the Restaurant with given name
    public func getRest(_ withid:String) -> Restaurant? {
        if self.contains(withid) {
            return totalList.getRest(withid)
        }
        return nil
    }
    
    // Change the price of a history restaurant
    // NOTE!!!!!!!!
    // NOTE!!!!!!!!
    // NOTE!!!!!!!!
    // The top of the UI list should be the last element in self.list
    // Index should start with 1, refers to the first element on the UI list
    public func changePrice(index: Int, price: Double) {
//        var item = getRest(name);
//        if item != nil {
//            item!.updateAverage(price)
//        }
        if index <= self.list.count {
            var thisEat = self.list[self.list.count - index]
            thisEat.price = price
            if totalList.contains(thisEat.name) {
                totalList.getRest(thisEat.name)?.updateAverage(price)
                totalList.save()
            }
        }
        self.save()
    }
    
    // Get the money totaly spent
    public func getTotalPrice() -> Double {
        var result: Double = 0
        for item in self.list {
            var myPrice = item.price
            if myPrice == nil {
                myPrice = getRest(item.name)?.getAvg$()
            }
            result = result + myPrice!
        }
        return result
    }
    
    // Remove the Restaurant object in list
    public func remove(_ index: Int) {
        if index <= self.list.count {
            self.list.remove(at: index)
        }
        self.save()
    }
    
    // Save this object
    public func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: History.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }

    // Read the RestList stored in the given directory
    public static func read() -> History?  {
        //        RestList.DocumentsDirectory.path
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? History
    }
    
    // Clear history
    public static func clear() {
            do {
                try FileManager.default.removeItem(at: NSURL(fileURLWithPath: History.ArchiveURL.path) as URL)

            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = RestList.DocumentsDirectory.appendingPathComponent("history");
    

}
