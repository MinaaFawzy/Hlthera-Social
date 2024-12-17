//
//  MultipleSelectionCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class MultipleSelectionCVC: UICollectionViewCell {
    @IBOutlet weak var labelText:UILabel!
    @IBOutlet weak var buttonRemove:UIButton!
    var removeCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonRemoveTapped(_ sender: Any) {
        removeCallback?()
    }
    
}
