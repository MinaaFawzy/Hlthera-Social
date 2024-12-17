//
//  PagesListingVC.swift
//  HSN
//
//  Created by user206889 on 11/16/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import SwiftUI

class PagesListingVC: UIViewController {
    @IBOutlet var navigationViews: [UIView]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var stackViewHghtConstraint : NSLayoutConstraint!
    var isFromLandingPage = false
    var selectedTab = 0
//    {
//        didSet{
//            
//            self.tableView.reloadData()
//        }
//    }
    var data:UserProfileModel?
    var hasCameFrom:HasCameFrom = .viewProfile
    var createdByMe:[CompanyPageModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    var following:[CompanyPageModel] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
            
        } else {
            // Fallback on earlier versions
        }
      //  setupNavigation()
        setupTableView()
        setupRefreshControl()
        setStatusBar()//#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        if isFromLandingPage {
            self.btnFollowing.isHidden = true
            self.stackView.isHidden = true
            stackViewHghtConstraint.constant = 0
            labelHeaderTitle.text = selectedTab == 0 ? "Your Pages" : "Following Pages"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func getData(){
        if isFromLandingPage {
            globalApis.getAllPages(){ mine,followed in
                self.createdByMe = mine
                self.following = followed
                self.tableView.refreshControl?.endRefreshing()
            }
        }else{
            globalApis.getAllCompanyPages(){ mine in
                self.createdByMe = mine
               // self.following = followed
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
    @IBAction func buttonCreatePageTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: SelectBusinessTypeVC.getStoryboardID()) as? SelectBusinessTypeVC else { return }
       
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
       // setupNavigation(selectedIndex: sender.tag)
        if isFromLandingPage { self.selectedTab = sender.tag }
        
        guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: PagesListingVC.getStoryboardID()) as? PagesListingVC else { return }
        vc.isFromLandingPage = true
        vc.selectedTab = sender.tag
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

extension PagesListingVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0{
            return createdByMe.count
        }else{
            return following.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupListTVC.identifier, for: indexPath) as! GroupListTVC
        cell.buttonRadio.isHidden = true
        if selectedTab == 0{
            let obj = createdByMe[indexPath.row]
            cell.labelName.text = String.getString(obj.page_name).capitalized
            cell.labelTotalMembers.text = "Total Members: " +  String.getString(obj.total_followers_count)
            //cell.labelTotalCount.text =  String.getString(obj.join_users.count > 5 ? "+" + String.getString(obj.join_users.count - 4) : obj.join_users.count)
            cell.companyId = obj.id
            cell.imageGroup.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.profile_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            cell.stackView.isHidden = true
            cell.viewMembers.isHidden = false
            cell.buttonFollow.isHidden = true
    
            if obj.adminUsers.contains(where:{ (user: AdminUser) -> Bool in
                (user.parent_user_id == UserData.shared.id) || (user.user_id == UserData.shared.id)}) {
                cell.viewAdmin.isHidden = false
                cell.alignViewConstraint.constant = -10
            }else{
                cell.viewAdmin.isHidden = true
                cell.viewAdmin.isHidden = obj.user_id == UserData.shared.id ? false : true
                cell.alignViewConstraint.constant = obj.user_id == UserData.shared.id ? -10 : 0
            }
            
        }
        else{
            let obj = following[indexPath.row]
            cell.labelName.text = String.getString(obj.page_name).capitalized
            cell.labelTotalMembers.text = "Total Members: " +  String.getString(obj.total_followers_count)
            //cell.labelTotalCount.text =  String.getString(obj.join_users.count > 5 ? "+" + String.getString(obj.join_users.count - 4) : obj.join_users.count)
            
            cell.imageGroup.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.profile_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            cell.companyId = obj.id
            cell.stackView.isHidden = true
            cell.viewMembers.isHidden = false
            cell.buttonFollow.isHidden = false
            cell.stackView.isHidden = true
            cell.viewMembers.isHidden = true
            cell.followUnfollowCallback = {
                globalApis.followUnfollowPageApi(pageId: obj.id, isFollowing: false, completion: { _,_ in
                    self.moveToPopUp(text: "Page unfollowed successfully!", completion: {
                        self.following.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    })
                })
            }
            cell.viewAdmin.isHidden = obj.user_id == UserData.shared.id ? false : true
            
//            return weekDays.contains(where: { (days: DaysModel) -> Bool in
//              slot.fromSlot = days.fromTime
//              slot.toSlot = days.toTime
//              if days.dayName == "All Days" && days.isselected{
//                   print("all days ====")
//                   return true
//              }else{
//                  return slot.day.lowercased() == days.dayName.lowercased() && days.isselected;
//               }
//          })
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if selectedTab == 0{
            globalApis.getCompanyProfile(id: createdByMe[indexPath.row].id, completion: { data in
                guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: ViewPageVC.getStoryboardID()) as? ViewPageVC else { return }
                vc.pageId = data.id
                vc.data = data
                if data.company_page_created_by_me{
                    vc.hasCameFrom = .viewPageAdmin
                }
                else{
                    vc.hasCameFrom = .viewPage
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
        }else{
            globalApis.getCompanyProfile(id: following[indexPath.row].id, completion: { data in
                guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: ViewPageVC.getStoryboardID()) as? ViewPageVC else { return }
                vc.pageId = data.id
                vc.data = data
                if data.company_page_created_by_me{
                    vc.hasCameFrom = .viewPageAdmin
                }
                else{
                    vc.hasCameFrom = .viewPage
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
        if self.selectedTab == 0{
        var obj = self.createdByMe[indexPath.row]
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                globalApis.deletePage(id: obj.id, completion: {
                    self.getData()
                    self.tableView.reloadData()
                })
            }
            deleteAction.image = #imageLiteral(resourceName: "delete_white")
            deleteAction.backgroundColor = .red
        
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

            return configuration
        }
        else{
            return UISwipeActionsConfiguration()
        }
    }

    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
       // let cell = tableView.cellForRow(at: indexPath) as! HomeSearchTVC
       // cell.viewBG.isHidden = false
        let mainView = tableView.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
        if !mainView.isEmpty{
            let backgroundView = mainView[0].subviews
            if !backgroundView.isEmpty{
                backgroundView[0].frame = CGRect(x: 0, y: 5, width: mainView[0].frame.width, height: mainView[0].frame.height-10)
                backgroundView[0].layoutIfNeeded()
            }
        }
        
        }
//    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        if let index = indexPath{
//            let cell = tableView.cellForRow(at: index) as! HomeSearchTVC
//
//            UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
//               // cell.viewBG.isHidden = true
//                cell.viewBG.layoutIfNeeded()
//            })
//        }
//    }
}
