//
//  DocumentVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class DocumentVC: UICollectionViewCell {
    @IBOutlet weak var labelFileName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var buttonRemoveFile: UIButton!
    var deleteCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonDeleteTapped(_ sender: Any) {
        deleteCallback?()
    }
    
}
