//
//  MomentsViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/29/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
        UIScrollViewDelegate, UITextFieldDelegate{
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for _ in 0...dataItem.count{
            selectItems.append(false)
            likeItems.append(false)
        }
        test.delegate = self
        self.commentView.commentTextField.delegate = self
        refreshControl.addTarget(self, action: #selector(MomentsViewController.refreshData),
                                 for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.tableView = UITableView(frame: self.view.frame, style:UITableViewStyle.grouped)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView?.tableHeaderView = headerView()
        self.tableView?.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        self.view.addSubview(self.tableView!)
        self.tableView?.addSubview(refreshControl)
        self.tableView!.allowsMultipleSelection = true
        self.view.backgroundColor = UIColor.white
        commentView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.bounds.width, height: 30))
        commentView.isHidden = true
        self.view.addSubview(self.commentView)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MomentsViewController.handleTap(_:))))
        NotificationCenter.default.addObserver(self, selector:#selector(MomentsViewController.keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MomentsViewController.keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func refreshData() {
        print("123")
        biaozhi = true
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItem.count
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
        let identify:String = "SwiftCell\(indexPath.row)"
        //禁止重用机制
        var cell:MomentsTableViewCell? = tableView.cellForRow(at: indexPath) as? MomentsTableViewCell
        if cell == nil{
            cell = MomentsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identify)
        }
        comment_height = cell!.setData(name: dataItem[indexPath.row]["name"]! as! String, imagePic: dataItem[indexPath.row]["avator"]! as! String,content: dataItem[indexPath.row]["content"]! as! String,imgData: dataItem[indexPath.row]["imageUrls"]! as! [String],indexRow:indexPath as NSIndexPath,selectItem: selectItems[indexPath.row],like:goodComm[indexPath.row]["good"]!,likeItem:likeItems[indexPath.row],CommentNameArray:goodComm[indexPath.row]["commentName"]! ,CommentArray:goodComm[indexPath.row]["comment"]! )
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
        }
        cell!.commentchange = { () in
            self.replyViewDraw = cell!.convert(cell!.bounds,to:self.view.window).origin.y + cell!.frame.size.height
            self.commentView.commentTextField.becomeFirstResponder()
            self.commentView.sendBtn.addTarget(self, action: #selector(MomentsViewController.sendComment(_:)), for:.touchUpInside)
            self.commentView.sendBtn.tag = indexPath.row
        }
        return cell!
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        var h_content = cellHeightByData(data: dataItem[indexPath.row]["content"]! as! String)
        let h_image = cellHeightByData1(imageNum: (dataItem[indexPath.row]["imageUrls"]! as AnyObject).count)
        var h_like:CGFloat = 0.0
        // let h_comment = cellHeightByCommentNum(Comment: goodComm[indexPath.row]["commentName"]!.count)
        if h_content>13*5{
            if !self.selectItems[indexPath.row]{
                h_content = 13*5
            }
        }
        if goodComm[indexPath.row]["good"]!.count > 0{
            h_like = 40
        }
        return h_content + h_image + 40 + h_like + comment_height
    }

    
    func headerView() ->UIView{
        
        imagePicView.frame = CGRect(origin: CGPoint(x:0, y:-200), size: CGSize(width:self.view.bounds.width, height:225))
        imagePic.frame = CGRect(origin: CGPoint(x:0, y:-125), size: CGSize(width:self.view.bounds.width, height:350))
        imagePic.image = UIImage(named: "22")
        imagePicView.addSubview(imagePic)
        imagePic.clipsToBounds = true
        self.nameLable.frame = CGRect(origin: CGPoint(x:0, y:170), size: CGSize(width:60, height:18))
        self.nameLable.frame.origin.x = self.view.bounds.width - 140
        self.nameLable.text = "Neet"
        self.nameLable.font = UIFont.systemFont(ofSize: 22)
        self.nameLable.textColor = UIColor.white
        self.avatorImage.frame = CGRect(origin: CGPoint(x:0, y:150), size: CGSize(width:70, height:70))
        self.avatorImage.frame.origin.x = self.view.bounds.width - 80
        self.avatorImage.image = UIImage(named: "WechatIMG15")
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
        goodComm[sender.tag]["commentName"]!.append("Neet")
        goodComm[sender.tag]["comment"]!.append(commentView.commentTextField.text!)
        self.commentView.commentTextField.resignFirstResponder()
        self.tableView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
