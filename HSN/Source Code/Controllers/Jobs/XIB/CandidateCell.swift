//
//  CandidateCell.swift
//  HSN
//
//  Created by Apple on 04/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
//import Lottie

class CandidateCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var lblQualification : UILabel!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var lblExperience : UILabel!
    @IBOutlet weak var lblSkills : UILabel!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var viewFavorite: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var candidate : CandidateDetailsModel?{
        didSet {
            //self.viewFavorite.contentMode = .scaleAspectFill
            //self.viewFavorite.loopMode = .playOnce
            //self.viewFavorite.animationSpeed = 0.5
            //viewFavorite!.play()
            if let obj = self.candidate {
                lblName.text = obj.user?.full_name
                profileImage.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.user?.profile_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                let date = Date(unixTimestamp: Double.getDouble(obj.apply_date_time))
                let formatter = RelativeDateTimeFormatter()
                formatter.unitsStyle = .full
                lblTime.text = formatter.localizedString(for: date, relativeTo: Date())
                
                self.buttonFavourite.isSelected = obj.is_favourite
                //self.viewFavorite.currentFrame = obj.is_favourite ? AnimationFrameTime(90) : AnimationFrameTime(30)
                lblSkills.text = obj.skills
                lblExperience.text = obj.total_experience
            }
        }
    }
    
    @IBAction func buttonMessageTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
        vc.receiverid = String.getString(self.candidate?.user?.id)
        vc.receivername = String.getString(self.candidate?.user?.full_name)
        vc.receiverprofile_image = kBucketUrl+String.getString(self.candidate?.user?.profile_pic)
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonCallTapped(_ sender: Any) {
        if let phoneNumber = self.candidate?.mobile_number {
            if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @IBAction func buttonFavouriteTapped(_ sender: UIButton) {
        
        let dict = ["company_id" : self.candidate?.company_id, "company_job_id" : self.candidate?.company_job_id, "user_id" : self.candidate?.user?.id] as [String : Any]
        
        globalApis.favoriteUnfavoriteCandidate(params: dict, completion: { status in
            self.buttonFavourite.isSelected = status
            self.candidate?.is_favourite = status
            if let topVC = UIApplication.topViewController() as? CandidatesListVC {
                topVC.getData()
               // topVC.getFavoriteData()
            }
//            else if let homeVC = UIApplication.topViewController() as? HomeVC {
//                homeVC.tableViewFeed.reloadData()
//            }else if let prevc = self.parent?.navigationController?.previousViewController() as? JBTabBarController {
//                if let homeVC = prevc.viewControllers?[0] as? HomeVC {
//                    homeVC.homeFeed[homeVC.selectedPost].is_favourite = status
//                    homeVC.tableViewFeed.reloadData()
//                }
//            }
            if status{
                //self.viewFavorite.play(fromFrame: AnimationFrameTime(30), toFrame: 90, loopMode: .playOnce) { finished in}
            }
            else{
                //self.viewFavorite.play(fromFrame: AnimationFrameTime(90), toFrame: 30, loopMode: .playOnce) { finished in}
            }
        })

    }
}
