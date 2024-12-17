//
//  LoungeHomeCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 19/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeHomeCVC: UICollectionViewCell {

    @IBOutlet weak var labelTotalPeople: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonInvite: UIButton!
    @IBOutlet weak var buttonNotification: UIButton!
    
    var callback:(()->())?
    var callbackNotification:((UIButton)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonInviteTapped(_ sender: Any) {
        callback?()
    }
    @IBAction func buttonNotificationTapped(_ sender: UIButton) {
        callbackNotification?(sender)
    }
    
}
