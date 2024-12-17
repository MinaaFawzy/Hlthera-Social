//
//  PeopleCardQuickViewCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 08/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class PeopleCardQuickViewCVC: UICollectionViewCell {
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelHeadline: UILabel!
    @IBOutlet weak var buttonNetworkConnections: UIButton!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var buttonConnect: UIButton!
    
    var callbackConnect:(()->())?
    var callbackDismiss:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCover.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageCover.contentMode = UIView.ContentMode.scaleAspectFill
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        // Initialization code
    }
    func configure(data obj:RecommendedUsersModel){
        self.labelFullName.text = String.getString(obj.full_name).capitalized
        self.labelProfession.text = obj.employee_type.capitalized.isEmpty ? ("Unknown") : (obj.employee_type.capitalized)
        self.labelHeadline.text = obj.mutual_connecation + " Mutual Friends"
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
//        self.labelFullName.text = obj.full_name.capitalized
//        self.labelProfession.text = obj.employee_type.isEmpty ? ("Unkown") : (obj.employee_type.capitalized)
//        //obj.mutual_connecation + " Mutual Friends"
//        self.labelLocation.text = obj.address.isEmpty ? ("Unknown") : (obj.address.capitalized) + ", " + (obj.country_name.capitalized) //todo
//        self.labelHeadline.text = obj.headline.isEmpty ? "Welcome to my profile" : obj.headline
//        let res = Int.getInt(obj.connecation_count) <= 1 ? " Network connection" : " Network connections"
//        self.buttonNetworkConnections.setTitle(obj.connecation_count + res, for: .normal)
//        self.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
//        self.imageCover.downlodeImage(serviceurl: kBucketUrl + obj.cover_pic, placeHolder: #imageLiteral(resourceName: "cover_page_placeholder"))
//        self.labelFollowers.text = obj.follower_count + " Followers"
//        if obj.is_connected_withme.isEmpty{
//            self.buttonConnect.setTitle("Connect", for: .normal)
//        }else if obj.is_connected_withme == "0"{
//            self.buttonConnect.setTitle("Pending", for: .normal)
//            self.buttonConnect.isUserInteractionEnabled = false
//            self.buttonConnect.backgroundColor = UIColor(named: "1")
//        }
//        else if obj.is_connected_withme == "1"{
//            self.buttonConnect.setTitle("Message", for: .normal)
//            self.buttonConnect.isUserInteractionEnabled = true
//        }
//        else if obj.is_connected_withme == "2"{
//            self.buttonConnect.setTitle("Accept", for: .normal)
//            self.buttonConnect.isUserInteractionEnabled = true
//        }
        
    }
    @IBAction func buttonConnectTapped(_ sender: Any) {
        callbackConnect?()
    }
    @IBAction func buttonDismissTapped(_ sender: Any) {
        callbackDismiss?()
    }
   
    
}
