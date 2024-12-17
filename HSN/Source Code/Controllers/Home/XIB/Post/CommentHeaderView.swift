//
//  CommentHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 11/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class CommentHeaderView: UIView {
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var imageComment: UIImageView!
    @IBOutlet weak var buttonTotalLikes: ResizableButton!
    @IBOutlet weak var buttonTotalReplies: UIButton!
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var imageDotReplies: UIImageView!
    @IBOutlet weak var constraintImageHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var exclusiveHeaderView: UIView!
    @IBOutlet weak var lblExclusiveTitle: UILabel!
    @IBOutlet weak var lblExclusiveTime: UILabel!
    
    var isReply = false
    var data:CommentModel? {
        didSet{
           // tableViewComments.reloadData()
        }
    }
    
    func configure(data:CommentModel){
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        imageComment.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageComment.contentMode = UIView.ContentMode.scaleAspectFill
        updateCell(data: data, isReply: false)
    }
    func updateCell(data obj:CommentModel,isReply:Bool){
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        self.data = obj
        
        labelFullName.text = String.getString(obj.user?.full_name).capitalized
        labelComment.text = obj.comment
        labelProfession.text = String.getString(obj.user?.employee_type).capitalized
        imageProfile.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.user?.profile_pic)),placeholder:#imageLiteral(resourceName: "profile_placeholder"))
        self.buttonTotalLikes.setTitle(obj.total_likes_count, for: .normal)
        self.buttonTotalReplies.setTitle(String.getString(obj.total_replies_count) + " Replies", for: .normal)
        self.labelTime.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.comment_date)), relativeTo: Date())
        if obj.picture.isEmpty{
            constraintImageHeight.constant = 0
            //constraintImageBottom.constant = 0
            imageComment.isHidden = true
        }else{
            constraintImageHeight.constant = 125
            //constraintImageBottom.constant = 15
            imageComment.isHidden = false
            imageComment.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.picture)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder"))
        }
        if obj.is_comment_like_by_user{
            
            self.buttonLike.isSelected = true
        }
        else{
           
            self.buttonLike.isSelected = false
        }
        if obj.replies.isEmpty{
           // self.tableViewComments.reloadData()
           //self.constraintTableViewHeight.constant = 0
        }else{
            
           // self.constraintTableViewHeight.constant  = 0
            
           // self.tableViewComments.reloadData()
        }
        self.isReply = isReply
        if isReply{
            
               
            
            labelComment.textColor = .red
        }
        else {
            labelComment.textColor = .black
            guard let replies = data?.replies else {return}
           
           
        }
        
      
    }
    @IBAction func buttonLikeTapped(_ sender: UIButton) {
        globalApis.likeUnlikePost(postId: String.getString(data?.id), isPostLike: !sender.isSelected, type: .comment, emojiType: 1, postMode: .user, completion: { totalLikes, status,reactions,reactionsCount  in
            self.buttonLike.isSelected = status != 0 ? true : false
            self.buttonTotalLikes.setTitle(String.getString(totalLikes), for: .normal)

            
        })
    }
    @IBAction func buttonReplyTapped(_ sender: Any) {
    }
    @IBAction func buttonRepliedLikeUnlikeTapped(_ sender: Any) {
    }
    @IBAction func buttonRepliedReplyTapped(_ sender: Any) {
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
