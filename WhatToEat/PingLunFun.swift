//
//  PingLunFun.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit


import UIKit

class PingLunFun: UIView {
    
    let commentTextField = UITextField()
    let sendBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1).cgColor
        
        self.commentTextField.frame = CGRect(origin: CGPoint(x: 5, y: 2), size: CGSize(width: UIScreen.main.bounds.width - 80, height: 26))
        self.commentTextField.placeholder = "Comment"
        self.commentTextField.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        self.commentTextField.setValue(UIColor(red: 160/255, green: 160/255, blue: 154/255, alpha: 1), forKeyPath: "_placeholderLabel.textColor")
        self.commentTextField.setValue(UIFont.systemFont(ofSize: 13), forKeyPath: "_placeholderLabel.font")
        self.commentTextField.layer.cornerRadius = 5
        self.commentTextField.layer.masksToBounds = true
        self.commentTextField.layer.borderWidth = 1
        self.commentTextField.layer.borderColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1).cgColor
        self.commentTextField.contentVerticalAlignment = .bottom
        self.sendBtn.frame = CGRect(origin: CGPoint(x: 0,y :2), size: CGSize(width: 60, height: 26))
        self.sendBtn.frame.origin.x = UIScreen.main.bounds.width - 70
        self.sendBtn.setTitle("Send", for: .normal)
        
        self.sendBtn.layer.borderWidth = 1
        self.sendBtn.layer.cornerRadius = 5
        self.sendBtn.layer.masksToBounds = true
        self.sendBtn.layer.borderColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1).cgColor
        self.sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.sendBtn.setTitleColor(UIColor.white, for: .normal)
        self.sendBtn.backgroundColor = UIColor.black
        self.addSubview(commentTextField)
        self.addSubview(sendBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

