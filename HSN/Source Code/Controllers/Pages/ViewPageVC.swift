//
//  ViewPageVC.swift
//  HSN
//
//  Created by user206889 on 11/16/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import GooglePlaces
class ViewPageVC: UIViewController,UpdateProfilePageProtocal,SubTabSwitchProtocol {
    func didSelectTab(on index: Int) {
        self.selectedSubTab = index
        if selectedTab == 4{
            if lifes.indices.contains(index){
                self.selectedLife = self.lifes[index]
            }
        }
        else if selectedTab == 0{
            getData()
        }
    }
    
    func currentProfilePage(index: Int) {
        self.selectedTab = index
    }
    
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelGroupName: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    
    var navView:PageSubTabsView?
    var selectedLife:PageLifeModel? {
        didSet{
            self.tableView.reloadData()
        }
    }
    var jobs:[JobModel] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var lifes:[PageLifeModel] = []
    var events:[EventListModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    var products:[PageProductModel] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var isCameFromNotififications = false
    var selectedTab = 0
    {
        didSet{
            switch selectedTab {
            case 0:
                navView?.refreshNav(data: ["All","Image","Video","Article","Document"])
            case 2:
                globalApis.getPageProductsLife(type: selectedTab == 2 ? .productMedia : .lifeMedia, pageId: self.pageId, completion: {
                    products,_,_ in
                    self.products = products
                    
                })
            case 3:
               
                globalApis.getPageProductsLife(type: .jobMedia, pageId: self.pageId, completion: {
                    _,_,jobs in
                    self.jobs = jobs
                    
                })
            case 4:
                globalApis.getPageProductsLife(type: .lifeMedia, pageId: self.pageId, completion: {
                    _,lifes,_ in
                    self.lifes = lifes
                    self.navView?.refreshNav(data: lifes.map{$0.view_name.capitalized})
                    
                })
            case 6:
                globalApis.getAllPageEvents(pageId: self.pageId, completion: {
                    events in
                    self.events = events.filter{$0.company_id == String.getString(self.data?.id)}
                    //self.navView?.refreshNav(data: lifes.map{$0.view_name.capitalized})
                    
                })
            default:break
            }
            self.tableView.reloadData()
        }
    }
    var selectedSubTab = 0
    var pageId = ""
    var data:CompanyPageModel?
    var adminData:[GroupUserModel] = []
    var hasCameFrom:HasCameFrom = .viewPage
    var pagesHeaderView:PagesHeaderView?
    var pageAboutView:PageAboutView?
    
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
       // self.adminData = data?.group_members.filter{$0.is_admin} ?? []
        
        self.labelGroupName.text = data?.page_name ?? "Page"
        self.pagesHeaderView = UINib(nibName: "PagesHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? PagesHeaderView
        self.pageAboutView = UINib(nibName: "PageAboutView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? PageAboutView
        self.navView = UINib(nibName: "PageSubTabsView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? PageSubTabsView
        self.navView?.initialSetup(parent: self)
        self.navView?.didChangeProtocol = self
        
       
        navView?.refreshNav(data: ["All","Image","Video","Article","Document"])
        self.pagesHeaderView?.initialSetup(hasCameFrom,userData: data ,parentVC: self,selectedTab: self.selectedTab,protocal: self)
        self.pageAboutView?.initialSetup(hasCameFrom, userData: data, parentVC: self)
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
        self.tableView.reloadData()
        if data == nil{
            getData()
        }
        // Do any additional setup after loading the view.
    }
    
    func getCurrentPostType()->Int{
        switch selectedSubTab{
        case 0:
            return -1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 0
        case 4:
            return 3
        
        default:return 00
        }
    }
    
    func getData(){
        globalApis.getCompanyProfile(id: pageId,type: getCurrentPostType()){ data in
            self.data = data
            //self.adminData = data.group_members.filter{$0.is_admin}
            self.labelGroupName.text = data.page_name
            if data.company_page_created_by_me{
                self.buttonEdit.isHidden = false
                self.buttonAdd.setImage(UIImage(named: "create_post"), for: .normal)
                
            }
            else{
                self.buttonEdit.isHidden = true
                self.buttonAdd.setImage(UIImage(named: "bell_white_white"), for: .normal)
                
            }
            self.pagesHeaderView?.updateData(data: data)
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
        globalApis.getAllPageEvents(pageId: self.pageId, completion: {
            events in
            self.events = events.filter{$0.company_id == String.getString(self.data?.id)}
            //self.navView?.refreshNav(data: lifes.map{$0.view_name.capitalized})
            
        })
        globalApis.getPageProductsLife(type: .jobMedia, pageId: self.pageId, completion: {
            _,_,jobs in
            self.jobs = jobs
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
 
    @objc func refresh(_ sender:UIRefreshControl) {
        getData()
     }
    
    func calculateLifesRows()->Int{
        if let obj = selectedLife{
            var total = 0
            if !obj.media.isEmpty{
                total = total + 1
            }
            if obj.company_leader_visibility{
                total = total + 1
            }
            if obj.company_testimonials_visibility{
                total = total + 1
            }
            if obj.company_photos_visibility{
                total = total + 1
            }
            let totalModules = obj.company_spot_light.filter{$0.spotlight_visibility}.count
            total = total + totalModules
            return total
        }
        else{
            return 0
        }
    }
    
    func setupRefreshControl(){

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupTableView(){
        tableView.register(UINib(nibName: GroupListTVC.identifier, bundle: nil), forCellReuseIdentifier: GroupListTVC.identifier)
        tableView.register(UINib(nibName: ExperienceTVC.identifier, bundle: nil), forCellReuseIdentifier: ExperienceTVC.identifier)
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableView.register(UINib(nibName: RateRecommendReviewTVC.identifier, bundle: nil), forCellReuseIdentifier: RateRecommendReviewTVC.identifier)
        tableView.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableView.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        tableView.register(UINib(nibName: ConnectionsTVC.identifier, bundle: nil), forCellReuseIdentifier: ConnectionsTVC.identifier)
        tableView.register(UINib(nibName: HomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: HomeSearchTVC.identifier)
        tableView.register(PageMediaTVC.nib, forCellReuseIdentifier: PageMediaTVC.identifier)
        tableView.register(PageLifeLeadersTVC.nib, forCellReuseIdentifier: PageLifeLeadersTVC.identifier)
        tableView.register(PageLifeViewModuleTVC.nib, forCellReuseIdentifier: PageLifeViewModuleTVC.identifier)
        tableView.register(PageLifeViewTestimonialsTVC.nib, forCellReuseIdentifier: PageLifeViewTestimonialsTVC.identifier)
        tableView.register(PageLifePhotosTVC.nib, forCellReuseIdentifier: PageLifePhotosTVC.identifier)
        tableView.register(PageProductsListViewTVC.nib, forCellReuseIdentifier: PageProductsListViewTVC.identifier)
        tableView.register(UINib(nibName: ViewJobTVC.identifier, bundle: nil), forCellReuseIdentifier: ViewJobTVC.identifier)
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
        vc.pageData = self.data
        vc.parentVC = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        switch selectedTab{
        case 3:
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddProductsLifeVC.getStoryboardID()) as? AddProductsLifeVC else { return }
            vc.hasCameFrom = .createJob
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EventListingVC.getStoryboardID()) as? EventListingVC else { return }
            vc.hasCameFrom = .viewCompanyEvent
            vc.pageId = self.pageId
            self.navigationController?.pushViewController(vc, animated: true)
       default:break
        }
    }
    
    @IBAction func buttonCreateGroupTapped(_ sender: Any) {
        if selectedTab == 6{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateEventVC.getStoryboardID()) as? CreateEventVC else { return }
            vc.hasCameFrom = .createCompanyEvent
            vc.companyId = String.getString(self.data?.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if selectedTab == 3{
            if let obj = data{
                if obj.company_page_created_by_me{
                    guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: CreateJobVC.getStoryboardID()) as? CreateJobVC else { return }
                    vc.pageId = self.pageId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: CreateJobAlertVC.getStoryboardID()) as? CreateJobAlertVC else { return }
                    vc.callback = { title,location in
                        globalApis.createJobAlert(id: self.pageId, title: title, location: location.name ?? "", completion: {
                            self.moveToPopUp(text: "Job alert saved!", completion: {
                                
                            })
                        })
                        
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.present(vc, animated: true)
                }
            }
        }
        else{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreatePostVC.getStoryboardID()) as? CreatePostVC else { return }
            vc.hasCameFrom = .createPagePost
            vc.pageId = String.getString(self.data?.id)
            vc.pageName = String.getString(data?.page_name)
          //  vc.selectedVisibility = 3
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

extension ViewPageVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedTab{
        case 0:
            return 3
        case 4:
            return 7//calculateLifesRows() + 2
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch selectedTab{
        case 0:
            switch section{
            case 0:
                return self.pagesHeaderView
            case 1:
                return self.navView
            case 2:
                return UIView()
            default:return UIView()
            }
        case 1:
            switch section{
            case 0:
                return self.pagesHeaderView
            case 1:
                return self.pageAboutView
            default:return UIView()
            }
        case 4:
            switch section{
            case 0:
                return self.pagesHeaderView
            case 1:
                return self.navView
            case 2:
                return UIView() //media
            case 3:
                return UIView() //leaders
            case 4:
                return UIView() //modules
            case 5:
                return UIView() //Testimonials
            case 6:
                return UIView() //Company Photos
                
            default:return UIView()
            }
        default:
            switch section{
            case 0:
                return self.pagesHeaderView
            case 2:
                return UIView()
            default:return UIView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch selectedTab{
        case 0:
            switch section{
            case 0:
                return UITableView.automaticDimension
            case 1:
                return UITableView.automaticDimension
            case 2:
                return 0
            default:return 0
            }
        case 1:
            switch section{
            case 0:
                return UITableView.automaticDimension
            case 1:
                return UITableView.automaticDimension
            default:return 0
            }
        case 4:
            let obj = selectedLife ?? PageLifeModel(data: [:])
            switch section{
            case 0:
                return UITableView.automaticDimension
            case 1:
                return UITableView.automaticDimension
            case 2:
                return  0//media
            case 3:
                return obj.members_of_company_leader.isEmpty ? 0 : 0 //30 //leaders
            case 4:
                return obj.company_spot_light.isEmpty ? 0 : 0 //30 //modules
                
            case 5:
                return obj.company_testimonial.isEmpty ? 0 : 0 //30 //Testimonials
            
            case 6:
                return obj.company_photos.isEmpty ? 0 : 0 //30  //Company Photos
                
            default:return 0
            }
        default:
            switch section{
            case 0:
                return UITableView.automaticDimension
            case 2:
                return 0
            default:return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch selectedTab{
        case 0:
            switch section{
            case 0:
                return 0
            case 1:
                return 0
            case 2:
                return data?.company_post.count ?? 0
            default:return 0
            }
        case 1:
            switch section{
            case 0:
                return 0
            case 1:
                return 0
            default:return 0
            }
        case 2:
            switch section{
            case 0:
                return 0
            case 1:
                return products.count
            default:return 0
            }
        case 3:
            switch section{
            case 0:
                return 0
            case 1:
                return jobs.count
            default:return 0
            }
        case 4:
            let obj = selectedLife ?? PageLifeModel(data: [:])
            switch section{
            case 0:
                return 0
            case 1:
                return 0
            case 2:
                return  obj.media.isEmpty ? 0 : 1 //media
            case 3:
                return obj.members_of_company_leader.isEmpty ? 0 : obj.company_leader_visibility ? 1 : 0 //leaders
            case 4:
                let visibleModules = obj.company_spot_light.filter{$0.spotlight_visibility}
                self.selectedLife?.company_spot_light = visibleModules
                return obj.company_spot_light.isEmpty ? 0 : visibleModules.count  //modules
                
            case 5:
                return obj.company_testimonial.isEmpty ? 0 : obj.company_testimonials_visibility ? 1 : 0 //Testimonials
            
            case 6:
                return obj.company_photos.isEmpty ? 0 : obj.company_photos_visibility ? 1 : 0 //Company Photos
                
            default:return 0
            }
        case 5:
            switch section{
            case 0:
                return 0
            case 1:
                return data?.total_followers.count ?? 0
            default:return 0
            }
        case 6:
            switch section{
            case 0:
                return 0
            case 1:
                return events.count
            default:return 0
            }
        default:
            switch section{
            case 0:
                return 0
            case 2:
                return 0
            default:return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        switch selectedTab{
        case 0:
            switch section{
            case 0:
                return UITableViewCell()
            case 1:
                return UITableViewCell()
            case 2:
                if let postData = data?.company_post{
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
                                cell.updateCell(data: obj, type: .findExpert, isShared: true,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                                return cell
                            case 5:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                if postData.indices.contains(indexPath.row){
                                    let obj = postData[indexPath.row]
                                    cell.updateCell(data: obj, type: .poll, isShared:true,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                                    cell.parent = self
                                }
                                return cell
                            case 1,2,3,4:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.updateCell(data: obj, type: .media, isShared:true,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                                cell.pageData = self.data
                                cell.parent = self
                                return cell
                            case 0:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.updateCell(data: obj, type: .text,isShared:true,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                                cell.parent = self
                                return cell
                            default:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.updateCell(data: obj, type: .text, isShared: true,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                                        cell.parent = self
                                    return cell
                            }
                        case 5:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            if postData.indices.contains(indexPath.row){
                                let obj = postData[indexPath.row]
                         
                                cell.updateCell(data: obj, type: .poll,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                                cell.parent = self
                            }
                            return cell
                        case 1,2,3,4:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.updateCell(data: obj, type: .media,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                            cell.parent = self
                            return cell
                        case 0:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                            
                            cell.parent = self
                            return cell
                        default:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom,pageData:self.data ?? CompanyPageModel(data: [:]))
                                    cell.parent = self
                            cell.isShared = false
                                return cell
                        }
                    }
               }
                    return UITableViewCell()
                
            default:return UITableViewCell()
            }
        case 1:
            switch section{
            case 0:
                return UITableViewCell()
            case 1:
                return UITableViewCell()
            default:return UITableViewCell()
            }
        case 2:
            switch section{
            case 0:
                return UITableViewCell()
            case 1:
                if !products.isEmpty{
                    let cell = tableView.dequeueReusableCell(withIdentifier: PageProductsListViewTVC.identifier, for: indexPath) as! PageProductsListViewTVC
                    let obj = products[indexPath.row]
                    cell.labelProductName.text = obj.product_name.capitalized
                    cell.labelDescription.text = obj.tagline
                    cell.labelndustryType.text = obj.industry
                    cell.imageLogo.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: UIImage(named: "dummy_cover")!)
                    
                    return cell
                    
                }
                else{
                    return UITableViewCell()
                }
            default:return UITableViewCell()
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewJobTVC.identifier, for: indexPath) as! ViewJobTVC
            let obj = jobs[indexPath.row]
            cell.labelCompanyName.text = obj.company?.business_name
            cell.labelJobTitle.text = obj.job_title
            cell.labelLocation.text = obj.location
            cell.labelConnections.text = obj.facility
            cell.labelJobPostedDate.text = obj.posted_date
            cell.imageCompanyLogo.downlodeImage(serviceurl: String.getString(kBucketUrl + String.getString(obj.company?.profile_pic)), placeHolder: UIImage(named: "profile_placeholder"))
            let date = Date(unixTimestamp: Double.getDouble(obj.posted_date))
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            cell.labelJobPostedDate.text = formatter.localizedString(for: date, relativeTo: Date())
            cell.viewMembers.isHidden = false
            cell.buttonBookmark.isSelected = obj.is_favourite
            cell.bookmarkCallback = {
                globalApis.favoriteUnfavoriteJob(jobId: obj.id, status: !obj.is_favourite, completion: {
                    status in
                    obj.is_favourite = status
                    cell.buttonBookmark.isSelected = status
                })
            }
            return cell
        case 4:
            
            let obj = selectedLife ?? PageLifeModel(data: [:])
            switch section{
            case 0:
                return UITableViewCell()
            case 1:
                return UITableViewCell()
            case 2:
                if !obj.media.isEmpty{
                    let cell = tableView.dequeueReusableCell(withIdentifier: PageMediaTVC.identifier, for: indexPath) as! PageMediaTVC
                    cell.backgroundColor = .red
                    cell.playMedia(url: obj.media, on: self)
                    return cell
                }
                else{
                    return UITableViewCell()
                }
            case 3:
                if !obj.members_of_company_leader.isEmpty{
                    let cell = tableView.dequeueReusableCell(withIdentifier: PageLifeLeadersTVC.identifier, for: indexPath) as! PageLifeLeadersTVC
                    cell.isDeleteHidden = true
                    cell.updateData(heading: obj.company_leader_headline, description: obj.company_leader_content, data: obj.company_leader_name)
                    return cell
                }
                else{
                    return UITableViewCell()
                }
            case 4:
                if !obj.company_spot_light.isEmpty{
                    let cell = tableView.dequeueReusableCell(withIdentifier: PageLifeViewModuleTVC.identifier, for: indexPath) as! PageLifeViewModuleTVC
                    cell.updateData(data: obj.company_spot_light[indexPath.row], on: self)
                    return cell
                }
                else{
                    return UITableViewCell()
                }
                
            case 5:
                if !obj.company_testimonial.isEmpty{
                    let cell = tableView.dequeueReusableCell(withIdentifier: PageLifeViewTestimonialsTVC.identifier, for: indexPath) as! PageLifeViewTestimonialsTVC
                    cell.updateData(data: obj.company_testimonial)
                    return cell
                }
                else{
                    return UITableViewCell()
                }
            
            case 6:
                if !obj.company_photos.isEmpty{
                    let cell = tableView.dequeueReusableCell(withIdentifier: PageLifePhotosTVC.identifier, for: indexPath) as! PageLifePhotosTVC
                    cell.updateData(data: obj.company_photos)
                    return cell
                    
                }
                else{
                    return UITableViewCell()
                }
                
            default:return UITableViewCell()
            }
        case 5:
            switch section{
            case 0:
                return UITableViewCell()
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchTVC.identifier,for: indexPath) as! HomeSearchTVC
                let obj = data?.total_followers[indexPath.row] ?? AllUserModel(data: [:])
                cell.buttonSelection.isHidden = true
                cell.labelUserName.text = obj.full_name.capitalized
                cell.labelProfession.text = obj.employee_type.capitalized.isEmpty ? ("Unknown") : (obj.employee_type.capitalized)
                cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.buttonSelection.isSelected = obj.isSelected
                return cell
            default:return UITableViewCell()
            }
        case 6:
            switch section{
            case 0:
                return UITableViewCell()
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: GroupListTVC.identifier, for: indexPath) as! GroupListTVC
                
                    let obj = events[indexPath.row]
                cell.labelName.text = String.getString(obj.event?.name).capitalized
                cell.labelTotalMembers.text = "\(String.getString(obj.event?.start_date)) | \(String.getString(obj.event?.start_time))" + " - " + "\(String.getString(obj.event?.end_date)) | \(String.getString(obj.event?.end_time))"
                   
                    
                cell.imageGroup.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.event?.event_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                
                    cell.stackView.isHidden = true
                    cell.viewMembers.isHidden = true
                cell.buttonRadio.isHidden = true
              
                    
                
                return cell
            default:return UITableViewCell()
            }
        default:
            switch section{
            case 0:
                return UITableViewCell()
            case 2:
                return UITableViewCell()
            default:return UITableViewCell()
            }
        }
        
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch selectedTab{
        case 5:
            switch section{
            case 1:
                return 65
            default:return UITableView.automaticDimension
            }
        default:
            return UITableView.automaticDimension
        }
        
        

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch selectedTab{
            
        case 2:
            switch section{
            case 1:
                if selectedTab == 2{
                    guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: PageProductDetailsVC.getStoryboardID()) as? PageProductDetailsVC else { return }
                    vc.data = products[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:break
            }
        case 3:
            switch section{
            case 1:
               
                    guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: ViewJobVC.getStoryboardID()) as? ViewJobVC else { return }
                    vc.jobId = self.jobs[indexPath.row].id
                    self.navigationController?.pushViewController(vc, animated: true)
                
            default:break
            }
            
        case 6:
            switch section{
            case 1:
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewEventVC.getStoryboardID()) as? ViewEventVC else { return }
            vc.eventId = self.events[indexPath.row].event_id
                if self.events[indexPath.row].is_orgnizer == "1"{
                    vc.hasCameFrom = .viewEventCompanyAdmin
                }else{
                    vc.hasCameFrom = .viewCompanyEvent
                }

                self.navigationController?.pushViewController(vc, animated: true)
            default:break
            }
        
        default:
            break
        }
        
        
        
    }

}
