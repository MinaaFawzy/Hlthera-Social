//
//  SettingsNewVC.swift
//  HSN
//
//  Created by Prashant Panchal on 13/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class SettingsNewVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var viewHeader: UIView!
    @IBOutlet weak private var viewUserHeader: UIView!
    @IBOutlet weak private var constraintLabelNameTop: NSLayoutConstraint!
    @IBOutlet weak private var imageProfile: UIImageView!
    @IBOutlet weak private var labelName: UILabel!
    @IBOutlet weak private var labelUserName: UILabel!
    
    // MARK: - Stored Properties
    var data: UserProfileModel?
    var array = [
        "Lounges",
        "Fitness",
        "Pages",
        "Events",
        "Groups",
        "Jobs",
        "Discover more",
        "Find a healer",
        "Hashtags",
        "Subscriptions",
        "Promotions",
        "Saved",
        "Insights",
        "",
        "Favourites"
    ]
    var arrayIcons = [
        UIImage(named: "lounges1")!,
        UIImage(named: "fitness_icon")!,
        UIImage(named: "pages-1")!,
        UIImage(named: "events_icon")!,
        UIImage(named: "groups_icon1")!,
        UIImage(named: "jobs")!,
        UIImage(named: "discover_more-1")!,
        UIImage(named: "find_a_healer")!,
        UIImage(named: "hashtags")!,
        UIImage(named: "subscription")!,
        UIImage(named: "promotions-1")!,
        UIImage(named: "saved_icon")!,
        UIImage(named: "insights")!,
        UIImage(named: "Hlthera Exclusive")!,
        UIImage(named: "favourite_posts")!
    ]
    
    //var array = ["Events","Subscription Plan","Settings","Lounge","Groups","Favorite Post","Following Hashtag","Discover More","Find An Expert","Create Page","Created Pages","Jobs","Promotions"]
    //var arrayIcons = [UIImage(named: "events-2")!,UIImage(named: "subscription")!,UIImage(named: "settings")!,UIImage(named: "lounges")!,UIImage(named: "groups-1")!,UIImage(named: "favourites")!,UIImage(named: "hashtags")!,UIImage(named: "discover_more-1")!,UIImage(named: "find_a_healer")!,UIImage(named: "pages-1")!,UIImage(named: "pages-1")!,UIImage(named: "jobs")!,UIImage(named: "promotions-1")!]
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingsCVC.nib, forCellWithReuseIdentifier: SettingsCVC.identifier)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.viewHeader.setGradientSettingsBackground()
            self.viewUserHeader.setGradientSettingsBackground()
            self.collectionView.reloadData()
        })
        //let window = UIApplication.shared.windows[0]
        //let topPadding = window.safeAreaInsets.top
        //constraintLabelNameTop.constant = topPadding + 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
        
        globalApis.getMyHashTags(completion: { data in
            //self.tags = data
            //self.tableView.reloadData()
        })
        
        globalApis.getExclusivePlan(completion: { data in
            if data.count > 0 {
                kSharedUserDefaults.setExclusiveActive(isActive: true)
            } else {
                kSharedUserDefaults.setExclusiveActive(isActive: false)
            }
        })
        
        globalApis.getProfile(id: UserData.shared.id, completion: { [weak self] data in
            guard let self = self else { return }
            self.data = data
            self.updateData()
        })
    }
    
    func updateData() {
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        //self.labelName.text = UserData.shared.first_name.capitalized + " " + UserData.shared.last_name.capitalized
        self.labelName.text = UserData.shared.full_name.capitalized
        //self.labelAddress.text = UserData.shared.location.isEmpty ? "Unknown Location" : UserData.shared.location
        self.labelUserName.text = UserData.shared.username.isEmpty ? UserData.shared.full_name.capitalized : UserData.shared.username
    }
    
    @IBAction private func buttonSettingsTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AppSettingsVC.getStoryboardID()) as? AppSettingsVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonEditProfileTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
        vc.hasCameFrom = .editProfile
        vc.data = data
        vc.id = String.getString(self.data?.id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func buttonTryNowTapped(_ sender: Any) {}
    
    @IBAction private func buttonLogoutTapped(_ sender: Any) {
        kSharedAppDelegate?.logout()
        //if #available(iOS 14, *) {
        //ImagePicker14.shared.showPicker(filter: .images, limit: 5, { image in
        //print(image)
        //})
        //} else {
        // Fallback on earlier versions
        //}
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension SettingsNewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:SettingsCVC.identifier , for: indexPath) as! SettingsCVC
        
        if indexPath.row == 13 {
            cell.imageIcon.isHidden = true
            cell.labelName.isHidden = true
            cell.imageHltheraExclusive.isHidden = false
            cell.imageHltheraExclusive.image = arrayIcons[indexPath.row]
            cell.viewMain.backgroundColor = UIColor(hexString: "CEDBEE")
        } else {
            cell.imageIcon.isHidden = false
            cell.labelName.isHidden = false
            cell.labelName.text = array[indexPath.row]
            cell.imageHltheraExclusive.isHidden = true
            cell.imageIcon.image = arrayIcons[indexPath.row]
            cell.viewMain.backgroundColor = UIColor.white
        }
        self.constraintCollectionViewHeight.constant = self.collectionView.contentSize.height
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width/3
        return CGSize(width:width, height: width/1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EventListingVC.getStoryboardID()) as? EventListingVC else { return }
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: LoungeVC.getStoryboardID()) as? LoungeVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1{
            //            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SubscriptionVC.getStoryboardID()) as? SubscriptionVC else { return }
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FitnessTrackVC.getStoryboardID()) as? FitnessTrackVC else { return }
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            guard let vc = UIStoryboard(name: Storyboards.kFitness, bundle: nil).instantiateViewController(withIdentifier: FitnessWalkThroughVC.getStoryboardID()) as? FitnessWalkThroughVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {
            //            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AppSettingsVC.getStoryboardID()) as? AppSettingsVC else { return }
            //            self.navigationController?.pushViewController(vc, animated: true)
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: PagesListingVC.getStoryboardID()) as? PagesListingVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //        else if indexPath.row == 2{
        //            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else { return }
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        //        else if indexPath.row == 3{
        //            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: ViewInsightsVC.getStoryboardID()) as? ViewInsightsVC else { return }
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        else if indexPath.row == 3 {
            //guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: ScheduledLoungesVC.getStoryboardID()) as? ScheduledLoungesVC else { return }
            //vc.isManageRooms = true
            //self.navigationController?.pushViewController(vc, animated: true)
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EventsViewController.getStoryboardID()) as? EventsViewController else { return }
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: GroupsVC.getStoryboardID()) as? GroupsVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: JobsListingVC.getStoryboardID()) as? JobsListingVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            //isHashtags = !isHashtags
            //tableView.reloadData()
            
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: DiscoverProfilesVC.getStoryboardID()) as? DiscoverProfilesVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            //guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: DiscoverProfilesVC.getStoryboardID()) as? DiscoverProfilesVC else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FindExpertVC.getStoryboardID()) as? FindExpertVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 8{
            //isHashtags = !isHashtags
            //tableView.reloadData()
            //guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FindExpertVC.getStoryboardID()) as? FindExpertVC else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            //guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: SelectBusinessTypeVC.getStoryboardID()) as? SelectBusinessTypeVC else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SubscriptionVC.getStoryboardID()) as? SubscriptionVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
            //guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: PagesListingVC.getStoryboardID()) as? PagesListingVC else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 11{
            guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: JobsListingVC.getStoryboardID()) as? JobsListingVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 12{
            //guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else { return }
            //self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 13 {
            
            if kSharedUserDefaults.getExclusiveActive() {
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ExclusivePostVC.getStoryboardID()) as? ExclusivePostVC else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: PremiumExclusiveVC.getStoryboardID()) as? PremiumExclusiveVC else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        else if indexPath.row == 14 {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FavoritesPostVC.getStoryboardID()) as? FavoritesPostVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
