//
//  HashTagsCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 22/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class HashTagsCVC: UICollectionViewCell {
    @IBOutlet weak var buttonTag: UIButton!
    var callbackTagTapped:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonTagTapped(_ sender: Any) {
        callbackTagTapped?()
    }
    
}
