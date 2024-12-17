//
//  PhotoCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import ImageViewer_swift
class PhotoCVC: UICollectionViewCell {
    @IBOutlet weak var imageMedi: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var imagePlayBtn: UIImageView!
    var editCallback:(()->())?
    var deleteCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        imageMedi.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageMedi.contentMode = UIView.ContentMode.scaleAspectFill
        
        // Initialization code
    }
    @IBAction func buttonEditTapped(_ sender: Any) {
        editCallback?()
    }
    @IBAction func buttonDeleteTapped(_ sender: Any) {
        deleteCallback?()
    }
    
}
