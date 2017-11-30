//
//  CommentLikeView.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class CommentLikeView: UIView {
    
    let likeViewBackImage = UIImageView()
    var likeImage = UIImageView()
    var likeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        self.likeImage.image = UIImage(named: "likewhite")
        self.likeViewBackImage.image = UIImage(named:"comment")
        
        self.likeImage.frame = CGRect(origin: CGPoint(x:2,y:2), size:CGSize(width:20,height:20))
        self.likeViewBackImage.frame = CGRect(origin: CGPoint(x:0,y:-6), size:CGSize(width:60,height:20))
        self.likeLabel.frame = CGRect(origin: CGPoint(x:25,y:2), size:CGSize(width:UIScreen.main.bounds.width - 10 - 55 - 15 - 27,height:20))
        self.likeLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(likeViewBackImage)
        self.addSubview(likeImage)
        self.addSubview(likeLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
}

