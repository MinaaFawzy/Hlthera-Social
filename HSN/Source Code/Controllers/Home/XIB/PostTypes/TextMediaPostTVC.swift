//
//  TextMediaPostTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 27/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import AVKit
import AlignedCollectionViewFlowLayout
import SwiftyGif
import LinkPresentation
import JellyGif
import SDWebImage
import Lottie

class TextMediaPostTVC: UITableViewCell, EmojiDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var leadingHeaderConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet var constraintViewLinkPreviewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTags: UICollectionView!
    @IBOutlet weak var constraintCollectionViewTagsHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet var viewLinkPreview: UIView!
    @IBOutlet weak var viewMainContent: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var stackViewGifs: UIStackView!
    @IBOutlet weak var viewReactions: UIView!
    @IBOutlet var lottieViews: [LottieAnimationView]!
    
    var constraintHeaderShareHeight: NSLayoutConstraint?
    var parent: UIViewController?
    var headerObj: PostHeader?
    var footerObj: PostFooter?
    var data: HomeFeedModel = HomeFeedModel(data: [:])
    var groupData: HSNGroupModel?
    var pageData: CompanyPageModel?
    var isShared: Bool = false
    var isInsights: Bool = false
    var postType: PostTypes = .media
    var hasCameFrom: HasCameFrom = .none
    var gesture: UITapGestureRecognizer = UITapGestureRecognizer()
    var isFromComment = false
    var isPostFromHome: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupHeaderView()
        setupFooterView()
        gesture = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        self.viewMainContent.addGestureRecognizer(self.gesture)
        gesture.isEnabled = false
    }
    
    override func layoutSubviews() {
        setupGifs()
        viewReactions(status: false)
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
        self.removeEmojis() {
            
        }
        globalApis.likeUnlikePost(postId: String.getString(data.id), isPostLike: true, type: .post, emojiType: index, postMode: data.postMode, completion: { [weak self] (likes, result, reactions, reactionsCount)  in
            guard let self = self else { return }
            self.data.total_likes_count = String.getString(likes)
            self.data.is_post_like = String.getString(result)
            self.data.count_reaction_like = reactions
            self.data.count_reaction_like_count = reactionsCount
            self.footerObj?.updateData()
        })
    }
    
    @objc func dismissTapped(_:UITapGestureRecognizer) {
        self.removeEmojis() {}
    }
    
    @IBAction func buttonsReactionTapped(_ sender: UIButton) {
        reactEmoji(index: sender.tag + 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupLinkPreview(urlString: String) {
        
        if let url = URL(string: urlString) {
            var lpView = LPLinkView(url: url)
            if let data = MetaDataCache.retrieve(urlString: urlString) {
                lpView = LPLinkView(metadata: data)
            } else {
                let provider = LPMetadataProvider()
                provider.startFetchingMetadata(for: url, completionHandler: { metaData, error in
                    guard let data = metaData,error == nil else {
                        return
                    }
                    MetaDataCache.cache(metadata: data)
                    DispatchQueue.main.async {
                        lpView.metadata = data
                    }
                })
            }
            
            self.resetLinkPreview()
            self.constraintViewLinkPreviewHeight.constant = 50
            self.viewLinkPreview.isHidden = false
            self.viewLinkPreview.tag = 097
            self.viewLinkPreview.addSubview(lpView)
            lpView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([lpView.leadingAnchor.constraint(equalTo: self.viewLinkPreview.leadingAnchor),lpView.topAnchor.constraint(equalTo: self.viewLinkPreview.topAnchor),lpView.trailingAnchor.constraint(equalTo: self.viewLinkPreview.trailingAnchor),lpView.bottomAnchor.constraint(equalTo: self.viewLinkPreview.bottomAnchor)])
        }
    }
    
    func resetLinkPreview() {
        self.constraintViewLinkPreviewHeight.constant = 0
        self.viewLinkPreview.isHidden = true
        self.viewLinkPreview.subviews.forEach({if $0.tag == 097{$0.removeFromSuperview()}})
    }
    
    func setPostType(dict: [String: Any]) {
        // removeEmojis(){}
        if isShared {
            self.viewContent.isHidden = false
            let view = UINib(nibName: "ViewHeaderShare", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ViewHeaderShare
            view.initialSetup(vc: self.parent ?? UIViewController(), dict: dict, hasCameFrom: self.hasCameFrom, data: self.data, groupData: self.groupData,postType:self.postType)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            viewContent.subviews.forEach{$0.removeFromSuperview()}
            self.viewContent.addSubview(view)
            NSLayoutConstraint.activate([   view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 0),
                                            view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: 0),
                                            view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0),
                                            view.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0) ])
        } else {
            removeHeaderShare(dict: [:])
            switch postType {
            case .text:
                self.viewContent.isHidden = true
            case .media:
                if data.post_pic.isEmpty && data.media == ""{ //by n wed 2 for exlusive post
                    self.viewContent.isHidden = true
                } else {
                    self.viewContent.isHidden = false
                    let view = UINib(nibName: "ViewMedia", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ViewMedia
                    view.initialSetup(data: self.data, vc: self.parent ?? UIViewController(), isShared: isShared)
                    view.translatesAutoresizingMaskIntoConstraints = false
                    viewContent.subviews.forEach{$0.removeFromSuperview()}
                    self.viewContent.addSubview(view)
                    NSLayoutConstraint.activate([
                        view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 0),
                        view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: 0),
                        view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0),
                        view.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0)
                    ])
                }
            case .poll:
                if data.user_poll.isEmpty {
                    self.viewContent.isHidden = true
                } else {
                    self.viewContent.isHidden = false
                    let view = UINib(nibName: "ViewPolls", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ViewPolls
                    view.initialSetup(isShared: isShared, data: self.data, vc: self.parent ?? UIViewController())
                    view.translatesAutoresizingMaskIntoConstraints = false
                    viewContent.subviews.forEach{ $0.removeFromSuperview() }
                    self.viewContent.addSubview(view)
                    NSLayoutConstraint.activate([   view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 0),
                                                    view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: 0),
                                                    view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0),
                                                    view.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0)
                                                ])
                }
            case .findExpert:
                self.viewContent.isHidden = false
                let view = UINib(nibName: "ViewFindExpert", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ViewFindExpert
                view.initialSetup(isShared: isShared, data: self.data, vc: self.parent ?? UIViewController())
                view.translatesAutoresizingMaskIntoConstraints = false
                viewContent.subviews.forEach{$0.removeFromSuperview()}
                self.viewContent.addSubview(view)
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 0),
                    view.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: 0),
                    view.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0),
                    view.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0)
                ])
            case .share:
                print("shareeeee")
            default: print("none")
            }
        }
    }
    
    func setupHeaderShare(dict: [String: Any]) {}
    
    //MARK: Configure Cell
    func configure(type: HasCameFrom, on vc: UIViewController, data obj: HomeFeedModel) {
        if isFromComment {
            viewMainContent.cornerRadius = 0
            viewMainContent.shadowColor = .clear
            self.contentView.backgroundColor = .white
            self.footerObj?.viewBottomLine.isHidden = false
            self.leadingHeaderConstraint.constant = 30
        }
        
        if obj.postMode == .admin {
            let date = Date.init(iso8601String: String.getString(obj.created_at))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            self.headerObj?.lblExclusiveTime.text = "Post on : \(dateFormatter.string(from:date))"
            self.headerObj?.exclusiveHeaderView.isHidden = false
            self.headerObj?.lblExclusiveTitle.text = obj.title
        }
        
        self.parent = vc
        switch Int.getInt(obj.is_post_type) {
        case 7:
            self.updateCell(data: obj, type: .findExpert, cameFrom: type)
        case 6:
            guard let sharedObj = obj.share_post else {return}
            switch Int.getInt(sharedObj.is_post_type){
            case 7:
                self.updateCell(data: sharedObj, type: .findExpert, cameFrom: type)
            case 5:
                self.updateCell(data: sharedObj, type: .poll, cameFrom: type)
            case 1,2,3,4,8:
                self.updateCell(data: sharedObj, type: .media, cameFrom: type)
            case 0:
                self.updateCell(data: sharedObj, type: .text, cameFrom: type)
            default:
                self.updateCell(data: sharedObj, type: .text, cameFrom: type)
            }
        case 5:
            self.updateCell(data: obj, type: .poll, cameFrom: type)
        case 1,2,3,4,8:
            self.updateCell(data: obj, type: .media, cameFrom: type)
        case 0:
            self.updateCell(data: obj, type: .text, cameFrom: type)
        default:
            self.updateCell(data: obj, type: .text, cameFrom: type)
        }
    }
    
    //MARK: Update Data
    func updateCell(
        data obj: HomeFeedModel,
        isSameProfile:Bool = false,
        dict: [String:Any] = [:],
        type: PostTypes,
        isShared: Bool = false,
        cameFrom: HasCameFrom,
        groupData: HSNGroupModel = HSNGroupModel(data: [:]),
        pageData: CompanyPageModel = CompanyPageModel(data: [:]),
        isInsights: Bool = false
    ) {
        self.hasCameFrom = cameFrom
        self.data = obj
        self.isInsights = isInsights
        self.groupData = groupData
        headerObj?.parent = self.parent
        headerObj?.dict = dict
        headerObj?.hasCameFrom = self.hasCameFrom
        headerObj?.data = self.data
        headerObj?.groupData = groupData
        if obj.isSelected {
            self.viewMainContent.borderWidth = 2
            self.viewMainContent.borderColor = UIColor(named: "5")
        } else {
            self.viewMainContent.borderWidth = 0
            self.viewMainContent.borderColor = .clear
        }
        
        footerObj?.parent = self.parent
        footerObj?.data = self.data
        
        
        let readmoreFont = UIFont(name: "SFProDisplay-Regular", size: 11.0)
        let readmoreFontColor = UIColor.lightGray
        self.postType = type
        if isPostFromHome {
            self.labelDescription.text = obj.description
            if obj.description.count > 150 {
                self.labelDescription.numberOfLines = 3
                DispatchQueue.main.async {
                    self.labelDescription.addTrailing(with: "... ", moreText: "see more", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
                }
            }
        } else {
            self.labelDescription.numberOfLines = 0
            self.labelDescription.text = obj.description
        }
        
        
        
        self.isShared = isShared
        setPostType(dict:dict)
        
        let res = checkForUrls(text: obj.description)
        if !res.isEmpty{
            setupLinkPreview(urlString: String.getString(res.first?.absoluteString))
        } else {
            resetLinkPreview()
        }
        if isInsights {
            self.removeHeaderFooterView()
            self.viewMainContent.isUserInteractionEnabled = false
        }
        if obj.hashTag.isEmpty {
            self.collectionViewTags.isHidden = true
            self.constraintCollectionViewTagsHeight.constant = 0
        } else {
            self.collectionViewTags.isHidden = false
            self.constraintCollectionViewTagsHeight.constant = 30
            self.collectionViewTags.reloadData()
        }
    }
    
    func setupHeaderView() {
        let view = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostHeader
        self.viewHeader.addSubview(view)
        view.frame = self.viewHeader.bounds
        self.headerObj = view
        self.headerObj?.onBack = { [weak self] in
            guard let self = self else { return }
            self.parent?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func removeHeaderShare(dict: [String: Any]) {
        self.viewContent.subviews.forEach{$0.removeFromSuperview()}
        self.viewContent.isHidden = true
    }
    
    func removeHeaderFooterView() {
        //        if isInsights{
        //           // self.viewHeader.isHidden = true
        //            let res = self.stackViewMain.arrangedSubviews.filter{$0.tag == 097}
        //            if !res.isEmpty{
        //                res[0].isHidden = true
        //            }
        //        }
    }
    
    func setupFooterView() {
        let footerSubView = UINib(nibName: "PostFooter", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! PostFooter
        let longTap =  UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longTap.minimumPressDuration = 0.5
        longTap.delaysTouchesBegan = true
        longTap.delegate = self
        longTap.numberOfTouchesRequired = 1
        longTap.allowableMovement = 10
        
        self.footerObj = footerSubView
        footerSubView.tag = 097
        footerObj?.buttonLike.addGestureRecognizer(longTap)
        
        viewFooter.addSubview(footerSubView)
        footerSubView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            footerSubView.topAnchor.constraint(equalTo: viewFooter.topAnchor, constant: 0),
            footerSubView.leadingAnchor.constraint(equalTo: viewFooter.leadingAnchor, constant: 0),
            footerSubView.trailingAnchor.constraint(equalTo: viewFooter.trailingAnchor, constant: 0),
            footerSubView.bottomAnchor.constraint(equalTo: viewFooter.bottomAnchor, constant: 0),
        ])
    }
    
    func getEmojiImage(index: Int) -> UIImage {
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
        default: return UIImage()
        }
    }
    
    func getEmojiNames(index: Int) -> String {
        switch index {
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
        default: return "None"
        }
    }
    
    func emojiTapped(btn: UIButton, index: Int) {
        
        removeEmojis(){}
        globalApis.likeUnlikePost(
            postId: String.getString(data.id),
            isPostLike: true,
            type: .post,
            emojiType: index+1,
            postMode: data.postMode,
            completion: { [weak self] (likes, result, reactions, reactionsCount)  in
                guard let self = self else { return }
                self.data.total_likes_count = String.getString(likes)
                self.data.is_post_like = String.getString(result)
                self.data.count_reaction_like = reactions
                self.data.count_reaction_like_count = reactionsCount
                self.footerObj?.updateData()
                
                //self.footerObj?.buttonLike.isSelected = true
                //self.footerObj?.labelLike.text = self.getEmojiNames(index: index)
                //self.footerObj?.buttonLike.setImage(self.getEmojiImage(index: index), for: .selected)
                //self.footerObj?.labelTotalLikes.text = String.getString(self.data.total_likes_count) + " Likes"
            })
    }
    
    func showEmojis(btns: [EmojiButton?], on mainView: UIView) {
        removeEmojis(){}
        let emojiView = UIView()
        let stack = UIStackView()
        emojiView.backgroundColor = .white
        emojiView.tag = 097
        emojiView.restorationIdentifier = "emojisview"
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        emojiView.addSubview(stack)
        btns.indices.forEach {
            stack.addArrangedSubview(btns[$0]?.emojiView() ?? UIView())
            btns[$0]?.tag = $0
        }
        
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        stack.spacing = 5
        emojiView.frame = CGRect(x: self.footerObj?.buttonLike.center.x ?? 0, y: self.footerObj?.stackView.frame.maxY ?? 0, width: 0.0, height: 0.0);
        mainView.addSubview(emojiView)
        
        //emojiView.isHidden = true
        UIView.animate(withDuration: 0.25,delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,animations: {
            NSLayoutConstraint.activate([   emojiView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0),
                                            emojiView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant:-67.5),
                                            stack.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor, constant: 10),
                                            stack.trailingAnchor.constraint(equalTo: emojiView.trailingAnchor, constant: -10),
                                            stack.bottomAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: -5),
                                            stack.topAnchor.constraint(equalTo: emojiView.topAnchor, constant: 5)
                                        ])
            emojiView.layoutIfNeeded()
        })
        
        emojiView.drawShadowEmojis()
        
    }
    
    func removeEmojis(completion: (()->())) {
        self.viewReactions(status: false)
    }
    
    @objc func buttonLongPressed(_ sender:UILongPressGestureRecognizer){
        if sender.state != UIGestureRecognizer.State.ended {
            //When lognpress is start or running
            viewReactions(status: true)
            //showEmojis(btns:[EmojiButton(name: EmojisGifNames.thumbsUp, size: 40,delegate: self)
            //,EmojiButton(name: EmojisGifNames.clap, size: 40,delegate: self),
            //EmojiButton(name: EmojisGifNames.handHeart, size: 40,delegate: self),
            //EmojiButton(name: EmojisGifNames.heart, size: 40,delegate: self),
            //EmojiButton(name: EmojisGifNames.light, size: 40,delegate: self),
            //EmojiButton(name: EmojisGifNames.thinking, size: 40,delegate: self)] , on: self.viewMainContent)
        } else {
            //When lognpress is finish
        }
    }
    
    func setupCollectionView() {
        //let alignedFlowLayout = collectionViewTags?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        //alignedFlowLayout?.horizontalAlignment = .left
        //alignedFlowLayout?.verticalAlignment = .top
        self.collectionViewTags.delegate = self
        self.collectionViewTags.dataSource = self
        self.collectionViewTags.register(UINib(nibName: HashTagsCVC.identifier, bundle: nil), forCellWithReuseIdentifier: HashTagsCVC.identifier)
    }
    
}

extension TextMediaPostTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.hashTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if data.hashTag.indices.contains(indexPath.row){
            let obj = data.hashTag[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagsCVC.identifier, for: indexPath) as! HashTagsCVC
            let text = obj.name.replacingOccurrences(of: "#", with: "")
            cell.buttonTag.setTitle("#" + text, for: .normal)
            cell.callbackTagTapped = {
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewTagVC.getStoryboardID()) as? ViewTagVC else { return }
                vc.tag = obj.name
                vc.tagId = obj.id
                self.parent?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if collectionView == collectionViewTags{
        //return CGSize(width: self.collectionView.frame.width, height: 84)
        //}
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}

class HomePostCVC: UICollectionViewCell {
    
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var pageControl:UIPageControl!
    var count = 0
    
    override func layoutSubviews() {
        pageControl.numberOfPages = count
    }
    
}

extension UITableView {
    func numberOfRowHome(numberofRow count: Int? ,image: UIImage = UIImage(named: "no_data")!) -> Int {
        let noDataImg = UIImageView()
        noDataImg.image = image
        noDataImg.translatesAutoresizingMaskIntoConstraints = false
        if Int.getInt(count) == 0 {
            noDataImg.restorationIdentifier = "nodatafound"
            self.addSubview(noDataImg)
            NSLayoutConstraint.activate([noDataImg.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant:  150),
                                         noDataImg.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),noDataImg.heightAnchor.constraint(equalToConstant: 200),
                                         noDataImg.widthAnchor.constraint(equalToConstant: 200)])
        } else {
            self.subviews.map{ if $0.restorationIdentifier == "nodatafound" {
                $0.removeFromSuperview()
            }}
        }
        return Int.getInt(count)
    }
    
    func numberOfRow(numberofRow count: Int? ,image: UIImage = UIImage(named: "no_data")!) -> Int {
        let noDataImg = UIImageView()
        let view = UIView()
        noDataImg.image = image
        noDataImg.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        if Int.getInt(count) == 0 {
            noDataImg.restorationIdentifier = "nodatafound"
            view.restorationIdentifier = "nodataview"
            self.addSubview(view)
            
            NSLayoutConstraint.activate([view.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant:  0),
                                         view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                                         
                                         view.heightAnchor.constraint(equalTo: self.heightAnchor),
                                         view.widthAnchor.constraint(equalTo: self.widthAnchor)])
            view.addSubview(noDataImg)
            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            NSLayoutConstraint.activate([noDataImg.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant:  0),
                                         noDataImg.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),noDataImg.heightAnchor.constraint(equalToConstant: 200),
                                         noDataImg.widthAnchor.constraint(equalToConstant: 200)])
        }
        else{
            self.subviews.map{ if $0.restorationIdentifier == "nodataview" {
                $0.removeFromSuperview()
            }}
        }
        return Int.getInt(count)
    }
    
    func numberOfRowGIF(numberofRow count:Int? ) -> Int {
        
        let view = UIView()
        
        view.backgroundColor = .clear
        
        do {
            let gif = try UIImage(gifName: "notification.gif")
            DispatchQueue.main.async {
                let imageview = UIImageView(gifImage: gif, loopCount: -1) //Use -1 for infinite loop
                imageview.contentMode = .scaleAspectFit
                imageview.frame = view.bounds
                view.addSubview(imageview)
                
            }
        } catch {
            print(error)
        }
        
        
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        if Int.getInt(count) == 0 {
            
            view.restorationIdentifier = "nodataview"
            
            
            self.addSubview(view)
            
            NSLayoutConstraint.activate([view.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant:  0),
                                         view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                                         
                                         view.heightAnchor.constraint(equalTo: self.heightAnchor),
                                         view.widthAnchor.constraint(equalTo: self.widthAnchor)])
            
        }
        else{
            self.subviews.map{ if $0.restorationIdentifier == "nodataview" {
                $0.removeFromSuperview()
            }}
        }
        return Int.getInt(count)
    }
}

extension UICollectionView {
    func numberOfRow(numberofRow count:Int? ,image:UIImage = UIImage(named: "no_profile_image")!) -> Int {
        let noDataImg = UIImageView()
        noDataImg.image = image
        noDataImg.translatesAutoresizingMaskIntoConstraints = false
        if Int.getInt(count) == 0 {
            noDataImg.restorationIdentifier = "nodatafound"
            self.addSubview(noDataImg)
            NSLayoutConstraint.activate([noDataImg.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant:  0),
                                         noDataImg.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),noDataImg.heightAnchor.constraint(equalToConstant: 200),
                                         noDataImg.widthAnchor.constraint(equalToConstant: 200)])
        }
        else{
            self.subviews.map{ if $0.restorationIdentifier == "nodatafound" {
                $0.removeFromSuperview()
            }}
        }
        return Int.getInt(count)
    }
}

extension UIViewController {
    func downloadPDFFile(string: String) {
        let url = URL(string: string)!
        let fileName = String.getString(url.lastPathComponent)
        
        savePdf(urlString: string, fileName: fileName)
        
    }
    
    func savePdf(urlString: String, fileName: String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "HSN-\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                
                self.moveToPopUp(text: "Document has been saved in Files app", completion: {
                    
                })
                //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
            } catch {
                print("Pdf could not be saved")
                CommonUtils.showToast(message: "Document download failed, please try again")
            }
        }
    }
}

class EmojiButton: UIButton {
    
    var emojiDel: EmojiDelegate?
    var emojiGifName: String = ""
    var btnSize: Int = 35
    var img: SDAnimatedImageView?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    init(name: String, size: Int, delegate: EmojiDelegate){
        super.init(frame:CGRect(x: 0, y: 0, width: size, height: size) )
        emojiGifName = name
        self.btnSize = size
        self.emojiDel = delegate
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    deinit {
        //img = nil
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        //emojiDel = nil
    }
    
    func emojiView() -> UIView {
        let btn = self
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: btnSize, height: btnSize))
        img = SDAnimatedImageView(frame:CGRect(x: 0, y: 0, width: btnSize, height: btnSize) )
        // img = UIImage.gifImageWithName(<#T##String#>)
        
        mainView.addSubview(btn)
        
        
        img?.image = SDAnimatedImage(named: self.emojiGifName + ".gif")
        
        
        //   let gif =  try UIImage(gifName: emojiGifName)
        // let imageview = UIImageView(gifImage: gif, loopCount: -1) //Use -1 for infinite loop
        img?.contentMode = .scaleAspectFit
        //imageview.frame = btn.frame
        img?.frame = btn.frame
        
        //imageview.translatesAutoresizingMaskIntoConstraints = false
        img?.translatesAutoresizingMaskIntoConstraints = false
        
        //mainView.addSubview(imageview)
        mainView.addSubview(img!)
        //            NSLayoutConstraint.activate([imageview.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
        //                                         imageview.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
        //                                         imageview.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
        //                                         imageview.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
        //                                         imageview.heightAnchor.constraint(equalToConstant: btn.frame.height),
        //                                         imageview.widthAnchor.constraint(equalToConstant: btn.frame.width)])
        NSLayoutConstraint.activate([img!.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
                                     img!.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
                                     img!.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
                                     img!.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
                                     img!.heightAnchor.constraint(equalToConstant: btn.frame.height),
                                     img!.widthAnchor.constraint(equalToConstant: btn.frame.width)])
        
        return mainView
    }
    
    func emojiViewWithoutButton() -> UIView {
        //
        //        let btn = self
        //        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: btnSize, height: btnSize))
        //        let img = SDAnimatedImageView(frame: CGRect(x: 0, y: 0, width: btnSize, height: btnSize))
        //
        //        DispatchQueue.main.async {
        //            img.image = SDAnimatedImage(named: self.emojiGifName + ".gif")
        //            img.contentMode = .scaleAspectFit
        //            img.frame = btn.frame
        //            img.translatesAutoresizingMaskIntoConstraints = false
        //            mainView.addSubview(img)
        //            NSLayoutConstraint.activate([img.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
        //                                         img.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
        //                                         img.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
        //                                         img.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
        //                                         img.heightAnchor.constraint(equalToConstant: btn.frame.height),
        //                                         img.widthAnchor.constraint(equalToConstant: btn.frame.width)])
        //        }
        //
        return UIView()
        //return mainView
    }
    
    @objc func tapped(button: UIButton) {
        emojiDel?.emojiTapped(btn: button, index: button.tag)
    }
}

protocol EmojiDelegate {
    func emojiTapped(btn: UIButton, index: Int)
}

struct MetaDataCache {
    
    static func cache(metadata: LPLinkMetadata) {
        // Check if the metadata already exists for this URL
        do {
            guard retrieve(urlString: metadata.url!.absoluteString) == nil else {
                return
            }
            
            // Transform the metadata to a Data object and
            // set requiringSecureCoding to true
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: metadata,
                requiringSecureCoding: true)
            
            // Save to user defaults
            UserDefaults.standard.setValue(data, forKey: metadata.url!.absoluteString)
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
        }
    }
    
    static func retrieve(urlString: String) -> LPLinkMetadata? {
        do {
            // Check if data exists for a particular url string
            guard
                let data = UserDefaults.standard.object(forKey: urlString) as? Data,
                // Ensure that it can be transformed to an LPLinkMetadata object
                let metadata = try NSKeyedUnarchiver.unarchivedObject(
                    ofClass: LPLinkMetadata.self,
                    from: data)
            else { return nil }
            return metadata
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
            return nil
        }
    }
    
}
//MARK: - UILable extension
extension UILabel{
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        if self.visibleTextLength == 0 { return }
        
        let lengthForVisibleString: Int = self.visibleTextLength
        
        if let myText = self.text {
            
            let mutableString: String = myText
            
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: myText.count - lengthForVisibleString), with: "")
            
            let readMoreLength: Int = (readMoreText.count)
            
            guard let safeTrimmedString = trimmedString else { return }
            
            if safeTrimmedString.count <= readMoreLength { return }
            
            print("this number \(safeTrimmedString.count) should never be less\n")
            print("then this number \(readMoreLength)")
            
            // "safeTrimmedString.count - readMoreLength" should never be less then the readMoreLength because it'll be a negative value and will crash
            let trimmedForReadMore: String = (safeTrimmedString as NSString).replacingCharacters(in: NSRange(location: safeTrimmedString.count - readMoreLength, length: readMoreLength), with: "") + trailingText
            
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    }
    
    var visibleTextLength: Int {
        
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        if let myText = self.text {
            
            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: myText, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
            
            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (myText as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: myText.count - index - 1)).location
                    }
                } while index != NSNotFound && index < myText.count && (myText as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
        }
        
        if self.text == nil {
            return 0
        } else {
            return self.text!.count
        }
    }
}
