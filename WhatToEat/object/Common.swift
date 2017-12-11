//
//  Common.swift
//  WhatToEat
//
//  Created by zichu zheng on 12/4/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation
import CoreLocation

class Common {

//    public enum listName {
//        case baseOnLocation
//        case custom
//    }
    
    public static var defaultLocation : Coordinate {
        get {
            return Coordinate(latitude: 37.785834, longitude: -122.406417)
        }
    }
    
    public static func haha() -> Int {
        return 0
    }
    
    public static func saveToRestList(latitude : Double, longitude : Double) {
        let url = "https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=\(latitude)&longitude=\(longitude)"
        let tokenString = "Bearer XC28UCfVfPvioZMT3WdKcZSuf9KgrHeJtWcEyog3xNOkgGJCSFY_Lax7GC6KGwOA2qbFaOS-h9KlYWNP8ihIkrInjz-TcDKGHzrKGLXC89JZkmSkxbolzD6wqcIUWnYx"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(tokenString, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let tache = session.dataTask(with: request) { (data, response, error) -> Void in
//            if (error != nil) {
//                return
//            }
            if (response != nil) {
                let responseParse = response as! HTTPURLResponse
                if (responseParse.statusCode == 200) {
                    // save data to object
                    let dict = try! JSONSerialization.jsonObject(with: data!, options: [])
                    let restList = RestList(json: dict as! [String : Any], name: "baseOnLocation",
                                            location: Coordinate(latitude : latitude, longitude : longitude))
                    let dao = RestListDAO()
                    dao.savelist(restList)
                    dao.save()
                }
//            } else {
//                //send alert when status code is not 200
//                let alert = UIAlertController(title: "Alert", message: "statusCode: \(responseParse.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                vc.present(alert, animated: true, completion: nil)
//            }
            }
        }
        tache.resume()
    }

}

