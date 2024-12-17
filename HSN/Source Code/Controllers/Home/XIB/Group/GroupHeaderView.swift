//
//  GroupHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 15/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class GroupHeaderView: UIView {
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imageGroupIcon: UIImageView!
    @IBOutlet weak var buttonEdit: ResizableButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelGroupName: UILabel!
    @IBOutlet var imagesMembers: [UIImageView]!
    @IBOutlet weak var buttonTotalMembers: UIButton!
   // @IBOutlet weak var labelTotalMembers: UILabel!
    @IBOutlet weak var labelTotalMembersCount: UILabel!
    @IBOutlet weak var labelMembersNames: UILabel!
    @IBOutlet var ViewsNavigation: [UIView]!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnActivity: UIButton!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnInvitePeople: ResizableButton!
    
    private var hasCameFrom:HasCameFrom?
    private var data:HSNGroupModel?
    private var pageData:CompanyPageModel?
     private var parentVC:UIViewController?
    var selectedTab = 0
    private var protocal:UpdateProfilePageProtocal?
    
    class func viewInstance()->GroupHeaderView{
        let view = UINib(nibName: "GroupHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GroupHeaderView
        return view
    }
    
    func initialSetup(_ hasCameFrom:HasCameFrom, userData:HSNGroupModel?, parentVC:ViewGroupVC,selectedTab:Int = 0,protocal:UpdateProfilePageProtocal?){
        self.data = userData
        self.parentVC = parentVC
        self.protocal = protocal
        setupNavigation(selectedIndex: selectedTab)
        viewHeader.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewHeader.layer.cornerRadius = 25
       updateData(data: userData)
        
        imageCover.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageCover.contentMode = UIView.ContentMode.scaleAspectFill
        imageGroupIcon.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageGroupIcon.contentMode = UIView.ContentMode.scaleAspectFill
        switch hasCameFrom{
        case .viewGroup:
            self.buttonEdit.isHidden = true
        case .viewGroupAdmin:
            self.buttonEdit.isHidden = false
        default:break
        }
    }
    func initialSetup(_ hasCameFrom:HasCameFrom, userData:CompanyPageModel?, parentVC:UIViewController,selectedTab:Int = 0,protocal:UpdateProfilePageProtocal?){
        self.btnAbout.setTitle("About Page", for: .normal)
        self.btnActivity.setTitle("Page Activities", for: .normal)
        self.pageData = userData
        self.parentVC = parentVC
        self.protocal = protocal
        self.hasCameFrom = hasCameFrom
        setupNavigation(selectedIndex: selectedTab)
        viewHeader.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewHeader.layer.cornerRadius = 25
       updateData(data: userData)
        
        imageCover.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageCover.contentMode = UIView.ContentMode.scaleAspectFill
        imageGroupIcon.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageGroupIcon.contentMode = UIView.ContentMode.scaleAspectFill
        self.btnInvitePeople.setTitle("Follow Page", for: .normal)
        switch hasCameFrom{
        case .viewPage:
            self.buttonEdit.isHidden = true
        case .viewPageAdmin:
            self.buttonEdit.isHidden = false
        default:break
        }
    }

    func updateData(data:HSNGroupModel?){
        if let obj = data{
            self.labelGroupName.text = obj.name
            self.labelDescription.text = obj.about
            self.buttonTotalMembers.setTitle(String.getString(obj.total_group_members_count) + " Members", for: .normal)
                self.labelTotalMembersCount.text = "+" + String.getString(obj.total_group_members_count)
            self.labelMembersNames.text = "Temp"
            
            self.imageGroupIcon.kf.setImage(with: URL(string: kBucketUrl + obj.group_pic),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            self.imageCover.kf.setImage(with: URL(string: kBucketUrl + obj.cover_pic),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"))
        }
    }
    func updateData(data:CompanyPageModel?){
        if let obj = data{
            self.labelGroupName.text = obj.page_name
            self.labelDescription.text = obj.description
            self.buttonTotalMembers.setTitle(String.getString(obj.total_followers_count) + " Members", for: .normal)
                self.labelTotalMembersCount.text = "+" + String.getString(obj.total_followers_count)
            self.labelMembersNames.text = "Temp"
            
            self.imageGroupIcon.kf.setImage(with: URL(string: kBucketUrl + obj.profile_pic),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            self.imageCover.kf.setImage(with: URL(string: kBucketUrl + obj.cover_pic),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"))
            setPageFollowed(status: obj.company_page_follow_by_me)
        }
    }
    
    func setupNavigation(selectedIndex:Int = 0){
   
        for (index,view) in self.ViewsNavigation.enumerated(){
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
    func setPageFollowed(status:Bool){
        if status{
            self.btnInvitePeople.setTitle("Unfollow Page", for: .normal)
        }else{
            self.btnInvitePeople.setTitle("Follow Page", for: .normal)
        }
    }
    @IBAction func buttonTotalMembersTapped(_ sender: Any) {
        if hasCameFrom == .viewPage || hasCameFrom == .viewPageAdmin{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectGroupVC.getStoryboardID()) as? SelectGroupVC else { return }
            vc.groupMembers = data?.group_members ?? []
            vc.hasCameFrom = .viewGroup
            
            self.parentVC?.navigationController?.present(vc, animated: true)
        }
        else{
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectGroupVC.getStoryboardID()) as? SelectGroupVC else { return }
            vc.groupMembers = data?.group_members ?? []
            vc.hasCameFrom = .viewGroup
            
            self.parentVC?.navigationController?.present(vc, animated: true)
        }
        
       
    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        if hasCameFrom == .viewPageAdmin{
            
            guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: EditPageVC.getStoryboardID()) as? EditPageVC else { return }
           
            vc.data = pageData
            vc.pageId = pageData?.id ?? ""
            
            self.parentVC?.navigationController?.pushViewController(vc, animated: true)

        }
        else{
           
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateGroupVC.getStoryboardID()) as? CreateGroupVC else { return }
           
            vc.hasCameFrom = .editGroup
            vc.editData = data
            
            self.parentVC?.navigationController?.pushViewController(vc, animated: true)

        }
    }
    @IBAction func buttonInvitePeopleTapped(_ sender: Any) {
        if hasCameFrom == .viewPage || hasCameFrom == .viewPageAdmin{
           // obj?.id
            if let obj = pageData{
                globalApis.followUnfollowPageApi(pageId: obj.id, isFollowing: !obj.company_page_follow_by_me , completion: { count,status in
                    self.parentVC?.moveToPopUp(text: "Page \(status ? "followed" : "unfollowed") successfully!", completion: {
                        self.setPageFollowed(status: status)
                        obj.company_page_follow_by_me  = status
                        self.buttonTotalMembers.setTitle(String.getString(count) + " Members", for: .normal)
                            self.labelTotalMembersCount.text = "+" + String.getString(count)
                    })
                })
            }
          
           // globalApis.followUnfollowPageApi(pageId: data?.id ?? "", isFollowing: data., completion: <#T##(Int, Bool) -> ()#>)

        }
        else{
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectRecipientVC.getStoryboardID()) as? SelectRecipientVC else { return }
        vc.parentVC = self.parentVC ?? UIViewController()
        vc.hasCameFrom = .invitePeopleGroup
        vc.groupId = String.getString(data?.id)
        vc.callbackInvitePeople = { people in
            if !people.isEmpty{
                globalApis.sendGroupInvitationApi(userIds: people.map{$0.recipient_id}, groupId: String.getString(self.data?.id), completion: {
                    self.parentVC?.moveToPopUp(text: "Invitation Sent Successfully!", completion: {
                        
                        
                    })
                })
            }
            
            
        }
        
        self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func buttonNavigationsTapped(_ sender: UIButton) {
        setupNavigation(selectedIndex: sender.tag)
        self.selectedTab = sender.tag
        protocal?.currentProfilePage(index: sender.tag)
    }
    
}
