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
    func encode(with aCoder: NSCoder) {
        aCoder.encode(list, forKey: "objList")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.list = aDecoder.decodeObject(forKey: "objList") as! [String:String]
    }
    
    public var list:[String: String]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("objList")
    
    public func read() -> [RestList?]  {
        var result:[RestList?] = []
        for item in self.list.keys {
            result.append(RestList.read(url: list[item]!))
        }
        return result;
    }
    
    override init() {
        self.list = [:]
    }
    
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
    
    public func savelist(_ restlist:RestList) {
        list[restlist.name] = restlist.save()
    }
    
    public func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: RestListDAO.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save...", log: OSLog.default, type: .error)
        }
    }
    
    public static func getDAO() -> RestListDAO? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: RestListDAO.ArchiveURL.path) as? RestListDAO
    }
    
}
