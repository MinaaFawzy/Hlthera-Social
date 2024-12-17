//
//  ViewPostVC.swift
//  HSN
//
//  Created by Prashant Panchal on 25/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import PhotosUI
import AVKit
import BSImagePicker
import AssetsLibrary
import AssetsPickerViewController
import DPTagTextView
import DropDown
import GiphyUISDK
import ISEmojiView
import FittedSheets

class ViewPostVC: UIViewController {
    
    @IBOutlet weak var postOwnerInfo: UIView!
    @IBOutlet weak var lablePostOwner: UILabel!
    @IBOutlet weak var imagePostOwner: UIImageView!
    @IBOutlet weak var labelPostBy: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textViewComment: DPTagTextView!
    @IBOutlet weak var constraintImageBottom: NSLayoutConstraint!
    //@IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var imageComment: UIImageView!
    @IBOutlet weak var buttonCross: UIButton!
    @IBOutlet weak var constraintImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet var constraintHideRightToolbar: NSLayoutConstraint!
    @IBOutlet var constraintShowRightToolbar: NSLayoutConstraint!
    @IBOutlet weak var viewBottomToolbar: UIView!
    @IBOutlet weak var constraintBottomToolbarHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewRightToolbar: UIStackView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var replyingView: UIView!
    @IBOutlet weak var lbl_replyFrom: UILabel!
    @IBOutlet weak var lbl_replyTo: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    let loader = UIActivityIndicatorView(style: .white)
    
    var commentView: CommentHeaderView?
    var tableViewTagged: UITableView = UITableView()
    var dropDown = DropDown()
    var data: HomeFeedModel?
    var users: [String] = []
    var taggedPeople: [AllUserModel] = []
    var searchPeopleToTag: [AllUserModel] = [] {
        didSet {
            tableViewTagged.reloadData()
        }
    }
    var currentPage = 1
    var totalPage = 1
    var isLoadingList = false
    var totalComment = 0
    var hasCameFrom: HasCameFrom = .homeFeed
    var replyID = ""
    var gifUrl = ""
    var isRelevant = 1
    
    var comments: [CommentModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postOwnerInfo.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor(named: "5")
        // Remove back button text
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0.0 }
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 0.1
        self.commentView = UINib(nibName: "CommentHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? CommentHeaderView
        //labelPostBy.text = String.getString(data?.user_first_name).capitalized + "'s Post"
        
        if let obj = data {
            labelPostBy.text = String.getString(obj.is_company_post ? String.getString(obj.company_detail?.page_name).split(separator: " ").first?.capitalized : obj.user_full_name.split(separator: " ").first?.capitalized) + "'s Post"
            lbl_replyFrom.text = obj.user_full_name
        }
        
        setupCells()
        //setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.imageProfile.kf.setImage(with: URL(string: kBucketUrl + UserData.shared.profile_pic))
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        imageComment.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageComment.contentMode = UIView.ContentMode.scaleAspectFill
        constraintImageHeight.constant = 0
        constraintImageBottom.constant = 0
        buttonCross.isHidden = true
        setupTextView()
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        viewBottomToolbar(isHidden: true)
        setupTaggedTableView()
        viewTaggedTableView(isHidden: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        IQKeyboardManager.shared.enable = false
        getData()
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: .UIResponder.keyboardWillShowNotification, object: nil)
        //            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    
    
    @objc internal func keyboardWillShow(_ notification : Notification?) -> Void {
        
        var _kbSize:CGSize!
        
        if let info = notification?.userInfo {
            
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            
            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                let screenSize = UIScreen.main.bounds
                
                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                print("Your Keyboard Size \(_kbSize)")
                if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_X_MAX {
                    constraintBottom.constant = _kbSize.height-42.5
                }else {
                    constraintBottom.constant = _kbSize.height
                }
                self.view.layoutIfNeeded()
                scrollToBottom(animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        constraintBottom.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func scrollToBottom(animated: Bool) {
        if !comments.isEmpty{
            let indexPath = IndexPath(row: comments.count-1, section: 1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated )
        }
    }
    
    func setupTaggedTableView() {
        self.view.addSubview(tableViewTagged)
        
        tableViewTagged.delegate = self
        tableViewTagged.dataSource = self
        
        // tableViewTagged.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height)
        tableViewTagged.translatesAutoresizingMaskIntoConstraints = false
        self.view.bringSubviewToFront(tableViewTagged)
        let leading = tableViewTagged.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor,constant: 0)
        let trailing = tableViewTagged.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor,constant: 0)
        
        let top = tableViewTagged.topAnchor.constraint(equalTo: tableView.topAnchor,constant: 0)
        let bottom = tableViewTagged.bottomAnchor.constraint(equalTo: tableView.bottomAnchor,constant: 0)
        //  self.tableViewHeight = tableViewTagged.heightAnchor.constraint(equalToConstant: 220)
        NSLayoutConstraint.activate([top,leading,trailing,bottom])
        tableViewTagged.register(UINib(nibName: HomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: HomeSearchTVC.identifier)
        tableViewTagged.tableFooterView = UIView()
    }
    
    func viewTaggedTableView(isHidden: Bool) {
        if isHidden{
            self.tableViewTagged.isHidden = true
        }
        else{
            self.tableViewTagged.isHidden = false
        }
    }
    
    func viewBottomToolbar(isHidden: Bool) {
        if isHidden {
            constraintShowRightToolbar.isActive = false
            constraintHideRightToolbar.isActive = true
            constraintHideRightToolbar.constant = 15
            constraintBottomToolbarHeight.constant = 0
            viewBottomToolbar.isHidden = true
            stackViewRightToolbar.isHidden = false
            //btnSend.isHidden = true
            // cameraButton.isHidden = false
            //   imageProfile.isHidden = true
        } else {
            //btnSend.isHidden = false
            //            constraintShowRightToolbar.isActive = true
            //            constraintHideRightToolbar.isActive = false
            //            constraintShowRightToolbar.constant = 15
            //            constraintBottomToolbarHeight.constant = 50
            //            viewBottomToolbar.isHidden = false
            //            stackViewRightToolbar.isHidden = true
            //            //cameraButton.isHidden = true
            // imageProfile.isHidden = false
        }
    }
    
    func getData() {
        globalApis.getAllComments(postId: String.getString(data?.id), page: 1, filter: isRelevant, postMode: data?.postMode ?? .user){ comments,lastPage,totalComments,status,totalLikes in
            self.tableView.refreshControl?.endRefreshing()
            print(comments.count)
            self.comments = comments
            self.totalPage = lastPage
            self.currentPage = 1
            self.totalComment = totalComments
            self.data?.total_likes_count = totalLikes
            self.data?.is_post_like = String.getString(status)
            self.tableView.reloadData()
            if let prevc = self.navigationController?.previousViewController() as? JBTabBarController {
                if let homeVC = prevc.viewControllers?[0] as? HomeVC {
                    homeVC.updateData()
                }
            }
        }
    }
    
    @objc func refresh(_ sender:UIRefreshControl){
        getData()
    }
    
    func setupTextView() {
        textViewComment.dpTagDelegate = self
        //textViewComment.dpTagDelegate = self // set DPTagTextViewDelegate Delegate
        textViewComment.setTagDetection(false) // true :- detecte tag on tap , false :- Search Tags using mentionSymbol & hashTagSymbol.
        textViewComment.mentionSymbol = "@" // Search start with this mentionSymbol.
        //textViewComment.hashTagSymbol = "#" // Search start with this hashTagSymbol for hashtagging.
        textViewComment.allowsHashTagUsingSpace = true // Add HashTag using space
        textViewComment.textViewAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                              NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 14)!] // set textview defult text Attributes
        textViewComment.mentionTagTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "3")!,
                                                    NSAttributedString.Key.backgroundColor: UIColor.clear,
                                                    NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Medium", size: 14)!] // set textview mentionTag text Attributes
        textViewComment.hashTagTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "3")!,
                                                 NSAttributedString.Key.backgroundColor: UIColor.clear,
                                                 NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 14)!] // set textview hashTag text Attributes
        //Set pre text and tags
        //Clear textview
        textViewComment.setPlaceholder()
    }
    
    func setupCells() {
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableView.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableView.register(UINib(nibName: CommentTVC.identifier, bundle: nil), forCellReuseIdentifier: CommentTVC.identifier)
        tableView.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableView.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonImageTapped(_ sender: Any) {
        ImagePickerHelper.shared.showBSPickerController(limit: 1){data in
            if let assets = data as? [PHAsset] {
                for asset in assets{
                    let fileName = asset.value(forKey: "filename")
                    let fileUrl = URL(string: fileName as! String)
                    if let name = fileUrl?.deletingPathExtension().lastPathComponent {
                        print(name)
                    }
                    if ((fileUrl?.absoluteString.hasSuffix("GIF")) != nil) {
                        
                    } else {
                        self.imageComment.image = asset.getAssetThumbnail()
                    }
                    self.buttonCross.isHidden = false
                    self.constraintImageBottom.constant = 15
                    self.constraintImageHeight.constant = 125
                    self.imageComment.isHidden = false
                    self.imageComment.tag = 1
                }
            }
            if let image = data as? UIImage {
                print(image)
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                self.imageComment.image = image
                self.buttonCross.isHidden = false
                self.constraintImageBottom.constant = 15
                self.constraintImageHeight.constant = 125
                self.imageComment.isHidden = false
                self.imageComment.tag = 1
            }
            self.gifUrl = ""
        }
    }
    
    @IBAction func tap_GifBtn(_ sender: Any) {
        let giphy = GiphyViewController()
        giphy.mediaTypeConfig = [.gifs]
        giphy.theme = GPHTheme(type: .lightBlur)
        giphy.stickerColumnCount = GPHStickerColumnCount.four
        giphy.showConfirmationScreen = false
        giphy.rating = .ratedPG13
        GiphyViewController.trayHeightMultiplier = 0.7
        giphy.delegate = self
        present(giphy, animated: true, completion: nil)
    }
    
    func hideImageDialog() {
        self.buttonCross.isHidden = true
        self.constraintImageBottom.constant = 0
        self.constraintImageHeight.constant = 0
        self.imageComment.image = nil
        self.imageComment.isHidden = true
        self.imageComment.tag = 0
    }
    
    @IBAction func buttonEmojiTapped(_ sender: UIButton) {
        self.emojiKeyboard()
    }
    
    @IBAction func buttonCrossTapped(_ sender: Any) {
        hideImageDialog()
    }
    
    @IBAction func buttonTagPeopleTapped(_ sender: Any) {
        viewTaggedTableView(isHidden: false)
        textViewComment.insertText("@")
        textViewComment.becomeFirstResponder()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelReplyAction(_ sender: Any) {
        self.replyingView.isHidden = true
        self.replyID = ""
    }
    
    @IBAction func buttonPostCommentTapped(_ sender: Any) {
        
        if textViewComment.text.isEmpty && textViewComment.text.isEmpty && imageComment.image == nil && gifUrl.isEmpty {
            CommonUtils.showToast(message: "Please Enter Comment")
            return
        } else {
            globalApis.commentOnPostApi(postId: String.getString(data?.id), comment: String.getString(textViewComment.text),
                                        tagPeople: self.taggedPeople.map{$0.id}.joined(separator: ","),
                                        media: imageComment.tag == 0 ? [] : imageComment.image ?? UIImage(),isReplyId: self.replyID, gif: gifUrl, postMode: data?.postMode ?? .user) { [weak self] comments in
                guard let self = self else { return }
                self.textViewComment.text = ""
                self.replyID = ""
                globalApis.getAllComments(postId: String.getString(self.data?.id), page: 1, filter: self.isRelevant, postMode: self.data?.postMode ?? .user) { [weak self] comments, lastPage, totalComments, status, totalLikes in
                    guard let self = self else { return }
                    self.totalPage = lastPage
                    self.isLoadingList = false
                    print(comments.count)
                    self.data?.total_comments_count = String.getString(comments.count)
                    self.comments = comments
                    self.totalComment = totalComments
                    self.currentPage = 1
                    self.hideImageDialog()
                    self.textViewComment.setText("", arrTags: [])
                    self.textViewComment.checkPlaceholder()
                    self.data?.total_likes_count = totalLikes
                    self.data?.is_post_like = String.getString(status)
                    self.viewTaggedTableView(isHidden: true)
                    self.viewBottomToolbar(isHidden: true)
                    self.view.endEditing(true)
                    self.replyingView.isHidden = true
                    self.textViewComment.text = nil
                    self.textViewComment.inputView = nil
                    self.imageComment.image = nil
                    if let prevc = self.navigationController?.previousViewController() as? JBTabBarController {
                        if let homeVC = prevc.viewControllers?[0] as? HomeVC {
                            homeVC.updateData()
                        }
                    }
                }
            }
        }
    }
}

extension ViewPostVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewTagged {
            return 1
        } else {
            return 2
        }
        //10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableViewTagged || data?.postMode == .admin {
            return 0
        } else {
            switch section {
            case 0:
                return 0
            case 1:
                return 35
            default: return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView != tableViewTagged {
            if indexPath.row + 1 == self.comments.count {
                if currentPage <= totalPage{
                    self.currentPage += 1
                    globalApis.getAllComments(postId: String.getString(data?.id), page: currentPage, filter: isRelevant,postMode: data?.postMode ?? .user){ comments,lastPage,totalComments,status,totalLikes in
                        print(comments.count)
                        self.isLoadingList = false
                        self.comments.append(comments)
                        self.data?.total_likes_count = totalLikes
                        self.data?.is_post_like = String.getString(status)
                    }
                }
            }
        }
        //        if self.comments.count < self.totalComment && !isLoadingList{
        //            self.isLoadingList = true
        //            self.currentPage = self.currentPage+1
        //
        //        }
    }
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView == tableView{
    //            if (((scrollView.contentOffset.y + scrollView.frame.size.height-50) > scrollView.contentSize.height ){
    //
    //            }
    //        }
    //        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableViewTagged || data?.postMode == .admin {
            return UIView()
        } else {
            return self.createCommentHeaderView(text: isRelevant == 1 ? "Most Relevant" : "All Comments", color: UIColor(named: "5")!,backgroundColor: .white)
            //            switch section{
            //            case 0:
            //                return tableView.createHeaderView(text: "Comments", color: UIColor(named: "5")!)
            //            case 1:
            //                guard let view = commentView else {return UIView()}
            //                view.configure(data: comments[section-1])
            //                return view
            //
            //            default:return UIView()
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewTagged{
            return searchPeopleToTag.count
        } else {
            switch section {
            case 0:
                return 1
            case 1:
                return comments.count
            default:return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewTagged {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchTVC.identifier, for: indexPath) as! HomeSearchTVC
            if searchPeopleToTag.indices.contains(indexPath.row) {
                let obj = searchPeopleToTag[indexPath.row]
                cell.labelUserName.text = obj.full_name.capitalized
                cell.labelProfession.text = obj.employee_type.capitalized.isEmpty ? ("Unkown") : (obj.employee_type.capitalized)
                cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            }
            return cell
        } else {
            switch indexPath.section {
            case 0:
                let obj = data ?? HomeFeedModel(data: [:])
                self.lablePostOwner.text = obj.is_company_post ? String.getString(obj.company_detail?.page_name).capitalized : obj.user_full_name.capitalized

                let url = obj.is_company_post ? String.getString(obj.company_detail?.profile_pic) : obj.user_profile_pic
                if let downloaded =  obj.userProfilePic{
                    self.imagePostOwner.image = downloaded
                }
                else{
                    
                    imagePostOwner.kf.setImage(with: URL(string: kBucketUrl + url),placeholder:#imageLiteral(resourceName: "profile_placeholder"))
                }
                lablePostOwner.isUserInteractionEnabled = true
                
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.isFromComment = true
                cell.parent = self
                cell.configure(type: self.hasCameFrom, on: self, data: obj)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentTVC.identifier, for: indexPath) as! CommentTVC
                let obj = comments[indexPath.row]
                cell.postByUserId = data?.user_id ?? ""
                cell.updateCell(data: obj,isReply: false)
                cell.layoutIfNeeded()
                cell.refreshCallback = {
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
                cell.replyCallback = { replyID in
                    self.textViewComment.text = ""
                    self.textViewComment.becomeFirstResponder()
                    self.replyID = replyID
                    self.lbl_replyTo.text = String.getString(obj.user?.full_name)
                    self.replyingView.isHidden = false
                }
                return cell
            default: break
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewTagged {
            return 50
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewTagged {
            self.textViewComment.addTag(tagText: searchPeopleToTag[indexPath.row].first_name + " " + searchPeopleToTag[indexPath.row].last_name)
            self.taggedPeople.append(searchPeopleToTag[indexPath.row])
            self.tableViewTagged.reloadData()
            viewTaggedTableView(isHidden: true)
        }
    }
    
    
    func createCommentHeaderView(text:String,color:UIColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1),backgroundColor:UIColor = .clear,font:UIFont = UIFont(name: "SFProDisplay-Bold", size: 16)!) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let imageView = UIImageView.init(frame: CGRect(x: 120, y: 10, width: 20, height: 20))
        imageView.image = UIImage.init(named: "arrow_down")
        let labelTitle = UILabel()
        
        headerView.backgroundColor = backgroundColor
        headerView.addSubview(imageView)
        headerView.addSubview(labelTitle)
        let headerButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        headerButton.addTarget(self, action: #selector(openCommentOptionView), for: .touchUpInside)
        headerView.addSubview(headerButton)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,constant: 15),
        ])
        labelTitle.text = text
        labelTitle.font = font
        labelTitle.textColor = color
        return headerView
    }
    
    @objc func openCommentOptionView() {
        
        guard let optionsSheetVC = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: RelevantCommentVC.getStoryboardID()) as? RelevantCommentVC else { return }
        optionsSheetVC.callBack = ({ filter in
            self.isRelevant = filter
            self.getData()
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
        self.navigationController?.present(sheetController, animated: true)
    }
}

extension ViewPostVC : DPTagTextViewDelegate {
    func dpTagTextView(_ textView: DPTagTextView, didChangedTagSearchString strSearch: String, isHashTag: Bool) {
        print("#search",strSearch)
        globalApis.getAllUsers(searchText:strSearch,completion: {
            data in
            self.searchPeopleToTag = data
            self.viewTaggedTableView(isHidden: false)
            
            //            let res = data.map{$0.first_name + " " + $0.last_name}
            //            if res.count > 5{
            //                self.dropDown.dataSource = Array(res.prefix(upTo: 6))
            //            }
            //            else{
            //                self.dropDown.dataSource = res
            //            }
        })
        
        
        //dropDown.anchorView = textViewComment
        //  var dataUsers:[AllUserModel] = []
        
        //        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
        //            self.textViewComment.addTag(tagText: item)
        //
        //            self.taggedPeople.append(dataUsers[index])
        //        }
        //        dropDown.width = textViewComment.frame.width
        //        dropDown.bottomOffset = CGPoint(x: 0, y: 150)
        //        dropDown.show()
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didInsertTag tag: DPTag) {
        print("hello")
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didRemoveTag tag: DPTag) {
        print("hello")
        for (index,tagged) in taggedPeople.enumerated(){
            if tagged.first_name + " " + tagged.last_name == tag.name{
                self.taggedPeople.remove(at: index)
                viewTaggedTableView(isHidden: true)
            }
        }
        
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didSelectTag tag: DPTag) {
        print("hello")
    }
    
    func dpTagTextView(_ textView: DPTagTextView, didChangedTags arrTags: [DPTag]) {
        print("#start")
        
    }
    
    func textViewDidChange(_ textView: DPTagTextView) {
        self.defaultKeyboard()
        textView.checkPlaceholder()
        if textView.text.isEmpty{
            viewTaggedTableView(isHidden: true)
            viewBottomToolbar(isHidden: true)
        }
        else{
            viewBottomToolbar(isHidden: false)
        }
    }
}

extension UITextView{
    
    func setPlaceholder() {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Share your thoughts..."
        placeholderLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)!
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
}
extension ViewPostVC : GiphyDelegate {
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        
        let gifURL : String = "https://media2.giphy.com/media/" + (media.id) + "/giphy.gif"
        
        giphyViewController.dismiss(animated: true, completion: {
            // let imageURL = UIImage.gifImageWithURL(gifUrl: gifURL)
            
            self.imageComment.setGifFromURL(URL.init(string: gifURL)!, customLoader: self.loader)
            self.buttonCross.isHidden = false
            self.constraintImageBottom.constant = 15
            self.constraintImageHeight.constant = 125
            self.imageComment.isHidden = false
            self.imageComment.tag = 1
            self.gifUrl = gifURL
            // self.sendGif(url: gifURL)
        })
    }
    
    func didDismiss(controller: GiphyViewController?) {UIActivityIndicatorView.Style.medium
        // your user dismissed the controller without selecting a GIF.
    }
}

//MARK:- Extension for Emoji Send
extension ViewPostVC : EmojiViewDelegate {
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        self.textViewComment.insertText(emoji)
    }
    
    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        self.textViewComment.inputView = nil
        self.textViewComment.keyboardType = .default
        self.textViewComment.reloadInputViews()
    }
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        self.textViewComment.deleteBackward()
    }
    
    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        self.textViewComment.resignFirstResponder()
        self.textViewComment.inputView = nil
        self.textViewComment.keyboardType = .default
        self.textViewComment.reloadInputViews()
    }
    
    //Keyboard methods
    func emojiKeyboard() {
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        //self.btnEmoji.isSelected = true
        self.textViewComment.inputView = emojiView
        self.textViewComment.reloadInputViews()
        self.textViewComment.becomeFirstResponder()
    }
    
    func defaultKeyboard() {
        //self.chatTextView.resignFirstResponder()
        self.textViewComment.inputView = nil
        self.textViewComment.keyboardType = .default
        self.textViewComment.reloadInputViews()
        self.textViewComment.becomeFirstResponder()
        //self.btnEmoji.isSelected = false
    }
    
}

extension ViewPostVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = tableView.contentOffset.y
        if scrollPos <= 50 {
            self.postOwnerInfo.isHidden = true
        } else {
            self.postOwnerInfo.isHidden = false
        }
    }
}
