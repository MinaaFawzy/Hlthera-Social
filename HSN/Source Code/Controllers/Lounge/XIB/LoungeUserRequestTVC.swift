//
//  LoungeUserRequestTVC.swift
//  HSN
//
//  Created by user206889 on 11/3/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeUserRequestTVC: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    
    var callbackAcceptReject:((Bool)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnAcceptRejectTapped(_ sender: UIButton) {
        callbackAcceptReject?(sender.tag == 0 ? false : true)
    }
    
}
