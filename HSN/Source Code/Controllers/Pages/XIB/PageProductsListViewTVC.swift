//
//  PageProductsListViewTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 03/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageProductsListViewTVC: UITableViewCell {
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelndustryType: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
