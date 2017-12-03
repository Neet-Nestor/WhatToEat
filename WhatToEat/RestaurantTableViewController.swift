//
//  RestaurantTableViewController.swift
//  WhatToEat
//
//  Created by zichu zheng on 12/3/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        let latitude = 47.656893
        let longitude = -122.313282
        
        let url = "https://api.yelp.com/v3/businesses/search?term=restuarant&latitude=\(latitude)&longitude=\(longitude)"
        let tokenString = "Bearer XC28UCfVfPvioZMT3WdKcZSuf9KgrHeJtWcEyog3xNOkgGJCSFY_Lax7GC6KGwOA2qbFaOS-h9KlYWNP8ihIkrInjz-TcDKGHzrKGLXC89JZkmSkxbolzD6wqcIUWnYx"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(tokenString, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let tache = session.dataTask(with: request) { (data, response, error) -> Void in
            let responseParse = response as! HTTPURLResponse
            if (responseParse.statusCode == 200) {
                //
                let dict = try! JSONSerialization.jsonObject(with: data!, options: [])

                
                
            } else {
                let alert = UIAlertController(title: "Alert", message: "statusCode: \(responseParse.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        tache.resume()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantListCell
        //        cell.myImage.image = UIImage(named: ("\(indexPath.row % 3 + 1).jpg"))
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
