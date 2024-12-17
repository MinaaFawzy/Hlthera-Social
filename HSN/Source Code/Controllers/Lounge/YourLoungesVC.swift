//
//  YourLoungesVC.swift
//  HSN
//
//  Created by Ankur on 20/06/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets

class YourLoungesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblScheduleLater : UILabel!
    @IBOutlet weak var viewCurrent: UIView!
    @IBOutlet weak var viewScheduleLater : UIView!
    
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var observerRef:DatabaseReference?
    
    var MyLoungeList:[RoomModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var loungeList:[RoomModel] = []
    var isCurrentLounge = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
        setStatusBar()//(color: UIColor(hexString: "F5F7F9"))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: UpcomingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        tableView.register(UINib(nibName: LoungeScheduledTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeScheduledTVC.identifier)
        setupFirebase {}
    }
    
    
    @objc func refresh(_ sender:UIRefreshControl)
    {
        setupFirebase {}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObservers()
    }
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createScheduleLounge(_ sender: UIButton) {
        isCurrentLounge = sender.tag == 0 ? true : false
        self.MyLoungeList = isCurrentLounge ? self.loungeList.filter({$0.schedule == false}) : self.loungeList.filter({$0.schedule})
        lblCurrent.textColor = sender.tag == 1 ? UIColor(hexString: "8794AA") : UIColor(hexString: "263E68")
        lblScheduleLater.textColor = sender.tag == 1 ? UIColor(hexString: "263E68") : UIColor(hexString: "8794AA")
        viewCurrent.isHidden = sender.tag == 0 ? false : true
        viewScheduleLater.isHidden = sender.tag == 1 ? false : true
        
        //        if selectedIndex == indexPath {
        //            cell.viewCategories.isHidden = false
        //            cell.labelCategories.textColor = UIColor(hexString: "263E68")
        //        }
    }
}

extension YourLoungesVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyLoungeList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isCurrentLounge {
            let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as! UpcomingTableViewCell
            
            if indexPath.row % 2 == 0 {
                cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "346FC8"), col2: UIColor(hexString: "7289F7"))
            }else if indexPath.row % 3 == 0 {
                cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "3085E3"), col2: UIColor(hexString: "95C6FA"))
            }else{
                cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "1D416D"), col2: UIColor(hexString: "4275C1"))
            }
            
            let obj = MyLoungeList[indexPath.row]
            
            cell.labelName.isHidden = obj.anonymousState
            cell.labelHeading.text = obj.category
            //        cell.labelType.text = obj.type.capitalized
            cell.buttonSponsored.isHidden = obj.is_sponsered == 1 ? true : false
            cell.labelDiscription.text = obj.description
            cell.labelName.text = obj.name
            cell.labelViewers.text = String.getString(obj.users.count)
            cell.buttonNotification.isSelected = obj.notificationsEnabled
            cell.labelRemainImages.text = ""
            // cell.buttonSponsored.isHidden = false
            let count = Int(String.getString(obj.users.count - 1)) ?? 0
            if count > 0 {
                if count <= 3 {
                    for i in 0...count {
                        print("ImagePath -- \(String.getString(obj.users[i].profile))")
                        cell.imagesUser[i].downlodeImage(serviceurl: String.getString(obj.users[i].profile) , placeHolder: UIImage(named: "profile_placeholder"))
                    }
                    if count <= 3{
                        cell.labelRemainImages.text = ""
                    }else{
                        cell.labelRemainImages.text = "+\((count - 3))"
                    }
                }
            }
            
            cell.callbackNotifications = { sender in
                sender.isSelected = !sender.isSelected
                obj.notificationsEnabled = sender.isSelected
                self.currentRoomRef = self.roomsRef?.child(obj.roomId)
                self.currentRoomRef?.child("users").child(UserData.shared.id).updateChildValues(["notifications":sender.isSelected ? 1 : 0])
            }
            cell.callbackJoin = {
                let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                if let vc = optionsSheetVC as? AudioRoomVC{
                    vc.isCreatedBySelf = true
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
            cell.callbackShare = {
                let textToShare = "Join Hlthera Audio Room!"
                if let myWebsite = NSURL(string: obj.link) {
                    let objectsToShare = [textToShare, myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
            
            cell.callbackSponsored = {
                guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else { return }
                kSharedAppDelegate?.promotionType = "louge"
                kSharedAppDelegate?.loungeId = obj.roomId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: LoungeScheduledTVC.identifier, for: indexPath) as! LoungeScheduledTVC
            let obj = MyLoungeList[indexPath.row]
            cell.imgLoungeType.image = getLoungeTypeImage(type: obj.type)
            cell.btnInvite.isHidden = true
            // cell.btnDelete.isHidden = false
            cell.labelName.text = obj.category
            cell.labelType.text = obj.type.capitalized
            cell.labelDescription.text = obj.description
            //  cell.labelDate.text = obj.scheduleAt
            cell.imageProfile.downlodeImage(serviceurl: obj.profile, placeHolder: UIImage(named: "profile_placeholder"))
            
            cell.callbackInvite = {
                if obj.id == UserData.shared.id{
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: LoungeSendInvitationVC.getStoryboardID()) as! LoungeSendInvitationVC
                    self.navigationController?.present(vc, animated: true)
                }
                else{
                    let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                    let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                    if let vc = optionsSheetVC as? AudioRoomVC{
                        vc.isCreatedBySelf = true
                        vc.roomId = obj.roomId
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
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
}


extension YourLoungesVC {
    func setupFirebase(completion:@escaping ()->()){
        self.mainRef = rootRef.child("usertouser")
        self.roomsRef = mainRef?.child("rooms")
        //self.currentRoomRef = roomsRef?.child(roomId)
        roomsRef?.observe(.value) { (snap) in
            print(snap.value,"SNAP VALUE")
            //&& $0.roomId == self.roomId
            let userID = String.getString(UserData.shared.id)
            let data = kSharedInstance.getDictionary(snap.value).values.map{RoomModel(data: kSharedInstance.getDictionary($0))}.sorted{ $0.createdAt > $1.createdAt }
            //            self.UpcomingLounge = data.filter({$0.ongoing == false})
            self.loungeList = data.filter({$0.id == userID})
            self.MyLoungeList = self.isCurrentLounge ? self.loungeList.filter({$0.schedule == false}) : self.loungeList.filter({$0.schedule})
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func removeObservers(){
        roomsRef?.removeAllObservers()
    }
}
