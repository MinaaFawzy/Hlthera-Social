//
//  ExperienceDataTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 27/07/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ExperienceDataTVC: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocatino: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageDot: UIImageView!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var imageCompany: UIImageView!
    @IBOutlet weak var labelTotalExperience: UILabel!
    
    var editCallback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        editCallback?()
    }
    
}
