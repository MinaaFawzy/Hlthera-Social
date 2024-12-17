//
//  SettingsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 04/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet  var constraintImageTrailing: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    //    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var constraintHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintImageWidth: NSLayoutConstraint!
    @IBOutlet  var constraintNameTrailing: NSLayoutConstraint!
    @IBOutlet  var constraintNameLeading: NSLayoutConstraint!
    @IBOutlet  var constraintImageCenterX: NSLayoutConstraint!
    @IBOutlet  var constraintImageCenterY: NSLayoutConstraint!
    @IBOutlet  var constriaintNameTop: NSLayoutConstraint!
    //  @IBOutlet  var constraintNameCenterX: NSLayoutConstraint!
    @IBOutlet  var constraintBtnCenterX: NSLayoutConstraint!
    @IBOutlet  var constraintButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet  var constraintNameCenterY: NSLayoutConstraint!
    //    var array = ["Events","Subscription Plan","Settings","Fitness Track","Groups","Favorite Post","Following Hashtag","Discover More","Find An Expert"]
    //    var arrayIcons = [UIImage(named: "events")!,UIImage(named: "subscription_plan")!,UIImage(named: "settings")!,UIImage(named: "fitness_track")!,UIImage(named: "groups")!,UIImage(named: "groups")!,UIImage(named: "following_hashtag")!,UIImage(named: "discover_more")!,UIImage(named: "find_and_expert")!]
    //"Promotions","Insights",UIImage(named: "promotions")!,UIImage(named: "Group 101035")!
    var array = ["Events","Subscription Plan","Settings","Lounge","Groups","Favorite Post","Following Hashtag","Discover More","Find An Expert","Create Page","Created Pages","Jobs","Promotions"]
    var arrayIcons = [UIImage(named: "events")!,UIImage(named: "subscription_plan")!,UIImage(named: "settings")!,UIImage(named: "lounge")!,UIImage(named: "groups")!,UIImage(named: "favourite")!,UIImage(named: "following_hashtag")!,UIImage(named: "discover_more")!,UIImage(named: "find_and_expert")!,UIImage(named: "Group 101126")!,UIImage(named: "Group 101127")!,UIImage(named: "Group 101127")!,UIImage(named: "promotions")!]
    var isHashtags = false
    var tags: [HashTagModel] = []
    var data: UserProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setStatusBar(color: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1))
        self.tableView.register(UINib(nibName: SettingsTVC.identifier, bundle: nil), forCellReuseIdentifier: SettingsTVC.identifier)
        self.tableView.register(UINib(nibName: SettingsHashTagsTVC.identifier, bundle: nil), forCellReuseIdentifier: SettingsHashTagsTVC.identifier)
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        
        if  DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_X_MAX {
            tableView.contentInset = UIEdgeInsets(top: 280, left: 0, bottom: 80, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 280, left: 0, bottom: 0, right: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.viewHeader.setGradientSettingsBackground()
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
        globalApis.getMyHashTags(completion: {data in
            self.tags = data
            self.tableView.reloadData()
        })
        globalApis.getProfile(id: UserData.shared.id, completion: { data in
            self.data  = data
            self.updateData()
        })
    }
    
    func updateData(){
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        //self.labelName.text = UserData.shared.first_name.capitalized + " " + UserData.shared.last_name.capitalized
        self.labelName.text = UserData.shared.full_name.capitalized
        //self.labelAddress.text = UserData.shared.location.isEmpty ? "Unknown Location" : UserData.shared.location
    }
    
    @IBAction func buttonViewProfileTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
        vc.hasCameFrom = .editProfile
        vc.data = data
        vc.id = String.getString(self.data?.id)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        kSharedAppDelegate?.logout()
        //        if #available(iOS 14, *) {
        //            ImagePicker14.shared.showPicker(filter: .images, limit: 5, { image in
        //                print(image)
        //            })
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }
    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isHashtags && indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier:SettingsHashTagsTVC.identifier , for: indexPath) as! SettingsHashTagsTVC
            cell.parent = self
            cell.labelName.text = array[indexPath.row]
            cell.imageIcon.image = arrayIcons[indexPath.row]
            
            cell.updateCell(data: tags)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:SettingsTVC.identifier , for: indexPath) as! SettingsTVC
            cell.labelName.text = array[indexPath.row]
            cell.switchOption.isHidden = true
            cell.imageIcon.image = arrayIcons[indexPath.row]
            if indexPath.row == 6{
                cell.imageDropDown.isHidden = false
            }
            else{
                cell.imageDropDown.isHidden = true
            }
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = 25 - (scrollView.contentOffset.y + 25)
        let heightHeader = min(max(yOffset, 125), 800)
        constraintHeaderHeight.constant = heightHeader
        print(String.getString(scrollView.contentOffset.y),String.getString(yOffset))
        self.viewHeader.layer.sublayers?.first?.frame = viewHeader.frame
        UIView.animate(withDuration: 0.35) {
            if heightHeader < 180{
                self.constraintImageCenterX.isActive = false
                self.constraintImageTrailing.isActive = true
                self.constraintImageTrailing.constant = 15
                self.constriaintNameTop.isActive = false
                self.constraintNameTrailing.isActive = false
                self.constraintNameLeading.isActive = true
                self.constraintNameLeading.constant = 15
                //self.constraintNameCenterX.isActive = true
                self.labelName.textAlignment = .left
                self.labelName.font = UIFont(name: "Corben-Bold", size: 14)
                self.constraintBtnCenterX.isActive = false
                self.constraintButtonLeading.isActive = true
                DispatchQueue.main.async {
                    self.constraintImageHeight.constant = 50
                    self.constraintImageWidth.constant = 50
                    self.viewImage.cornerRadius = 25
                    self.imageProfile.cornerRadius = 25
                }
                self.constraintNameCenterY.isActive = true
                self.constraintNameCenterY.constant = -6.75
                self.constraintImageCenterY.isActive = true
                self.constraintImageCenterY.constant = 15
                //self.setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
                
                UIView.animate(withDuration: 0.25) {
                    self.viewHeader.layoutIfNeeded()
                }
            } else {
                self.labelName.font = UIFont(name: "Corben-Bold", size: 16)
                self.constraintImageCenterX.isActive = true
                self.constraintImageCenterY.isActive = true
                self.constraintImageCenterY.constant = 0
                self.constraintImageTrailing.isActive = false
                self.constriaintNameTop.isActive = true
                self.constriaintNameTop.constant = 15
                self.constraintNameTrailing.isActive = true
                self.constraintNameTrailing.constant = 50
                self.constraintNameLeading.isActive = true
                self.constraintNameLeading.constant = 50
                //self.constraintNameCenterX.isActive = false
                
                self.labelName.textAlignment = .center
                self.constraintBtnCenterX.isActive = true
                self.constraintButtonLeading.isActive = false
                // self.constraintbt
                DispatchQueue.main.async {
                    self.constraintImageHeight.constant = 125
                    self.constraintImageWidth.constant = 125
                    self.viewImage.cornerRadius = 62.5
                    self.imageProfile.cornerRadius = 62.5
                }
                self.constraintNameCenterY.isActive = false
            }
            self.view.layoutSubviews()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isHashtags && indexPath.row == 6{
            return UITableView.automaticDimension
        }
        else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EventListingVC.getStoryboardID()) as? EventListingVC else { return }
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EventsViewController.getStoryboardID()) as? EventsViewController else { return }
            vc.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SubscriptionVC.getStoryboardID()) as? SubscriptionVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AppSettingsVC.getStoryboardID()) as? AppSettingsVC else { return }
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
        else if indexPath.row == 3{
            //            guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: ScheduledLoungesVC.getStoryboardID()) as? ScheduledLoungesVC else { return }
            //            vc.isManageRooms = true
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            //            guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: CreateLoungeVC.getStoryboardID()) as? CreateLoungeVC else { return }
            ////            vc.isManageRooms = true
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: LoungeVC.getStoryboardID()) as? LoungeVC else { return }
            //            vc.isManageRooms = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 4{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: GroupsVC.getStoryboardID()) as? GroupsVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 5{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FavoritesPostVC.getStoryboardID()) as? FavoritesPostVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 6{
            isHashtags = !isHashtags
            tableView.reloadData()
        }
        
        else if indexPath.row == 7{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: DiscoverProfilesVC.getStoryboardID()) as? DiscoverProfilesVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 8{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: FindExpertVC.getStoryboardID()) as? FindExpertVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 9{
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: SelectBusinessTypeVC.getStoryboardID()) as? SelectBusinessTypeVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 10{
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: PagesListingVC.getStoryboardID()) as? PagesListingVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 11{
            guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: JobsListingVC.getStoryboardID()) as? JobsListingVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 12{
            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UIView {
    func setGradientSettingsBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor, #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1).cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 25
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor, #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor]
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        //gradientLayer.endPoint = CGPoint(x: 1, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.bounds
        //        gradientLayer.cornerRadius = 25
        //        gradientLayer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
