//
//  PostHeader.swift
//  HSN
//
//  Created by Prashant Panchal on 27/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import FittedSheets
//import Lottie

class PostHeader: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UIButton!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelGroupPost: UILabel!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var viewEdited: UIView!
    @IBOutlet weak var viewFavorite: UIView!
    @IBOutlet weak var exclusiveHeaderView: UIView!
    @IBOutlet weak var lblExclusiveTitle: UILabel!
    @IBOutlet weak var lblExclusiveTime: UILabel!
    
    // MARK: Stored Properties
    var parent: UIViewController?
    var groupData: HSNGroupModel?
    var data: HomeFeedModel?{
        didSet {
            updateData()
        }
    }
    var callbackName: (()->())?
    var onBack: (()->())?
    var dict: [String: Any] = [:]
    var hasCameFrom: HasCameFrom = .none
    var sheetController: SheetViewController?
    
    // MARK: - Functions
    class func viewInstace() -> PostHeader {
        let view = UINib(nibName: "PostHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PostHeader
        return view
    }
    
    func showBottomSheet(height: Int = 475, percent: Float = 0.45) {
        
        let optionsSheetVC = parent?.storyboard?.instantiateViewController(withIdentifier: OptionsSheetVC.getStoryboardID()) as! OptionsSheetVC
        if let vc = optionsSheetVC as? OptionsSheetVC{
            vc.hasCameFrom = self.hasCameFrom
            vc.parentVC = self.parent
            vc.userHomeFeedData = self.data
            vc.data = self.groupData
        }
        let options = SheetOptions(
            pullBarHeight: 24, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
        )
        sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.intrinsic], options: options)
        sheetController?.allowGestureThroughOverlay = false
        sheetController?.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
        sheetController?.minimumSpaceAbovePullBar = 0
        sheetController?.treatPullBarAsClear = false
        sheetController?.autoAdjustToKeyboard = false
        sheetController?.dismissOnOverlayTap = true
        
        // Disable the ability to pull down to dismiss the modal
        sheetController?.dismissOnPull = true
        // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())
        parent?.present(sheetController ?? SheetViewController(controller: parent ?? UIViewController()), animated: false, completion: nil)
    }
    
    func updateData() {
        //self.viewFavorite.contentMode = .scaleAspectFill
        //self.viewFavorite.loopMode = .playOnce
        //self.viewFavorite.animationSpeed = 1
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        if let obj = data{
            
            let date = Date(unixTimestamp: Double.getDouble(obj.date_of_post))
            
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            
            labelDate.text = obj.is_post_promotion ? ("Sponsored") : (formatter.localizedString(for: date, relativeTo: Date()))
            if dict.isEmpty{
                //labelName.setTitle(obj.user_first_name.capitalized + " " + obj.user_last_name.capitalized, for: .normal)
                labelName.setTitle(obj.is_company_post ? String.getString(obj.company_detail?.page_name).capitalized : obj.user_full_name.capitalized, for: .normal)
                
                let url = obj.is_company_post ? String.getString(obj.company_detail?.profile_pic) : obj.user_profile_pic
                if let downloaded =  obj.userProfilePic{
                    self.imageProfile.image = downloaded
                }
                else{
                    
                    imageProfile.kf.setImage(with: URL(string: kBucketUrl + url),placeholder:#imageLiteral(resourceName: "profile_placeholder"))
                }
                labelName.isUserInteractionEnabled = true
            }
            else{
                //labelName.setTitle(String.getString(dict["fname"]).capitalized + " " + String.getString(dict["lname"]).capitalized, for: .normal)
                labelName.setTitle(obj.is_company_post ? String.getString(obj.company_detail?.page_name).capitalized : String.getString(dict["fullname"]).capitalized, for: .normal)
                let url = obj.is_company_post ? String.getString(obj.company_detail?.profile_pic) : String.getString(dict["image"])
                imageProfile.kf.setImage(with: URL(string: kBucketUrl + url ),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                labelName.isUserInteractionEnabled = false
            }
            self.buttonFavourite.isSelected = obj.is_favourite
            //self.viewFavorite.currentFrame = obj.is_favourite ? AnimationFrameTime(90) : AnimationFrameTime(30)
            if obj.group_id.isEmpty{
                self.labelGroupPost.isHidden = true
            }
            else{
                self.labelGroupPost.isHidden = false
            }
            if obj.is_post_edited{
                self.viewEdited.isHidden = false
            }
            else{
                self.viewEdited.isHidden = true
            }
        }
    }
    
    @IBAction func buttonFavoriteTapped(_ sender: UIButton) {
        globalApis.favoriteUnfavoritePost(postId: String.getString(data?.id), status: !sender.isSelected, completion: { status in
            self.buttonFavourite.isSelected = status
            self.data?.is_favourite = status
            if let topVC = UIApplication.topViewController() as? FavoritesPostVC {
                topVC.updateData()
            }else if let homeVC = UIApplication.topViewController() as? HomeVC {
                homeVC.tableViewFeed.reloadData()
            }else if let prevc = self.parent?.navigationController?.previousViewController() as? JBTabBarController {
                if let homeVC = prevc.viewControllers?[0] as? HomeVC {
                    homeVC.homeFeed[homeVC.selectedPost].is_favourite = status
                    homeVC.tableViewFeed.reloadData()
                }
            }
            if status{
                //self.viewFavorite.play(fromFrame: AnimationFrameTime(30), toFrame: 90, loopMode: .playOnce) { finished in}
            }
            else{
                //self.viewFavorite.play(fromFrame: AnimationFrameTime(90), toFrame: 30, loopMode: .playOnce) { finished in}
            }
        })
    }
    
    @IBAction func buttonNameTapped(_ sender: Any) {
        if let obj = data{
            if obj.is_company_post{
                guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: ViewPageVC.getStoryboardID()) as? ViewPageVC else { return }
                //vc.data = data
                vc.pageId = obj.company_detail?.id ?? ""
                if let nav = self.parent{
                    nav.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    let navigationController = navv
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
                //                globalApis.getCompanyProfile(id: String.getString(obj.company_detail?.id), completion: { data in
                //
                //
                //                })
            }else{
                //                globalApis.getProfile(id: String.getString(self.data?.user_id), completion: {user in
                //
                //
                //
                //
                //                })
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                //vc.data = user
                vc.id = obj.user_id
                vc.hasCameFrom = .viewProfile
                if String.getString(self.data?.user_id) == UserData.shared.id{
                    vc.hasCameFrom = .editProfile
                }
                
                if let nav = self.parent{
                    nav.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    let navigationController = navv
                    navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
        
        
    }
    
    @IBAction func buttonMoreTapped(_ sender: Any) {
        //        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OptionsSheetVC.getStoryboardID()) as? OptionsSheetVC else { return }
        //
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overFullScreen
        //
        //        if let nav = self.parent{
        //            nav.present(vc, animated: true)
        //        }
        //        else{
        //
        //            let navigationController = navv
        //            navigationController?.present(vc, animated: true)
        //
        //        }
        showBottomSheet()
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        onBack?()
    }
    
}




