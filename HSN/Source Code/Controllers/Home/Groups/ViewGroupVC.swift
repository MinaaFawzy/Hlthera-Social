//
//  ViewGroupVC.swift
//  HSN
//
//  Created by Prashant Panchal on 15/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewGroupVC: UIViewController,UpdateProfilePageProtocal {
    func currentProfilePage(index: Int) {
        self.selectedTab = index
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelGroupName: UILabel!
    var isCameFromNotififications = false
    var selectedTab = 0
    {
        didSet{
            
            self.tableView.reloadData()
        }
    }
    var groupId = ""
    var data:HSNGroupModel?
    var adminData:[GroupUserModel] = []
    var hasCameFrom:HasCameFrom = .viewGroup
    var groupHeaderView:GroupHeaderView?
    var groupAboutView:GroupAboutHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
            
        } else {
            // Fallback on earlier versions
        }
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupTableView()
        setupRefreshControl()
        self.adminData = data?.group_members.filter{$0.is_admin} ?? []
        
        self.labelGroupName.text = data?.name ?? "Group"
        self.groupHeaderView = UINib(nibName: "GroupHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? GroupHeaderView
        self.groupAboutView = UINib(nibName: "GroupAboutHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? GroupAboutHeader
        self.groupHeaderView?.initialSetup(hasCameFrom,userData: data ,parentVC: self,selectedTab: self.selectedTab,protocal: self)
        self.groupAboutView?.initialSetup(hasCameFrom, userData: data, parentVC: self)
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
        self.tableView.reloadData()
        if data == nil{
            getData()
        }
        // Do any additional setup after loading the view.
    }
    func getData(){
        globalApis.getGroup(id: groupId){ data in
            self.data = data
            self.adminData = data.group_members.filter{$0.is_admin}
            self.labelGroupName.text = data.name
            self.groupHeaderView?.updateData(data: data)
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
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
        tableView.register(UINib(nibName: ExperienceTVC.identifier, bundle: nil), forCellReuseIdentifier: ExperienceTVC.identifier)
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableView.register(UINib(nibName: RateRecommendReviewTVC.identifier, bundle: nil), forCellReuseIdentifier: RateRecommendReviewTVC.identifier)
        tableView.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableView.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        tableView.register(UINib(nibName: ConnectionsTVC.identifier, bundle: nil), forCellReuseIdentifier: ConnectionsTVC.identifier)
        
        
    }
    
    
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        if isCameFromNotififications{
            kSharedAppDelegate?.moveToHomeScreen(index: 3)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
   
    @IBAction func buttonMoreTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OptionsSheetVC.getStoryboardID()) as? OptionsSheetVC else { return }
        vc.hasCameFrom = .viewGroup
        vc.data = self.data
        vc.parentVC = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
       
    }
    @IBAction func buttonCreateGroupTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreatePostVC.getStoryboardID()) as? CreatePostVC else { return }
        vc.hasCameFrom = .createGroupPost
        vc.groupId = String.getString(self.data?.id)
        vc.groupName = String.getString(data?.name)
        vc.selectedVisibility = 3
        self.navigationController?.pushViewController(vc, animated: true)
        
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
extension ViewGroupVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTab == 0{
            return 2
            
        }
        else{
            return 4
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if selectedTab == 0{
            switch section{
            case 0:
                return self.groupHeaderView
            default:
                return UIView()
            }
        }else{
            switch section{
            case 0:
                return self.groupHeaderView
            case 1:
                return self.groupAboutView
            case 2:
                return tableView.createHeaderView(text: "Group Admins")
            case 3:
                return tableView.createHeaderView(text: "Members")
                
            default:return UIView()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if selectedTab == 0{
            switch section{
            case 0:
                return UITableView.automaticDimension
            default:
                return 0
            }
        }else{
            switch section{
            case 0:
                return UITableView.automaticDimension
            case 1:
                return UITableView.automaticDimension
            case 2:
                return 30
            case 3:
                return 30
                
            default:return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0{
            switch section{
            case 0:
                return 0
            default:
                return data?.user_post.count ?? 0
            }
        }else{
            switch section{
            case 0:
                return 0
            case 1:
                return 0
            case 2:
                return adminData.count
            case 3:
                return data?.group_members.count ?? 0
                
            default:return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedTab == 0{
            switch indexPath.section{
            default:
                if let postData = data?.user_post{
                    if postData.indices.contains(indexPath.row){
                        let obj = postData[indexPath.row]
                        switch Int.getInt(obj.is_post_type){
                        
                        case 7:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.updateCell(data: obj, type: .findExpert, isShared: false,cameFrom: self.hasCameFrom)
                            return cell
                        case 6:
                            switch Int.getInt(obj.share_post?.is_post_type){
                            case 7:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.updateCell(data: obj, type: .findExpert, isShared: true,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                                return cell
                            case 5:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                if postData.indices.contains(indexPath.row){
                                    let obj = postData[indexPath.row]
                                    cell.updateCell(data: obj, type: .poll, isShared:true,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                                    cell.parent = self
                                }
                                return cell
                            case 1,2,3,4:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.updateCell(data: obj, type: .media, isShared:true,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                                cell.groupData = self.data
                                cell.parent = self
                                return cell
                            case 0:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.updateCell(data: obj, type: .text,isShared:true,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                                cell.parent = self
                                return cell
                            default:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.updateCell(data: obj, type: .text, isShared: true,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                                        cell.parent = self
                                    return cell
                            }
                        case 5:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            if postData.indices.contains(indexPath.row){
                                let obj = postData[indexPath.row]
                         
                                cell.updateCell(data: obj, type: .poll,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                                cell.parent = self
                            }
                            return cell
                        case 1,2,3,4:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.updateCell(data: obj, type: .media,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                            cell.parent = self
                            return cell
                        case 0:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                            
                            cell.parent = self
                            return cell
                        default:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom,groupData:self.data ?? HSNGroupModel(data: [:]))
                                    cell.parent = self
                            cell.isShared = false
                                return cell
                        }
                        
                       
                    }
                  
                }
                
            
            }
        }else{
            switch indexPath.section{
            
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionsTVC.identifier, for: indexPath) as! ConnectionsTVC
                cell.updateCell(data: adminData[indexPath.row] ?? GroupUserModel(data: [:]))
                cell.buttonMore.isHidden = true
                cell.constraintRemoveConnectionHeight.constant = 0
                cell.buttonRemove.isHidden = true
                cell.buttonMore.isUserInteractionEnabled = true
                cell.deleteCallback = {
                    
                }
                cell.moreCallback = {
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OptionsSheetVC.getStoryboardID()) as? OptionsSheetVC else { return }
                    vc.hasCameFrom = .viewGroupAdmin
                    vc.data = self.data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionsTVC.identifier, for: indexPath) as! ConnectionsTVC
                cell.updateCell(data: data?.group_members[indexPath.row] ?? GroupUserModel(data: [:]))
                cell.constraintRemoveConnectionHeight.constant = 0
                cell.buttonRemove.isHidden = true
                cell.buttonMore.isUserInteractionEnabled = true
                cell.deleteCallback = {
                    
                }
                cell.moreCallback = {
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OptionsSheetVC.getStoryboardID()) as? OptionsSheetVC else { return }
                    vc.hasCameFrom = .viewGroupAdmin
                    vc.data = self.data
                    vc.memberId = self.data?.group_members[indexPath.row].user_id ?? ""
                    vc.parentVC = self
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.present(vc, animated: true)
                }
                return cell
                
            default:return UITableViewCell()
            }
        }
        return UITableViewCell()
       
    }
   
    
    
}
