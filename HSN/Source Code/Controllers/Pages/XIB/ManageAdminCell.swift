//
//  ManageAdminCell.swift
//  HSN
//
//  Created by Apple on 14/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ManageAdminCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelTotalMembers: UILabel!
    @IBOutlet weak var buttonRadio: UIButton!
    @IBOutlet weak var buttonAdmin: UIButton!
    
    var selectUserCallback:((UIButton)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var obj : InvitationsModel?{
        didSet {
            if let user = obj?.user{
                self.lblUserName.text = String.getString(user.full_name).capitalized
                self.labelTotalMembers.text = user.employee_type.capitalized.isEmpty ? ("Unknown") : (user.employee_type.capitalized)
                self.profileImage.downlodeImage(serviceurl: kBucketUrl + user.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            }
        }
      
    }
    
    var admin : CandidateDetailsModel?{
        didSet {
            
            if let user = self.admin?.user {
                lblUserName.text = user.full_name
                profileImage.kf.setImage(with: URL(string: kBucketUrl+String.getString(user.profile_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                self.labelTotalMembers.text = user.employee_type.capitalized.isEmpty ? ("Unknown") : (user.employee_type.capitalized)
            }
        
        }
      
    }
    
    @IBAction func buttonRadioTapped(_ sender: UIButton) {
        buttonRadio.isSelected = !sender.isSelected
        selectUserCallback?(buttonRadio)
        
    }
    
    @IBAction func buttonAdminTapped(_ sender: Any) {
        
        
    }

}
