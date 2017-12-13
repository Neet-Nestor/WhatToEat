//
//  MatchViewController.swift
//  WhatToEat
//
//  Created by Student User on 11/30/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var miniImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shareTextView: UITextView!
    @IBOutlet weak var costInput: UITextField!
    var historyGenerated: History?
    var resultRest: Restaurant?
    var distance: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (resultRest != nil) {
            setResultRest()
        }
        shareTextView.layer.borderWidth = 2
        shareTextView.delegate = self
        shareTextView.text = "Tell others your experience!"
        shareTextView.textColor = UIColor.lightGray
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var myhis = History.read()
        if myhis == nil {
            myhis = History()
        }
        myhis!.add(resultRest!)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if shareTextView.textColor == UIColor.lightGray {
            shareTextView.text = nil
            shareTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if shareTextView.text.isEmpty {
            shareTextView.text = "Tell others your experience!"
            shareTextView.textColor = UIColor.lightGray
        }
    }
    
//    @IBAction func doneButtonPressed(_ sender: Any) {
//
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setResultRest() {
        self.nameLabel.text = resultRest?.getName()
        self.miniImage.image = (resultRest?.getImage())!
        //cell.stars[0].image = UIImage(named: "filledStar_2x")
        if let star = resultRest?.getRating() {
            for index in 0...(star - 1) {
                self.stars[index].image = UIImage(named: "filledStar_2x")
            }
        }
        self.tagsLabel.text = resultRest?.getTags().joined(separator: ", ")
        self.addressLabel.text = resultRest?.getAddr().toString()
        
        let restLocation = resultRest?.getCoordinate()
        
        self.distanceLabel.text = "\(distance ?? 0) km"
        self.priceLabel.text = resultRest?.getDollarSign()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToMainSegue") {
            if let des = segue.destination as? MainViewController {
                if (costInput.text != nil &&
                    costInput.text!.count > 0 &&
                    Double(costInput.text!) != nil) {
                    var hisList = History.read()
                    if hisList == nil {
                        hisList = History()
                    }
                    hisList!.changePrice(index: 1, price: Double(costInput.text!)!)
                }
                if (shareTextView.textColor != UIColor.lightGray
                    && shareTextView.text.count > 0) {
                    let shareText = "I ate at \(self.nameLabel.text!), which mainly serves \(self.tagsLabel.text!) and located at\(self.addressLabel.text!). \(shareTextView.text!)"
                    Common.socket.emit("pyqSend", ["user_id" : Common.myFacebookID,
                                                   "user_name" : Common.myFacebookName,
                                                   "content" : shareText,
                                                   "avator" : Common.myFacebookProfileImageURL])
                }
                
            }
        }
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
