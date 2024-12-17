//
//  UploadPhotoVideoBtnCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 30/11/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class UploadPhotoVideoBtnCVC: UICollectionViewCell {
    var uploadCallback:(()->())?

    @IBOutlet weak var buttonCamera: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonUploadTapped(_ sender: Any) {
        uploadCallback?()
    }
    
}
