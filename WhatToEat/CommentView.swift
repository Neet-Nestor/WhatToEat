//
//  CommentView.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//


import UIKit

class CommentView: UIView {
    var nameLabel = UILabel()
    var commentLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
       // self.nameLabel.frame = CGRect(origin: CGPoint(x: 0,y: 2), size: CGSize(width:100, height:20))
        //self.nameLabel.textAlignment = .left
        //self.nameLabel.font = UIFont.systemFont(ofSize: 15)
        self.commentLabel.frame = CGRect(origin: CGPoint(x:0,y:2), size: CGSize(width:300,height:20))
        self.commentLabel.font = UIFont.systemFont(ofSize: 15)
        self.nameLabel.textColor = UIColor.blue
        self.commentLabel.textAlignment = .left
        //self.addSubview(nameLabel)
        self.addSubview(commentLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

