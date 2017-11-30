//
//  extention.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

extension String{
        
    //MARK:获得string内容高度
    
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat{
        
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
        
        let text = self as NSString
        
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
        
    }//funcstringHeightWith
    
}//extension end

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

func cellHeightByData(data:String)->CGFloat{
    
    let content = data
    let height=content.stringHeightWith(fontSize: 13,width: UIScreen.main.bounds.width - 55 - 10)
    return  height
    
}
    
func cellHeightByData1(imageNum:Int)->CGFloat{
    
//        let lines:CGFloat = (CGFloat(imageNum))/3
    var picHeight:CGFloat = 0
    switch imageNum{
    case 0:
        picHeight = 0
        break
    case 1...3:
        picHeight = 80
        break
    case 4...6:
        picHeight = 155
        break
    case 7...9:
        picHeight = 230
        break
    default:
        picHeight = 0
    }
    return picHeight
    
}

func cellHeightByCommentNum(Comment:Int)->CGFloat{
    return CGFloat(Comment * 20)
}
    
    


