//
//  VideoCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class VideoCVC: UICollectionViewCell {

    @IBOutlet weak var viewMedia: UIView!
    var editCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonEditTapped(_ sender: Any) {
        editCallback?()
    }
    
}
