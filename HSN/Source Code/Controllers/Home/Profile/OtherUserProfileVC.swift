//
//  OtherUserProfileVC.swift
//  HSN
//
//  Created by Prashant Panchal on 19/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class OtherUserProfileVC: UIViewController, UpdateProfilePageProtocal {
    
    // MARK: - Outlets
    @IBOutlet weak private var labelPageTitle: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var backButton: UIButton!
    @IBOutlet weak private var settingsButton: UIButton!
    @IBOutlet weak private var headerView: UIView!
    
    // MARK: - Stored Properties
    var id = ""
    var data: UserProfileModel?
    var hasCameFrom: HasCameFrom = .editProfile
    var followBtnText: String = "Follow"
    var userProfileHeaderView: UserProfileHeaderView?
    var viewProgress: ProfileProgressView?
    var selectedTab = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245, green: 247, blue: 249) // or any other desired color
        // Swift 5 or above
        tableView.contentInsetAdjustmentBehavior = .always
        if id.isEmpty { id = UserData.shared.id }
        setupTableView()
        setupRefreshControl()
        getProfile()
        setStatusBar()
        if hasCameFrom == .editProfile {
            backButton.isHidden = true
            settingsButton.isHidden = false
        } else {
            settingsButton.isHidden = true
        }
        tableView.backgroundColor = .systemBackground
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDidLoad()
    }
    
    // MARK: - Custom Methods
    func currentProfilePage(index: Int) {
        self.selectedTab = index
    }
    
    func setViewBackgroundColors(view: UIView, color: UIColor) {
        view.backgroundColor = color
        
        for subview in view.subviews {
            setViewBackgroundColors(view: subview, color: color)
        }
    }
    
    func updateHeader() {
        followBtnText = data?.is_following ?? false ? "Unfollow" : "Follow"
        userProfileHeaderView = UINib(nibName: "UserProfileHeader", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? UserProfileHeaderView
        userProfileHeaderView?.initialSetup(hasCameFrom, userData: data ?? UserProfileModel(data: [:]), parentVC: self, protocal: self, selectedTab: self.selectedTab)
        viewProgress = UINib(nibName: "ProfileProgressView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ProfileProgressView
        viewProgress?.initialSetup(data: data)
        labelPageTitle.text = self.hasCameFrom == .viewProfile ? (userProfileHeaderView?.labelFullName.text) : ("Profile")
        tableView.sectionHeaderHeight = UITableView.automaticDimension;
    }
    
    func getProfile() {
        globalApis.getProfile(id: id, isSelf: true, completion: { [weak self] profile in
            guard let self = self else { return }
            self.data = profile
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateHeader()
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ExperienceTVC.identifier, bundle: nil), forCellReuseIdentifier: ExperienceTVC.identifier)
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableView.register(UINib(nibName: RateRecommendReviewTVC.identifier, bundle: nil), forCellReuseIdentifier: RateRecommendReviewTVC.identifier)
        tableView.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableView.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 0.1
        tableView.reloadData()
    }
}

// MARK: - Actions
extension OtherUserProfileVC {
    @IBAction private func settingsTapped(_ sender: Any) {
    guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "AppSettingsVC") as? AppSettingsVC else { return }
    self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        getProfile()
    }
    
    @IBAction private func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension OtherUserProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTab == 0 {
            return 6
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return self.userProfileHeaderView
        case 1:
            //return self.viewProgress
            return nil
        case 2:
            if hasCameFrom == .viewProfile {
                return tableView.createHeaderView(
                    text: "Experience",
                    color: UIColor(named: "5")!,
                    backgroundColor: UIColor(named: "Card Background Color")!
                )
            } else {
                return tableView.createHeaderViewBtnAdd(
                    text: "Experience",
                    btnTitle: "Add New Experience",
                    viewBackroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1)
                ) { btn in
                    guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "WorkViewController") as? WorkViewController else { return }
                    nextvc.hasCameFrom = .editProfile
                    self.navigationController?.pushViewController(nextvc, animated: true)
                }
            }
        case 3:
            if hasCameFrom == .viewProfile {
                return tableView.createHeaderView(
                    text: "Education",
                    color: UIColor(named: "5")!,
                    backgroundColor: UIColor(named: "Card Background Color")!
                )
            } else {
                return tableView.createHeaderViewBtnAdd(text: "Education", btnTitle: "Add New Education", viewBackroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1)) { btn in
                    guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "AddEditEducationVC") as? AddEditEducationVC else { return }
                    nextvc.hasCameFrom = .editProfile
                    self.navigationController?.pushViewController(nextvc, animated: true)
                }
            }
        case 4:
            if hasCameFrom == .viewProfile {
                return tableView.createHeaderView(
                    text:"License & Certificate",
                    color: UIColor(named: "5")!,
                    backgroundColor: UIColor(named: "Card Background Color")!)
            } else {
                return tableView.createHeaderViewBtnAdd(text: "License & Certificate", btnTitle: "Add New License/Certificate", viewBackroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1)) { btn in
                    guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "AddEditCertificateVC") as? AddEditCertificateVC else { return }
                    nextvc.hasCameFrom = .editProfile
                    self.navigationController?.pushViewController(nextvc, animated: true)
                }
            }
        case 5:
            if let obj = data {
                return tableView.createHeaderViewBtn(text: "Activities", btnTitle: obj.is_following ? "Unfollow" : "Follow",btnIsSelected: obj.is_following,isHidden: hasCameFrom == .editProfile ? true : false,trailing: -15, viewBackgroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1)) { [weak self] btn in
                    guard let self = self else { return }
                    globalApis.followUnfollowApi(userId: String.getString(obj.id), isFollowing: !btn.isSelected,isConnectedWithMe:obj.is_connected_withme , completion: { [weak self] totalFollowers, status in
                        guard let self = self else { return }
                        if status {
                            btn.setTitle("Following", for: .normal)
                            self.data?.is_following = status
                            self.tableView.reloadData()
                        } else {
                            btn.setTitle("Follow", for: .normal)
                            self.data?.is_following = status
                            self.tableView.reloadData()
                        }
                    })
                }
            } else {
                return UIView()
            }
            
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // return selectedTab == 0 ?  (data?.user_post.count ?? 0 : 0
        if selectedTab == 0 {
            if let obj = data {
                switch section {
                case 0:
                    return UITableView.automaticDimension
                case 1:
                    return 0 // self.hasCameFrom == .viewProfile ?  0 : UITableView.automaticDimension
                case 2:
                    return obj.user_company_experience.isEmpty ? hasCameFrom == .viewProfile ? 0 : 30 : 30
                case 3:
                    return obj.user_education.isEmpty ?  hasCameFrom == .viewProfile ? 0 : 30 : 30
                case 4:
                    return obj.user_certificate.isEmpty ?  hasCameFrom == .viewProfile ? 0 : 30 : 30
                case 5:
                    return obj.user_post.isEmpty ? 40 : 40
                default: return 0
                }
            }
        } else {
            switch section {
            case 0:
                return UITableView.automaticDimension
            default: return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // For rating and recommendation
        if section == 1 && selectedTab == 2 {
            return data?.user_rating.count ?? 0
        }else if section == 1 && selectedTab == 1 {
            return data?.recommend_user.count ?? 0
        }
        
        if section == 0 || section == 1{
            return 0
        }
        else if section == 2 {
            if let obj = data {
                if selectedTab == 0 {
                    return (obj.user_company_experience.isEmpty ? 0 : 1)
                } else if selectedTab == 1 {
                    return obj.recommend_user.count
                } else {
                    return obj.user_rating.count
                }
            }
        }
        else if section == 3 {
            if let obj = data {
                if selectedTab == 0{
                    return (obj.user_education.isEmpty ? 0 : 1)
                } else if selectedTab == 1 {
                    return obj.recommend_user.count
                } else {
                    return obj.user_rating.count
                }
            }
        } else if section == 4 {
            if let obj = data {
                if selectedTab == 0 {
                    return (obj.user_certificate.isEmpty ? 0 : 1)
                } else if selectedTab == 1 {
                    return obj.recommend_user.count
                } else {
                    return obj.user_rating.count
                }
            }
        } else {
            if let obj = data {
                if selectedTab == 0 {
                    return obj.user_post.count
                } else if selectedTab == 1 {
                    return obj.recommend_user.count
                } else {
                    return obj.user_rating.count
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTab == 0 {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewPostVC.getStoryboardID()) as? ViewPostVC else { return }
            vc.data = data?.user_post[indexPath.row]
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            if selectedTab == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: RateRecommendReviewTVC.identifier, for: indexPath) as! RateRecommendReviewTVC
                if let recommendationsObj = data?.recommend_user {
                    if recommendationsObj.indices.contains(indexPath.row) {
                        let obj = recommendationsObj[indexPath.row]
                        cell.labelName.text = String.getString(obj.user?.full_name.capitalized)
                        cell.labelProfession.text = String.getString(obj.user?.employee_type.capitalized).isEmpty ? ("Unknown") : (String.getString(obj.user?.employee_type.capitalized))
                        cell.labelText.text = "\"" +  String.getString(obj.description)
                        cell.viewRating.isHidden = true
                        cell.viewRating.isUserInteractionEnabled = false
                        cell.constraintCosmosHeight.constant = 0
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        cell.labelDate.text = dateFormatter.string(from: Date(unixTimestamp: Double.getDouble(obj.time)))
                        cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String.getString(obj.user?.profile_pic), placeHolder: #imageLiteral(resourceName: "no_profile_image"))
                    }
                }
                return cell
            } else if selectedTab == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: RateRecommendReviewTVC.identifier, for: indexPath) as! RateRecommendReviewTVC
                if let recommendationsObj = data?.user_rating {
                    if recommendationsObj.indices.contains(indexPath.row) {
                        let obj = recommendationsObj[indexPath.row]
                        //cell.labelName.text = String.getString(obj.user?.first_name.capitalized) + " " + String.getString(obj.user?.last_name.capitalized)
                        cell.labelName.text = String.getString(obj.user?.full_name.capitalized)
                        cell.labelProfession.text = String.getString(obj.user?.employee_type.capitalized).isEmpty ? ("Unkown") : (String.getString(obj.user?.employee_type.capitalized))
                        cell.viewRating.rating = Double.getDouble(obj.rating)
                        cell.viewRating.isHidden = false
                        cell.viewRating.isUserInteractionEnabled = false
                        cell.labelText.text = "\"" +  String.getString(obj.description)
                        cell.constraintCosmosHeight.constant = 20
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        cell.labelDate.text = dateFormatter.string(from: Date(unixTimestamp: Double.getDouble(obj.time)))
                        cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String.getString(obj.user?.profile_pic), placeHolder: #imageLiteral(resourceName: "no_profile_image"))
                    }
                }
                return cell
            }
        case 2:
            if selectedTab == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ExperienceTVC.identifier, for: indexPath) as! ExperienceTVC
                if let obj = data?.user_company_experience {
                    cell.updateCell(data: obj,hasCameFrom,parentVC: self.navigationController ?? UINavigationController(),type: .experience)
                }
                cell.refreshCallback = {
                    self.tableView.reloadData()
                }
                return cell
            }
            if selectedTab == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: RateRecommendReviewTVC.identifier, for: indexPath) as! RateRecommendReviewTVC
                if let recommendationsObj = data?.recommend_user {
                    if recommendationsObj.indices.contains(indexPath.row){
                        let obj = recommendationsObj[indexPath.row]
                        cell.labelName.text = String.getString(obj.user?.full_name.capitalized)
                        cell.labelProfession.text = String.getString(obj.user?.employee_type.capitalized).isEmpty ? ("Unknown") : (String.getString(obj.user?.employee_type.capitalized))
                        cell.labelText.text = "\"" +  String.getString(obj.description)
                        cell.viewRating.isHidden = true
                        cell.viewRating.isUserInteractionEnabled = false
                        cell.constraintCosmosHeight.constant = 0
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        cell.labelDate.text = dateFormatter.string(from: Date(unixTimestamp: Double.getDouble(obj.time)))
                        cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String.getString(obj.user?.profile_pic), placeHolder: #imageLiteral(resourceName: "no_profile_image"))
                    }
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: RateRecommendReviewTVC.identifier, for: indexPath) as! RateRecommendReviewTVC
                if let recommendationsObj = data?.user_rating{
                    if recommendationsObj.indices.contains(indexPath.row){
                        let obj = recommendationsObj[indexPath.row]
                        //cell.labelName.text = String.getString(obj.user?.first_name.capitalized) + " " + String.getString(obj.user?.last_name.capitalized)
                        cell.labelName.text = String.getString(obj.user?.full_name.capitalized)
                        cell.labelProfession.text = String.getString(obj.user?.employee_type.capitalized).isEmpty ? ("Unkown") : (String.getString(obj.user?.employee_type.capitalized))
                        cell.viewRating.rating = Double.getDouble(obj.rating)
                        cell.viewRating.isHidden = false
                        cell.viewRating.isUserInteractionEnabled = false
                        cell.labelText.text = "\"" +  String.getString(obj.description)
                        cell.constraintCosmosHeight.constant = 20
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        cell.labelDate.text = dateFormatter.string(from: Date(unixTimestamp: Double.getDouble(obj.time)))
                        cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String.getString(obj.user?.profile_pic), placeHolder: #imageLiteral(resourceName: "no_profile_image"))
                    }
                }
                return cell
            }
        case 3:
            if selectedTab == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ExperienceTVC.identifier, for: indexPath) as! ExperienceTVC
                if let obj = data?.user_education{
                    cell.updateCell(data: obj,hasCameFrom,parentVC: self.navigationController ?? UINavigationController(),type: .education)
                    
                }
                return cell
            }
        case 4:
            if selectedTab == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ExperienceTVC.identifier, for: indexPath) as! ExperienceTVC
                if let obj = data?.user_certificate{
                    cell.updateCell(data: obj,hasCameFrom,parentVC: self.navigationController ?? UINavigationController(),type: .certificate)
                    
                }
                return cell
            }
        case 5:
            if selectedTab == 0 {
                if let postData = data?.user_post {
                    if postData.indices.contains(indexPath.row) {
                        let obj = postData[indexPath.row]
                        switch Int.getInt(obj.is_post_type) {
                        case 7:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                            setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                            setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
//                            cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
                            cell.updateCell(data: obj, isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)], type: .findExpert, isShared: false,cameFrom: self.hasCameFrom)
                            return cell
                        case 6:
                            switch Int.getInt(obj.share_post?.is_post_type) {
                            case 7:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                                setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                                setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                                cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .findExpert, isShared: true,cameFrom: self.hasCameFrom)
                                return cell
                            case 5:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                                setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                                setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
//                                cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
                                if postData.indices.contains(indexPath.row) {
                                    let obj = postData[indexPath.row]
                                    cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .poll, isShared:true,cameFrom: self.hasCameFrom)
                                    cell.parent = self
                                }
                                return cell
                            case 1,2,3,4:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                                setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                                setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                                cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .media, isShared:true,cameFrom: self.hasCameFrom)
                                cell.parent = self
                                return cell
                            case 0:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                                setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                                setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                                cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .text,isShared:true,cameFrom: self.hasCameFrom)
                                cell.parent = self
                                return cell
                            default:
                                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                                cell.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                                cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                                setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                                setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                                cell.updateCell(data: obj, isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)], type: .text, isShared: true,cameFrom: self.hasCameFrom)
                                cell.parent = self
                                return cell
                            }
                        case 5:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                            setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                            setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                            if postData.indices.contains(indexPath.row) {
                                let obj = postData[indexPath.row]
                                cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .poll,cameFrom: self.hasCameFrom)
                                cell.parent = self
                            }
                            return cell
                        case 1,2,3,4:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                            setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                            setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                            cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .media,cameFrom: self.hasCameFrom)
                            cell.parent = self
                            return cell
                        case 0:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                            setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                            setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                            cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .text,cameFrom: self.hasCameFrom)
                            cell.parent = self
                            return cell
                        default:
                            let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                            cell.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewMainContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewContent.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.collectionViewTags.backgroundColor = UIColor(named: "Card Background Color")
//                            cell.viewLinkPreview.backgroundColor = UIColor(named: "Card Background Color")
//                            setViewBackgroundColors(view: cell.viewHeader, color: UIColor(named: "Card Background Color")!)
//                            setViewBackgroundColors(view: cell.viewFooter, color: UIColor(named: "Card Background Color")!)
                            cell.updateCell(data: obj,  isSameProfile: true, dict: ["fname":String.getString(data?.first_name),"lname":String.getString(data?.last_name),"image":String.getString(data?.profile_pic),"fullname":String.getString(data?.full_name)],type: .text,cameFrom: self.hasCameFrom)
                            cell.parent = self
                            cell.isShared = false
                            return cell
                        }
                    }
                }
            }
        default: return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



