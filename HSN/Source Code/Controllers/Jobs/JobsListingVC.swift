//
//  JobsListingVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class JobsListingVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintSearchHeight: NSLayoutConstraint!
    @IBOutlet var navigationViews: [UIView]!
    
    var selectedIndex = 0
    var selectedSection = 1
    var selectedJobType = ""
    var data:[JobModel] = [] {
        didSet{
            
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()

        }
    }
    var selectedFilter:[Int:Int] = [:]
    var filter:[String:Any] = [ApiParameters.job_title:"",
                               ApiParameters.job_type:"",
                               ApiParameters.duration_type:"",
                               ApiParameters.distance:"",
                               ApiParameters.user_latitude:"",
                               ApiParameters.user_longitude:""]
    var jobHeaderView:ViewJobHeader?
    var selectedTab = 0
    {
        didSet{
            getData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupTableView()
        setupRefreshControl()
        self.jobHeaderView = UINib(nibName: "ViewJobHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ViewJobHeader
        constraintSearchHeight.constant = 0
       // self.jobHeaderView?.initialSetup(hasCameFrom,userData: data ,parentVC: self,selectedTab: self.selectedTab,protocal: self)
        
        setupNavigation()
        

        // Do any additional setup after loading the view.
    }
    
    func getData(){
        if selectedTab == 0{
            globalApis.getAllJobs(filter: filter, completion: {
                data in
                self.data = data        })
        }
        else{
            globalApis.getAllFavouriteJobs(jobTitle:"", completion: {
                data in
                self.data = data        })
            
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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
            
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UINib(nibName: ViewJobTVC.identifier, bundle: nil), forCellReuseIdentifier: ViewJobTVC.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
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
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSearchTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            constraintSearchHeight.constant = 50
            
        }
        else{
            constraintSearchHeight.constant = 0
        }
    }
    func getJobType(index:Int)->String{
        switch index{
        case 0:
            return "Coorperate Jobs"
        case 1:
            return "Public Sector"
        case 2:
            return "Coorperate Jobs"
        default:return ""
        }
        
    }
    @IBAction func buttonFilterTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: FilterJobVC.getStoryboardID()) as? FilterJobVC else {return}
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selectedFilter = selectedFilter
        vc.selectedJobType = selectedJobType
         vc.callback = { jobType,selection in
             self.selectedFilter = selection
             self.selectedJobType = jobType
             if !self.selectedJobType.isEmpty{
                 self.filter[ApiParameters.job_type] = jobType
             }else{
                 self.filter[ApiParameters.job_type] = ""
             }
             if self.selectedFilter.keys.contains(2){
                 self.filter[ApiParameters.duration_type] = String.getString((self.selectedFilter[1] ?? 0) + 1)
             }
             else{
                 self.filter[ApiParameters.duration_type] = ""
             }
             if self.selectedFilter.keys.contains(3){
                 self.filter[ApiParameters.distance] = String.getString((self.selectedFilter[2] ?? 0) + 1)
                 self.filter[ApiParameters.user_latitude] = ""
                 self.filter[ApiParameters.user_longitude] = ""
             }
             else{
                 self.filter[ApiParameters.distance] = ""
                 self.filter[ApiParameters.user_latitude] = ""
                 self.filter[ApiParameters.user_longitude] = ""
             }
             self.getData()
         }
         UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: { })
        
    }
    
    @IBAction func buttonTabTapped(_ sender: UIButton) {
        setupNavigation(selectedIndex: sender.tag)
        self.selectedTab = sender.tag
        
        
    }
    
}
extension JobsListingVC:UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        switch section{
//        case 0:
//            return tableView.createHeaderView(text: "Recommended Jobs")
//        default:
//            return tableView.createHeaderView(text: "Similar Jobs")
//        }
//
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        if selectedTab == 0{
//            switch section{
//            case 0:
//                return UITableView.automaticDimension
//            default:
//                return 0
//            }
//        }else{
//            switch section{
//            case 0:
//                return UITableView.automaticDimension
//            case 1:
//                return UITableView.automaticDimension
//            case 2:
//                return 30
//            case 3:
//                return 30
//
//            default:return 0
//            }
//        }
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0{
            return data.count
        }else{
            return data.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewJobTVC.identifier, for: indexPath) as! ViewJobTVC
        let obj = data[indexPath.row]
        cell.labelCompanyName.text = obj.company?.business_name
        cell.labelJobTitle.text = obj.job_title
        cell.labelLocation.text = obj.location
        cell.labelConnections.text = obj.facility
        cell.labelJobPostedDate.text = obj.posted_date
        cell.imageCompanyLogo.downlodeImage(serviceurl: String.getString(kBucketUrl + String.getString(obj.company?.profile_pic)), placeHolder: UIImage(named: "profile_placeholder"))
        cell.viewMembers.isHidden = false
       // cell.labelJobPostedDate.text = getDateFromCreatedAtString(dateString: String.getString(obj.posted_date))
        let date = Date(unixTimestamp: Double.getDouble(obj.posted_date))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        cell.labelJobPostedDate.text = formatter.localizedString(for: date, relativeTo: Date())
        cell.buttonBookmark.isSelected = obj.is_favourite
        cell.bookmarkCallback = {
            globalApis.favoriteUnfavoriteJob(jobId: obj.id, status: !obj.is_favourite, completion: {
                status in
                obj.is_favourite = status
                cell.buttonBookmark.isSelected = status
            })
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: ViewJobVC.getStoryboardID()) as? ViewJobVC else { return }
        vc.jobId = self.data[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension JobsListingVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            self.filter[ApiParameters.job_title] = ""
        }
        else{
            self.filter[ApiParameters.job_title] = searchText
        }
        getData()
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.filter[ApiParameters.job_title] = ""
        getData()
    }
    @objc func buttonCrossTapped(_ sender:Any){
        self.filter[ApiParameters.job_title] = ""
    }
}
