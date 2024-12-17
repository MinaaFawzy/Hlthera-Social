//
//  LoungeNotificationVC.swift
//  HSN
//
//  Created by Ankur on 21/06/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class LoungeNotificationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var viewGIF: UIView!
    @IBOutlet weak var lblUnreadCount: UILabel!

    
    var newCurrentPage = 1
    var newTotalPage = 1
    var newIsLoadingList = false
    var newTotal = 0
    var oldCurrentPage = 1
    var oldTotalPage = 1
    var oldIsLoadingList = false
    var oldTotal = 0
    
    var newNotifications:[NotificationModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var oldNotifications:[NotificationModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UINib(nibName: AcceptRejectNotificationTVC .identifier, bundle: nil), forCellReuseIdentifier: AcceptRejectNotificationTVC.identifier)
        tableView.register(UINib(nibName: LoungeNotificationTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeNotificationTVC.identifier)
        
        tableView.register(UINib(nibName: NoDataFoundTVC .identifier, bundle: nil), forCellReuseIdentifier: NoDataFoundTVC.identifier)
        tableView.tableFooterView = UIView()
       
        self.viewGIF.isHidden = true
        setStatusBar()//(color: UIColor(hexString: "F5F7F9"))
        let view = UIView()
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self,
                                  action: #selector(refresh(_:)),
                                  for: .valueChanged)
         tableView.refreshControl = refreshControl
        view.backgroundColor = .clear
        
        do {
            let gif = try UIImage(gifName: "notification.gif")
            DispatchQueue.main.async {
                let imageview = UIImageView(gifImage: gif, loopCount: -1) //Use -1 for infinite loop
                imageview.contentMode = .scaleAspectFill
                imageview.frame = self.viewGIF.bounds
                self.viewGIF.addSubview(imageview)
                print("added")
            }
        } catch {
            print(error)
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func refresh(_ sender:UIRefreshControl)
     {
         getData()
     }
    override func viewWillAppear(_ animated: Bool) {
        newNotifications = []
        oldNotifications = []
        getData()
    }
    func getData(){
        
        globalApis.getAllLoungeNotification(page: 1, completion: { new,old,newLastPage,newTotal,oldLastPage,oldTotal in
            self.newNotifications = new
            self.oldNotifications = old
            self.newTotal = newTotal
            self.oldTotal = oldTotal
            self.newTotalPage = newLastPage
            self.oldTotalPage = oldLastPage
            self.tableView.refreshControl?.endRefreshing()
            self.lblUnreadCount.isHidden = self.newNotifications.filter({$0.is_read == false}).count > 0 ? false : true
            self.lblUnreadCount.text = String.getString(self.newNotifications.filter({$0.is_read == false}).count)

        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonSearchTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: HomeSearchVC.getStoryboardID()) as? HomeSearchVC else { return }
        vc.callback = { index,user in
            globalApis.getProfile(id: String.getString(user?.id), completion: { data in
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                vc.data = data
                vc.id = data.id
                vc.hasCameFrom = .viewProfile
                self.navigationController?.pushViewController(vc, animated: true)

            })


        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func buttonMessageTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: MessagesVC.getStoryboardID()) as? MessagesVC else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension LoungeNotificationVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
      //  newNotifications.isEmpty ? (self.viewGIF.isHidden = false) : (self.viewGIF.isHidden = true)
        return 1 //newNotifications.isEmpty ? 0 : 2
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            return tableView.createHeaderViewBtn(text: "New", btnTitle: "Mark all as read", btnIsSelected: false, withBackgroundColor: false, color: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1) ,completion: { sender in
                globalApis.markAllNotificationsAsRead(markAllRead: true, completion: {
                    self.moveToPopUp(text: "All notifications marked as read succesfully!", completion: { [self] in
                        newNotifications = []
                        oldNotifications = []
                        getData()
                    })
                })
                
            })
        case 1:
            return tableView.createHeaderView(text: "Earlier", color: UIColor(named: "5")!,backgroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1))
        default:return UIView()
        }
    }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            //
            return  newNotifications.count
        case 1:
            return oldNotifications.count
        default:return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoungeNotificationTVC.identifier, for: indexPath) as! LoungeNotificationTVC

       
            let obj = newNotifications[indexPath.row]
            cell.labelText.text = obj.message
            cell.contentView.backgroundColor = obj.is_read ? .white : UIColor.init(hexString: "#F5F7F9")
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            cell.labelTimeDuration.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.time)), relativeTo: Date())
            cell.imgUser.kf.setImage(with: URL(string: obj.image_name),placeholder:#imageLiteral(resourceName: "profile_placeholder") )
//            if obj.is_read{
//                cell.viewDash.isHidden = true
//            }
//            else{
//                cell.viewDash.isHidden = false
//            }
//            if obj.notify_type == "2"  {
//
//                cell.constraintViewAcceptRejectHeight.constant = 30
//                cell.viewAcceptReject.isHidden = false
//            }
//            else{
//                cell.constraintViewAcceptRejectHeight.constant = 0
//                cell.viewAcceptReject.isHidden = true
//            }
//            cell.joinCallback = {
//                switch Int.getInt(obj.notify_type){
//                case 2:
//                    globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 1, groupId:"" , memberId: "", completion: {
//                        self.moveToPopUp(text: "Group Request Accepted Successfully!", completion: {
//                            self.getData()
//                        })
//                    })
//                case 1:
//                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
//                    vc.eventId = obj.type_id
//                    self.navigationController?.pushViewController(vc, animated: true)
//                default:break
//                }
//            }
//            cell.cancelCallback = {
//                switch Int.getInt(obj.notify_type){
//                case 2:
//                    globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 2, groupId:"" , memberId: "", completion: {
//                        self.moveToPopUp(text: "Group Request Rejected Successfully!", completion: {
//                            self.getData()
//                        })
//                    })
//
//
//                default:break
//                }
//            }
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: LoungeNotificationTVC.identifier, for: indexPath) as! LoungeNotificationTVC

            let obj = newNotifications[indexPath.row]
            cell.labelText.text = obj.message
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            cell.labelTimeDuration.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.time)), relativeTo: Date())
            cell.imgUser.kf.setImage(with: URL(string: kBucketUrl + obj.image_name),placeholder:#imageLiteral(resourceName: "profile_placeholder") )
         
//                let cell = tableView.dequeueReusableCell(withIdentifier: AcceptRejectNotificationTVC.identifier, for: indexPath) as! AcceptRejectNotificationTVC
//                cell.viewDash.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
//                cell.viewDash.cornerRadius1 = 10
//                let obj = oldNotifications[indexPath.row]
//                cell.labelTitle.text = obj.message
//                cell.profileImage.kf.setImage(with: URL(string: kBucketUrl + obj.image_name),placeholder:#imageLiteral(resourceName: "profile_placeholder") )
//                let formatter = RelativeDateTimeFormatter()
//                formatter.unitsStyle = .full
//                cell.labelTime.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.time)), relativeTo: Date())
//                if obj.notify_type == "1"{
//                    cell.constraintViewAcceptRejectHeight.constant = 0
//                    cell.viewAcceptReject.isHidden = true
//                }
//                else{
//                    cell.constraintViewAcceptRejectHeight.constant = 30
//                    cell.viewAcceptReject.isHidden = false
//                }
//            if obj.is_read{
//                cell.viewDash.isHidden = true
//            }
//            else{
//                cell.viewDash.isHidden = false
//            }
//                cell.joinCallback = {
//                    switch Int.getInt(obj.notify_type){
//                    case 2:
//                        globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 1, groupId:"" , memberId: "", completion: {
//                            self.moveToPopUp(text: "Group Request Accepted Successfully!", completion: {
//                                self.getData()
//                            })
//                        })
//                    case 1:
//                        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
//                        vc.eventId = obj.type_id
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    default:break
//                    }
//                }
//                cell.cancelCallback = {
//                    switch Int.getInt(obj.notify_type){
//                    case 2:
//                        globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 2, groupId:"" , memberId: "", completion: {
//                            self.moveToPopUp(text: "Group Request Rejected Successfully!", completion: {
//                                self.getData()
//                            })
//                        })
//                    case 1:
//                        self.oldNotifications.remove(at: indexPath.row)
//                        self.tableView.reloadData()
//
//                    default:break
//                    }
//                }
                return cell
            
        default:return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.section{
//        case 0:
//            let obj = newNotifications[indexPath.row]
//            switch Int.getInt(obj.notify_type){
//            case 1:
//                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
//                vc.eventId = obj.type_id
//                self.navigationController?.pushViewController(vc, animated: true)
//            case 3:
//                guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
//                vc.receiverid = obj.sender_id
//                self.navigationController?.pushViewController(vc, animated: true)
//
//
//
//            default:break
//            }
//            if !obj.is_read{
//                globalApis.markAllNotificationsAsRead(markAllRead: false,id: obj.id, completion: {
//
//                })
//
//            }
//        case 1:
//            let obj = oldNotifications[indexPath.row]
//            switch Int.getInt(obj.notify_type){
//            case 3:
//                guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
//                vc.receiverid = obj.sender_id
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            default:break
//            }
//            if !obj.is_read{
//                globalApis.markAllNotificationsAsRead(markAllRead: false,id: obj.id, completion: {
//
//                })
//            }
//
//        default: break
//        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}
