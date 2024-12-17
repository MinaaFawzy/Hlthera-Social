//
//  PeopleCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PeopleCVC: UICollectionViewCell {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelMutualFriends: UILabel!
    @IBOutlet weak var buttonConnect: UIButton!
    
    var connectCallback:(()->())?
    var closeCallback:(()->())?
    
    func updateCell(data obj:RecommendedUsersModel) {
        self.labelName.text = String.getString(obj.full_name).capitalized
        self.labelProfession.text = obj.employee_type.capitalized.isEmpty ? ("Unknown") : (obj.employee_type.capitalized)
        self.labelMutualFriends.text = obj.mutual_connecation + " Mutual Friends"
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "no_profile_image"))
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        // Initialization code
    }
    @IBAction func buttonConnectTapped(_ sender: Any) {
        connectCallback?()
     
    }
    @IBAction func buttonCloseTapped(_ sender: Any) {
        closeCallback?()
    }
    
}
