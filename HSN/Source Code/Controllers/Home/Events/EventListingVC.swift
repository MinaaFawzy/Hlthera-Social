//
//  EventListingVC.swift
//  HSN
//
//  Created by Prashant Panchal on 16/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class EventListingVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet  var constraintHideBtns: NSLayoutConstraint!
    @IBOutlet  var constraintShowBtns: NSLayoutConstraint!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var buttonAddEvent: UIButton!
    @IBOutlet weak var buttonAddEventTop: UIButton!
    @IBOutlet weak var constraintTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    var hasCameFrom:HasCameFrom = .viewEvent
    var pageId = ""
    var events:[EventListModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    var searchResults:[EventListModel] = []
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
            
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
        setupRefreshControl()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search Events"
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    func getData(){
        switch hasCameFrom{
        case .viewEvent:
            globalApis.getAllEvents(){ data in
                self.events = data
                
                self.tableView.refreshControl?.endRefreshing()
                
            }
            self.constraintHideBtns.isActive = true
            self.constraintHideBtns.constant = 15
            self.constraintShowBtns.isActive = false
            self.buttonAddEvent.isHidden = true
            self.buttonSkip.isHidden = true
        case .viewCompanyEvent:
            
            globalApis.getAllPageEvents(pageId: pageId){ data in
                self.events = data.filter{$0.company_id == self.pageId}
                self.tableView.refreshControl?.endRefreshing()
                self.constraintHideBtns.isActive = false
                self.constraintShowBtns.constant = 15
                self.constraintShowBtns.isActive = true
                self.buttonAddEventTop.isHidden = true
                
            }
        default:break
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
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSkipTapped(_ sender: Any) {
        kSharedAppDelegate?.moveToHomeScreen()
    }
    @IBAction func buttonAddTapped(_ sender: Any) {
        
        switch hasCameFrom{
        case .viewEvent:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateEventVC.getStoryboardID()) as? CreateEventVC else { return }
    //                vc.groupId = self.activeGroups[indexPath.row].group_id
    //                vc.data = data
    //                if self.activeGroups[indexPath.row].is_admin == "1"{
    //                    vc.hasCameFrom = .viewGroup
    //                }
    //                else{
    //                    vc.hasCameFrom = .viewGroupAdmin
    //                }
            self.navigationController?.pushViewController(vc, animated: true)
        case .viewCompanyEvent:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateEventVC.getStoryboardID()) as? CreateEventVC else { return }
            vc.hasCameFrom = .createCompanyEvent
            vc.companyId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        default:break
        }
     
        
        
        
        

        
    }
    @IBAction func buttonSearchTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.searchBar.isHidden = false
            self.isSearching = true
            self.constraintTableViewTop.constant = 50
            self.searchBar.becomeFirstResponder()
        }
        else{
            self.searchBar.isHidden = true
            self.isSearching = false
            self.constraintTableViewTop.constant = 0
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
extension EventListingVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearching ? searchResults.count : events.count
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupListTVC.identifier, for: indexPath) as! GroupListTVC
        
        let obj = isSearching ? searchResults[indexPath.row] : events[indexPath.row]
        cell.labelName.text = String.getString(obj.event?.name).capitalized
        cell.labelTotalMembers.text = "\(String.getString(obj.event?.start_date)) | \(String.getString(obj.event?.start_time))" + " - " + "\(String.getString(obj.event?.end_date)) | \(String.getString(obj.event?.end_time))"
           
            
        cell.imageGroup.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.event?.event_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
        
            cell.stackView.isHidden = true
            cell.viewMembers.isHidden = true
        cell.buttonRadio.isHidden = true
      
            
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
        let obj = isSearching ? searchResults[indexPath.row] : events[indexPath.row]
        
        
        switch hasCameFrom{
        case .viewEvent:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
        vc.eventId = obj.event_id
            if obj.is_orgnizer == "1"{
                vc.hasCameFrom = .viewEventAdmin
            }else{
                vc.hasCameFrom = .viewEvent
            }
            vc.pageId = self.pageId

            self.navigationController?.pushViewController(vc, animated: true)
        case .viewCompanyEvent:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
        vc.eventId = obj.event_id
            if obj.is_orgnizer == "1"{
                vc.hasCameFrom = .viewEventCompanyAdmin
            }else{
                vc.hasCameFrom = .viewCompanyEvent
            }
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        default:break
        }
     
      
      
        
        
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                var obj = self.events[indexPath.row]
                    let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                        
                        if self.hasCameFrom == .viewCompanyEvent{
                            globalApis.deletePageEvent(id: obj.event_id, completion: {
                                self.getData()
                                self.tableView.reloadData()
                            })
                        }
                        else if self.hasCameFrom == .viewEvent && obj.user_id == UserData.shared.id{
                            globalApis.deleteEvent(id: obj.event_id, completion: {
                                self.getData()
                                self.tableView.reloadData()
                            })
                        }
                        else{
                            CommonUtils.showToast(message: "Event can only be deleted by admin")
                            return
                        }
                        
                        
                    }
                    deleteAction.image = #imageLiteral(resourceName: "delete_white")
                    deleteAction.backgroundColor = .red
                
                    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

                    return configuration
                    
                
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

extension EventListingVC:UISearchBarDelegate{
    func hideSearch(){
        searchBar.text = ""
        isSearching = false
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        
        searchResults = self.events.filter{String.getString($0.event?.name).lowercased().prefix(searchText.count) == searchText.lowercased()}
      
        self.tableView.reloadData()
    }
   
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearch()
    }
    @objc func buttonCrossTapped(_ sender:Any){
       
        hideSearch()
    }

    
}
