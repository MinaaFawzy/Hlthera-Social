//
//  PostFooter.swift
//  HSN
//
//  Created by Prashant Panchal on 27/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import SDWebImage
import Lottie
import FittedSheets

class PostFooter: UIView, EmojiDelegate {
    func emojiTapped(btn: UIButton, index: Int) {
         print("hello")
    }
    
    @IBOutlet weak var stackViewEmojis: UIStackView!
    @IBOutlet weak var labelTotalLikes: UILabel!
    @IBOutlet weak var buttonTotalComments: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var buttonTotalPostShares: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewGIF: LottieAnimationView!
    //@IBOutlet  var constraintLikesHide: NSLayoutConstraint!
    @IBOutlet weak var labelLike: UILabel!
    @IBOutlet weak var viewLabels: UIView!
    @IBOutlet weak var viewBottomLine: UIView!
    @IBOutlet var reactions : [UIImageView]!
    
    var likeCallback:(()->())?
    var commentCallback:(()->())?
    var shareCallback:(()->())?
    var sendCallback:(()->())?
    var parent:UIViewController?
    var data:HomeFeedModel?{
        didSet{
            updateData()
        }
    }
   
    func getEmojiGIFNames(index:Int)->String{
        switch index{
        case 0:
            return EmojisGifNames.thumbsUp
        case 1:
            return  EmojisGifNames.clap
        case 2:
            return  EmojisGifNames.handHeart
        case 3:
            return  EmojisGifNames.heart
        case 4:
            return EmojisGifNames.light
        case 5:
            return EmojisGifNames.thinking
        default:return "None"
        }
    }
    
    func getLottieEmojiGIFNames(index:Int)->String{
        switch index{
        case 0:
            return LottieEmojisGifNames.thumbsUp
        case 1:
            return  LottieEmojisGifNames.clap
        case 2:
            return  LottieEmojisGifNames.handHeart
        case 3:
            return  LottieEmojisGifNames.heart
        case 4:
            return LottieEmojisGifNames.light
        case 5:
            return LottieEmojisGifNames.thinking
        default:return "None"
        }
    }
 
    func updateData() {
        if let obj = data {
            self.buttonTotalPostShares.setTitle(String.getString(obj.post_share_count), for: .normal)
            self.buttonLike.isSelected = Int.getInt(obj.is_post_like) != 0 ? true : false
            self.stackViewEmojis.arrangedSubviews.forEach{$0.removeFromSuperview()}
            if !obj.count_reaction_like.isEmpty {
                obj.count_reaction_like.forEach { _ in
                  // let view = EmojiButton(name: getEmojiGIFNames(index: Int.getInt($0)-1), size: 20, delegate: self).emojiViewWithoutButton()
//                    let view = LottieAnimationView(name: getLottieEmojiGIFNames(index: Int.getInt($0)-1))
//
//                    view.play()
//                    view.contentMode = .scaleAspectFill
//                    view.loopMode = .loop
//                    view.animationSpeed = 0.75
//                    view.backgroundColor = .clear

                   //stackViewEmojis.addArrangedSubview(view)
                }
            }
            //Int.getInt(obj.is_post_like) != 1
            if   Int.getInt(obj.is_post_like) != 0{
                viewGIF.isHidden = false
                //obj.image = SDAnimatedImage(named: names[index] + ".gif")
                viewGIF.animation = .named(getLottieEmojiGIFNames(index: Int.getInt(obj.is_post_like)-1))
                viewGIF.contentMode = .scaleAspectFill
                viewGIF.loopMode = .loop
                viewGIF.animationSpeed = 0.75
                viewGIF.play()
                //viewEmoji.heightAnchor.constraint(equalToConstant: btn.frame.height),
                //viewEmoji.widthAnchor.constraint(equalToConstant: btn.frame.width)
                buttonLike.isHidden = false
                self.buttonLike.isSelected ? (self.buttonLike.setImage((UIImage()), for: .selected)) : ()
            } else {
                viewGIF.stop()
                viewGIF.isHidden = true
                buttonLike.isHidden = false
                self.buttonLike.isSelected ? (self.buttonLike.setImage(getEmojiImage(index: Int.getInt(obj.is_post_like)-1), for: .selected)) : ()
            }
            
            self.buttonLike.isSelected ? (self.labelLike.text = getEmojiNames(index: Int.getInt(obj.is_post_like)-1)) : (self.labelLike.text = "Like")
            if Int.getInt(obj.total_likes_count) == 0{
                labelTotalLikes.isHidden = true
            } else {
                labelTotalLikes.isHidden = false
            }
            if Int.getInt(obj.total_comments_count) == 0{
                buttonTotalComments.isHidden = true
            } else {
                buttonTotalComments.isHidden = false
            }
            if Int.getInt(obj.post_share_count) == 0{
                buttonTotalPostShares.isHidden = true
            } else {
                buttonTotalPostShares.isHidden = false
            }
            if Int.getInt(obj.total_likes_count) == 0 && Int.getInt(obj.total_comments_count) == 0 && Int.getInt(obj.post_share_count) == 0 {
               self.viewLabels.isHidden = true
            } else{
                self.viewLabels.isHidden = false
            }
            var headerEmojis:[ReactionsHeaderModel] = []
            for (index,val) in obj.count_reaction_like.enumerated() {
                headerEmojis.append(ReactionsHeaderModel(isSelected: false, count: obj.count_reaction_like_count[index], image: getEmojiImage(index: Int.getInt(val)-1), name:val))
            }
            
            //? "Like" : "Likes"
            let likes = Int.getInt(obj.total_likes_count) <= 1
            let comments = Int.getInt(obj.total_comments_count) <= 1 ? "Comment" : "Comments"
            self.labelTotalLikes.text = obj.total_likes_count
            self.buttonTotalComments.setTitle(obj.total_comments_count, for: .normal)
           
            //Hide all reaction initally
            for reaction in reactions {
                reaction.isHidden = true
            }
            
            for (index, like_type) in obj.likeType.enumerated() {
                reactions[index].isHidden = false
                reactions[index].image = getEmojiImage(index: like_type-1)
            }
        }
    }
    
 
    @IBAction private func buttonEmojisTapped(_ sender: Any) {
        showReactionListView()
//        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ReactionsListVC.getStoryboardID()) as? ReactionsListVC else { return }
//        vc.data = self.data
//
//        if let nav = self.parent{
//
//            nav.navigationController?.present(vc, animated: true)
//        }
//        else{
//
//            let navigationController = navv
//            navigationController?.present(vc, animated: true)
//
//        }
    }
    
    func showReactionListView() {
            guard let optionsSheetVC = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ReactionsListVC.getStoryboardID()) as? ReactionsListVC else { return }
            
            if let vc = optionsSheetVC as? ReactionsListVC {
                vc.data = self.data
            }
            let options = SheetOptions(
                pullBarHeight: 24, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
            )

           let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.marginFromTop(100)], options: options)
            sheetController.allowGestureThroughOverlay = false
            sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
            sheetController.minimumSpaceAbovePullBar = 0
            sheetController.treatPullBarAsClear = false
            sheetController.autoAdjustToKeyboard = false
            sheetController.dismissOnOverlayTap = true
            

            // Disable the ability to pull down to dismiss the modal
            sheetController.dismissOnPull = true
           // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())
            if let nav = self.parent{
                nav.navigationController?.present(sheetController, animated: true)
            }
            else{
                let navigationController = navv
                navigationController?.present(sheetController, animated: true)
            }
           // self.navigationController?.present(sheetController, animated: false, completion: nil)

    }
    
    
    
    @IBAction private func buttonLikeTapped(_ sender: UIButton) {
        globalApis.likeUnlikePost(postId: String.getString(data?.id), isPostLike: !sender.isSelected, type: .post, emojiType: 1, postMode: data?.postMode ?? .user, completion: { likes, result,reacions,reactionsCount in
            self.data?.total_likes_count = String.getString(likes)
        
            self.data?.is_post_like = String.getString(result)
            self.data?.count_reaction_like  = reacions
            self.data?.count_reaction_like_count = reactionsCount
            
//            sender.isSelected = result != 0 ? true : false
//            self.labelLike.text = "Like"
//            self.buttonLike.setImage(self.getEmojiImage(index:0), for: .selected)
//            self.labelTotalLikes.text = String.getString(self.data?.total_likes_count) + " Likes"
//            if Int.getInt(self.data?.total_likes_count) == 0{
//                self.labelTotalLikes.isHidden = true
//            }
//            else{
//                self.labelTotalLikes.isHidden = false
//            }
            self.updateData()
        })
    }
    
    @IBAction private func buttonCommentTapped(_ sender: Any) {
        for controller in  self.parent?.navigationController?.viewControllers ?? []{
            if controller.isKind(of: ViewPostVC.self){
                return
            }
        }
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewPostVC.getStoryboardID()) as? ViewPostVC else { return }
        vc.data = data
        if let nav = self.parent{
            vc.modalPresentationStyle = .fullScreen
            nav.navigationController?.present(vc, animated: true)
      
        }
        else{
            let navigationController = navv
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
      
        }
    }
    
    @IBAction func buttonShareTapped(_ sender: Any) {
//        for controller in  self.parent?.navigationController?.viewControllers ?? []{
//            if controller.isKind(of: CreatePostVC.self){
//                return
//            }
//        }
        
        if data?.postMode == .admin {
            openCommentOptionView()
        }else{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreatePostVC.getStoryboardID()) as? CreatePostVC else { return }
            vc.shareData = data
            vc.isShare = true
            vc.findExpertTitle = String.getString(data?.question)
            vc.city = String.getString(data?.city_name)
            vc.state = String.getString(data?.state_name)
            vc.country = String.getString(data?.country_name)
            if let nav = self.parent{
                nav.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let navigationController = navv
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBAction func buttonSendTapped(_ sender: Any) {
        sendCallback?()
    }
    
    func openCommentOptionView() {
        
        guard let optionsSheetVC = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: RelevantCommentVC.getStoryboardID()) as? RelevantCommentVC else { return }
        optionsSheetVC.isAdmin = true
        optionsSheetVC.callBack = ({ type in
            self.sharePost(type)
        })

        let options = SheetOptions(
            pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
        )

       let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.fixed(250)], options: options)
        sheetController.allowGestureThroughOverlay = false
        sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = false
        sheetController.autoAdjustToKeyboard = false
        sheetController.dismissOnOverlayTap = true

        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = true
        self.parent?.navigationController?.present(sheetController, animated: true)
    }
    

    func sharePost(_ shareType : Int){
        let url = ServiceName.admin_share_post
        let params = [
            "type" : shareType,
           // ApiParameters.description:String.getString(data?.description),
            ApiParameters.hashTag:"",
            ApiParameters.postType:data?.title,
            "find_expert_title" : data?.title,
            ApiParameters.tagPeople:"",
            ApiParameters.is_post_type:8,
            ApiParameters.share_with:1,
            ApiParameters.post_id : data?.id ?? "",
            "city_name" : "",
            "state_name" : "",
            "country_name" : ""] as [String : Any]
    
        
            globalApis.sharePost(params, completion: {
                dictResult in
                
            })
        
        
    }
}
    

//Some common method
func getEmojiNames(index:Int)->String{
    switch index{
    case 0:
        return "Like"
    case 1:
        return  "Clap"
    case 2:
        return  "Support"
    case 3:
        return  "Love"
    case 4:
        return "Interesting"
    case 5:
        return "Thinking"
    default:return "None"
    }
}

func getEmojiImage(index:Int)->UIImage{
    switch index{
    case 0:
        return UIImage(named: "post_liked")!
    case 1:
        return UIImage(named: EmojisNames.clap)!
    case 2:
        return UIImage(named: EmojisNames.handHeart)!
    case 3:
        return UIImage(named: EmojisNames.heart)!
    case 4:
        return UIImage(named: EmojisNames.light)!
    case 5:
        return UIImage(named: EmojisNames.thinking)!
    default:return UIImage()
    }
}
