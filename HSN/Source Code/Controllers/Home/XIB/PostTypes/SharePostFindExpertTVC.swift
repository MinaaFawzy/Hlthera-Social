//
//  SharePostFindExpertTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SharePostFindExpertTVC: UITableViewCell {

    @IBOutlet weak var viewHeaderMain: UIView!
    @IBOutlet weak var viewHeaderShared: UIView!
    @IBOutlet weak var labelDescriptionMain: UILabel!
    @IBOutlet weak var labelDescriptionShared: UILabel!
    @IBOutlet weak var collectionViewMediaShared: UICollectionView!
    @IBOutlet weak var viewFooterMain: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    
    var headerMainObj:PostHeader?
    var headerSharedObj:PostHeader?
    var footerObj:PostFooter?
    var parent:UIViewController?
    var hasCameFrom:HasCameFrom = .sharePost
    var data:HomeFeedModel = HomeFeedModel(data: [:]) {
        didSet{
            self.collectionViewMediaShared.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupCollectionView()
        setupHeaderView()
        setupFooterView()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.pageControl.numberOfPages = data.share_post?.post_pic.count ?? 0
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupHeaderView(){
        let view = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        viewHeaderMain.addSubview(view)
        view.frame = viewHeaderMain.bounds
        self.headerMainObj = view
        let view1 = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        viewHeaderShared.addSubview(view1)
        view.frame = viewHeaderShared.bounds
        self.headerSharedObj = view1
    }
    
    func setupFooterView(){
        let view = UINib(nibName: "PostFooter", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostFooter
        viewFooterMain.addSubview(view)
        view.frame = viewFooterMain.bounds
        self.footerObj = view
        
        
    }
    

}
