//
//  MoreProfilePopUpVC.swift
//  HSN
//
//  Created by Prashant Panchal on 20/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class MoreProfilePopUpVC: UIViewController {
    var parentVC:OtherUserProfileVC?
    var data:UserProfileModel?
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var constraintBottomHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.layer.cornerRadius = 18
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            let bottomPadding = window.safeAreaInsets.bottom
            constraintBottomHeight.constant = bottomPadding + 15
        }
    }
    @IBAction func buttonShareProfileTapped(_ sender: Any) {
        
    }
    
    @IBAction func buttonConnectTapped(_ sender: Any) {
        
    }
    
    @IBAction func buttonRecommendTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: RateRecommendVC.getStoryboardID()) as? RateRecommendVC else { return }
            vc.data = self.data
            self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        })
    }
    @IBAction func buttonRateReviewTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: RateRecommendVC.getStoryboardID()) as? RateRecommendVC else { return }
            vc.isRating = true
            vc.data = self.data
            self.parentVC?.navigationController?.pushViewController(vc, animated: true)
        })
    }
    @IBAction func buttonReportTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: AlertConfirmationVC.getStoryboardID()) as? AlertConfirmationVC else { return }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.alertDesc = "Are you sure you want to block this user?"
            vc.yesCallback = {
                
                self.parentVC?.dismiss(animated: true, completion: {
                    
                    globalApis.blockUserApi(userId: String.getString(self.data?.id)){
                        self.parentVC?.moveToPopUp(text: "User Blocked Successfully!", completion: {
                            kSharedAppDelegate?.moveToHomeScreen()
                        })
                    }
                       
                    
                    
            })
                
            
        }
            self.parentVC?.navigationController?.present(vc, animated: true)
        
        })
  
    }
  
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
