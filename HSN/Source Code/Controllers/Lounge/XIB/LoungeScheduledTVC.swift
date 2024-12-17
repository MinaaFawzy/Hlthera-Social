//
//  LoungeScheduledTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 19/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeScheduledTVC: UITableViewCell {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imgLoungeType: UIImageView!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var LoungeUserNameLabel: UILabel!
    
    var callbackDelete:(()->())?
    var callbackShare:(()->())?
    var callbackInvite:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnLoungeTapped(_ sender: Any) {
        callbackDelete?()
    }
    @IBAction func btnShareTapped(_ sender: Any) {
        callbackShare?()
    }
    @IBAction func btnInviteTapped(_ sender: Any) {
        callbackInvite?()
    }
    
}
