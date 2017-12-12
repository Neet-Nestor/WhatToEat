//
//  OneEat.swift
//  ObjectTest
//
//  Created by Andrew Liu on 12/10/17.
//  Copyright © 2017 Andrew Liu. All rights reserved.
//

import Foundation
import os.log

class OneEat: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(id, forKey: "id")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let price = aDecoder.decodeObject(forKey: "price") as? Double
        let id = aDecoder.decodeObject(forKey: "id") as! String
        self.init(id: id, name: name, price: price)
    }
    
    public var totalList:WhatToEatCompleteRestList
    public var id:String
    public var name:String
    public var price:Double?
    
    init(id: String, name: String, price: Double?) {
        self.id = id
        var myList = WhatToEatCompleteRestList.read();
        if myList == nil {
            self.totalList = WhatToEatCompleteRestList()
            
        } else {
            self.totalList = myList!
        }
        self.name = name
        self.price = price
    }
    
}

