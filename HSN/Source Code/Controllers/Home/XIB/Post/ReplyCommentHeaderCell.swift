//
//  ReplyCommentHeaderCell.swift
//  HSN
//
//  Created by Apple on 30/08/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ReplyCommentHeaderCell: UITableViewCell {
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var lblReplyCount: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
