//
//  CommentTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 27/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Stripe
import Lottie

class CommentTVC: UITableViewCell {
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var imageComment: UIImageView!
    @IBOutlet weak var buttonTotalLikes: ResizableButton!
    @IBOutlet weak var buttonTotalReplies: UIButton!
    @IBOutlet weak var repliedView: UIView!
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var imageDotReplies: UIImageView!
    @IBOutlet weak var constraintImageHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var tableViewComments: OwnTableView!
    @IBOutlet weak var authorView : UIView!
    @IBOutlet weak var stackViewGifs: UIStackView!
    @IBOutlet weak var viewReactions: UIView!
    @IBOutlet weak var commentRepliedLine : UIImageView!
    @IBOutlet weak var commentRepliedLineHght : NSLayoutConstraint!
    @IBOutlet var lottieViews: [LottieAnimationView]!
    @IBOutlet weak var labelTotalLikes: UILabel!
    @IBOutlet var reactions : [UIImageView]!
    @IBOutlet weak var lblReplyCount: UILabel!
    
    var postByUserId = ""
    let loader = UIActivityIndicatorView(style: .white)
    //@IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    var replyCallback:((String)->())?
    var refreshCallback:(()->())?
    var isReply = false
    var data: CommentModel? {
        didSet {
            //tableViewComments.reloadData()
        }
    }
    let formatter = RelativeDateTimeFormatter()
    var gesture:UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewComments.delegate = self
        tableViewComments.dataSource = self
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        imageComment.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageComment.contentMode = UIView.ContentMode.scaleAspectFill
        self.tableViewComments.register(UINib(nibName: CommentTVC.identifier, bundle: nil), forCellReuseIdentifier: CommentTVC.identifier)
        self.tableViewComments.register(UINib(nibName: ReplyCommentHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: ReplyCommentHeaderCell.identifier)
        self.imageComment.roundedCornersNew(corners: [.bottomLeft, .bottomRight], radius: 12.0)
        
        //set emoji reaction
        gesture = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        self.addGestureRecognizer(self.gesture)
        gesture.isEnabled = false
        setupGifs()
        setup()
        viewReactions(status: false)
        //self.constraintTableViewHeight.constant = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(data obj:CommentModel,isReply:Bool){
        
        commentRepliedLine.isHidden = obj.replies.count == 0 ? true : false
        
        formatter.unitsStyle = .full
        self.data = obj
        
        labelFullName.text = String.getString(obj.user?.full_name).capitalized
        labelComment.text = obj.comment
        //labelProfession.text = String.getString(obj.user?.employee_type).capitalized
        imageProfile.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.user?.profile_pic)),placeholder:#imageLiteral(resourceName: "profile_placeholder"))
        //self.buttonTotalLikes.setTitle(obj.total_likes_count, for: .normal)
        //self.buttonTotalReplies.setTitle(String.getString(obj.total_replies_count) + " Replies", for: .normal)
        self.labelTime.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.comment_date)), relativeTo: Date())
        if obj.picture.isEmpty {
            constraintImageHeight.constant = 0
            //constraintImageBottom.constant = 0
            imageComment.isHidden = true
            commentRepliedLineHght.constant = 100
        } else {
            commentRepliedLineHght.constant = 200
            constraintImageHeight.constant = 125
            //constraintImageBottom.constant = 15
            imageComment.isHidden = false
            if String.getString(obj.picture).fileExtension() == "gif" {
                imageComment.setGifFromURL(URL.init(string: String.getString(obj.picture))!, customLoader: self.loader)
            } else {
                imageComment.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.picture)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder"))
            }
        }
        self.buttonLike.setTitleColor(obj.is_comment_like_by_user ? (Int.getInt(obj.count_reaction_like) == 1 ? UIColor.init(hexString: "#2E7AC5") : .orange) : UIColor.init(hexString: "#6E6E73"), for: .normal)
        self.buttonLike.setTitle(obj.is_comment_like_by_user ? getEmojiNames(index: Int.getInt(obj.count_reaction_like)-1) : "Like", for: .normal)
        
        //(self.labelLike.text = getEmojiNames(index: Int.getInt(obj.is_post_like)-1)) : (self.labelLike.text = "Like")
        //self.buttonLike.isSelected = obj.is_comment_like_by_user ? true : false
        self.tableViewComments.reloadData()
        self.isReply = isReply
        
        if isReply {
            print("object replies count =========", obj.replies.count , " &&&&&&obejct id  ==", obj.id)
            self.buttonReply.setTitleColor(UIColor.init(hexString: "#2E7AC5"), for: .normal)
            self.buttonReply.isHidden = true
            self.repliedView.isHidden = false
            self.lblReplyCount.text = obj.replies.count == 1 ? "\(obj.replies.count) Reply" : "\(obj.replies.count) Replies"
        } else {
            self.buttonReply.isHidden = false
            self.repliedView.isHidden = true
            self.buttonReply.setTitleColor(UIColor.init(hexString: "#6E6E73"), for: .normal)
        }
        self.labelTotalLikes.text = obj.total_likes_count
        self.authorView.isHidden = postByUserId == obj.user_id ? false : true
        for (index, like_type) in obj.likeType.enumerated() {
            reactions[index].isHidden = false
            reactions[index].image = getEmojiImage(index: like_type-1)
        }
    }
    
    func updateReplyCell(data obj: CommentModel, isReply: Bool) {
        
        commentRepliedLine.isHidden = true
        formatter.unitsStyle = .full
        labelFullName.text = String.getString(obj.user?.full_name).capitalized
        labelComment.text = obj.comment
        //   labelProfession.text = String.getString(obj.user?.employee_type).capitalized
        imageProfile.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.user?.profile_pic)),placeholder:#imageLiteral(resourceName: "profile_placeholder"))
        //        self.buttonTotalLikes.setTitle(obj.total_likes_count, for: .normal)
        //     self.buttonTotalReplies.setTitle(String.getString(obj.total_replies_count) + " Replies", for: .normal)
        self.labelTime.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.comment_date)), relativeTo: Date())
        
        if obj.picture.isEmpty{
            constraintImageHeight.constant = 0
            imageComment.isHidden = true
        }else{
            constraintImageHeight.constant = 125
            imageComment.isHidden = false
            if String.getString(obj.picture).fileExtension() == "gif" {
                imageComment.setGifFromURL(URL.init(string: String.getString(obj.picture))!, customLoader: self.loader)
            }else{
                
                imageComment.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.picture)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder"))
            }
        }
        self.buttonLike.setTitleColor(obj.is_comment_like_by_user ? (Int.getInt(obj.count_reaction_like) == 1 ? UIColor.init(hexString: "#2E7AC5") : .orange) : UIColor.init(hexString: "#6E6E73"), for: .normal)
        self.buttonLike.setTitle(obj.is_comment_like_by_user ? getEmojiNames(index: Int.getInt(obj.count_reaction_like)-1) : "Like", for: .normal)
        self.tableViewComments.reloadData()
        self.isReply = isReply
        
        if let isExpand = self.data?.isReplyExpand {
            self.repliedView.isHidden = isExpand ? true : false
            labelComment.text = ""
        }
        
        if isReply{
            print("object replies count =========", obj.replies.count , " &&&&&&obejct id  ==", obj.id)
            self.buttonReply.setTitleColor(UIColor.init(hexString: "#2E7AC5"), for: .normal)
            self.buttonReply.isHidden = true
            self.lblReplyCount.text = obj.replies.count == 1 ? "\(obj.replies.count) Reply" : "\(obj.replies.count) Replies"
        }
        else {
            self.buttonReply.isHidden = false
            self.buttonReply.setTitleColor(UIColor.init(hexString: "#6E6E73"), for: .normal)
        }
        
        self.authorView.isHidden = postByUserId == obj.user_id ? false : true
        self.labelTotalLikes.text = obj.total_likes_count
        for (index, like_type) in obj.likeType.enumerated() {
            reactions[index].isHidden = false
            reactions[index].image = getEmojiImage(index: like_type-1)
        }
    }
    
    @IBAction func buttonLikeTapped(_ sender: UIButton) {
        globalApis.likeUnlikePost(postId: String.getString(data?.id), isPostLike: !sender.isSelected, type: .comment, emojiType: 1, postMode: .user, completion: { totalLikes, status,reactions,reactionsCount  in
            //  self.buttonLike.isSelected = status != 0 ? true : false
            self.buttonLike.setTitleColor(status != 0 ? UIColor.init(hexString: "#2E7AC5") : UIColor.init(hexString: "#6E6E73"), for: .normal)
            //    self.buttonTotalLikes.setTitle(String.getString(totalLikes), for: .normal)
        })
    }
    
    @IBAction func buttonReplyTapped(_ sender: Any) {
        replyCallback?(String.getString(data?.id))
    }
    
    @IBAction func buttonRepliedLikeUnlikeTapped(_ sender: Any) {
    }
    
    @IBAction func buttonRepliedReplyTapped(_ sender: Any) {
    }
    
    @IBAction func buttonsReactionTapped(_ sender: UIButton) {
        reactEmoji(index: sender.tag + 1)
    }
    
    func setupGifs() {
        let size: UIView.ContentMode = .scaleAspectFill
        lottieViews[0].contentMode = size
        lottieViews[1].contentMode = size
        lottieViews[2].contentMode = size
        lottieViews[3].contentMode = size
        lottieViews[4].contentMode = size
        lottieViews[5].contentMode = size
        lottieViews[0].loopMode = .loop
        lottieViews[1].loopMode = .loop
        lottieViews[2].loopMode = .loop
        lottieViews[3].loopMode = .loop
        lottieViews[4].loopMode = .loop
        lottieViews[5].loopMode = .loop
        lottieViews[0].animationSpeed = 0.75
        lottieViews[1].animationSpeed = 0.75
        lottieViews[2].animationSpeed = 0.75
        lottieViews[3].animationSpeed = 0.75
        lottieViews[4].animationSpeed = 0.75
        lottieViews[5].animationSpeed = 0.75
    }
    
    func setup() {
        let longTap =  UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longTap.minimumPressDuration = 0.5
        longTap.delaysTouchesBegan = true
        longTap.delegate = self
        longTap.numberOfTouchesRequired = 1
        longTap.allowableMovement = 10
        self.buttonLike.addGestureRecognizer(longTap)
    }
    
    @objc func buttonLongPressed(_ sender:UILongPressGestureRecognizer){
        if sender.state != UIGestureRecognizer.State.ended {
            //When lognpress is start or running
            viewReactions(status: true)
        }
        else {
            //When lognpress is finish
        }
    }
    
    func viewReactions(status: Bool) {
        if status {
            gesture.isEnabled = true
            self.viewReactions.isHidden = false
            lottieViews[0].play()
            lottieViews[1].play()
            lottieViews[2].play()
            lottieViews[3].play()
            lottieViews[4].play()
            lottieViews[5].play()
        } else {
            gesture.isEnabled = false
            self.viewReactions.isHidden = true
            lottieViews[0].stop()
            lottieViews[1].stop()
            lottieViews[2].stop()
            lottieViews[3].stop()
            lottieViews[4].stop()
            lottieViews[5].stop()
        }
    }
    
    func didSelectRow(completion: (() -> ())) {
        viewReactions(status: false)
        completion()
    }
    
    func reactEmoji(index: Int) {
        self.removeEmojis() {}
        
        globalApis.likeUnlikePost(postId: String.getString(data?.id), isPostLike: true, type: .comment, emojiType: index, postMode: .user, completion: { totalLikes, status,reactions,reactionsCount  in
            //  self.buttonLike.isSelected = status != 0 ? true : false
            self.buttonLike.setTitleColor(status != 0 ? UIColor.init(hexString: "#2E7AC5") : UIColor.init(hexString: "#6E6E73"), for: .normal)
            self.data?.total_likes_count = String.getString(totalLikes)
            self.data?.is_comment_like_by_user = (status != 0)
            //  self.data?.count_reaction_like = reactions
            // self.data?.count_reaction_like_count = reactionsCount
        })
        
        //globalApis.likeUnlikePost(postId: String.getString(data.id), isPostLike: true, type: .post, emojiType: index, completion: { likes, result,reactions,reactionsCount  in
        //            self.data.total_likes_count = String.getString(likes)
        //            self.data.is_post_like = String.getString(result)
        //            self.data.count_reaction_like = reactions
        //            self.data.count_reaction_like_count = reactionsCount
        //            self.footerObj?.updateData()
        //        })
    }
    
    @objc func dismissTapped(_:UITapGestureRecognizer) {
        self.removeEmojis() {}
    }
    
    func removeEmojis(completion: (() -> ())) {
        self.viewReactions(status: false)
    }
    
}

extension CommentTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReply || self.data?.replies.count == 0{
            return 0
        }
        return (self.data?.isReplyExpand  ?? false) ? Int.getInt(self.data?.replies.count) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.data?.isReplyExpand ?? false) == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReplyCommentHeaderCell.identifier, for: indexPath) as! ReplyCommentHeaderCell
            let obj = data?.replies[indexPath.row]
            cell.labelFullName.text = String.getString(obj?.user?.full_name).capitalized
            cell.imageProfile.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj?.user?.profile_pic)),placeholder:#imageLiteral(resourceName: "profile_placeholder"))
            cell.lblReplyCount.text = self.data?.replies.count == 1 ? "\(self.data?.replies.count ?? 0) Reply" : "\(self.data?.replies.count ?? 0) Replies"
            //cell.updateReplyCell(data: data?.replies[indexPath.row] ?? CommentModel(data: [:]), isReply: true)
            cell.layoutIfNeeded()
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTVC.identifier, for: indexPath) as! CommentTVC
            cell.updateReplyCell(data: data?.replies[indexPath.row] ?? CommentModel(data: [:]), isReply: true)
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    //    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //        self.constraintTableViewHeight.constant  = cell.frame.height
    //
    //
    //        //self.tableView.layoutIfNeeded()
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let isExpand = self.data?.isReplyExpand {
            return isExpand ? UITableView.automaticDimension : 65
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let isExpand = self.data?.isReplyExpand else {return }
        if !isExpand {
            self.data?.isReplyExpand = true
            self.tableViewComments.reloadData()
            if let topVC = UIApplication.topViewController() as? ViewPostVC {
                topVC.tableView.reloadData()
                topVC.tableView.beginUpdates()
                topVC.tableView.endUpdates()
                
            }
            self.layoutIfNeeded()
        }
    }
}

class OwnTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
}

extension String {
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
