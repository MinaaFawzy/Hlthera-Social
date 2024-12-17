//
//  GroupsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 15/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
    @IBOutlet var navigationViews: [UIView]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var btnRequested: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var constraintTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var stackViewHghtConstraint : NSLayoutConstraint!
    
    
    var selectedTab = 0
//    {
//        didSet{
//            self.tableView.reloadData()
//        }
//    }
    var isSearching = false
    var data:UserProfileModel?
    var hasCameFrom:HasCameFrom = .viewProfile
    var activeGroups:[GroupListingModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    var requestedGroups:[GroupListingModel] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var searchResults:[GroupListingModel] = []
    var isFromLandingGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     setupNavigation()
        setupTableView()
        setupRefreshControl()
        setStatusBar()
        //#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
       // self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
      //  self.tableView.estimatedSectionHeaderHeight = 0.1;
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        self.searchBar.delegate = self
        self.searchBar.isHidden = true
        //self.constraintTableViewTop.constant = 0
        if isFromLandingGroup {
            self.btnSearch.isHidden = true
            self.btnRequested.isHidden = true
            self.stackView.isHidden = true
            stackViewHghtConstraint.constant = 0
            labelHeaderTitle.text = selectedTab == 0 ? "Your Groups" : "Requested Groups"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData(){
        if isFromLandingGroup {
            globalApis.getGroupsList(){ all,req in
                self.activeGroups = all
                self.requestedGroups = req
                self.tableView.refreshControl?.endRefreshing()
                
            }
        }else{
            globalApis.getAllGroups(){ all in
                self.activeGroups = all
               // self.requestedGroups = req
                self.tableView.refreshControl?.endRefreshing()
                
            }
        }
    }
    
    @objc func refresh(_ sender:UIRefreshControl)
     {
        getData()
        
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
    
    func setupTableView(){
        tableView.register(UINib(nibName: GroupListTVC.identifier, bundle: nil), forCellReuseIdentifier: GroupListTVC.identifier)
    }
    
    func setupNavigation(selectedIndex:Int = 0){
   
        for (index,view) in self.navigationViews.enumerated(){
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
    
    @IBAction func buttonCreateGroupTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateGroupVC.getStoryboardID()) as? CreateGroupVC else { return }
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
        //setupNavigation(selectedIndex: sender.tag)
        if isFromLandingGroup {
            self.selectedTab = sender.tag
        }
   ///     self.tableView.reloadData()
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: GroupsVC.getStoryboardID()) as? GroupsVC else { return }
        vc.selectedTab = sender.tag
        vc.isFromLandingGroup = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonSearchTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.searchBar.isHidden = false
            self.isSearching = true
           // self.constraintTableViewTop.constant = 0 // 50
            self.searchBar.becomeFirstResponder()
        }
        else{
            self.searchBar.isHidden = true
            self.isSearching = false
           // self.constraintTableViewTop.constant = 0
            self.view.endEditing(true)
        }
        self.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension GroupsVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0{
            return isSearching ? searchResults.count : activeGroups.count
        }else{
            return isSearching ? searchResults.count : requestedGroups.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupListTVC.identifier, for: indexPath) as! GroupListTVC
        cell.buttonRadio.isHidden = true
        if selectedTab == 0{
            var obj = activeGroups[indexPath.row]
            if isSearching{
                obj = searchResults[indexPath.row]
            }
            else{
                obj = activeGroups[indexPath.row]
            }
                
                cell.labelName.text = String.getString(obj.group?.name).capitalized
                cell.labelTotalMembers.text = "Total Members: " +  String.getString(obj.join_users.count)
                cell.labelTotalCount.text =  String.getString(obj.join_users.count > 5 ? "+" + String.getString(obj.join_users.count - 4) : obj.join_users.count)
                
                cell.imageGroup.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.group?.group_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.stackView.isHidden = true
                cell.viewMembers.isHidden = isFromLandingGroup ? false :true
                cell.btnJoin.isHidden = (isFromLandingGroup || UserData.shared.id == obj.user_id) ? true : false
                let filter = obj.join_users.filter({$0.id == UserData.shared.id}).count
                cell.btnJoin.setTitle(filter > 0 ? "Joined" : "Join", for: .normal)
                cell.btnJoin.isUserInteractionEnabled = filter > 0 ? false : true
            
                cell.acceptCallback = {
                    globalApis.acceptRejectGroupRequest(id: obj.id, type: 1, groupId: obj.id, memberId: UserData.shared.id,join_group : "1"){
                        self.moveToPopUp(text: "Group has been joined Successfully!", completion: {
                            self.getData()
                        })
                    }
                }
           }
         else{
            var obj = requestedGroups[indexPath.row]
            if isSearching{
                obj = searchResults[indexPath.row]
            }
            else{
                obj = requestedGroups[indexPath.row]
            }
            cell.stackView.isHidden = false
            cell.viewMembers.isHidden = true
            cell.acceptCallback = {
                globalApis.acceptRejectGroupRequest(id: obj.id, type: 1, groupId: obj.group_id, memberId: ""){
                    self.moveToPopUp(text: "Request Accepted Successfully!", completion: {
                        self.getData()
                    })
                }
            }
            cell.rejectCallback = {
                globalApis.acceptRejectGroupRequest(id: obj.id, type: 2, groupId: obj.group_id, memberId: ""){
                    self.moveToPopUp(text: "Request Rejected Successfully!", completion: {
                        self.getData()
                    })
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if selectedTab == 0{
            if isSearching{
                globalApis.getGroup(id: searchResults[indexPath.row].id, completion: { data in
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewGroupVC.getStoryboardID()) as? ViewGroupVC else { return }
                    vc.groupId = self.searchResults[indexPath.row].id
                    vc.data = data
                    if self.searchResults[indexPath.row].is_admin == "1"{
                        vc.hasCameFrom = .viewGroupAdmin
                    }
                    else{
                        vc.hasCameFrom = .viewGroup
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }
            else{
                globalApis.getGroup(id: activeGroups[indexPath.row].id, completion: { data in
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewGroupVC.getStoryboardID()) as? ViewGroupVC else { return }
                    vc.groupId = self.activeGroups[indexPath.row].id
                    vc.data = data
                    if self.activeGroups[indexPath.row].is_admin == "1"{
                        vc.hasCameFrom = .viewGroupAdmin
                    }
                    else{
                        vc.hasCameFrom = .viewGroup
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                })
            }
        }
        
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension GroupsVC:UISearchBarDelegate{
    func hideSearch(){
        searchBar.text = ""
        isSearching = false
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        if selectedTab == 0{
            searchResults = self.activeGroups.filter{String.getString($0.group?.name).lowercased().prefix(searchText.count) == searchText.lowercased()}
        }
        else{
            searchResults = self.requestedGroups.filter{String.getString($0.group?.name).lowercased().prefix(searchText.count) == searchText.lowercased()}
        }
        self.tableView.reloadData()
    }
   
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearch()
    }
    @objc func buttonCrossTapped(_ sender:Any){
       
        hideSearch()
    }

    
}
