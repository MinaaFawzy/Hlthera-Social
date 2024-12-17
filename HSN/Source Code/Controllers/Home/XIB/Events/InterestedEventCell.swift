//
//  InterestedEventCell.swift
//  HSN
//
//  Created by Ankur on 01/06/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class InterestedEventCell: UITableViewCell {
    
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelEventLocation: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelEventTime: UILabel!
    @IBOutlet weak var buttonIntrested: UIButton!
    @IBOutlet weak var labelInterestedCount: UILabel!
    @IBOutlet weak var imageInterested: UIImageView!
    @IBOutlet weak var labelonline: UILabel!
    @IBOutlet weak var viewInterestedButton: UIView!
    @IBOutlet weak var labelInterested: UILabel!
   
    var callbackShare:(()->())?
    var callbackInterested:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonIntrested(_ sender: UIButton) {
        self.callbackInterested?()
    }
    @IBAction func buttonShare(_ sender: UIButton) {
        
    }

}
