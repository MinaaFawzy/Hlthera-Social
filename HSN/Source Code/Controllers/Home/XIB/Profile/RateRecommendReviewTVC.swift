//
//  RateRecommendReviewTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 20/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Cosmos

class RateRecommendReviewTVC: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var constraintCosmosHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
    }

}
