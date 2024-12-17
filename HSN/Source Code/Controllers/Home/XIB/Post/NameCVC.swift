//
//  NameCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 16/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class NameCVC: UICollectionViewCell {

    @IBOutlet weak var labelName: UILabel!
    var deleteCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonRemoveTapped(_ sender: Any) {
        deleteCallback?()
    }
    
}
