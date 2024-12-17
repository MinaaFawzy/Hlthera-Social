//
//  PageLifeLeaderCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 30/11/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageLifeLeaderCVC: UICollectionViewCell {
    var callback:(()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonAddLeaderTapped(_ sender: Any) {
        callback?()
    }
    
}
