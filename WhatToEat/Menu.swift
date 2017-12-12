//
//  Menu.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import Foundation
import UIKit

class Menu:UIView{
    let likeBtn = UIButton()
    let commentBtn = UIButton()
    var line = UIView()
    var momentTag: Int = -1
    var show = false
    var isShowing = false
    var flag1 = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.momentTag = -1
        self.show = false
        self.isShowing = false
        self.backgroundColor = UIColor(red: 60/255, green: 64/255, blue: 66/255, alpha: 1)
        self.setNeedsLayout()
//        self.likeBtn.frame = CGRect(origin: CGPoint(x:0,y:0), size:CGSize(width:160,height:35))
//        self.likeBtn.addTarget(self, action: #selector(Menu.likeBtn), for: .TouchUpInside)
        self.commentBtn.frame = CGRect(origin: CGPoint(x:0,y:0), size:CGSize(width:80,height:35))
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.line = UIView(frame: CGRect(origin: CGPoint(x:80,y:5), size:CGSize(width:1,height:25)))
        self.line.backgroundColor = UIColor(red: 50/255, green: 53/255, blue: 56/255, alpha: 1)
        self.addSubview(self.commentBtn)
//        self.addSubview(self.likeBtn)
//        self.addSubview(self.line)
    }
    
    func clickMenu(){
        if(self.show){
            //按钮隐藏
            menuHide()
        }
        else{
            menuShow()
        }
    }
    
    
    
    func menuShow(){
        self.show = true
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.layoutSubviews, animations: {
            self.frame = CGRect(origin: CGPoint(x:self.frame.origin.x - 80,y:self.frame.origin.y), size:CGSize(width:80,height:34))
        }) { (Bool) in
            
        }
    }
    
    func menuHide(){
        self.show = false
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.layoutSubviews, animations: {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x + 80, y: self.frame.origin.y), size: CGSize(width:0.0, height:34))
        }) { (Bool) in
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

