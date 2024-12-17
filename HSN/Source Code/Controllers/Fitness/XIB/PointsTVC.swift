//
//  PointsTVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 25/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class PointsTVC: UITableViewCell {

    @IBOutlet weak var labelNumber: UILabel!
    
    @IBOutlet weak var imageName: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    
    @IBOutlet weak var labelPointss: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
