//
//  LoungeHomeTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeHomeTVC: UITableViewCell {
    
    
    @IBOutlet weak var loungeLogo: UIImageView!
    @IBOutlet weak var membersStack: UIStackView!
    @IBOutlet weak var labelLoungeName: UILabel!
    @IBOutlet weak var labelLoungeDescription: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelCreatedBy: UILabel!
    @IBOutlet weak var labelTotalParticipants: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var butttonInvitations: UIButton!
    
    var callbackJoin:(()->())?
    var callbackShare:(()->())?
    var callbackNotifications:((UIButton)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnShareTapped(_ sender: Any) {
        callbackShare?()
    }
    @IBAction func btnInviteTapped(_ sender: Any) {
        callbackJoin?()
    }
    @IBAction func btnNotificationsTapped(_ sender: UIButton) {
        callbackNotifications?(sender)
    }
    
}
