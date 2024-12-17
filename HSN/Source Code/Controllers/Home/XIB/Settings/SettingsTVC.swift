//
//  SettingsTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 07/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewCell {
    @IBOutlet weak var imageIcon:UIImageView!
    @IBOutlet weak var labelName:UILabel!
    @IBOutlet weak var imageDropDown: UIImageView!
    @IBOutlet weak var switchOption: UISwitch!
    
    var callbackSwitch:((Bool)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        switchOption.transform = CGAffineTransform(scaleX: 0.70, y: 0.65)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchChanged(_ sender: UISwitch) {
        callbackSwitch?(sender.isOn)
    }
    
}
