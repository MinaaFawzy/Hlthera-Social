//
//  UserProfileHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 12/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UIView {
    
    @IBOutlet weak var recommendationView: UIView!
    @IBOutlet weak var progressValueView: UIView!
    @IBOutlet weak var buttonConnect: UIButton!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var buttonTotalConnections: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var stackViewNavigation: UIStackView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var buttonMoreEdit: UIButton!
    @IBOutlet weak var constraintStackViewNavigationHeight: NSLayoutConstraint!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var lblProgress: UILabel!
    
    @IBOutlet weak var profileCell: UIView!
    
    
    private var hasCameFrom: HasCameFrom?
    private var data: UserProfileModel?
    private var parentVC: OtherUserProfileVC?
    private var selectedTab = 0
    private var protocal: UpdateProfilePageProtocal?
    
    var circularProgressBarView: CircularProgressBarView!
    var circularViewDuration: TimeInterval = 2
    
    class func viewInstance() -> UserProfileHeaderView {
        let view = UINib(nibName: "UserProfileHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UserProfileHeaderView
        return view
    }
    
    func initialSetup(
        _ hasCameFrom: HasCameFrom,
        userData: UserProfileModel,
        parentVC:OtherUserProfileVC,
        protocal: UpdateProfilePageProtocal?,
        selectedTab: Int = 0
    ) {
        if userData.account_type == 1{
            self.recommendationView.isHidden = false
            self.profileCell.isHidden = false
        } else {
            self.recommendationView.isHidden = true
            self.profileCell.isHidden = true
        }
        progressValueView.isHidden = true
        //self.reviewView.isHidden = userData.account_type == 0 ? false : true
        self.reviewView.isHidden = true
        self.verifiedImageView.isHidden = !userData.is_user_verified
        //self.verifiedImageView.isHidden = userData.isu
        self.protocal = protocal
        self.hasCameFrom = hasCameFrom
        self.data = userData
        self.parentVC = parentVC
        setupNavigation(selectedIndex: selectedTab)
        setupProfile()
        viewHeader.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewHeader.layer.cornerRadius = 25
        if let obj = data {
            //self.labelFullName.text = obj.first_name.capitalized + " " + obj.last_name.capitalized
            self.labelFullName.text = obj.full_name.capitalized
            self.labelProfession.text = obj.company_name.isEmpty ? ("Unkown") : (obj.company_name.capitalized)
            if obj.city_name.isEmpty {
                self.labelLocation.text = obj.country_name.isEmpty ? ("Unknown") : (obj.country_name.capitalized)
            } else {
                self.labelLocation.text = obj.country_name.isEmpty ? ("Unknown") : (obj.city_name.capitalized) + " , " + (obj.country_name.capitalized)
            }
            if obj.user_company_experience.count > 0 {
                self.labelDescription.text = obj.user_company_experience.first?.title ??  "Welcome to my profile"
            } else {
                self.labelDescription.text = obj.headline.isEmpty ? "Welcome to my profile" : obj.headline
            }
            let res = Int.getInt(obj.connecation_count) <= 1 ? " Network connection" : " Network connections"
            self.buttonTotalConnections.setTitle(obj.connecation_count + res, for: .normal)
            self.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "no_profile_image"))
            self.imageCover.downlodeImage(serviceurl: kBucketUrl + obj.cover_pic, placeHolder: #imageLiteral(resourceName: "cover_page_placeholder"))
            self.labelFollowers.text = obj.follower_count + " Followers"
            if obj.is_connected_withme.isEmpty {
                self.buttonConnect.setTitle("Connect", for: .normal)
            } else if obj.is_connected_withme == "0" {
                self.buttonConnect.setTitle("Pending", for: .normal)
                self.buttonConnect.isUserInteractionEnabled = false
                self.buttonConnect.backgroundColor = UIColor(named: "1")
            }
            else if obj.is_connected_withme == "1" {
                self.buttonConnect.setTitle("Message", for: .normal)
                self.buttonConnect.isUserInteractionEnabled = true
            }
            else if obj.is_connected_withme == "2" {
                self.buttonConnect.setTitle("Accept", for: .normal)
                self.buttonConnect.isUserInteractionEnabled = true
            }
            let progressValue = Int(convertArabicString(text: data?.profile_complete ?? "0"))
            lblProgress.text = "\(progressValue)%"
        }
        imageCover.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageCover.contentMode = UIView.ContentMode.scaleAspectFill
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        if hasCameFrom == .editProfile {
            setUpCircularProgressBarView()
            progressValueView.isHidden = false
        }
    }
    
    func setUpCircularProgressBarView() {
        // set view
        circularProgressBarView = CircularProgressBarView(frame: profileView.frame)
        // align to the center of the screen
        circularProgressBarView.center = profileView.center
        // call the animation with circularViewDuration
        let progressValue = Float(convertArabicString(text: data?.profile_complete ?? "0"))
        circularProgressBarView.progressAnimation(duration: circularViewDuration, value: progressValue/100)
        // add this view to the view controller
        profileView.addSubview(circularProgressBarView)
    }
    
    func setupProfile() {
        switch hasCameFrom {
        case .editProfile:
            setupEditProfile()
        case .viewProfile:
            setupViewProfile()
        case .tabBar:
            setupEditProfile()
        default: break
        }
    }
    
    func setupEditProfile() {
        buttonConnect.isHidden = true
        buttonMoreEdit.setTitle("Edit Profile", for: .normal)
        buttonMoreEdit.setImage(#imageLiteral(resourceName: "edit_profile"), for: .normal)
        labelFollowers.isHidden = true
        print("\(buttonMoreEdit.frame.width)")
        //stackViewNavigation.isHidden = true
        //constraintStackViewNavigationHeight.constant = 0
    }
    
    func setupViewProfile() {
        buttonConnect.isHidden = false
        buttonMoreEdit.setTitle("More", for: .normal)
        buttonMoreEdit.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        labelFollowers.isHidden = false
        //stackViewNavigation.isHidden = false
        //constraintStackViewNavigationHeight.constant = 30
    }
    
    func setupNavigation(selectedIndex: Int = 0) {
        self.selectedTab = selectedIndex
        for (index,view) in self.stackViewNavigation.arrangedSubviews.enumerated() {
            for btn in view.subviews {
                if let button  = btn as? UIButton {
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                    //button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Bold", size: 15)) : (UIFont(name: "SFProDisplay-Medium", size: 15))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                } else {
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                }
            }
        }
    }
    
    @IBAction func buttonMoreTapped(_ sender: Any) {
        switch hasCameFrom {
        case .viewProfile:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MoreProfilePopUpVC.getStoryboardID()) as? MoreProfilePopUpVC else { return }
            vc.parentVC = self.parentVC
            vc.data = self.data
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            parentVC?.navigationController?.present(vc, animated: true)
        case .editProfile:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: EditProfileVC.getStoryboardID()) as? EditProfileVC else { return }
            //vc.parentVC = self.parentVC
            //vc.data = self.data
            //vc.nav = parentVC
            vc.data = data
            parentVC?.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    
    @IBAction func buttonConnectTapped(_ sender: Any) {
        if String.getString(data?.is_connected_withme) == "2" {
            globalApis.acceptConnectionRequest(id: String.getString(data?.connecation_userid), completion: {
                self.parentVC?.moveToPopUp(text: "Request Accepted Successfully", completion: {
                    self.buttonConnect.setTitle("Message", for: .normal)
                    self.buttonConnect.backgroundColor = UIColor(named: "5")
                    self.buttonConnect.isUserInteractionEnabled = false
                })
            })
        } else if String.getString(data?.is_connected_withme) == "1" {
            guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
            
            vc.receiverid = String.getString(data?.id)
            vc.receivername = String.getString(data?.first_name) + " " + String.getString(data?.last_name)
            vc.receiverprofile_image = kBucketUrl+String.getString(data?.profile_pic)
            parentVC?.navigationController?.pushViewController(vc, animated: true)
        } else {
            globalApis.makeConnection(id: data?.id ?? "", completion: {
                self.buttonConnect.setTitle("Pending", for: .normal)
                self.buttonConnect.backgroundColor = UIColor(named: "1")
            })
        }
    }
    
    @IBAction func buttonTotalConnectionsTapped(_ sender: Any) {}
    
    @IBAction func buttonsNavigationTapped(_ sender: UIButton) {
        setupNavigation(selectedIndex: sender.tag)
        protocal?.currentProfilePage(index: sender.tag)
    }
    
}

protocol UpdateProfilePageProtocal {
    func currentProfilePage(index: Int)
}
