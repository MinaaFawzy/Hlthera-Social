//
//  ViewJobTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewJobTVC: UITableViewCell {

    @IBOutlet weak var labelJobTitle: UILabel!
    @IBOutlet weak var labelCompanyName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelConnections: UILabel!
    @IBOutlet weak var viewMembers: UIView!
    @IBOutlet weak var labelJobPostedDate: UILabel!
    @IBOutlet weak var imageCompanyLogo: UIImageView!
    @IBOutlet weak var buttonBookmark: UIButton!
    
    var bookmarkCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonBookMarkTapped(_ sender: Any) {
        bookmarkCallback?()
    }
    
}
