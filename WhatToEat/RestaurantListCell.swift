//
//  RestaurantListCell.swift
//  WhatToEat
//
//  Created by Student User on 11/23/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class RestaurantListCell: UITableViewCell {

    @IBOutlet weak var miniImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
