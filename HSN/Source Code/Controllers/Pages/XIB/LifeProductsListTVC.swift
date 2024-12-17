//
//  LifeProductsListTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 30/11/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LifeProductsListTVC: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    var editCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        editCallback?()
    }
}
