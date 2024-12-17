//
//  MessagesViewController.swift
//  CrediWeb
//
//  Created by Deepak on 02/02/21.
//

import UIKit
import RealmSwift

class MessagesVC: UIViewController {
    
    // MARK: - Outlets & Variables
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var ViewsNavigation: [UIView]!
    
    @IBOutlet weak var headerView: UIView!
    //var data: [String: Any] = [:]
    var data: [ResentUsers] = []
    var allData: [ResentUsers] = []
    var unreadData: [ResentUsers] = []
    var users: [String: Any] = [:]
    var selectedTab = 0 {
        didSet {
            self.tableViewMessages.reloadData()
        }
    }
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        setupSearchBar()
        // Swift 5 or above
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        //tableViewMessages.messageDelegate = self
        setupNavigation(selectedIndex: selectedTab)
        // setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        tableViewMessages.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        //        Chat_hepler.Shared_instance.RecentUsersList(userid: UserData.shared.id, message: {data in
        //            self.data = data ?? [:]
        //        })
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        //        if !(UserData.shared.isProfileCreated ?? false){
        //            CommonUtils.showAlert(title: kAppName, message: Notifications.completeProfile, buttonTitle: "OK", completion: {_ in
        //                kSharedAppDelegate?.moveToBorrowerTabBar(selectedIndex: 4)
        //            })
        //
        //        }
    }
    func setupSearchBar() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(hexString: "#F5F7F9")
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#8794AA")])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor(hexString: "#8794AA")
            }
        }
        searchBar.backgroundImage = UIImage()
        searchBar.scopeBarBackgroundImage = UIImage()
        searchBar.delegate = self
        let searchView = self.searchBar
        //        searchView?.layer.cornerRadius = 20
        //        searchView?.clipsToBounds = true
        //        searchView?.borderWidth = 0
        //        searchView?.setSearchIcon(image: #imageLiteral(resourceName: "search_white"))
        //        searchView?.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        //        searchView?.backgroundImage = UIImage()
        let searchField = self.searchBar.searchTextField
        //        searchField.backgroundColor = .white
        //        searchField.font = UIFont(name: "Helvetica", size: 13)
        //        searchField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
    }
    
    func getData() {
        Chat_hepler.Shared_instance.Resent_Users(userid: UserData.shared.id, message: {
            data in
            self.data = ResentUsers.fetchResentListFromDatabase() ?? []
            self.unreadData = data?.filter{String.getString($0.unread) != "0"} ?? []
            Chat_hepler.Shared_instance.AllUsers(users: { [weak self] data in
                guard let self = self else { return }
                self.users = data ?? [:]
                self.tableViewMessages.reloadData()
            })
            
        })
    }
    
    func setupNavigation(selectedIndex:Int = 0){
        
        for (index,view) in self.ViewsNavigation.enumerated(){
            for btn in view.subviews{
                if let button  = btn as? UIButton{
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                    //  button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Medium", size: 16)) : (UIFont(name: "SFProDisplay-Regular", size: 16))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                }
                
                else{
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                    
                }
            }
        }
    }
    
    // MARK: - Methods
    func didTap(_ tableView: UITableView, index: Int, data: Any?) {
        //        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(identifier: Identifiers.kChatController) as? ChatViewController else {return}
        //        vc.receivername = "\(String.getString((data as? Contacts)?.firstName)) \(String.getString((data as? Contacts)?.LastName))"
        //        vc.receiverid = String.getString((data as? Contacts)?.id)
        //        vc.receiverprofile_image = String.getString((data as? Contacts)?.profilePicture)
        //        vc.contactDetail = data as? Contacts
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Button Actions
    @IBAction func buttonBack(_ sender: UIButton) {
        // kSharedAppDelegate?.moveToBorrowerTabBar(selectedIndex: 2)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonNavigationsTapped(_ sender: UIButton) {
        setupNavigation(selectedIndex: sender.tag)
        self.selectedTab = sender.tag
        //protocal?.currentProfilePage(index: sender.tag)
    }
    
}

extension MessagesVC: UISearchBarDelegate {
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        self.tableViewMessages.searchedContactsArray = self.tableViewMessages.contactsArray.filter{$0.firstName?.lowercased().contains(String.getString(searchBar.text?.lowercased())) ?? false}
    //                print(searchBar.text)
    //                if searchBar.text == ""{
    //                    self.tableViewMessages.searchedContactsArray = self.tableViewMessages.contactsArray
    //                }
    //    }
}

extension MessagesVC {
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //        if(segue.identifier == "SubscribePopUp"){
    //            let vc = segue.destination as! SubscriptionViewController
    //            vc.onDone = { result in
    //
    //                if(result == 1){
    //
    //                    let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
    //
    //                    vc.dismiss(animated: true, completion: {
    //                        if !(kSharedInstance.getDictionary(userDetails["subscription"]).count == 0){
    //                            self.tableViewMessages.getChatList()
    //                        }else{
    //                            kSharedAppDelegate?.moveToBorrowerTabBar(selectedIndex: 2)
    //                        }
    //                    })
    //                } else if(result == 2){
    ////                    vc.dismiss(animated: true, completion: nil)
    //                    let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
    //
    //                    if !(kSharedInstance.getDictionary(userDetails["subscription"]).count == 0){
    //                        self.tableViewMessages.getChatList()
    //                    }
    //
    //                    vc.dismiss(animated: true, completion: nil)
    //                    guard let vc = self.storyboard?.instantiateViewController(identifier: BorrowerIdentifiers.kSubscriptionListViewController) as? SubscriptionListViewController else {return}
    //                    vc.isFromChat = true
    //                    self.navigationController?.pushViewController(vc, animated: true)
    //                }
    //            }
    //        }
    //
    //    }
}

extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0 {
            return data.count
        } else {
            return unreadData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedTab == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
            let obj = data[indexPath.row]
            cell.labelMessage.text = obj.last_message
            cell.labelName.text = obj.name == "" ? "Unkown User" : obj.name
            cell.viewReadCount.layer.cornerRadius = cell.viewReadCount.frame.height/2
            cell.viewReadCount.isHidden = true
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            cell.labelTime.text = formatter.localizedString(for: Date(milliseconds: Int64(Double.getDouble(obj.timestamp))), relativeTo: Date())
            
            cell.imageProfile.kf.setImage(with: URL(string:kBucketUrl + String.getString(kSharedInstance.getDictionary(users[String.getString(obj.to)])["Image"])),placeholder: #imageLiteral(resourceName: "no_profile_image"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTVC.identifier, for: indexPath) as! MessageTVC
            let obj = unreadData[indexPath.row]
            cell.labelMessage.text = obj.last_message
            cell.labelName.text = obj.name == "" ? "Unkown User" : obj.name
            cell.viewReadCount.layer.cornerRadius = cell.viewReadCount.frame.height/2
            cell.viewReadCount.isHidden = true
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            cell.labelTime.text =  formatter.localizedString(for: Date(milliseconds: Int64(Double.getDouble(obj.timestamp))), relativeTo: Date())
            
            cell.imageProfile.kf.setImage(with: URL(string:kBucketUrl + String.getString(kSharedInstance.getDictionary(users[String.getString(obj.to)])["Image"])),placeholder: #imageLiteral(resourceName: "no_profile_image"))
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTab == 0{
            guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
            vc.receiverid = String.getString(data[indexPath.row].from) == UserData.shared.id ? (String.getString(data[indexPath.row].to)) : (String.getString(data[indexPath.row].from))
            vc.receivername = String.getString(data[indexPath.row].name)
            //vc.receiverprofile_image = kBucketUrl+String.getString(obj.user?.profile_pic)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
            vc.receiverid = String.getString(data[indexPath.row].from) == UserData.shared.id ? (String.getString(data[indexPath.row].to)) : (String.getString(data[indexPath.row].from))
            vc.receivername = String.getString(unreadData[indexPath.row].name)
            //vc.receivername = String.getString(obj.user?.first_name) + " " + String.getString(obj.user?.last_name)
            //vc.receiverprofile_image = kBucketUrl+String.getString(obj.user?.profile_pic)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            // delete the item here
            let recId = String.getString(self.data[indexPath.row].from) == UserData.shared.id ? (String.getString(self.data[indexPath.row].to)) : (String.getString(self.data[indexPath.row].from))
            if self.selectedTab == 0{
                Chat_hepler.Shared_instance.deleteChatNode(Senderid: UserData.shared.id, Receiverid:recId )
            }
            else{
                Chat_hepler.Shared_instance.deleteChatNode(Senderid: UserData.shared.id, Receiverid: recId)
            }
            self.getData()
            self.tableViewMessages.reloadData()
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "bin")
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class MessageTVC: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelReadCount: UILabel!
    @IBOutlet weak var viewReadCount: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
}
