//
//  LoungeSuggestionsTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 14/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeSuggestionsTVC: UITableViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet weak var labelName: UILabel!    
    @IBOutlet weak var viewContent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
