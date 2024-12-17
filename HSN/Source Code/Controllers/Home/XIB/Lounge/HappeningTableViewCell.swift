//
//  HappeningTableViewCell.swift
//  HSN
//
//  Created by Mukul Dixit on 13/05/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class HappeningTableViewCell: UITableViewCell {

    @IBOutlet weak var labelHappeningNow: UILabel!
    @IBOutlet weak var CollectionViewHappeningNow: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
