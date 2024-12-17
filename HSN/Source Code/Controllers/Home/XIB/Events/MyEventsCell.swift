//
//  MyEventsCell.swift
//  HSN
//
//  Created by Ankur on 23/05/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class MyEventsCell: UITableViewCell {

    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelEventLocation: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelEventTime: UILabel!
    @IBOutlet weak var labelonline: UILabel!
    @IBOutlet weak var labelInterestCount: UILabel!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var buttonSponsor: UIButton!
    
    var callbackShare:(()->())?
    var callbackEdit:(()->())?
    var callbackSponsor:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewCell.maskingCorner([.topLeft,.topRight], radius: 8.0)
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonEdit(_ sender: UIButton) {
        self.callbackEdit?()
    }
    @IBAction func buttonShare(_ sender: UIButton) {
        
    }
    @IBAction func buttonSponsor(_ sender: UIButton) {
        self.callbackSponsor?()
    }

}
