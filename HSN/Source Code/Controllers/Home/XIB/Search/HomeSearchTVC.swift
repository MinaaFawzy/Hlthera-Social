//
//  HomeSearchTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 20/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class HomeSearchTVC: UITableViewCell {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var imageReaction: UIImageView!
    @IBOutlet weak var buttonSelection: UIButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var callbackSelection: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
    }
    
    @IBAction func buttonSelectTapped(_ sender: Any) {
        callbackSelection?()
    }
    
}
