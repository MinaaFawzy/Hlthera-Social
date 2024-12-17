//
//  NameTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 22/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class NameTVC: UITableViewCell {

    @IBOutlet weak var buttonHashTag: UIButton!
    var callbackHashTag:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonHashTagTapped(_ sender: Any) {
        callbackHashTag?()
    }
    
}
