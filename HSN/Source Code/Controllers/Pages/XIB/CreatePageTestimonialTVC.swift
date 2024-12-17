//
//  CreatePageTestimonialTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 01/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreatePageTestimonialTVC: UITableViewCell {
    @IBOutlet weak var viewAddLeader: UIView!
    @IBOutlet weak var viewLeader: UIView!
    @IBOutlet weak var labelLeaderName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textViewQuote: IQTextView!
    
    var callback:(()->())?
    var callbackDelete:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonSelectEmployeeTapped(_ sender: Any) {
        callback?()
    }
    @IBAction func buttonDeleteTapped(_ sender: Any) {
        self.callbackDelete?()
        
    }
    
}
