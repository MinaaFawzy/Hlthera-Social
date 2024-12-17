//
//  CreatePostVC.swift
//  HSN
//
//  Created by Prashant Panchal on 04/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import DropDown
import AssetsPickerViewController
import SVProgressHUD
import FittedSheets
import LocalAuthentication
import LinkPresentation
import IQKeyboardManagerSwift

class CreatePostVC: UIViewController, MediaSelection {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonPostVisibility: UIButton!
    @IBOutlet weak var collectionViewPeople: UICollectionView!
    @IBOutlet weak var constraintPeopleHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewMedia: UICollectionView!
    @IBOutlet weak var constraintMediaHeight: NSLayoutConstraint!
    //@IBOutlet weak var collectionViewHashTags: UICollectionView!
    //@IBOutlet weak var constraintHashTagHeight: NSLayoutConstraint!
    @IBOutlet weak var textFieldHashTags: IQTextView!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonTagPeople: UIButton!
    @IBOutlet weak var viewPostType: UIView!
    @IBOutlet weak var buttonPostType: UIButton!
    @IBOutlet weak var tableViewSharePost: UITableView!
    @IBOutlet weak var constraintTableViewSharePostHeight: NSLayoutConstraint!
    @IBOutlet weak var labelTotalMediaCount: UILabel!
    @IBOutlet weak var viewMediaCount: UIView!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var viewLinkPeview: UIView!
    @IBOutlet weak var constraintLinkHeight: NSLayoutConstraint!
    
    var hasCameFrom:HasCameFrom = .createPost
    var sheetController:SheetViewController?
    var bottomSheetVC: UIViewController = UIViewController()
    var hashTags: [String] = []
    var media: [Any] = []
    var postTypes: [String] = []
    var dropDown = DropDown()
    var selectedVisibility = 0
    var selectedPostType = 0
    var findExpertPostType = "Fitness"
    var findExpertHashTags = ""
    var country = ""
    var state = ""
    var city = ""
    var findExpertDescription = ""
    var findExpertTitle = ""
    var isCelebration = false
    var isStory = false
    var celebrationId = -1
    var celebrationImgUrl = ""
    var recipientsId = ""
    var usersId = ""
    var taggedPeople: [AllUserModel] = []
    var bottomSheetDelegate: BottomSheet?
    var selectedIndex = 0
    var shareData: HomeFeedModel?
    var isShare: Bool = false
    var isFindExpert:Bool = false
    var groupId = ""
    var groupName = ""
    var currentMediaIndex = 1
    var editData: HomeFeedModel?
    var editedPictureIds: [String] = []
    var oldUrl: URL?
    var pageName = ""
    var pageId = ""
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        textView.text = kSharedUserDefaults.getPostDraft()
        constraintLinkHeight.constant = 0
        viewLinkPeview.isHidden = true
        //setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setStatusBar()
        textView.delegate = self
        hideInitialThings()
        getPostTypes()
        self.viewMediaCount.isHidden = true
        self.imageProfile.kf.setImage(with: URL(string: kBucketUrl + UserData.shared.profile_pic),placeholder:#imageLiteral(resourceName: "profile_placeholder"))
        self.labelName.text = UserData.shared.full_name.capitalized
        setupShare()
        setupCollectionViews()
        switch hasCameFrom {
        case .createPost, .findExpert, .sharePost:
            self.buttonPostVisibility.isUserInteractionEnabled = true
        case .editPost, .editGroupPost, .editPagePost:
            self.labelPageTitle.text = "Edit Post"
            self.buttonPostVisibility.isUserInteractionEnabled = true
            fillEditData()
        case .createGroupPost:
            self.buttonPostVisibility.isUserInteractionEnabled = false
            self.buttonPostVisibility.setTitle(groupName, for: .normal)
            self.buttonPostVisibility.setImage(#imageLiteral(resourceName: "make_group_admin"), for: .normal)
        case .createPagePost:
            self.buttonPostVisibility.isUserInteractionEnabled = false
            self.buttonPostVisibility.setTitle(pageName, for: .normal)
            self.buttonPostVisibility.setImage(#imageLiteral(resourceName: "make_group_admin"), for: .normal)
        default: break
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
   }
    
    // Handle "Done" button tap
    @objc func doneButtonTapped() {
        // Hide the keyboard or perform other actions here
        view.endEditing(true)
    }
    
    func fillEditData() {
        if let obj = self.editData {
            switch Int.getInt(obj.share_with) {
            case 1:
                self.buttonPostVisibility.setTitle("Anyone", for: .normal)
                //self.buttonPostVisibility.setImage(image, for: .normal)
                self.selectedVisibility = 0
            case 2:
                self.buttonPostVisibility.setTitle("Connections only", for: .normal)
                //self.buttonPostVisibility.setImage(image, for: .normal)
                self.selectedVisibility = 1
            case 3:
                self.buttonPostVisibility.setTitle("Group", for: .normal)
                //self.buttonPostVisibility.setImage(image, for: .normal)
                self.selectedVisibility = 3
            case 4:
                self.buttonPostVisibility.setTitle("No one", for: .normal)
                //self.buttonPostVisibility.setImage(image, for: .normal)
                self.selectedVisibility = 2
            default: break
            }
            self.textView.text = obj.description
            self.hashTags = obj.hashTag.map{$0.name}
            self.taggedPeople = obj.tag_people
            self.usersId = taggedPeople.map{$0.id}.joined(separator: ",")
            if !obj.postType.isEmpty && obj.postType != "Select Type of Post" {
                self.buttonPostType.setTitle(obj.postType, for: .normal)
                self.buttonPostType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonPostType.tag = 1
            }
            self.media = obj.post_pic.map { URL(string: kBucketUrl + $0.picture) }
            var postType = 0
            self.textFieldHashTags.text = obj.hashTag.map{$0.name}.joined(separator: " ")
            if !obj.post_pic.isEmpty{
                postType = getPostType(url: URL(string: kBucketUrl + String.getString(obj.post_pic.first?.picture))!)
                self.labelTotalMediaCount.text = "\(Int(currentMediaIndex) ?? 0)/\(media.count)"
                self.viewMediaCount.isHidden = false
            }
            self.selectedPostType = postType
            if media.contains(where: {
                $0 is UIImage
            }) && media.contains(where: {
                $0 is URL
            }) {
                bottomSheetDelegate?.refreshBottomSheet(type: 1)
            } else {
                bottomSheetDelegate?.refreshBottomSheet(type: postType)
            }
            //bottomSheetDelegate?.refreshBottomSheet(type: postType)
            if selectedPostType != 0{
                sheetController?.setSizes([.percent(0.15), .fixed(CGFloat(100))])
            }
            buttonShare.isHidden = false
            buttonTagPeople.isHidden = false
            viewPostType.isHidden = false
            self.groupId = obj.group_id
            self.constraintMediaHeight.constant = 300
            self.collectionViewMedia.isHidden = false
            self.editedPictureIds = Array(repeating: "#", count:media.count)
            // self.collectionViewMedia.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [weak self] in
                guard let self = self else { return }
                self.collectionViewMedia.reloadData()
                self.collectionViewPeople.reloadData()
            })
        }
    }
    
    func getPostType(url: URL) -> Int {
        switch getMediaType(urlString: "", url: url) {
        case 1:
            return 1
        case 2:
            return 3
        case 3:
            return 2
        default: return 0
        }
    }
    
    func setupShare() {
        if isShare {
            constraintTableViewSharePostHeight.constant = 500
            tableViewSharePost.isHidden = false
            tableViewSharePost.reloadData()
            self.constraintMediaHeight.constant = 0
            self.selectedPostType = 6
            self.tableViewSharePost.isUserInteractionEnabled = false
        }
        else if isFindExpert {
            constraintTableViewSharePostHeight.constant = 500
            tableViewSharePost.isHidden = false
            tableViewSharePost.reloadData()
            self.constraintMediaHeight.constant = 0
            self.selectedPostType = 7
            self.tableViewSharePost.isUserInteractionEnabled = false
            self.viewPostType.isHidden = true
            self.buttonPostType.tag = 1
            self.buttonPostType.setTitle(findExpertPostType, for: .normal)
            self.textView.text = findExpertDescription
            self.textFieldHashTags.text = findExpertHashTags
        } else {
            constraintTableViewSharePostHeight.constant = 0
            tableViewSharePost.isHidden = true
            self.constraintMediaHeight.constant = 0
            setupBottomSheet2(percent: 0.2)
            sheetController?.resize(to: .percent(0.2))
            bottomSheetDelegate?.refreshBottomSheet(type: selectedPostType)
        }
        tableViewSharePost.delegate = self
        tableViewSharePost.dataSource = self
        tableViewSharePost.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableViewSharePost.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableViewSharePost.isHidden = false
        //  tableViewSharePost.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableViewSharePost.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        tableViewSharePost.register(UINib(nibName: FindExpertTVC.identifier, bundle: nil), forCellReuseIdentifier: FindExpertTVC.identifier)
    }
    
    func getMediaType(urlString: String = "", url fileURL: URL) -> Int{
        let imageExtensions = ["png", "jpg", "gif","jpeg"]
        let documentExtensions = ["pdf","rtf","txt"]
        var url: URL?
        if urlString.isEmpty{
            url = fileURL
        }
        else{
            url = NSURL(fileURLWithPath: urlString) as URL
        }
        let pathExtention = url?.pathExtension
        if imageExtensions.contains(pathExtention!)
        {
            return 1
        }
        else if documentExtensions.contains(pathExtention!)
        {
            return 2
        }
        else
        {
            return 3
        }
    }
    
    func selectedMedia(fileUrl: Any = "", postType: Int, image: UIImage = UIImage(), id: Int = -1, other: String) {
        
        switch postType {
        case 1:
            if media.count < 5 {
                media.append(fileUrl)
            } else {
                CommonUtils.showToast(message: "Maximum Photos Limit is 5")
                return
            }
            self.isCelebration = false
        case 2:
            if media.count < 5 {
                if media.filter{ !($0 is UIImage) }.filter { checkVideo(url: $0 as! URL) }.count > 0 {
                    CommonUtils.showToast(message: "Maximum Video Limit is 1")
                    return
                } else {
                    media.append(fileUrl)
                }
            } else {
                CommonUtils.showToast(message: "Maximum Media Limit is 5")
                return
            }
            self.isCelebration = false
        case 3:
            if media.count < 5 {
                media.append(fileUrl)
            } else {
                CommonUtils.showToast(message: "Maximum Documents Limit is 5")
                return
            }
            self.isCelebration = false
        case 4:
            media.removeAll()
            self.celebrationId = Int.getInt(celebrationId) + 1
            self.celebrationImgUrl = fileUrl as? String ?? ""
            media.append(image)
            //media.append(fileUrl)
            self.isCelebration = true
            self.recipientsId = other
        case 5:
            media.removeAll()
            media.append(fileUrl)
            self.isStory = true
            createStory()
        default:
            break
        }
        buttonShare.isHidden = false
        buttonTagPeople.isHidden = false
        viewPostType.isHidden = false
        selectedPostType = postType
        self.viewMediaCount.isHidden = false
        self.labelTotalMediaCount.text = "\(Int(currentMediaIndex) ?? 0)/\(media.count)"
        
        //bottomSheetDelegate?.refreshBottomSheet(type: postType)
        if media.contains(where: {
            $0 is UIImage
        }) && media.contains(where: {
            $0 is URL
        }){
            bottomSheetDelegate?.refreshBottomSheet(type: 1)
        }
        
        else{
            bottomSheetDelegate?.refreshBottomSheet(type: postType)
        }
        sheetController?.setSizes([.percent(0.15), .fixed(CGFloat(100))])
        
        self.constraintMediaHeight.constant = 300
        self.collectionViewMedia.isHidden = false
        self.collectionViewMedia.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.collectionViewMedia.reloadData()
        })
        self.editedPictureIds.append("0")
        //        let res = bottomSheetVC.view.constraints.filter{$0.firstAttribute == .height || $0.secondAttribute == .height
        //        }
        //        if !res.isEmpty && res.indices.contains(0){
        //             res[0].constant = 75
        //        }
        //[.percent(0.15), .fixed(CGFloat(height))]
        // sheetController?.resize(to: .fixed(50))
    }
    
    func checkVideo(url: URL) -> Bool{
        let imageExtensions = ["png", "jpg", "gif","jpeg"]
        let documentExtensions = ["pdf"]
        let pathExtention = url.pathExtension
        if imageExtensions.contains(pathExtention)
        {
            return false
        }
        else if documentExtensions.contains(pathExtention)
        {
            return false
        }else
        {
            return true
        }
    }
    
    func editCelebration(){
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateOccassionVC.getStoryboardID()) as? CreateOccassionVC else { return }
        vc.occassionType = self.celebrationId - 1
        vc.parentVC = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editData(at index: Int) {
        if isCelebration{
            editCelebration()
        } else {
            ImagePickerHelper.shared.showPickerController( {image in
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                if self.hasCameFrom == .editPost || self.hasCameFrom == .editGroupPost || self.hasCameFrom == .editPagePost{
                    self.editedPictureIds[index] = self.editData?.post_pic[index].id ?? ""
                }
                self.media[index] = image as! UIImage
                
                self.collectionViewMedia.reloadData()
            })
        }
        
    }
    
    func deleteData(at index: Int) {
        if currentMediaIndex < media.count {
            self.labelTotalMediaCount.text = "\(Int(currentMediaIndex))/\(media.count-1)"
        } else if currentMediaIndex == media.count {
            currentMediaIndex = currentMediaIndex - 1
            self.labelTotalMediaCount.text = "\(Int(currentMediaIndex))/\(media.count-1)"
        } else {
            self.labelTotalMediaCount.text = "\(Int(index+1))/\(media.count-1)"
        }
        self.media.remove(at: index)
        if hasCameFrom == .editPost || hasCameFrom == .editGroupPost || hasCameFrom == .editPagePost{
            deleteMediaApi(id: Int.getInt(editData?.post_pic[index].id))
            self.editedPictureIds[index] = "#"
            
        }
        if editedPictureIds.indices.contains(index){
            editedPictureIds.remove(at: index)
        }
        self.collectionViewMedia.reloadData()
        if media.isEmpty{
            currentMediaIndex = 1
            viewMediaCount.isHidden = true
            collectionViewMedia.isHidden = true
            if isCelebration{
                self.media = []
                self.isCelebration = false
                self.selectedPostType = 0
                bottomSheetDelegate?.refreshBottomSheet(type: 0)
                sheetController?.setSizes([.percent(0.15), .fixed(CGFloat(475))])
            }else{
                hideInitialThings()
                self.selectedPostType = 0
                bottomSheetDelegate?.refreshBottomSheet(type: 0)
                sheetController?.setSizes([.percent(0.15), .fixed(CGFloat(475))])
                
            }
        }
        else{
            
            viewMediaCount.isHidden = false
            collectionViewMedia.isHidden = false
        }
        
    }
    
    func setupBottomSheet2(height: Int = 475, percent: Float = 0.15) {
        textFieldHashTags.delegate = self
        bottomSheetVC = self.storyboard?.instantiateViewController(withIdentifier: CreatePostBottomSheetVC.getStoryboardID()) as! CreatePostBottomSheetVC
        if let vc = bottomSheetVC as? CreatePostBottomSheetVC {
            vc.myProtocal = self
            vc.parentVC = self
            vc.currentTotalImages = media.count
            self.bottomSheetDelegate = vc
            vc.hasCameFrom = self.hasCameFrom
            vc.groupId = self.groupId
            vc.companyId = self.pageId
        }
        let options = SheetOptions(
            pullBarHeight: 0, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: true
        )
        sheetController = SheetViewController(controller: bottomSheetVC, sizes: [.percent(percent), .fixed(CGFloat(height))], options: options)
        sheetController?.allowGestureThroughOverlay = true
        sheetController?.overlayColor = .clear
        sheetController?.minimumSpaceAbovePullBar = 0
        sheetController?.treatPullBarAsClear = true
        sheetController?.autoAdjustToKeyboard = false
        sheetController?.dismissOnOverlayTap = false
        // Disable the ability to pull down to dismiss the modal
        sheetController?.dismissOnPull = false
        sheetController?.animateIn(to: self.view, in: self)
    }
    
    func hideInitialThings() {
        buttonShare.isHidden = false
        collectionViewMedia.isHidden = false
        self.constraintMediaHeight.constant = 0
        buttonTagPeople.isHidden = false
        viewPostType.isHidden = false
    }
    
    func setupCollectionViews() {
        collectionViewMedia.register(UINib(nibName: PhotoCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCVC.identifier)
        collectionViewMedia.register(UINib(nibName: VideoCVC.identifier, bundle: nil), forCellWithReuseIdentifier: VideoCVC.identifier)
        collectionViewMedia.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellWithReuseIdentifier: DocumentVC.identifier)
        // collectionViewHashTags.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellWithReuseIdentifier: DocumentVC.identifier)
        collectionViewPeople.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellWithReuseIdentifier: DocumentVC.identifier)
        collectionViewPeople.register(UINib(nibName: NameCVC.identifier, bundle: nil), forCellWithReuseIdentifier: NameCVC.identifier)
        
    }
    
    func leaveAlert() {
        let alert = UIAlertController(title: "Save this post as a draft?", message: "If you discard now, you'll lose this post.", preferredStyle: UIAlertController.Style.alert)
        let saveDraftButton = UIAlertAction(title: "Save Draft", style: .default) { _ in
            kSharedUserDefaults.setPostDraft(postDraft: self.textView.text)
            self.leaveScreen()
        }
        let DiscardPostButton = UIAlertAction(title: "Discard Post" , style: .default) { _ in
            kSharedUserDefaults.setPostDraft(postDraft: "")
            self.leaveScreen()
        }
        DiscardPostButton.setValue(UIColor.red, forKey: "titleTextColor")
       
        let continueEditingButton = UIAlertAction(title: "Continue editing", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        alert.addAction(saveDraftButton)
        alert.addAction(DiscardPostButton)
        alert.addAction(continueEditingButton)
        
        
        self.present(alert, animated: true)
    }
    func leaveScreen() {
        for controller in self.navigationController?.viewControllers ?? [] {
            if controller.isKind(of: JBTabBarController.self) {
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    open override func viewWillAppear(_ animated: Bool) {
        
        if isCelebration{
            self.setupCollectionViews()
            buttonShare.isHidden = false
            buttonTagPeople.isHidden = false
            viewPostType.isHidden = false
            bottomSheetDelegate?.refreshBottomSheet(type: 6)
            
            //            let res = bottomSheetVC.view.constraints.filter{$0.firstAttribute == .height || $0.secondAttribute == .height
            //            }
            //            if !res.isEmpty && res.indices.contains(0){
            //                 res[0].constant = 0
            //            }
            
            sheetController?.setSizes([.percent(0.15), .fixed(CGFloat(100))])
            //self.media = [ddd]
            if media.isEmpty {
                self.constraintMediaHeight.constant = 0
            }
            else{
                self.constraintMediaHeight.constant = 300
            }
            self.collectionViewMedia.reloadData()
        }
    }
    
    @IBAction private func buttonBackTapped(_ sender: Any) {
        if textView.text == "" {
            for controller in self.navigationController?.viewControllers ?? [] {
                if controller.isKind(of: JBTabBarController.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            leaveAlert()
        }
        
    }
    
    @IBAction private func buttonTagPeopleTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectRecipientVC.getStoryboardID()) as? SelectRecipientVC else { return }
        vc.parentVC = self
        vc.hasCameFrom = .tagPeople
        vc.callback = { people in
            self.usersId = people.map{$0.id}.joined(separator: ",")
            self.taggedPeople = people
            self.collectionViewPeople.isHidden = false
            self.collectionViewPeople.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonPostVisibilityTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectPostVisiblityPopUpVC.getStoryboardID()) as? SelectPostVisiblityPopUpVC else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selected = self.selectedVisibility
        vc.callback = { [weak self] index, name, image in
            guard let self = self else { return }
            self.buttonPostVisibility.setTitle(name, for: .normal)
            self.buttonPostVisibility.setImage(image, for: .normal)
            self.selectedVisibility = index
        }
        vc.groupCallback = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: {
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectGroupVC.getStoryboardID()) as? SelectGroupVC else { return }
                vc.callback = { [weak self] group,selected in
                    guard let self = self else { return }
                    if selected {
                        self.groupId = group.group_id
                        self.buttonPostVisibility.setTitle(group.group?.name, for: .normal)
                        self.buttonPostVisibility.setImage(#imageLiteral(resourceName: "make_group_admin"), for: .normal)
                        self.selectedVisibility = 3
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        self.navigationController?.present(vc, animated: true)
        
    }
    
    @IBAction func buttonPostTypeTapped(_ sender: Any) {
        self.buttonPostType.setTitle("Select type of post", for: .normal)
        self.buttonPostType.setTitleColor(UIColor(named: "4"), for: .normal)
        self.buttonPostType.tag = 0
        showDropDown(on: self.navigationController, for: postTypes, completion: { value, index in
            self.buttonPostType.setTitle(value, for: .normal)
            self.buttonPostType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonPostType.tag = 1
        })
        //        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
        //            return
        //        }
        //        vc.items = postTypes
        //        vc.callback = {
        //            value,index in
        //            self.dismiss(animated: true){ [self] in
        //
        //                buttonPostType.setTitle(value, for: .normal)
        //                buttonPostType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //                buttonPostType.tag = 1
        //            }
        //
        //        }
        //        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonShareTapped(_ sender: Any) {
        if media.isEmpty && !isShare || media.isEmpty && !isFindExpert{
            self.selectedPostType = 0
        }
        if media.isEmpty && isShare{
            self.selectedPostType = 6
        }
        if media.isEmpty && isFindExpert{
            self.selectedPostType = 7
        }
        //        if buttonPostType.tag == 0{
        //            CommonUtils.showToast(message: "Please Select Post Type")
        //            return
        //        }
        if String.getString(textView.text).isEmpty {
            CommonUtils.showToast(message: "Please enter description")
            return
        }
        else{
            createPost()
            kSharedUserDefaults.setPostDraft(postDraft: "")
        }
    }
    
}

extension CreatePostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.viewMediaCount.isHidden = false
        let x = scrollView.contentOffset.x/scrollView.bounds.width
        currentMediaIndex  = Int(x + 1)
        self.labelTotalMediaCount.text = "\(Int(currentMediaIndex) ?? 0)/\(media.count)"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if collectionView == collectionViewHashTags{
        //            hashTags.count > 0 ? (self.collectionViewHashTags.isHidden = false) : ( self.collectionViewHashTags.isHidden = true)
        //            hashTags.count > 0 ? (constraintHashTagHeight.constant = CGFloat(hashTags.count * 50)) : (constraintHashTagHeight.constant = 0)
        //            return hashTags.count
        //
        //
        //        }
        if collectionView == collectionViewMedia {
            if media.count > 0 {
                self.collectionViewMedia.isHidden = false
            } else {
                self.collectionViewMedia.isHidden = true
                constraintMediaHeight.constant = 0
            }
            return media.count
        }
        else if collectionView == collectionViewPeople {
            if taggedPeople.count > 0{
                self.collectionViewPeople.isHidden = false
                constraintPeopleHeight.constant = CGFloat(50)
            } else {
                self.collectionViewPeople.isHidden = true
                self.constraintPeopleHeight.constant = 0
            }
            return taggedPeople.count
        }
        else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewMedia{
            let obj = media[indexPath.row]
            if obj is UIImage{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
                cell.imageMedi.image = obj as? UIImage ?? UIImage()
                cell.editCallback = { [self] in
                    editData(at: indexPath.row)
                }
                cell.deleteCallback = { [self] in
                    deleteData(at: indexPath.row)
                    
                }
                cell.imageMedi.setupImageViewer()
                return cell
            }
            else if obj is URL
            {
                switch getMediaType(urlString: "",url:obj as! URL){
                case 1:
                    let url = obj as! URL
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
                    //  cell.imageMedi.downlodeImage(serviceurl: url as? String ?? "", placeHolder: #imageLiteral(resourceName: "cover_page_placeholder"))
                    
                    cell.imageMedi.kf.setImage(with: url,placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: { data in
                        cell.imageMedi.setupImageViewer()
                    })
                    
                    
                    cell.editCallback = { [self] in
                        editData(at: indexPath.row)
                    }
                    cell.deleteCallback = { [self] in
                        deleteData(at: indexPath.row)
                    }
                    cell.imageMedi.setupImageViewer()
                    return cell
                case 2:
                    let url = obj as! URL
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentVC.identifier, for: indexPath) as! DocumentVC
                    cell.labelFileName.text = String.getString(url.lastPathComponent)
                    cell.deleteCallback = { [self] in
                        deleteData(at: indexPath.row)
                    }
                    return cell
                case 3:
                    let url = obj as! URL
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
                    VideoPickerHelper.shared.thumbnil(url: url, completionClosure: {
                        image in
                        cell.imageMedi.image = image
                    })
                    cell.editCallback = { [self] in
                        VideoPickerHelper.shared.showVideoController(maxlength: 600){ (videoUrl, videoData,duration) -> (Void) in
                            print(videoUrl,videoData)
                            if duration <= 600{  var image:UIImage = UIImage()
                                
                                VideoPickerHelper.shared.thumbnil(url:videoUrl! , completionClosure: {imageThumbnail in
                                    image = imageThumbnail ?? UIImage()
                                })
                                if self.hasCameFrom == .editPost || self.hasCameFrom == .editGroupPost{
                                    self.editedPictureIds.append(self.editData?.post_pic[indexPath.row].id ?? "")
                                }
                                self.media[indexPath.row] = videoUrl
                                self.collectionViewMedia.isHidden = false
                                
                                self.collectionViewMedia.reloadData()
                            }else{
                                CommonUtils.showToast(message: "Video Length is too long, Select another video")
                                return
                            }
                        }
                    }
                    cell.deleteCallback = { [self] in
                        deleteData(at: indexPath.row)
                    }
                    return cell
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocumentVC.identifier, for: indexPath) as! DocumentVC
                    return cell
                }
            }
            else{
                return UICollectionViewCell()
            }
        }
        else if collectionView == collectionViewPeople{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameCVC.identifier, for: indexPath) as! NameCVC
            let obj = taggedPeople[indexPath.row]
            cell.labelName.text = obj.full_name.capitalized
            cell.deleteCallback = {
                self.taggedPeople.remove(at: indexPath.row)
                self.collectionViewPeople.reloadData()
                if self.taggedPeople.isEmpty{
                    self.collectionViewPeople.isHidden = true
                    self.constraintPeopleHeight.constant = 0
                }
            }
            self.constraintPeopleHeight.constant = self.collectionViewPeople.contentSize.height
            return cell
        }
        else{
            return UICollectionViewCell()
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 0
        if media.indices.contains(indexPath.row){
            let data = media[indexPath.row]
            if data is UIImage{
                height = 300
            }
            else if data is URL{
                switch getMediaType(urlString: "",url:data as! URL){
                case 1:
                    height = 300
                case 2:
                    height = 84
                    self.viewMediaCount.isHidden = true
                    self.collectionViewMedia.isScrollEnabled = true
                    self.constraintMediaHeight.constant = CGFloat(84*media.count)
                case 3:
                    height = 300
                default: height = 300
                }
            }
        }
        if collectionView == collectionViewMedia{
            return CGSize(width: self.collectionViewMedia.frame.width, height: CGFloat(height))
        }
        else if collectionView == collectionViewPeople{
            return CGSize(width: self.collectionViewPeople.frame.width/2.05, height: 50)
        }
        else{
            return CGSize(width: 0, height: 0)
        }
    }
    
}

extension CreatePostVC {
    
    func createPost(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var url = ""
        var params:[String:Any] = [:]
        var temp = selectedVisibility
        //        if selectedVisibility == 3{
        //            selectedVisibility = 2
        //
        //        }
        //        else if selectedVisibility == 2 && temp == 2{
        //            selectedVisibility = 3
        //        }
        var tags = String.getString(textFieldHashTags.text).split(separator: " ")
        tags = tags.map{$0}
        if isCelebration{
            url = ServiceName.addCeleration
            params = [
                ApiParameters.description:String.getString(textView.text),
                ApiParameters.hashTag:tags.joined(separator: ","),
                ApiParameters.postType:buttonPostType.tag == 0 ? ("") : (String.getString(buttonPostType.titleLabel?.text)),
                ApiParameters.tagPeople:usersId,
                ApiParameters.is_post_type:String.getString(selectedPostType),
                ApiParameters.share_with: selectedVisibility == 2 ? String.getString(4) : (selectedVisibility == 3 ? (String.getString(selectedVisibility)) : (String.getString(selectedVisibility + 1))) ,
                ApiParameters.recipient_id:recipientsId,
                ApiParameters.celebrate_type:String.getString(celebrationId),
                ApiParameters.img_url:self.celebrationImgUrl
            ]
            if hasCameFrom == .createGroupPost || selectedVisibility == 3{
                params[ApiParameters.group_id] = groupId
            }
        }
        else{
            url = ServiceName.addPost
            params = [
                ApiParameters.description:String.getString(textView.text),
                ApiParameters.hashTag:tags.joined(separator: ","),
                ApiParameters.postType:buttonPostType.tag == 0 ? ("") : (String.getString(buttonPostType.titleLabel?.text)),
                ApiParameters.tagPeople:usersId,
                ApiParameters.is_post_type:String.getString(selectedPostType),
                ApiParameters.share_with:selectedVisibility == 2 ? String.getString(4) : (selectedVisibility == 3 ? (String.getString(selectedVisibility)) : (String.getString(selectedVisibility + 1))),
            ]
            if isShare{
                params[ApiParameters.post_id] = String.getString(shareData?.share_post?.id).isEmpty ? (String.getString(shareData?.id)) : (String.getString(shareData?.share_post?.id))
            }
            if isFindExpert{
                params[ApiParameters.country_name] = country
                params[ApiParameters.state_name] = state
                params[ApiParameters.city_name] = city
                params[ApiParameters.find_expert_title] = findExpertTitle
            }
            if hasCameFrom == .createGroupPost || selectedVisibility == 3{
                params[ApiParameters.group_id]  = groupId
            }
            
        }
        if hasCameFrom == .editPost || hasCameFrom == .editGroupPost || selectedVisibility == 3 || hasCameFrom == .editPagePost{
            params[ApiParameters.id]  = editData?.id
            params[ApiParameters.posted_picture_ids] = editedPictureIds
        }
        //        if hasCameFrom == .editPagePost{
        //
        //        }
        if hasCameFrom == .createPagePost{
            params[ApiParameters.company_id] = pageId
            
            params[ApiParameters.is_company_post] = "1"
        }
        else{
            params[ApiParameters.is_company_post] = "0"
        }
        
        var images:[[String:Any]] = []
        var documents:[[String:Any]] = []
        var videos:[String:Any] = [:]
        
        for data in media{
            if data is UIImage{
                images.append(["imageName":ApiParameters.mediaUpload,"image":(data as? UIImage ?? UIImage()).resized(withPercentage: 0.4, isOpaque: true)])
            }
            else if data is URL{
                switch getMediaType(urlString: "",url:data as! URL){
                case 1:
                    print("not valid")
                case 2:
                    if let obj = data as? URL{
                        if obj.isFileURL{
                            documents.append(["documentName":ApiParameters.mediaUpload,"document":data])
                        }
                    }
                case 3:
                    
                    videos = [ApiParameters.kvideo : data, ApiParameters.kvideoName : ApiParameters.mediaUpload]
                default: print("not valid")
                }
            }
        }
        
        NetworkManager.shared.requestMultiParts(serviceName: url, method: .post, arrImages: images, video: videos,document: documents,  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    CommonUtils.showHudWithNoInteraction(show: false)
                    CommonUtils.showToast(message: "Post created successfully")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        kSharedAppDelegate?.moveToHomeScreen()
                    })
                    
                default:
                    CommonUtils.showHudWithNoInteraction(show: false)
                    showAlertMessage.alert(message: "Something went wrong. Please try again")
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getPostTypes(){
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.type_of_post,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["type_of_post"])
                    self.postTypes = data.map{String.getString(kSharedInstance.getDictionary($0)["name"])}
                    
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func deleteMediaApi(id: Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.id:String.getString(id)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.delete_post_picture,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    print(String.getString(dictResult["message"]))
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func createStory(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        if !pageId.isEmpty{
            params[ApiParameters.company_id] = pageId
            params[ApiParameters.is_company_post] = "1"
        }
        var images:[[String:Any]] = []
        var documents:[[String:Any]] = []
        var videos:[String:Any] = [:]
        for data in media{
            if data is UIImage{
                images.append(["imageName":ApiParameters.mediaUpload,"image":data])
            }
            else if data is URL{
                switch getMediaType(urlString: "",url:data as! URL){
                case 1:
                    print("not valid")
                case 2:
                    documents.append(["documentName":ApiParameters.mediaUpload,"document":data])
                case 3:
                    videos = [ApiParameters.kvideo : data, ApiParameters.kvideoName : ApiParameters.mediaUpload]
                default: print("not valid")
                }
            }
        }
        
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.add_story, method: .post, arrImages: images, video: videos,document: documents,  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["type_of_post"])
                    if self?.hasCameFrom == .createGroupPost{
                        self?.navigationController?.popViewController(animated: true)
                    }
                    else{
                        kSharedAppDelegate?.moveToHomeScreen()
                    }
                    
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}

class ResizableButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        //labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right + 45, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        
        return desiredButtonSize
    }
}

extension CreatePostVC: UIDocumentPickerDelegate {
    
    func showDocumentPicker() {
        let types: [String] = self.returnAlldoctType()
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .pageSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func returnAlldoctType() ->[String] {
        return ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key", "public.item", "public.content", "public.audiovisual-content",  "public.audiovisual-content",  "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content"]
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pdfUrl = urls.first else { return  }
        let _ = pdfUrl.startAccessingSecurityScopedResource()
        let data = try! Data.init(contentsOf: pdfUrl)
        print(pdfUrl,data)
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

// extension CreatePostVC: AssetsPickerViewControllerDelegate {
//    
//    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
//    func assetsPickerDidCancel(controller: AssetsPickerViewController) {}
//    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
//        // do your job with selected assets
//        print(assets)
//        for asset in assets{
//           // PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { (image, info) in
//                               // Do something with image
//           
//            self.myProtocal?.selectedMedia(fileUrl: asset.getAssetThumbnail(),postType: 1,image: asset.getAssetThumbnail(),id: -1,other: "")
//                      //     }
//            
//        }
//    }
//    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {}
//    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
//}

extension CreatePostVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFindExpert {
            return 1
        } else {
            if let obj = shareData {
                return 1
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = shareData ?? HomeFeedModel(data: [:])
        let sharedObj = obj.share_post ?? HomeFeedModel(data: [:])
        switch isFindExpert ? 7 : Int.getInt(obj.is_post_type){
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: FindExpertTVC.identifier, for: indexPath) as! FindExpertTVC
            cell.labelTitle.text = findExpertTitle
            cell.labelDescription.text = city + "," + state + "," + country
            cell.labelType.text = "Recommendation needed"
            return cell
        case 6:
            switch Int.getInt(obj.share_post?.is_post_type){
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: FindExpertTVC.identifier, for: indexPath) as! FindExpertTVC
                cell.labelTitle.text = findExpertTitle
                cell.labelDescription.text = city + "," + state + "," + country
                cell.labelType.text = "Recommendation needed"
                
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                
                cell.updateCell(data: sharedObj, type: .poll, isShared:false, cameFrom: self.hasCameFrom)
                cell.parent = self
                
                return cell
            case 1,2,3,4:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: sharedObj, type: .media, isShared:false,cameFrom: self.hasCameFrom)
                cell.parent = self
                //cell.viewFooter.isHidden = true
                //cell.constraintFooterHeight.constant = 0
                return cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: sharedObj, type: .text,isShared:false,cameFrom: self.hasCameFrom)
                cell.parent = self
                //cell.viewFooter.isHidden = true
                //cell.constraintFooterHeight.constant = 0
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: sharedObj, type: .text, isShared: false,cameFrom: self.hasCameFrom)
                cell.parent = self
                //cell.viewFooter.isHidden = true
                //cell.constraintFooterHeight.constant = 0
                return cell
            }
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
            
            cell.updateCell(data: obj, type: .poll,cameFrom: self.hasCameFrom)
            cell.parent = self
            //            cell.viewFooter.isHidden = true
            //            cell.constraintFooterHeight.constant = 0
            
            return cell
        case 1, 2, 3, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
            cell.updateCell(data: obj, type: .media,cameFrom: self.hasCameFrom)
            cell.parent = self
            //            cell.viewFooter.isHidden = true
            //            cell.constraintFooterHeight.constant = 0
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
            cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom)
            cell.parent = self
            //            cell.viewFooter.isHidden = true
            //            cell.constraintFooterHeight.constant = 0
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
            cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom)
            cell.parent = self
            cell.isShared = false
            //            cell.viewFooter.isHidden = true
            //            cell.constraintFooterHeight.constant = 0
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(UITableView.automaticDimension)
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        constraintTableViewSharePostHeight.constant = cell.frame.height
    }
    
}

extension CreatePostVC {
    
    func setupBottomSheet() {
        bottomSheetVC = self.storyboard?.instantiateViewController(withIdentifier: CreatePostBottomSheetVC.getStoryboardID()) as! CreatePostBottomSheetVC
        if let vc = bottomSheetVC as? CreatePostBottomSheetVC {
            vc.myProtocal = self
            vc.parentVC = self
            vc.currentTotalImages = media.count
            self.bottomSheetDelegate = vc
        }
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        bottomSheetVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomSheetVC.view.bottomAnchor, multiplier: 1.0),
                                     bottomSheetVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0),
                                     bottomSheetVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0),
                                     bottomSheetVC.view.heightAnchor.constraint(equalToConstant: 450)])
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView1(_:)))
        bottomSheetVC.view.isUserInteractionEnabled = true
        bottomSheetVC.view.addGestureRecognizer(panGesture)
        let up = UISwipeGestureRecognizer(target: self, action: #selector(dragView))
        up.direction = .up
        let down = UISwipeGestureRecognizer(target: self, action: #selector(dragView))
        down.direction = .down
        //bottomSheetVC.view.addGestureRecognizer(up)
        //bottomSheetVC.view.addGestureRecognizer(down)
        print("\n#",bottomSheetVC.view.center.y)
        textFieldHashTags.delegate = self
    }
    
    @objc func dragView1(_ sender:UIPanGestureRecognizer) {
        //     self.view.bringSubview(toFront: viewDrag)
        let translation = sender.translation(in: self.view)
        if bottomSheetVC.view.center.y <= self.view.frame.height{
            bottomSheetVC.view.center.y = bottomSheetVC.view.center.y + translation.y
        } else {
            print("\n#",bottomSheetVC.view.center.y)
        }
        //        sender.setTranslation(CGPoint.zero, in: self.view)
        print("\n#!",bottomSheetVC.view.center.y)
        print("\n#@",self.view.frame.height)
    }
    
    @objc func dragView(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            let res = bottomSheetVC.view.constraints.filter{ $0.firstAttribute == .height || $0.secondAttribute == .height }
            if !res.isEmpty && res.indices.contains(0) {
                switch selectedPostType {
                case 0:
                    res[0].constant = 450
                case 1:
                    res[0].constant = 100
                case 2:
                    res[0].constant = 100
                case 3:
                    res[0].constant = 100
                case 4:
                    res[0].constant = 100
                case 5:
                    res[0].constant = 100
                case 6:
                    res[0].constant = 100
                default:
                    break
                }
            }
        case .down:
            let res = bottomSheetVC.view.constraints.filter{$0.firstAttribute == .height || $0.secondAttribute == .height
            }
            if !res.isEmpty && res.indices.contains(0) {
                res[0].constant = 75
            }
        default: break
        }
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseIn]) {
            self.bottomSheetVC.view.layoutIfNeeded()
        }
    }
    
}

extension CreatePostVC: UITextViewDelegate {
    
    func resetLinkPreview() {
        constraintLinkHeight.constant = 0
        viewLinkPeview.isHidden = true
    }
    
    func setupLinkPreview(url: URL) {
        for views in viewLinkPeview.subviews {
            if views.tag == 097 {
                views.removeFromSuperview()
            }
        }
        constraintLinkHeight.constant = 50
        viewLinkPeview.isHidden = false
        
        let linkPreview = LPLinkView(url: url)
        linkPreview.translatesAutoresizingMaskIntoConstraints = false
        linkPreview.tag = 097
        self.viewLinkPeview.addSubview(linkPreview)
        NSLayoutConstraint.activate([linkPreview.leadingAnchor.constraint(equalTo: self.viewLinkPeview.leadingAnchor),linkPreview.topAnchor.constraint(equalTo: self.viewLinkPeview.topAnchor),linkPreview.trailingAnchor.constraint(equalTo: self.viewLinkPeview.trailingAnchor),linkPreview.bottomAnchor.constraint(equalTo: self.viewLinkPeview.bottomAnchor)])
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url, completionHandler: { [weak self] (metaData, error) in
            guard let data = metaData, error == nil else { return }
            DispatchQueue.main.async { linkPreview.metadata = data }
        })
    }
    
    func detectLink(text: String) {
        let input = String.getString(text)
        let res = checkForUrls(text: input)
        if !res.isEmpty {
            setupLinkPreview(url: res.first!)
        } else {
            resetLinkPreview()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //detectLink(text: textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        detectLink(text: textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = NSString(string: textView.text).replacingCharacters(in: range, with: text)
        if text == "\n" {
            //chatTextView.resignFirstResponder()
            if !(textView.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                textView.text = textView.text + "\n"
                return false
            } else {
                textView.resignFirstResponder()
            }
        }
        return true
    }
    
}

extension UIViewController {
    func checkForUrls(text: String) -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
            return matches.compactMap({ $0.url })
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return []
    }
}

extension UITableViewCell {
    func checkForUrls(text: String) -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
            return matches.compactMap({ $0.url })
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return []
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
