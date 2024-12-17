//
//  InsightsPostTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 09/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import ActiveLabel
class InsightsPostTVC: UITableViewCell {
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var labelDescription: ActiveLabel!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    
    @IBOutlet weak var buttonComment: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonCommentTapped(_ sender: Any) {
    }
    @IBAction func buttonShareTapped(_ sender: Any) {
    }
    @IBAction func buttonLikeTapped(_ sender: Any) {
    }
    
}
