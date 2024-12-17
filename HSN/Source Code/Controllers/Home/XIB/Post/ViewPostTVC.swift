//
//  ViewPostTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 25/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewPostTVC: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
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
    
}
