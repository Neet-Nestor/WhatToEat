//
//  PhotoBrowser+CollectionView.swift
//  PhotoBrowser
//
//  Created by 成林 on 15/7/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit


extension PhotoBrowser: UICollectionViewDataSource,UICollectionViewDelegate{
    
    var cellID: String {return "ItemCell"}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleRotation(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleRotation(false)
        collectionView.isHidden = false
        let isZoomType = self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithCancelBtnClick || self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap
        
        if self.photoType == PhotoType.Local {
        
            collectionView.scrollToItem(at: NSIndexPath(forItem: showIndex, inSection: 0) as IndexPath, at: UICollectionViewScrollPosition.Left, animated: !isZoomType)
        
        }else{
         
            dispatch_after(dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),
                Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    
                    self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.showIndex, inSection: 0) as IndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: !isZoomType)
            }
        }
    }

    
    /**  准备  */
    func collectionViewPrepare(){
        
        //添加
        self.view.addSubview(collectionView)
        collectionView.make_4Inset(inset: UIEdgeInsetsMake(0, 0, 0, -CFPBExtraWidth))

        //注册cell
        collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        let isZoomType = self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithCancelBtnClick || self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap
        
        if isZoomType {
            collectionView.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoBrowser.handleRotation(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath as IndexPath) as! ItemCell
 
        itemCell.photoType = photoType
        
        itemCell.isHiddenBar = isHiddenBar
        
        itemCell.vc = vc
        
        let photoModel = photoModels[indexPath.row]
        
        photoModel.modelCell = itemCell
        
        itemCell.photoModel = photoModel
        
        itemCell.countLabel.text = "\(indexPath.row + 1) / \(photoModels.count)"
        
        if hideMsgForZoomAndDismissWithSingleTap && showType == .ZoomAndDismissWithSingleTap {itemCell.toggleDisplayBottomBar(isHidden: true)}
        
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let itemCell = cell as! ItemCell
        
        itemCell.reset()
    }

    
    @objc func handleRotation(_ anim: Bool){
        
        DispatchQueue.async(execute: {[unowned self] () -> Void in
            
            let layout = Layout()
            
            layout.itemSize = self.view.bounds.size.sizeWithExtraWidth
            
            self.collectionView.setCollectionViewLayout(layout, animated: anim)
            
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.page, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)
    }
    
}

