//
//  ViewPageLifeLeaderCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 30/11/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewPageLifeLeaderCVC: UICollectionViewCell {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfile: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    var deleteCallback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonDeleteTapped(_ sender: Any) {
        deleteCallback?()
    }
    
}
