//
//  Address.swift
//  WhatToEat
//
//  Created by Andrew Liu on 11/28/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation

class Address {
    private var first:String
    private var second:String?
    
    init(_ address: [String]) {
        self.first = address[0]
        self.second = address[1]
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
