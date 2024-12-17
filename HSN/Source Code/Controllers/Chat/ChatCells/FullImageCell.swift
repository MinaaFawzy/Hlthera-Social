//
//  FullImageCell.swift
//  RippleApp
//
//  Created by Mohd Aslam on 21/05/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class FullImageCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.contentView.clipsToBounds = true
        imgView.clipsToBounds = true
        
    }

}
