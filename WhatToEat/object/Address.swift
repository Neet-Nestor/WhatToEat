//
//  Address.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation

class Address: NSObject, NSCoding {
    // MARK: Encoding and Decoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(first, forKey: "first")
        aCoder.encode(second, forKey: "second")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.first = aDecoder.decodeObject(forKey: "first") as! String
        self.second = aDecoder.decodeObject(forKey: "second") as? String
    }
    
    // MARK: Fields
    private var first:String
    private var second:String?
    
    // MARK: Initializer
    init(_ address: [String]) {
        self.first = address[0]
//        self.second = address[1]
    }
    
    // getter
    public func getFirst() -> String{
        return self.first
    }
    
    public func getSecond() -> String? {
        return self.second
    }
    
    // functions
    
    // To string
    public func toString() -> String {
        if second == nil {
            return first
        } else {
            return first + second!
        }
    }
}
