//
//  ScheduledLoungesVC.swift
//  HSN
//
//  Created by Prashant Panchal on 19/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets

class ScheduledLoungesVC: UIViewController {

    @IBOutlet weak var noDataImageView: UIImageView!
    @IBOutlet weak var constraintTableTop: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var listTypeSegment: UISegmentedControl!
    @IBOutlet weak var createdButton: UIButton!
    @IBOutlet weak var scheduledForYouButton: UIButton!
    
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var observerRef:DatabaseReference?
    var roomId = ""
    var isSearching = false
    var myLounges:[RoomModel] = [] {
        didSet{
            for item in self.myLounges {
                if item.id == UserData.shared.id {
                    self.myCreatedLounges.append(item)
                }
            }
            tableView.reloadData()
        }
    }
    var myCreatedLounges:[RoomModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var myLoungesSearchResults:[RoomModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var isManageRooms = false
    var isViewAll = false
    var showCreatedList:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        let text = self.searchBar.textField
        self.viewSearch.isHidden = true
        setupTableCell()
        //setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setStatusBar()//(color: UIColor(hexString: "F5F7F9"))
        setupFirebase {}
//        setupSegmentTitilesColor()
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObservers()
    }
    
    func setupTableCell() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: LoungeScheduledTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeScheduledTVC.identifier)
        tableView.register(UINib(nibName: LoungeHomeTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeHomeTVC.identifier)
        tableView.register(UINib(nibName: CreatedLoungeTVC.identifier, bundle: nil), forCellReuseIdentifier: CreatedLoungeTVC.identifier)
        
    }
    
    func setupSegmentTitilesColor() {
        let selectedSegment = [NSAttributedString.Key.foregroundColor: UIColor.white]
        listTypeSegment.setTitleTextAttributes(selectedSegment, for: .selected)
        let unselectedSegment = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#8794AA")]
        listTypeSegment.setTitleTextAttributes(unselectedSegment, for: .normal)
        
    }
    
    func getLoungeTypeImage(type:String)->UIImage{
        switch type{
        case "public":
            return UIImage(named: "lounge_type_public1")!
            //UIImage(named: "sl_public")!
        case "private":
            return UIImage(named: "lounge_type_private1")! //UIImage(named: "sl_private")!
        case "connections","connection":
            return UIImage(named: "lounge_type_connections1")! // UIImage(named: "sl_connection")!
        default:
            return UIImage()
        }
    }

    func setupFirebase(completion:@escaping ()->()){
        self.mainRef = rootRef.child("usertouser")
        self.roomsRef = mainRef?.child("rooms")
        //self.currentRoomRef = roomsRef?.child(roomId)
        roomsRef?.observe(.value) { [self] (snap) in
                    print(snap.value,"SNAP VALUE")
            //&& $0.roomId == self.roomId
            if self.isViewAll{
                self.myLounges = kSharedInstance.getDictionary(snap.value).values.map{RoomModel(data: kSharedInstance.getDictionary($0))}.sorted{ $0.createdAt > $1.createdAt }

            }
            else{
                self.myLounges = kSharedInstance.getDictionary(snap.value).values.map{RoomModel(data: kSharedInstance.getDictionary($0))}.sorted{ $0.createdAt > $1.createdAt }
//                    .filter{self.isManageRooms ? ($0.id == UserData.shared.id) : ($0.id == UserData.shared.id)}
            }
        }
    }
    
    func removeObservers(){
        roomsRef?.removeAllObservers()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if isSearching{
            self.viewSearch.isHidden = true
            self.isSearching = false
            self.view.endEditing(true)
            self.btnBack.setImage(UIImage(named: "back_white"), for: .normal)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.viewSearch.isHidden = false
            self.isSearching = true
            self.constraintTableTop.constant = 55
            self.searchBar.becomeFirstResponder()
        }
        else{
            self.viewSearch.isHidden = true
            self.isSearching = false
            self.constraintTableTop.constant = 5
            self.view.endEditing(true)
        }
        self.tableView.reloadData()
        
    }
    
    @IBAction func listTypeSegmentTapped(_ sender: Any) {
//        for i in 0...(listTypeSegment.subviews.count - 1)  {
//            if i == listTypeSegment.selectedSegmentIndex {
//                listTypeSegment.subviews[i].backgroundColor = UIColor(named: "5")
//            } else {
//                listTypeSegment.subviews[i].backgroundColor = UIColor(hexString: "#F5F7F9")
//            }
//        }
        tableView.reloadData()
    }
    
    @IBAction func createdLoungeListButtonTapped(_ sender: UIButton) {
        showCreatedList = true
        createdButton.backgroundColor = UIColor(named: "5")
        createdButton.setTitleColor(.white, for: .normal)
        scheduledForYouButton.backgroundColor = UIColor(hexString: "#F5F7F9")
        scheduledForYouButton.setTitleColor(UIColor(hexString: "#8794AA"), for: .normal)
        tableView.reloadData()
        tableView.allowsSelection = false
    }
    
    @IBAction func scheduledLoungesButtonTapped(_ sender: Any) {
        showCreatedList = false
        scheduledForYouButton.backgroundColor = UIColor(named: "5")
        scheduledForYouButton.setTitleColor(.white, for: .normal)
        createdButton.backgroundColor = UIColor(hexString: "#F5F7F9")
        createdButton.setTitleColor(UIColor(hexString: "#8794AA"), for: .normal)
        tableView.reloadData()
        tableView.allowsSelection = true
    }
}
extension ScheduledLoungesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showCreatedList {
            noDataImageView.isHidden = !myCreatedLounges.isEmpty
            return myCreatedLounges.count
        } else {
            if isSearching{
                noDataImageView.isHidden = !myLoungesSearchResults.isEmpty
                return myLoungesSearchResults.count
            }
            else{
                noDataImageView.isHidden = !myLounges.isEmpty
                return myLounges.count
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if isViewAll {
        //
        //
        //            let cell = tableView.dequeueReusableCell(withIdentifier: LoungeHomeTVC.identifier, for: indexPath) as! LoungeHomeTVC
        //            var obj:RoomModel = RoomModel(data: [:])
        //            if isSearching{
        //                 obj = myLoungesSearchResults[indexPath.row]
        //            }
        //            else{
        //                 obj = myLounges[indexPath.row]
        //            }
        //
        //            cell.labelLoungeName.text = obj.category
        //            cell.labelType.text = obj.type.capitalized
        //            cell.labelLoungeDescription.text = obj.description
        //            if !obj.anonymousState {
        //                cell.labelCreatedBy.text = obj.name
        //                cell.membersStack.isHidden = false
        //                cell.loungeLogo.isHidden = true
        //            } else {
        //                cell.labelCreatedBy.text = "Anonymous"
        //                cell.membersStack.isHidden = true
        //                cell.loungeLogo.isHidden = false
        //            }
        //            cell.labelTotalParticipants.text = String.getString(obj.users.count)
        //            cell.butttonInvitations.isSelected = obj.notificationsEnabled
        //            cell.callbackNotifications = { sender in
        //                sender.isSelected = !sender.isSelected
        //                obj.notificationsEnabled = sender.isSelected
        //            }
        //            cell.callbackJoin = {
        //                if kSharedAppDelegate?.viewToShow.isHidden == true {
        //                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
        //                    let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
        //                    if let vc = optionsSheetVC as? AudioRoomVC{
        //                        vc.roomId = obj.roomId
        //                        vc.anonymousState = obj.anonymousState
        //                    }
        //                    let options = SheetOptions(
        //                        pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
        //                    )
        //
        //                    let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.marginFromTop(100)], options: options)
        //                    sheetController.allowGestureThroughOverlay = false
        //                    sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
        //                    sheetController.minimumSpaceAbovePullBar = 0
        //                    sheetController.treatPullBarAsClear = false
        //                    sheetController.autoAdjustToKeyboard = false
        //                    sheetController.dismissOnOverlayTap = true
        //
        //
        //                    // Disable the ability to pull down to dismiss the modal
        //                    sheetController.dismissOnPull = true
        //                    // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())
        //                    self.navigationController?.present(sheetController, animated: false, completion: nil)
        //                    //                self.navigationController?.present(vc, animated: false, completion: nil)
        //                } else {
        //                    CommonUtils.showToast(message: "You are already in lounge")
        //                }
        //
        //            }
        //
        //            cell.callbackShare = {
        //                let textToShare = "Join Hlthera Audio Room!"
        //                if let myWebsite = NSURL(string: obj.link) {
        //                    let objectsToShare = [textToShare, myWebsite] as [Any]
        //                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //
        //                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        //                    self.present(activityVC, animated: true, completion: nil)
        //                }
        //            }
        //            //cell.labelDateTime.text = getDateFromCreatedAtString(dateString: String.getString(obj.createdAt)).toString()
        //
        //            return cell
        //        } else {
        //        -------------------
        if showCreatedList {
            let cell = tableView.dequeueReusableCell(withIdentifier: CreatedLoungeTVC.identifier, for: indexPath) as! CreatedLoungeTVC
            
            var obj:RoomModel = RoomModel(data: [:])
            obj = myCreatedLounges[indexPath.row]
            
            cell.LoungeNameLabel.text = obj.category
            cell.LoungeDescriptionLabel.text = obj.description
            cell.LoungeMembersCountLabel.text = String.getString(obj.users.count)
            
            if obj.anonymousState {
                cell.LoungeOwnerNameLabel.text = "Anonymous"
                cell.AnonymouseLoungeImage.isHidden = false
                cell.usersImagesStackView.isHidden = true
                cell.otherImagesStack.isHidden = true
            } else {
                cell.LoungeOwnerNameLabel.text = obj.name
                cell.AnonymouseLoungeImage.isHidden = true
                cell.usersImagesStackView.isHidden = false
                cell.otherImagesStack.isHidden = false
            }
            let count = Int(String.getString(obj.users.count - 1)) ?? 0
            if count > 0 {
                if count <= 3 {
                    for i in 0...count {
                        cell.imagesUser[i].downlodeImage(serviceurl: String.getString(obj.users[i].profile) , placeHolder: UIImage(named: "profile_placeholder"))
                        cell.otherImagesUser[i].downlodeImage(serviceurl: String.getString(obj.users[i].profile) , placeHolder: UIImage(named: "profile_placeholder"))
                    }
                    if count <= 3{
                        cell.remineImageCountLabel.text = ""
                    }else{
                        cell.remineImageCountLabel.text = "+\((count - 3))"
                    }
                }
            }
            cell.callBackJoin = {
                if kSharedAppDelegate?.viewToShow.isHidden == true {
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                    if let vc = optionsSheetVC as? AudioRoomVC{
                        vc.roomId = obj.roomId
                        vc.anonymousState = obj.anonymousState
                    }
                    let options = SheetOptions(
                        pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
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
                    self.navigationController?.present(sheetController, animated: false, completion: nil)
                    //                self.navigationController?.present(vc, animated: false, completion: nil)
                } else {
                    CommonUtils.showToast(message: "You are already in lounge")
                }
            }
            cell.callBackShare = {
                let textToShare = "Join Hlthera Audio Room!"
                if let myWebsite = NSURL(string: obj.link) {
                    let objectsToShare = [textToShare, myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
            cell.callBackNotification = { sender in
                sender.isSelected = !sender.isSelected
                obj.notificationsEnabled = sender.isSelected
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoungeScheduledTVC.identifier, for: indexPath) as! LoungeScheduledTVC
            var obj:RoomModel = RoomModel(data: [:])
            if isSearching{
                obj = myLoungesSearchResults[indexPath.row]
            }
            else{
                obj = myLounges[indexPath.row]
            }
            cell.imgLoungeType.image = getLoungeTypeImage(type: obj.type)
            cell.btnInvite.isHidden = true
            // cell.btnDelete.isHidden = false
            cell.labelName.text = obj.category
            cell.labelType.text = obj.type.capitalized
            cell.labelDescription.text = obj.description
            //  cell.labelDate.text = obj.scheduleAt
            if !obj.anonymousState{
                cell.imageProfile.downlodeImage(serviceurl: obj.profile, placeHolder: UIImage(named: "no_profile_image"))
                cell.LoungeUserNameLabel.text = obj.name
            } else {
                cell.imageProfile.image = UIImage(named: "lounges1")
                cell.LoungeUserNameLabel.text = "Anonymous"
            }
            cell.callbackInvite = {
                if obj.id == UserData.shared.id{
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: LoungeSendInvitationVC.getStoryboardID()) as! LoungeSendInvitationVC
                    self.navigationController?.present(vc, animated: true)
                } else {
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                    if let vc = optionsSheetVC as? AudioRoomVC{
                        vc.roomId = obj.roomId
                        vc.anonymousState = obj.anonymousState
                    }
                    let options = SheetOptions(
                        pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
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
                    self.navigationController?.present(sheetController, animated: false, completion: nil)
                }
            }
            cell.callbackShare = {
                let textToShare = "Join Hlthera Audio Room!"
                if let myWebsite = NSURL(string: obj.link) {
                    let objectsToShare = [textToShare, myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
            let scheduleDate = getDateFromTimestamp(dateString: String.getString(obj.scheduleAt))
            cell.labelDate.text = scheduleDate.toString(withFormat: "EEE MMM dd, yyyy")
            cell.labelTime.text = scheduleDate.toString(withFormat: "hh:mm a")
            cell.callbackDelete = {
                self.roomsRef?.child(obj.roomId).removeValue()
                self.tableView.reloadData()
            }
            return cell
        }
//        }
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !showCreatedList {
            var obj: RoomModel = RoomModel(data: [:])
            if isSearching{
                obj = myLoungesSearchResults[indexPath.row]
            }
            else{
                obj = myLounges[indexPath.row]
            }
            if kSharedAppDelegate?.viewToShow.isHidden == true {
                let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                if let vc = optionsSheetVC as? AudioRoomVC{
                    vc.roomId = obj.roomId
                    vc.anonymousState = obj.anonymousState
                }
                let options = SheetOptions(
                    pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
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
                self.navigationController?.present(sheetController, animated: false, completion: nil)
                //                self.navigationController?.present(vc, animated: false, completion: nil)
            } else {
                CommonUtils.showToast(message: "You are already in lounge")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if showCreatedList {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showCreatedList {
            return 180
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var obj:RoomModel = RoomModel(data: [:])
            if isSearching{
                 obj = myLoungesSearchResults[indexPath.row]
            }
            else{
                 obj = myLounges[indexPath.row]
            }
            self.roomsRef?.child(obj.roomId).removeValue()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                var obj:RoomModel = RoomModel(data: [:])
                if self.isSearching{
                    obj = self.myLoungesSearchResults[indexPath.row]
                }
                else{
                    obj = self.myLounges[indexPath.row]
                }
                self.roomsRef?.child(obj.roomId).removeValue()
                self.tableView.reloadData()
                completionHandler(true)
            }
            deleteAction.image = UIImage.init(named: "delete_white")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }

    
}
extension ScheduledLoungesVC:UISearchBarDelegate{
    func hideSearch(){
        searchBar.text = ""
        isSearching = false
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        myLoungesSearchResults = self.myLounges.filter{String.getString($0.category).lowercased().prefix(searchText.count) == searchText.lowercased()}
        self.tableView.reloadData()
    }
   
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearch()
    }
    
    @objc func buttonCrossTapped(_ sender:Any){
       hideSearch()
    }

    
}

class CustomSegmentedControl: UISegmentedControl{
    private let segmentInset: CGFloat = 5       //your inset amount
//    private let segmentImage: UIImage? = UIImage(color: UIColor.white!)    //your color
    private let segmentImage: UIImage? = UIImage(color: UIColor(named: "5")!)    //your color

    override func layoutSubviews(){
        super.layoutSubviews()

        //background
        layer.cornerRadius = bounds.height/2
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        }
    }
}

extension UIImage{
    
    //creates a UIImage given a UIColor
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
