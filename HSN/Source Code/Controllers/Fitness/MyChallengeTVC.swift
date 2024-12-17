//
//  MyChallengeTVC.swift
//  HSN
//
//  Created by Shobhit Rastogi on 5/12/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class MyChallengeTVC: UITableViewCell {
    
    @IBOutlet weak var imageMyChallenge: UIImageView!
    var callBack:(()->())?
    var id:Int?
    var NameSearch:String?

    @IBOutlet weak var labelGoal: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelStartTime: UILabel!
    
    
    @IBOutlet weak var labelEndTime: UILabel!
    
    
    
    
    @IBOutlet weak var labelChallengeName: UILabel!
    
    
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonAccepted(_ sender: UIButton) {
        
        self.callBack?()
    }
}
