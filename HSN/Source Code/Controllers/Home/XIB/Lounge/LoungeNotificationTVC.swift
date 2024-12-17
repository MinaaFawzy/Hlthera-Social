//
//  LoungeNotificationTVC.swift
//  HSN
//
//  Created by Ankur on 06/07/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class LoungeNotificationTVC: UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelTimeDuration: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
