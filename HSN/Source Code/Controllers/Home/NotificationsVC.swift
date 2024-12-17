//
//  NotificationsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 04/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    //@IBOutlet weak private var buttonSearch: UIButton!
    //@IBOutlet weak private var buttonMessage: UIButton!
    @IBOutlet weak private var viewGIF: UIView!
    
    // MARK: - Stored Properties
    var newCurrentPage = 1
    var newTotalPage = 1
    var newIsLoadingList = false
    var newTotal = 0
    var oldCurrentPage = 1
    var oldTotalPage = 1
    var oldIsLoadingList = false
    var oldTotal = 0
    var markAllAsRead: Bool = false
    var unreadNotify = 0
    
    var newNotifications: [NotificationModel] = [] {
        didSet {
            tableView.reloadData()
            if let tabItems = self.tabBarController?.tabBar.items {
                let tabItem = tabItems[3]
                tabItem.badgeValue = nil
            }
        }
    }
    
    var oldNotifications: [NotificationModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setStatusBar()
        viewGIF.isHidden = true
        setupRefreshController()
        loadGIF()
    }
    
    private func loadGIF() {
        do {
            let gif = try UIImage(gifName: "notification.gif")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let imageview = UIImageView(gifImage: gif, loopCount: -1) //Use -1 for infinite loop
                imageview.contentMode = .scaleAspectFill
                imageview.frame = self.viewGIF.bounds
                self.viewGIF.addSubview(imageview)
            }
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newNotifications = []
        oldNotifications = []
        getData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        markAllAsRead = false
    }
    
    // MARK: - Methods
    func getData() {
        globalApis.getAllNotifications(page: 1, completion: { [weak self] new, old, newLastPage, newTotal, oldLastPage, oldTotal in
            guard let self = self else { return }
            self.newNotifications = new
            self.oldNotifications = old
            self.newTotal = newTotal
            self.oldTotal = oldTotal
            self.newTotalPage = newLastPage
            self.oldTotalPage = oldLastPage
            self.tableView.refreshControl?.endRefreshing()
        })
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: AcceptRejectNotificationTVC .identifier, bundle: nil), forCellReuseIdentifier: AcceptRejectNotificationTVC.identifier)
        tableView.register(UINib(nibName: NoDataFoundTVC .identifier, bundle: nil), forCellReuseIdentifier: NoDataFoundTVC.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func setupRefreshController() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(
            self,
            action: #selector(refresh(_:)),
            for: .valueChanged
        )
        tableView.refreshControl = refreshControl
    }
    
}

// MARK: - Actions
extension NotificationsVC {
    @IBAction private func buttonSearchTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: HomeSearchVC.getStoryboardID()) as? HomeSearchVC else { return }
        vc.callback = { [weak self] index,user in
            guard let self = self else { return }
            globalApis.getProfile(id: String.getString(user?.id), completion: { [weak self] data in
                guard let self = self else { return }
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
    
    @IBAction private func buttonMessageTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: MessagesVC.getStoryboardID()) as? MessagesVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        getData()
    }
}

// MARK: - UITableViewDelegate & DataSource
extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !markAllAsRead {
            newNotifications.isEmpty ? (self.viewGIF.isHidden = false) : (self.viewGIF.isHidden = true)
        } else {
            self.viewGIF.isHidden = true
        }
        if oldNotifications.isEmpty {
            return newNotifications.isEmpty ? 0 : 1
        } else {
            return newNotifications.isEmpty ? 0 : 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return tableView.createHeaderViewBtn(text: "New", btnTitle: "Mark all as read", btnIsSelected: false, withBackgroundColor: false, color: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), viewBackgroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), completion: { [weak self] sender in
                guard let self = self else { return }
                globalApis.markAllNotificationsAsRead(markAllRead: true, completion: { [weak self] in
                    guard let self = self else { return }
                    self.markAllAsRead = true
                    self.newNotifications = []
                    self.oldNotifications = []
                    self.getData()
                })
            })
        case 1:
            return tableView.createHeaderView(text: "Earlier", color: UIColor(named: "5")!, backgroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1))
        default: return UIView()
        }
    }
    
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
        switch indexPath.section {
        case 0:
            // Group Invitation
            let cell = tableView.dequeueReusableCell(withIdentifier: AcceptRejectNotificationTVC.identifier, for: indexPath) as! AcceptRejectNotificationTVC
            //cell.viewDash.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            //cell.viewDash.cornerRadius1 = 10
            let notificationItem = newNotifications[indexPath.row]
            cell.labelTitle.text = notificationItem.message
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            cell.labelTime.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(notificationItem.time)), relativeTo: Date())
            cell.profileImage.kf.setImage(with: URL(string: kBucketUrl + notificationItem.image_name), placeholder: #imageLiteral(resourceName: "profile_placeholder") )
            if notificationItem.is_read {
                cell.mainView.backgroundColor = .white
                cell.viewAcceptReject.backgroundColor = .white
            } else {
                unreadNotify += 1
                cell.mainView.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
                cell.viewAcceptReject.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
            }
            
            if notificationItem.notify_type == "6" && notificationItem.is_accepted == 0  {
                cell.constraintViewAcceptRejectHeight.constant = 30
                cell.viewAcceptReject.isHidden = false
            } else {
                cell.constraintViewAcceptRejectHeight.constant = 0
                cell.viewAcceptReject.isHidden = true
            }
            
            cell.joinCallback = { [weak self] in
                guard let self = self else { return }
                switch notificationItem.notify_type {
                case "6":
//                    globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 1, groupId:"" , memberId: "", completion: {
//                        self.moveToPopUp(text: "Group Request Accepted Successfully!", completion: {
//                            self.getData()
//                        })
//                    })
                    HSN.globalApis.acceptConnectionRequest(id: notificationItem.sender_id, completion: {
                        self.moveToPopUp(text: "Request Accepted Successfully") { [weak self] in
                            guard let self = self else { return }
                            self.getData()
                        }
                        
                    })
                case "1":
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
                    vc.eventId = notificationItem.type_id
                    self.navigationController?.pushViewController(vc, animated: true)
                default: break
                }
            }
            cell.cancelCallback = { [weak self] in
                guard let self = self else { return }
                switch notificationItem.notify_type {
                case "6":
//                    globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 2, groupId:"" , memberId: "", completion: {
//                        self.moveToPopUp(text: "Group Request Rejected Successfully!", completion: {
//                            self.getData()
//                        })
//                    })
                    HSN.globalApis.rejectConnectionRequest(id: notificationItem.sender_id, type: .receiver, completion: {
                        self.moveToPopUp(text: "Request Rejected Successfully") { [weak self] in
                            guard let self = self else { return }
                            self.getData()
                        }
                    })
                default: break
                }
            }
            
            cell.onMore = { [weak self] in
                guard let self = self else { return }
                let actionSheet = UIAlertController(title: "Notification", message: "Choose action", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Remove this notification", style: .cancel))
                actionSheet.addAction(UIAlertAction(title: "Turn off notifications of this type", style: .default))
                actionSheet.addAction(UIAlertAction(title: "Report issue to Notifications Team", style: .default))
                self.present(actionSheet, animated: true)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AcceptRejectNotificationTVC.identifier, for: indexPath) as! AcceptRejectNotificationTVC
            //cell.viewDash.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            //cell.viewDash.cornerRadius1 = 10
            let obj = oldNotifications[indexPath.row]
            cell.labelTitle.text = obj.message
            cell.profileImage.kf.setImage(with: URL(string: kBucketUrl + obj.image_name),placeholder:#imageLiteral(resourceName: "profile_placeholder") )
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            cell.labelTime.text = formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.time)), relativeTo: Date())
            if obj.notify_type == "7" {
                cell.constraintViewAcceptRejectHeight.constant = 0
                cell.viewAcceptReject.isHidden = true
            } else {
                cell.constraintViewAcceptRejectHeight.constant = 30
                cell.viewAcceptReject.isHidden = false
            }
            if obj.is_read {
                cell.mainView.backgroundColor = .white
                cell.viewAcceptReject.backgroundColor = .white
            } else {
                cell.mainView.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
                cell.viewAcceptReject.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
            }
            cell.joinCallback = { [weak self] in
                guard let self = self else { return }
                switch obj.notify_type {
                case "7":
//                    globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 1, groupId: "" , memberId: "", completion: { [weak self] in
//                        guard let self = self else { return }
//                        self.moveToPopUp(text: "Group Request Accepted Successfully!", completion: { [weak self] in
//                            guard let self = self else { return }
//                            self.getData()
//                        })
//                    })
                    HSN.globalApis.acceptConnectionRequest(id: obj.sender_id, completion: {
                        self.moveToPopUp(text: "Request Accepted Successfully") { [weak self] in
                            guard let self = self else { return }
                            self.getData()
                        }
                        
                    })
                case "1":
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
                    vc.eventId = obj.type_id
                    self.navigationController?.pushViewController(vc, animated: true)
                default: break
                }
            }
            cell.cancelCallback = { [weak self] in
                guard let self = self else { return }
                switch obj.notify_type {
                case "7":
//                    globalApis.acceptRejectGroupRequest(id: obj.type_id, type: 2, groupId:"" , memberId: "", completion: { [weak self] in
//                        guard let self = self else { return }
//                        self.moveToPopUp(text: "Group Request Rejected Successfully!", completion: { [weak self] in
//                            guard let self = self else { return }
//                            self.getData()
//                        })
//                    })
                    
                    globalApis.rejectConnectionRequest(id: obj.sender_id, type: .receiver, completion: {
                        self.moveToPopUp(text: "Request Rejected Successfully") { [weak self] in
                            guard let self = self else { return }
                            self.getData()
                        }
                    })
                case "1":
                    self.oldNotifications.remove(at: indexPath.row)
                    self.tableView.reloadData()
                default: break
                }
            }
            cell.onMore = { [weak self] in
                guard let self = self else { return }
                let actionSheet = UIAlertController(title: "Notification", message: "Choose action", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Remove this notification", style: .cancel))
                actionSheet.addAction(UIAlertAction(title: "Turn off notifications of this type", style: .default))
                actionSheet.addAction(UIAlertAction(title: "Report issue to Notifications Team", style: .default))
                self.present(actionSheet, animated: true)
            }
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let obj = newNotifications[indexPath.row]
            switch Int.getInt(obj.notify_type){
            case 1:
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
                vc.eventId = obj.type_id
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
                vc.receiverid = obj.sender_id
                self.navigationController?.pushViewController(vc, animated: true)
            default: break
            }
            if !obj.is_read {
                globalApis.markAllNotificationsAsRead(markAllRead: false,id: obj.id, completion: {
                    
                })
            }
        case 1:
            let obj = oldNotifications[indexPath.row]
            switch Int.getInt(obj.notify_type){
            case 3:
                guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
                vc.receiverid = obj.sender_id
                self.navigationController?.pushViewController(vc, animated: true)
                
            default: break
            }
            if !obj.is_read {
                globalApis.markAllNotificationsAsRead(markAllRead: false,id: obj.id, completion: {})
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //if indexPath.row + 1 == self.newNotifications.count {
        //            if newCurrentPage <= newTotalPage{
        //                self.newCurrentPage += 1
        //                globalApis.getAllNotifications(page: newCurrentPage, completion: { new,old,newLastPage,newTotal,oldLastPage,oldTotal in
        //
        //                    self.newIsLoadingList = false
        //                    self.oldIsLoadingList = false
        //                    self.newNotifications.append(new)
        //                    self.oldNotifications.append(old)
        //
        //
        //                               })
        //                }
        //
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
