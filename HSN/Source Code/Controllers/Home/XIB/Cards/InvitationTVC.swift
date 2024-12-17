//
//  InvitationTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class InvitationTVC: UITableViewCell {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelMutualFriends: UILabel!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonReject: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelRequestedToSpeak: UILabel!
    
    
    var acceptCallback:(()->())?
    var rejectCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(data obj:InvitationsModel){
        if let user = obj.user{
            self.labelName.text = String.getString(obj.user?.full_name).capitalized
            self.labelProfession.text = user.employee_type.capitalized.isEmpty ? ("Unknown") : (user.employee_type.capitalized)
            self.labelMutualFriends.text = user.mutual_connecation + " Mutual Friends"
            self.imageProfile.downlodeImage(serviceurl: kBucketUrl + user.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        }
      
    }
    @IBAction func buttonAcceptTapped(_ sender: Any) {
        acceptCallback?()
    }
    @IBAction func buttonRejectTapped(_ sender: Any) {
        rejectCallback?()
    }
    
}
