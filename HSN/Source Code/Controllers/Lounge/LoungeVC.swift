//
//  LoungeVC.swift
//  HSN
//
//  Created by Ankur on 24/05/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets
class LoungeVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var ViewSearchHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonMail: UIButton!
    @IBOutlet weak var buttonNotifications: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHappening: UICollectionView!
    @IBOutlet weak var tabelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var lblHappeningNow: UILabel!
    @IBOutlet weak var lblHappeningNowConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTF: UITextField!
    
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var observerRef:DatabaseReference?
    var connections:[InvitationsModel] = []
    var upcoming:[RoomModel] = []
    var Happening:[RoomModel] = []
    var UpcomingLounge:[RoomModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var HappeningNow:[RoomModel] = [] {
        didSet{
            collectionViewHappening.reloadData()
        }
    }
    
    var isManageRooms = false
    var isViewAll = true
    var selectedIndex = IndexPath(item: 0, section: 0)
    var arrFilter = ["Top","Local","This week","Connections","",""]
    // "Sponsored",
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableAndCollection()
        setStatusBar()//color: UIColor(hexString: "F5F7F9"))
        searchBarTF.placeholder(text: "Search Hlthera", color: UIColor(hexString: "#8794AA"))
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        ViewSearchHeightConstraint.constant = 0
        setupFirebase {
        }
        
        globalApis.getConnections(completion:{
            data in
            self.connections = data
        })
        
        //        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        //        self.tableView.estimatedSectionHeaderHeight = 25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            kSharedAppDelegate?.tabBarController?.manageMiddleConstraint()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObservers()
    }
    
    
    //MARK: - IBAction
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonMail(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: InvitesVC.getStoryboardID()) as? InvitesVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func buttonSearch(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        if sender.tag == 0 {
            ViewSearchHeightConstraint.constant = 35
            sender.tag = 1
        }
        else{
            ViewSearchHeightConstraint.constant = 0
            sender.tag = 0
        }
    }
    
    @IBAction func SearchLounge(_ sender:UITextField) {
        if sender.text?.count == 0 {
            self.UpcomingLounge = self.upcoming
        }else{
            UpcomingLounge = upcoming.filter({ (text) -> Bool in
                let tmp:NSString = text.category as? NSString ?? ""
                let range = tmp.range(of: sender.text!, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        tableView.reloadData()
    }
    
    @IBAction func buttonNotifiCations(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: LoungeNotificationVC.getStoryboardID()) as? LoungeNotificationVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonCreateLounge(_ sender: UIButton) {
        let dict = kSharedInstance.getDictionary(kSharedUserDefaults.getLounge())
        if dict["description"] != nil {
            if !kSharedAppDelegate!.isShowLounge {
                CommonUtils.showToast(message: "Lounge is already in process.")
                return
            }
        }
        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: CreateLoungeVC.getStoryboardID()) as? CreateLoungeVC else { return }
        //        vc.hasCameFrom = .createCompanyEvent
        //        vc.companyId = self.pageId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonYourLounges(_ sender: UIButton) {
        //        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: ScheduledLoungesVC.getStoryboardID()) as? ScheduledLoungesVC else { return }
        //        vc.isManageRooms = true
        ////        vc.isViewAll = true
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: ScheduledLoungesVC.getStoryboardID()) as? ScheduledLoungesVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - methods
    func setupTableAndCollection() {
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewHappening.delegate = self
        collectionViewHappening.dataSource = self
        collectionView.register(UINib(nibName: EventTopCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EventTopCollectionViewCell.identifier)
        collectionViewHappening.register(UINib(nibName: HappeningNowCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HappeningNowCollectionViewCell.identifier)
        tableView.register(UINib(nibName: UpcomingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.identifier)
    }
    
    func updateHight(table:UITableView) {
        let hight = CGFloat(UpcomingLounge.count) * CGFloat(185.0)
        self.tabelViewHeight.constant = CGFloat(hight)
        self.scrollView.contentSize.height = CGFloat(hight) + 302
        //   print("Scroll height - \(CGFloat(hight + 700))")
        self.tableView.isScrollEnabled = false
    }
    
    func setupRefreshControl(){
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender:UIRefreshControl)
    {
        setupFirebase{}
    }
}

//extension LoungeVC:UITableViewDelegate,UITableViewDataSource{
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//     return 7
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier, for: indexPath) as! EventsTableViewCell
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 280
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//}

//MARK: - Collection func
extension LoungeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewHappening{
            return HappeningNow.count
        }else{
            return arrFilter.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewHappening {
            
            let cell = collectionViewHappening.dequeueReusableCell(withReuseIdentifier: HappeningNowCollectionViewCell.identifier , for: indexPath)  as! HappeningNowCollectionViewCell
            
            if indexPath.row % 2 == 0 {
                cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "346FC8"), col2: UIColor(hexString: "7289F7"))
            }else if indexPath.row % 3 == 0 {
                cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "3085E3"), col2: UIColor(hexString: "95C6FA"))
            }else{
                cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "1D416D"), col2: UIColor(hexString: "4275C1"))
            }
            
            let obj = HappeningNow[indexPath.row]
            cell.labelHeading.text = obj.category.isEmpty ? "UnKnown category" : obj.category
            cell.labelSponsored.isHidden = obj.is_sponsered == 1 ? false : true
            //        cell.labelType.text = obj.type.capitalized
            cell.labelDiscription.text = obj.description.isEmpty ? "UnKnown description" : obj.description
            cell.labelProfileName.text = obj.name.isEmpty ? "UnKnown Name" : obj.name
            cell.labelUserCount.text = String.getString(obj.users.count)
            cell.buttonNotification.isSelected = obj.notificationsEnabled
            cell.buttonNotification.isHidden = true
            //            cell.labelCreative.text = String.getString(obj.type)
            //cell.imageProfile.downlodeImage(serviceurl: obj.profile, placeHolder: UIImage(named: "profile_placeholder"))
            
            cell.labelRemainProfile.text = ""
            let count = Int(String.getString(obj.users.count - 1)) ?? 0
            if count > 0 {
                if count <= 3 {
                    for i in 0...count {
                        print("ImagePath -- \(String.getString(obj.users[i].profile))")
                        cell.imagesUser[i].downlodeImage(serviceurl: String.getString(obj.users[i].profile) , placeHolder: UIImage(named: "no_profile_image"))
                    }
                    if count <= 3{
                        cell.labelRemainProfile.text = ""
                    }else{
                        cell.labelRemainProfile.text = "+\((count - 4))"
                    }
                }
            }
            cell.callbackNotifications = { sender in
                sender.isSelected = !sender.isSelected
                obj.notificationsEnabled = sender.isSelected
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventTopCollectionViewCell.identifier , for: indexPath)  as! EventTopCollectionViewCell
            cell.labelCategories.text = arrFilter[indexPath.item].isEmpty ? "Unknown Category" : arrFilter[indexPath.row]
            cell.viewCategories.isHidden = true
            
            //        cell.labelCategories.textColor = .lightGray
            cell.labelCategories.textColor = UIColor(hexString: "8794AA")
            if selectedIndex == indexPath {
                cell.viewCategories.isHidden = false
                cell.labelCategories.textColor = UIColor(hexString: "263E68")
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewHappening {
            //            guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as? AudioRoomVC else { return }
            //            //vc.isCreatedBySelf = true
            //            vc.roomId = HappeningNow[indexPath.row].id
            //            self.navigationController?.pushViewController(vc, animated: true)
            self.showLoungeView(HappeningNow[indexPath.row].id, anonymousState: HappeningNow[indexPath.row].anonymousState)
        }else{
            selectedIndex = indexPath
            searchFilterByType(tag: indexPath.row)
            self.collectionView.reloadData()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewHappening {
            let w = collectionViewHappening.frame.size.width / 2
            return CGSize(width: w, height: collectionViewHappening.frame.size.height)
        }
        return CGSize()
    }
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        let x = scrollView.contentOffset.x/scrollView.bounds.width
    //        self.pageControl.currentPage = Int(x)
    //
    //    }
    
}

//MARK: - Table Func
extension LoungeVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UpcomingLounge.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as! UpcomingTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "346FC8"), col2: UIColor(hexString: "7289F7"))
        }else if indexPath.row % 3 == 0 {
            cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "3085E3"), col2: UIColor(hexString: "95C6FA"))
        }else{
            cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "1D416D"), col2: UIColor(hexString: "4275C1"))
        }
        let obj = UpcomingLounge[indexPath.row]
        
        cell.labelHeading.text = obj.category.isEmpty ? "Unknown Category" : obj.category
        
        //        cell.labelType.text = obj.type.capitalized
        cell.labelSponsored.isHidden = obj.is_sponsered == 1 ? false : true
        cell.labelDiscription.text = obj.description.isEmpty ? "Unknown description" : obj.description
        cell.labelName.text = obj.name.isEmpty ? "Unknown name" : obj.name
        cell.labelViewers.text = String.getString(obj.users.count)
        cell.buttonNotification.isSelected = obj.notificationsEnabled
        cell.labelRemainImages.text = ""
        let count = Int(String.getString(obj.users.count - 1)) ?? 0
        if count > 0 {
            if count <= 3 {
                for i in 0...count {
                    cell.imagesUser[i].downlodeImage(serviceurl: String.getString(obj.users[i].profile) , placeHolder: UIImage(named: "no_profile_image"))
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
            //            let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
            //            let vc = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
            //            vc.roomId = obj.roomId
            //            self.navigationController?.pushViewController(vc, animated: true)
            self.showLoungeView(obj.roomId, anonymousState: obj.anonymousState)
            
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.updateHight(table: tableView)
        return 185
    }
    
    func showLoungeView(_ roomId : String, anonymousState: Bool){
        let optionsSheetVC = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
        
        if let vc = optionsSheetVC as? AudioRoomVC{
            //vc.isCreatedBySelf = true
            vc.roomId = roomId
            vc.anonymousState = anonymousState
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
    
    //    }
    
}

//MARK: - Firebase
extension LoungeVC {
    
    func setupFirebase(completion:@escaping ()->()){
        self.mainRef = rootRef.child("usertouser")
        self.roomsRef = mainRef?.child("rooms")
        
        roomsRef?.observe(.value) { (snap) in
            print(snap.value,"SNAP VALUE")
            //&& $0.roomId == self.roomId
            //            let date = NSDate() // current date
            //            let currentTimeStamp = date.timeIntervalSince1970
            let data = kSharedInstance.getDictionary(snap.value).values.map{RoomModel(data: kSharedInstance.getDictionary($0))}.sorted{ $0.createdAt > $1.createdAt }
            //            self.UpcomingLounge = data.filter({$0.ongoing == false})
            self.upcoming = data.filter({$0.ongoing == false})
            self.Happening = data.filter({$0.ongoing == true})
            //            self.HappeningNow = data.filter({$0.ongoing == true})
            self.searchFilterByType(tag: self.selectedIndex.row)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionViewHappening.reloadData()
                self.scrollView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func removeObservers(){
        roomsRef?.removeAllObservers()
    }
    
    func searchFilterByType(tag:Int){
        collectionViewHeight.constant = 210
        lblHappeningNow.isHidden = false
        lblHappeningNowConstraint.constant = 33.5
        // for top lounge
        if tag == 0 {
            self.UpcomingLounge.removeAll()
            self.HappeningNow.removeAll()
            self.UpcomingLounge = upcoming.sorted(by: {$0.users.count > $1.users.count})
            self.HappeningNow = Happening.sorted(by: {$0.users.count > $1.users.count})
            //            self.UpcomingLounge = upcoming.filter({$0.profile.count > $1.profile.count})
            
        }else if tag == 1{  // for local lounge
            self.UpcomingLounge.removeAll()
            self.HappeningNow.removeAll()
            self.UpcomingLounge = upcoming.filter({$0.country == UserData.shared.country})
            self.HappeningNow = Happening.filter({$0.country == UserData.shared.country})
            
        }else if tag == 2{ // for this week lounge
            self.UpcomingLounge.removeAll()
            self.HappeningNow.removeAll()
            collectionViewHeight.constant = 0
            lblHappeningNowConstraint.constant = 0
            lblHappeningNow.isHidden = true
            let upcoming = upcoming.filter({$0.schedule})
//            let happening = Happening.filter({$0.schedule})
            
            self.UpcomingLounge =  upcoming.filter({Date(timeIntervalSince1970: Double.getDouble($0.scheduleAt) / 1000.0).isInCurrent(.weekOfMonth)})
            //   self.HappeningNow = happening.filter({Date(timeIntervalSince1970: Double.getDouble($0.scheduleAt) / 1000.0).isInCurrent(.weekOfMonth)})
            
        }
        //        else if tag == 3{ // for sponsored lounge
        //            self.UpcomingLounge.removeAll()
        //            self.HappeningNow.removeAll()
        //            collectionViewHeight.constant = 0
        //            lblHappeningNowConstraint.constant = 0
        //            lblHappeningNow.isHidden = true
        ////            self.UpcomingLounge = upcoming
        ////            self.HappeningNow = Happening
        //
        //        }
        else if tag == 3{ // for connection lounge
            self.UpcomingLounge.removeAll()
            self.HappeningNow.removeAll()
            
            self.UpcomingLounge = upcoming.filter({user in
                return self.connections.filter({user.id == $0.recipient_id}).count > 0 ? true : false
            })
            
            self.HappeningNow = Happening.filter({user in
                return self.connections.filter({user.id == $0.recipient_id}).count > 0 ? true : false
            })
            
        }else if tag == 5{
            self.UpcomingLounge.removeAll()
            self.HappeningNow.removeAll()
            self.UpcomingLounge = upcoming
            self.HappeningNow = Happening
            
        }else if tag == 6{
            self.UpcomingLounge.removeAll()
            self.HappeningNow.removeAll()
            self.UpcomingLounge = upcoming
            self.HappeningNow = Happening
        }
    }
}

extension UIView{
    func setGradientBackgroundNew(col1:UIColor,col2:UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor, #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1).cgColor]
        gradientLayer.colors = [col1.cgColor,col2.cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
