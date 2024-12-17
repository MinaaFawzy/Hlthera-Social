//
//  AcceptRejectNotificationTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 22/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class AcceptRejectNotificationTVC: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    //@IBOutlet weak var viewDash: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var viewAcceptReject: UIView!
    @IBOutlet weak var constraintViewAcceptRejectHeight: NSLayoutConstraint!
    
    var joinCallback: (() -> ())?
    var cancelCallback: (() -> ())?
    var onMore: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        profileImage.contentMode = UIView.ContentMode.scaleAspectFill
    }

    @IBAction private func buttonJoinTapped(_ sender: Any) {
        joinCallback?()
    }
    
    @IBAction private func buttonCancelTapped(_ sender: Any) {
        cancelCallback?()
    }
    
    @IBAction private func moreTapped(_ sender: Any) {
        onMore?()
    }
    
}
