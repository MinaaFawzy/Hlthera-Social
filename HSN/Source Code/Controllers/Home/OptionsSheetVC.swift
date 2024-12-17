//
//  OptionsSheetVC.swift
//  HSN
//
//  Created by Prashant Panchal on 16/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class OptionsSheetVC: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnLeaveGroup: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnMakeAdmin: UIButton!
    @IBOutlet weak var btnSharePost: UIButton!
    @IBOutlet weak var btnDeletePost: UIButton!
    @IBOutlet weak var btnEditPost: UIButton!
    @IBOutlet weak var btnPromotePost: OptionSheetButton!
    @IBOutlet weak var btnViewInsights: OptionSheetButton!
    @IBOutlet weak var btnSendLoungeInvitation: OptionSheetButton!
    @IBOutlet weak var btnCopyLoungeLink: OptionSheetButton!
    @IBOutlet weak var btnShareLoungeAudioChatLink: OptionSheetButton!
    
    @IBOutlet weak var constraintBottomHeight: NSLayoutConstraint!
    var hasCameFrom:HasCameFrom = .viewGroup
    var data:HSNGroupModel?
    var pageData:CompanyPageModel?
    var userHomeFeedData:HomeFeedModel?
    var loungeData:RoomModel?
    var memberId = ""
    var parentVC:UIViewController?
    var deleteCallback:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let obj = viewContent.layer
        obj.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        obj.cornerRadius = 20
        switch hasCameFrom{
        case .viewGroup:
            btnLeaveGroup.isHidden = false
            btnReport.isHidden = false
            btnMakeAdmin.isHidden = true
            btnSharePost.isHidden = false
            btnDeletePost.isHidden = true
            btnRemove.isHidden = true
            btnViewInsights.isHidden = true
            btnPromotePost.isHidden = true
            btnCopyLoungeLink.isHidden = true
            btnSendLoungeInvitation.isHidden = true
            btnShareLoungeAudioChatLink.isHidden = true
            if let obj = data{
                if let user = obj.user{
                    if user.user_id == String.getString(UserData.shared.id){
                        btnDeletePost.isHidden = false
                        btnEditPost.isHidden = false
                        stackView.insertArrangedSubview(btnEditPost, at: 0)
                    }
                    else{
                        btnDeletePost.isHidden = true
                        btnEditPost.isHidden = true
                        
                    }
                }
                
                
            }
            
        case .viewGroupAdmin:
            btnLeaveGroup.isHidden = false
            btnReport.isHidden = false
            btnCopyLoungeLink.isHidden = true
            btnSendLoungeInvitation.isHidden = true
            btnShareLoungeAudioChatLink.isHidden = true
            if let obj = data{
                if let user = obj.user{
                    if user.is_admin{
                        btnRemove.isHidden = true
                        btnMakeAdmin.isHidden = true
                        if user.user_id == String.getString(UserData.shared.id){
                            btnDeletePost.isHidden = false
                            btnEditPost.isHidden = false
                            stackView.insertArrangedSubview(btnEditPost, at: 0)
                        }
                        else{
                            btnDeletePost.isHidden = true
                            btnEditPost.isHidden = true
                            
                        }
                        
                        
                        
                    }
                    else{
                        btnRemove.isHidden = false
                        btnMakeAdmin.isHidden = false
                    }
                }
                
            }
            btnSharePost.isHidden = false
            btnDeletePost.isHidden = false
            btnViewInsights.isHidden = true
            btnPromotePost.isHidden = true
            
        case .homeFeed,.viewProfile:
            btnLeaveGroup.isHidden = true
            btnReport.isHidden = false
            btnRemove.isHidden = true
            btnMakeAdmin.isHidden = true
            btnSharePost.isHidden = false
            btnDeletePost.isHidden = true
            btnCopyLoungeLink.isHidden = true
            btnSendLoungeInvitation.isHidden = true
            btnShareLoungeAudioChatLink.isHidden = true
            stackView.insertArrangedSubview(btnSharePost, at: 0)
            btnReport.setTitle(" Report this post", for:.normal)
            if userHomeFeedData?.postMode == .admin {
                btnReport.isHidden = true
            }
            
            if let obj = userHomeFeedData{
               
                if obj.user_id == String.getString(UserData.shared.id) && obj.postMode == .user{
                        btnDeletePost.isHidden = false
                        btnEditPost.isHidden = false
                        stackView.insertArrangedSubview(btnEditPost, at: 0)
                        if obj.is_post_promotion{
                            //insights is false
                            btnViewInsights.isHidden = true
                            btnPromotePost.isHidden = true
                        }else{
                            btnViewInsights.isHidden = true
                            //promote is false
                            btnPromotePost.isHidden = true
                        }
                       
                    }
                    else{
                        btnDeletePost.isHidden = true
                        btnEditPost.isHidden = true
                        btnViewInsights.isHidden = true
                        btnPromotePost.isHidden = true
                    }
               
                
                
            }

        case .selfFeed,.editProfile:
            btnLeaveGroup.isHidden = true
            btnReport.isHidden = false
            btnRemove.isHidden = true
            btnMakeAdmin.isHidden = true
            btnSharePost.isHidden = false
            btnDeletePost.isHidden = false
            btnEditPost.isHidden = false
            btnCopyLoungeLink.isHidden = true
            btnSendLoungeInvitation.isHidden = true
            btnShareLoungeAudioChatLink.isHidden = true
            if let obj = userHomeFeedData{
                if obj.is_post_promotion{
                    //insights is false
                    btnViewInsights.isHidden = true
                    btnPromotePost.isHidden = true
                }else{
                    //promote post is false
                    btnViewInsights.isHidden = true
                    btnPromotePost.isHidden = true
                }
            }
            
            stackView.insertArrangedSubview(btnSharePost, at: 0)
            stackView.insertArrangedSubview(btnDeletePost, at: 1)
            btnReport.setTitle(" Report this post", for:.normal)
            
        case .lounge:
            btnLeaveGroup.isHidden = true
            btnReport.isHidden = true
            btnRemove.isHidden = true
            btnMakeAdmin.isHidden = true
            btnSharePost.isHidden = true
            btnDeletePost.isHidden = true
            btnEditPost.isHidden = true
            btnCopyLoungeLink.isHidden = false
            btnSendLoungeInvitation.isHidden = false
            btnShareLoungeAudioChatLink.isHidden = false
            btnViewInsights.isHidden = true
            btnPromotePost.isHidden = true
//            stackView.insertArrangedSubview(btnSharePost, at: 0)
//            stackView.insertArrangedSubview(btnDeletePost, at: 1)
        default:break
        
        }
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            let bottomPadding = window.safeAreaInsets.bottom
            constraintBottomHeight.constant = bottomPadding + 15
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonCloseTapped(_ sender: Any) {
        if let vc = parentVC{
            
            vc.navigationController?.dismiss(animated: true, completion: nil)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func buttonsOptionTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            switch sender.tag{
            
            case 0:
                globalApis.acceptRejectGroupRequest(id: String.getString(self.data?.user_id), type: 2, groupId: String.getString(self.data?.id), memberId: String.getString(self.data?.user_id), completion: {
                    self.parentVC?.moveToPopUp(text: "Group Left Successfully!", completion: {
                        self.parentVC?.navigationController?.popViewController(animated: true)
                    })
                })
            case 1:
                self.parentVC?.moveToPopUp(text: "\(self.userHomeFeedData?.user_full_name ?? "") Will send text", completion: {
            })
            case 2:
                globalApis.acceptRejectGroupRequest(id: String.getString(self.data?.user_id), type: 2, groupId: String.getString(self.data?.id), memberId: self.memberId, completion: {
                    self.parentVC?.moveToPopUp(text: "User Removed Successfully!", completion: {
                        self.parentVC?.navigationController?.popViewController(animated: true)
                    })
                })
            case 4:
                let text = "Share Hlthera"
                if let urlStr = NSURL(string: "http://www.google.com") {
                    let objectsToShare = [urlStr,text] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                    if UIDevice.current.userInterfaceIdiom == .pad {
                        if let popup = activityVC.popoverPresentationController {
                            popup.sourceView = self.view
                            popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                        }
                    }

                    self.parentVC?.present(activityVC, animated: true, completion: nil)
                }
               
            case 5:
                globalApis.deletePost(id: String.getString(self.userHomeFeedData?.id), type: 1, completion: {
                    self.parentVC?.moveToPopUp(text: "Post Deleted Successfully!", completion: { [self] in
                        
                        switch self.hasCameFrom{
                        case .viewGroup,.viewGroupAdmin:
                            
                            if let vc = parentVC as? ViewGroupVC{
                                vc.getData()
                            }
                        case .homeFeed:
                            if let vc = parentVC as? HomeVC{
                                vc.updateData()
                            }
                      
                        case .selfFeed,.editProfile,.viewProfile:
                            if let vc = parentVC as? OtherUserProfileVC {
                                vc.getProfile()
                                
                            }
                        
                           
                        default:
                            self.parentVC?.navigationController?.popViewController(animated: true)
                        
                        }
                    })
                })
            case 6:
                if Int.getInt(self.userHomeFeedData?.is_post_type) == 5{
                    CommonUtils.showToast(message: "Polls cannot be edited once published")
                }
                else if Int.getInt(self.userHomeFeedData?.is_post_type) == 6{
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier:CreatePostVC.getStoryboardID()) as? CreatePostVC else {return }
                    vc.hasCameFrom = .editPost
                    vc.isShare = true
                    vc.shareData = self.userHomeFeedData
                    vc.editData = self.userHomeFeedData
                    self.parentVC?.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                     guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier:CreatePostVC.getStoryboardID()) as? CreatePostVC else {return }
                     vc.hasCameFrom = .editPost
                     vc.editData = self.userHomeFeedData
                     self.parentVC?.navigationController?.pushViewController(vc, animated: true)
                }
            case 7:
               
                guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier:CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else {return }
                promotionData = [ApiParameters.promotion_goal_type:"",
                                                  ApiParameters.promotion_goal:"",
                                                  ApiParameters.target_audience_type:"",
                                                  ApiParameters.location:"",
                                                  ApiParameters.interest:"",
                                                  ApiParameters.gender:"",
                                                  ApiParameters.age_group_to:"",
                                                  ApiParameters.age_group_from:"",
                                                  ApiParameters.price:"",
                                                  ApiParameters.duration:"",
                                                  ApiParameters.audience_reach:"",
                                                  ApiParameters.tax:"",
                                                  ApiParameters.total_amount:"",
                                                  ApiParameters.post_id:String.getString(self.userHomeFeedData?.id),
                                                  ApiParameters.tran_ref:"",
                                                  ApiParameters.cart_id:""]
                self.parentVC?.navigationController?.pushViewController(vc, animated: true)
            case 8:
                guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier:CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else {return }
                promotionData = [ApiParameters.promotion_goal_type:"",
                                                  ApiParameters.promotion_goal:"",
                                                  ApiParameters.target_audience_type:"",
                                                  ApiParameters.location:"",
                                                  ApiParameters.interest:"",
                                                  ApiParameters.gender:"",
                                                  ApiParameters.age_group_to:"",
                                                  ApiParameters.age_group_from:"",
                                                  ApiParameters.price:"",
                                                  ApiParameters.duration:"",
                                                  ApiParameters.audience_reach:"",
                                                  ApiParameters.tax:"",
                                                  ApiParameters.total_amount:"",
                                                  ApiParameters.post_id:String.getString(self.userHomeFeedData?.id),
                                                  ApiParameters.tran_ref:"",
                                                  ApiParameters.cart_id:""]
                self.parentVC?.navigationController?.pushViewController(vc, animated: true)
            case 9:
                let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: LoungeSendInvitationVC.getStoryboardID()) as! LoungeSendInvitationVC
                self.parentVC?.present(vc, animated: true)
            case 10:
                if let obj = self.loungeData{
                    UIPasteboard.general.string = obj.link
                    CommonUtils.showToast(message: "Link Copied Successfully!")
                }
            case 11:
                if let obj = self.loungeData{
                    let textToShare = "Join Hlthera Audio Room!"
                    if let myWebsite = NSURL(string: obj.link) {
                        let objectsToShare = [textToShare, myWebsite] as [Any]
                        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                        
                        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                        self.parentVC?.present(activityVC, animated: true, completion: nil)
                    }
                }
               
            default: break
            }
        })
    }
    
}
class OptionSheetButton:UIButton{
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        imageView?.layer.transform = CATransform3DMakeScale(1.25,1.25, 1.25)
    }
}
