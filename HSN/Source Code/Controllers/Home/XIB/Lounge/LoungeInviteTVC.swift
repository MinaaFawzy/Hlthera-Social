//
//  LoungeInviteTVC.swift
//  HSN
//
//  Created by Ankur on 04/07/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class LoungeInviteTVC: UITableViewCell {
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelShortName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    var buttonCallBack:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonInviteTapped(_ sender: UIButton) {
        self.buttonCallBack?()
    }
    
}
