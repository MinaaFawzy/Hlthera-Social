//
//  FindExpertTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class FindExpertTVC: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(obj:HomeFeedModel){
        self.labelTitle.text = "Find an Expert"
        self.labelDescription.text = obj.city_name + "," + obj.state_name + "," + obj.country_name
        self.labelType.text = "Recommendation needed"
    }
    
}
