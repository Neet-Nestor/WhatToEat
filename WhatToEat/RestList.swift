//
//  RestList.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation

class RestList {
    private var list:[Restaurant]
    
    init(json: [String:Any]) {
        self.list = []
        let data = json["businesses"] as! [Any]
        for rest in data {
            list.append(Restaurant(json: rest as! [String:Any]))
        }
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
}
