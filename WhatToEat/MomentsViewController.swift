//
//  MomentsViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit
import SocketIO
import FacebookCore
import FacebookLogin

class MomentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
        UIScrollViewDelegate, UITextFieldDelegate{
    
    var socket : SocketIOClient? = nil
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var tableView:UITableView?
    var refreshControl = UIRefreshControl()
    let imagePicView = UIView()
    let imagePic = UIImageView()
    let nameLable = UILabel()
    let avatorImage = UIImageView()
    var biaozhi = true
    var selectItems: [Bool] = []
    var likeItems:[Bool] = []
    var replyViewDraw:CGFloat!
    var test = UITextField()
    var commentView = PingLunFun()
    var comment_height:CGFloat = 0.0
    var dataArray: NSArray?
    var highlightMoment: Int?
    @IBOutlet weak var noLoginLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadingLabel.isHidden = true
        spinner.isHidden = true
        
        self.refreshControl.addTarget(self, action: #selector(MomentsViewController.refreshData),
                                      for: UIControlEvents.valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            
        // server codes
        
//        Common.socket = SocketIOClient(socketURL: myURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let accessToken = AccessToken.current {
            self.noLoginLabel.isHidden = true
            // User is logged in, use 'accessToken' here.
            loadingLabel.isHidden = false
            spinner.isHidden = false
            spinner.startAnimating()
            socket?.connect()
            Common.socket.on(clientEvent: .connect) {data, ack in
                print("socket connected")
                Common.socket.emit("pyqGet")
            }
            Common.socket.on("pyqSend") {data, ack in
                print("Receive: \(data)")
            }
            Common.socket.on("pyqGet") {data, ack in
                print("Receive: \(data)")
                self.dataArray = data as! NSArray
                let dataArray2 = self.dataArray![0] as! NSArray
                for _ in 0...dataArray2.count{
                    self.selectItems.append(false)
                    self.likeItems.append(false)
                }
                self.test.delegate = self
                self.commentView.commentTextField.delegate = self
                self.tableView = UITableView(frame: self.view.frame, style:UITableViewStyle.grouped)
                self.tableView!.delegate = self
                self.tableView!.dataSource = self
                self.tableView?.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
                self.view.addSubview(self.tableView!)
                if !(self.tableView?.subviews.contains(self.refreshControl))! {
                    self.tableView?.addSubview(self.refreshControl)
                }
                self.tableView!.allowsMultipleSelection = true
                self.view.backgroundColor = UIColor.white
                self.commentView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.bounds.width, height: 30))
                self.commentView.isHidden = true
                self.view.addSubview(self.commentView)
                self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MomentsViewController.handleTap(_:))))
                NotificationCenter.default.addObserver(self, selector:#selector(MomentsViewController.keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector:#selector(MomentsViewController.keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
                self.tableView?.tableHeaderView = self.headerView()
                self.tableView?.reloadData()
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.loadingLabel.isHidden = true
                if (self.refreshControl.isRefreshing) {
                    self.refreshControl.endRefreshing()
                }
            }
            
            Common.socket.on("pyqLike") {data, ack in
                print("Receive: \(data)")
            }
            
            Common.socket.on("pyqComment") {data, ack in
                print("Receive: \(data)")
                Common.socket.emit("pyqGet")
            }
            Common.socket.connect()
        }
    }

    @objc func refreshData() {
        Common.socket.emit("pyqGet")
        biaozhi = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let accessToken = AccessToken.current {
            return 1;
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let accessToken = AccessToken.current {
            if (dataArray != nil) {
                let dataArray2 = dataArray![0] as! NSArray
                return dataArray2.count
            }
        }
        return 0
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView?.separatorInset = UIEdgeInsets.zero
        self.tableView?.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        if (dataArray != nil) {
            let identify:String = "SwiftCell\(indexPath.row)"
            //禁止重用机制
            var cell:MomentsTableViewCell? = tableView.cellForRow(at: indexPath) as? MomentsTableViewCell
            if cell == nil{
                cell = MomentsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identify)
            }
            let array = dataArray as! NSArray
            let dataArray2 = dataArray![0] as! NSArray
            let dataDict = dataArray2[indexPath.row] as! [String: Any]
            let name = dataDict["user_name"] as! String
            let imagePic = dataDict["avator"]! as! String
            let content = dataDict["content"]! as! String
            let imageData: [String] = []
            //let like = dataDict["like"] as! [[String : String]]
            print(dataDict["comment"])
            let comment = dataDict["comment"] as! [[String: Any]]
            comment_height = cell!.setData(name: name, imagePic: imagePic,content: content,imgData: imageData,indexRow:indexPath as NSIndexPath,selectItem: selectItems[indexPath.row],likeArray:[] ,likeItem:likeItems[indexPath.row],commentArray: comment)
    //        cell!.displayView.tapedImageV = {[unowned self] index in
    //            cell!.pbVC.show(inVC: self,index: index)
    //        }
            cell!.selectionStyle = .none
            
            cell!.heightZhi = { cellflag in
                self.selectItems[indexPath.row] = cellflag
                self.tableView?.reloadData()
            }
            cell!.likechange = { cellflag in
                self.likeItems[indexPath.row] = cellflag
                self.tableView?.reloadData()
                self.highlightMoment = indexPath.row
            }
            cell!.commentchange = { () in
                self.replyViewDraw = cell!.convert(cell!.bounds,to:self.view.window).origin.y + cell!.frame.size.height
                self.highlightMoment = indexPath.row
                self.commentView.commentTextField.becomeFirstResponder()
                self.commentView.sendBtn.addTarget(self, action: #selector(MomentsViewController.sendComment(_:)), for:.touchUpInside)
                self.commentView.sendBtn.tag = indexPath.row
            }
            return cell!
        }
        return UITableViewCell()
    }
     
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            if (dataArray != nil) {
                let dataArray2 = dataArray![0] as! NSArray
                let dataDict = dataArray2[indexPath.row] as! [String: Any]
                var h_content = cellHeightByData(data: dataDict["content"]! as! String)
                let h_image = cellHeightByData1(imageNum: 0)
                var h_like:CGFloat = 0.0
                // let h_comment = cellHeightByCommentNum(Comment: goodComm[indexPath.row]["commentName"]!.count)
                if h_content>13*5{
                    if !self.selectItems[indexPath.row]{
                        h_content = 13*5
                    }
                }
//                let likesArray = dataDict["like"] as! [[String: Any]]
//                if likesArray.count > 0{
//                    var likesString:String = likesArray[0]["user_name"] as! String
//                    for index in 1...likesArray.count - 1 {
//                        likesString = "\(likesString), \(likesArray[index]["user_name"])"
//                    }
////                    h_like = likesString.stringHeightWith(fontSize: 14, width: UIScreen.main.bounds.width - 10 - 55 - 15)
//                    h_like = 40
//                }
                return h_content + h_image + 60 + h_like + comment_height
            }
            return 0
        }

    
    func headerView() ->UIView{
        
        imagePicView.frame = CGRect(origin: CGPoint(x:0, y:-200), size: CGSize(width:self.view.bounds.width, height:225))
        imagePic.frame = CGRect(origin: CGPoint(x:0, y:-125), size: CGSize(width:self.view.bounds.width, height:350))
        imagePic.image = UIImage(named: "22")
        imagePicView.addSubview(imagePic)
        imagePic.clipsToBounds = true
        self.nameLable.frame = CGRect(origin: CGPoint(x: 0, y:170), size: CGSize(width:200, height:18))
        self.nameLable.textAlignment = .right
        self.nameLable.frame.origin.x = self.view.bounds.width - 290
        self.nameLable.text = Common.myFacebookName
        self.nameLable.font = UIFont.systemFont(ofSize: 22)
        self.nameLable.textColor = UIColor.white
        self.avatorImage.frame = CGRect(origin: CGPoint(x:0, y:150), size: CGSize(width:70, height:70))
        self.avatorImage.frame.origin.x = self.view.bounds.width - 80
        if (Common.myFacebookProfileImageURL != nil) {
            self.avatorImage.hnk_setImageFromURL(URL(string: Common.myFacebookProfileImageURL!)!)
        }
        self.avatorImage.layer.borderWidth = 2
        self.avatorImage.layer.borderColor = UIColor.white.cgColor
        let view:UIView = UIView(frame: CGRect(origin: CGPoint(x:0, y:200), size: CGSize(width:self.view.bounds.width, height:26)))
        view.backgroundColor = UIColor.white
        imagePicView.addSubview(nameLable)
        imagePicView.addSubview(view)
        imagePicView.addSubview(avatorImage)
        return imagePicView
    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offset:CGPoint = scrollView.contentOffset
        
        if (offset.y < 0) {
            var rect:CGRect = imagePic.frame
            rect.origin.y = offset.y
            rect.size.height = 200 - offset.y
            imagePic.frame = rect
        }
    }
    */
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.commentView.commentTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc func keyBoardWillShow(_ note:NSNotification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let commentY = self.view.frame.height - deltaY
        var frame = self.commentView.frame
        let animations:(() -> Void) = {
            self.commentView.isHidden = false
            self.commentView.frame.origin.y = commentY - 30
            frame.origin.y = commentY
            var point:CGPoint = self.tableView!.contentOffset
            point.y -= (frame.origin.y - self.replyViewDraw)
            self.tableView!.contentOffset = point
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    @objc func keyBoardWillHide(_ note:NSNotification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.commentView.isHidden = true
            self.commentView.transform = CGAffineTransform.identity
            self.tableView!.frame.origin.y = 0
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    
    @objc func sendComment(_ sender:UIButton){
//        goodComm[sender.tag]["commentName"]!.append("Neet")
//        goodComm[sender.tag]["comment"]!.append(commentView.commentTextField.text!)
        if (Common.myFacebookID != nil && Common.myFacebookName != nil) {
            self.commentView.commentTextField.resignFirstResponder()
            let dataArray2 = dataArray![0] as! NSArray
//            let dataDict = dataArray2[highlightMoment!] as! [String: Any]
            var dataDict: [String: Any]? = nil
            if (sender.tag != -1) {
                dataDict = dataArray2[sender.tag] as! [String: Any]
            } else {
                dataDict = dataArray2[highlightMoment!] as! [String: Any]
            }
            let targetTime = dataDict!["time"] as! Int
            let targetId = dataDict!["user_id"] as! String
            Common.socket.emit("pyqComment", ["target_time" : targetTime,
                                        "target_user_id" : targetId,
                                        "my_user_id" : Common.myFacebookID,
                                        "my_user_name" : Common.myFacebookName,
                                        "content" : "\(self.commentView.commentTextField.text!)"])
            self.tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(MomentsViewController.keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func unwindToMoments(segue:UIStoryboardSegue) { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
