//
//  RestGenerator.swift
//  WhatToEat
//
//  Created by Andrew Liu on 12/2/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation
import os.log

class RestListDAO: NSObject, NSCoding {
    // MARK: encoding and decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(list, forKey: "objList")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.list = aDecoder.decodeObject(forKey: "objList") as! [String:String]
    }
    
    // MARK: Fields: a list containing the name of the list and the directory it is located.
    public var list:[String: String]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("objList")
    
    // MARK: Initializer : empty object
    override init() {
        self.list = [:]
    }
    
    // MARK: Functions
 
    // Read out all the list that is stored in the local directory.
    public func read() -> [RestList?]  {
        var result:[RestList?] = []
        for item in self.list.keys {
            result.append(RestList.read(url: list[item]!))
        }
        return result;
    }

    // Get a specific list with certain name.
    public func getList(_ name: String) -> RestList? {
        if (self.list.keys.contains(name)) {
            return RestList.read(url: list[name]!)
        }
        return nil
    }
    
    // Remove a list with certian name
    public func remove(_ name: String) {
        if list.keys.contains(name) {
            do {
                try FileManager.default.removeItem(at: NSURL(string:list[name]!) as! URL)
                list.removeValue(forKey: name)
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        }
        
    }
    
    // Save a RestList object.
    public func savelist(_ restlist:RestList) {
        list[restlist.name] = restlist.save()
    }
    
    // Save this object
    public func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: RestListDAO.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }
    
    // Return a DAO object with list of names mapped to its directory in local storage
    public static func getDAO() -> RestListDAO? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: RestListDAO.ArchiveURL.path) as? RestListDAO
    }
    
}
