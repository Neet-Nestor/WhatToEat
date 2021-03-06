//
//  MomentsTableViewCell.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import SocketIO

typealias heightChange = (_ cellFlag:Bool) -> Void
typealias likeChange = (_ cellFlag:Bool) -> Void
typealias commentChange = () -> ()

class MomentsTableViewCell: UITableViewCell {
    var socket : SocketIOClient? = nil
    var flag = true
    var show = false
    var likeflag = true
    var nameLabel = UILabel()
    var avatorImage:UIImageView!
//    let pbVC = PhotoBrowser()
    var contentLabel = UILabel()
    let displayView = DisplayView()
    var remoteThumbImage = [NSIndexPath:[String]]()
    var remoteImage :[String] = []
    var timeLabel = UILabel()
    var btn = UIButton()
    let menuview = Menu()
    var zhankaiBtn:UIButton!
    var collectionViewFrame = CGRect(origin: CGPoint(x:0,y:0), size:CGSize(width:0,height:0))
    var cellflag1 = false
    var heightZhi:heightChange?
    var likechange:likeChange?
    var commentchange:commentChange?
    var likeView = CommentLikeView()
    
    var likeLabelArray:[String] = []
    var commentView = PingLunFun()
    var commentNameLabel = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if avatorImage == nil{
            avatorImage = UIImageView(frame: CGRect(origin: CGPoint(x:8,y:10), size:CGSize(width:40,height:40)))
            self.contentView.addSubview(avatorImage)
        }
        nameLabel.frame = CGRect(origin: CGPoint(x:55,y:8), size:CGSize(width:260,height:17))
        nameLabel.textColor = UIColor(red: 74/255, green: 83/255, blue: 130/255, alpha: 1)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.contentView.addSubview(nameLabel)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.black
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textAlignment = .justified
    
        contentLabel.sizeToFit()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.gray
        timeLabel.text = "Moment Ago"
        btn.setImage(UIImage(named:"menu"), for: .normal)
        btn.addTarget(self, action: #selector(MomentsTableViewCell.click), for: .touchUpInside)
        
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(displayView)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(btn)
        
    }
    
    @objc func click(){
        menuview.clickMenu()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // return height of Comments
    func setData(name:String,imagePic:String,content:String,imgData:[String],indexRow:NSIndexPath,selectItem:Bool,likeArray:[[String: String]],likeItem:Bool, commentArray:[[String: Any]]) -> CGFloat{
        var h = cellHeightByData(data: content)
//        let h1 = cellHeightByData1(imageNum: imgData.count)
        let h1:CGFloat = 0.0
        var h2:CGFloat = 0.0
        var totalyCommentHeight:CGFloat = 0.0
        nameLabel.text = name
        avatorImage.hnk_setImageFromURL(URL(string: imagePic)!)
        if h<13*5{
            contentLabel.frame = CGRect(origin: CGPoint(x:55,y:25), size:CGSize(width:UIScreen.main.bounds.width - 55 - 15,height:h))
            collectionViewFrame = CGRect(origin: CGPoint(x:50,y:h+10+15), size:CGSize(width:230,height:h1))
            h2 = h1 + h + 27
        }
        else{
            if !selectItem{
                cellflag1 = !selectItem
                h = 13*5
                contentLabel.frame = CGRect(origin: CGPoint(x:55,y:25), size:CGSize(width:UIScreen.main.bounds.width - 55 - 10,height:h))
                zhankaiBtn = UIButton(frame: CGRect(origin: CGPoint(x:40,y:h+10+17), size:CGSize(width:100,height:15)))
                zhankaiBtn.setTitle("Show More", for: .normal)
                zhankaiBtn.titleLabel?.textAlignment = .left
                zhankaiBtn.addTarget(self, action: #selector(MomentsTableViewCell.clickDown(_:)), for: .touchUpInside)
                zhankaiBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                zhankaiBtn.setTitleColor(UIColor(red: 74/255, green: 83/255, blue: 130/255, alpha: 1), for: .normal)
                self.contentView.addSubview(zhankaiBtn)
                collectionViewFrame = CGRect(origin: CGPoint(x:40,y:h+10+15+15), size:CGSize(width:230,height:h1))
                h2 = h1 + h + 27 + 12
            }
            if selectItem{
                cellflag1 = !selectItem
                contentLabel.frame = CGRect(origin: CGPoint(x:55,y:25), size:CGSize(width:UIScreen.main.bounds.width - 55 - 10,height:h))
                zhankaiBtn = UIButton(frame: CGRect(origin: CGPoint(x:40,y:h+10+17), size:CGSize(width:100,height:15)))
                zhankaiBtn.setTitle("Show Less", for: .normal)
                zhankaiBtn.addTarget(self, action: #selector(MomentsTableViewCell.clickDown(_:)), for: .touchUpInside)
                zhankaiBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                zhankaiBtn.setTitleColor(UIColor(red: 74/255, green: 83/255, blue: 130/255, alpha: 1), for: .normal)
                self.contentView.addSubview(zhankaiBtn)
                collectionViewFrame = CGRect(origin: CGPoint(x:50,y:h+10+15+15), size:CGSize(width:230,height:h1))
                h2 = h1 + h + 27 + 12
            }
        }
        contentLabel.text = content
        displayView.frame = collectionViewFrame
        
        timeLabel.frame = CGRect(origin: CGPoint(x:55,y:h2), size:CGSize(width:100,height:15))
        btn.frame = CGRect(origin: CGPoint(x:0,y:h2), size:CGSize(width:15,height:12))
        btn.frame.origin.x = UIScreen.main.bounds.width - 10 - 15
        self.menuview.frame = CGRect(origin: CGPoint(x:0,y:h2 - 8), size:CGSize(width:14.5,height:0))
        self.menuview.frame.origin.x = UIScreen.main.bounds.width - 10 - 15
//        self.menuview.likeBtn.setImage(UIImage(named: "likewhite"), for: .normal)
//        if !likeItem{
//            self.menuview.likeBtn.setTitle("Like!", for: .normal)
//            likeflag = !likeItem
//        }
//        if likeItem{
//            self.menuview.likeBtn.setTitle("Cancel Like", for: .normal)
//            likeflag = !likeItem
//        }
        
//        self.menuview.likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.menuview.commentBtn.setImage(UIImage(named: "c"), for: .normal)
        self.menuview.commentBtn.setTitle("Comment", for: .normal)
        self.menuview.commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.menuview.commentBtn.tag = indexRow.row
//        self.menuview.likeBtn.tag = indexRow.row
//        self.menuview.likeBtn.addTarget(self, action: #selector(MomentsTableViewCell.LikeBtn(_:)), for: .touchUpInside)
        self.menuview.commentBtn.addTarget(self, action: #selector(MomentsTableViewCell.CommentBtn(_:)), for: .touchUpInside)
        for i in 0..<imgData.count{
            let imgUrl = imgData[i]
            self.remoteImage.append(imgUrl)
        }
        self.remoteThumbImage[indexRow] = self.remoteImage
        displayView.imgsPrepare(imgs: remoteThumbImage[indexRow]!, isLocal: true)
//        pbVC.showType = .Modal
//        pbVC.photoType = PhotoBrowser.PhotoType.Host
//        pbVC.hideMsgForZoomAndDismissWithSingleTap = true
//        var models: [PhotoBrowser.PhotoModel] = []
/*        for i in 0 ..< self.remoteThumbImage[indexRow]!.count{
            let model = PhotoBrowser.PhotoModel(hostHDImgURL:self.remoteThumbImage[indexRow]![i], hostThumbnailImg: (displayView.subviews[i] as! UIImageView).image, titleStr: "", descStr: "", sourceView: displayView.subviews[i])
            models.append(model)
        }*/
//        pbVC.photoModels = models
        var likeHeight:CGFloat = 0.0
//        if likeArray.count > 0{
//            var likesString:String = likeArray[0]["user_name"] as! String
//            for index in 1...likeArray.count - 1 {
//                likesString = "\(likesString), \(likeArray[index]["user_name"])"
//            }
//            likeHeight = likesString.stringHeightWith(fontSize: 10, width: UIScreen.main.bounds.width - 10 - 55 - 15)
//            self.likeView.frame = CGRect(origin: CGPoint(x:55,y:h2+19.5), size:CGSize(width:UIScreen.main.bounds.width - 10 - 55 - 15,height:likeHeight))
//            for i in 0..<likeArray.count{
//                likeLabelArray.append(likeArray[i]["user_name"]!)
//            }
//            self.likeView.likeLabel.text = likeLabelArray.joined(separator: ",")
//            self.likeView.likeLabel.numberOfLines = 0
//            self.likeView.likeLabel.font = UIFont.systemFont(ofSize: 14)
//            self.likeView.likeLabel.lineBreakMode = .byWordWrapping
//            self.likeView.likeLabel.sizeToFit()
//            self.contentView.addSubview(self.likeView)
//        }
        if commentArray.count>0{
            var h3 = h2+19.5+likeHeight
            if likeArray.count == 0{
                h3 = h2+19.5
            }
            for i in 0..<commentArray.count{
                let comment_view = CommentView()
                //comment_view.nameLabel.text = CommentNameArray[i]
                let userName = commentArray[i]["my_user_name"] as! String
                let commentContent = commentArray[i]["content"] as! String
                let mutableString = NSMutableAttributedString(string: "\(userName): \(commentContent)")
                
                mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 74/255, green: 83/255, blue: 200/255, alpha: 1), range: NSRange(location:0,length:userName.count))
                // set label Attribute
                let h4 = "\(userName): \(commentContent)".stringHeightWith(fontSize: 17, width: 300)
                NSLog("\(h4)")
                comment_view.commentLabel.attributedText = mutableString
                comment_view.commentLabel.frame = CGRect(origin: CGPoint(x:5,y:2), size: CGSize(width:290,height:h4))
                comment_view.frame = CGRect(origin: CGPoint(x:55,y:h3+(totalyCommentHeight)), size:CGSize(width:UIScreen.main.bounds.width - 10 - 55 - 15,height:h4 + 5))
                totalyCommentHeight = totalyCommentHeight + h4
                //comment_view.commentLabel.sizeToFit()
                //comment_view.sizeToFit()
                self.contentView.addSubview(comment_view)
            }
        }
        self.contentView.addSubview(self.menuview)
        return totalyCommentHeight
    }
    
    @objc func clickDown(_ sender:UIButton){
        
        if flag{
            flag = false
            if self.heightZhi != nil{
                self.heightZhi!(self.cellflag1)
            }
            
        }
        else{
            flag = true
            if self.heightZhi != nil{
                self.heightZhi!(self.cellflag1)
            }
        }
        
    }
    
    @objc func CommentBtn(_ sender:UIButton){
        if self.commentchange != nil{
            self.commentchange!()
        }
        menuview.menuHide()
    }
    
    @objc func LikeBtn(_ sender:UIButton){
        
//        if !likeflag{
//
//            //服务器接口上传数据
//            goodComm[sender.tag]["good"]!.removeAtIndex(goodComm[sender.tag]["good"]!.indexOf("胖大海")!)
//            if self.likechange != nil{
//                self.likechange!(cellFlag: self.likeflag)
//            }
//            menuview.menuHide()
//        }
//        else{
//            goodComm[sender.tag]["good"]!.append("胖大海")
//            if self.likechange != nil{
//                self.likechange!(cellFlag: self.likeflag)
//            }
//            menuview.menuHide()
//        }
//
        
    }
    
}

