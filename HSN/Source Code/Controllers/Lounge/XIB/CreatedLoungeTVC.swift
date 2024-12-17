//
//  CreatedLoungeTVC.swift
//  HSN
//
//  Created by Mina on 19/09/2023.
//  Copyright © 2023 Kartikeya. All rights reserved.
//

import UIKit

class CreatedLoungeTVC: UITableViewCell {

    //MARK: - @IBOutlets
    @IBOutlet var imagesUser:[UIImageView]!
    @IBOutlet var otherImagesUser:[UIImageView]!
    @IBOutlet weak var LoungeNameLabel: UILabel!
    @IBOutlet weak var LoungeDescriptionLabel: UILabel!
    @IBOutlet weak var LoungeOwnerNameLabel: UILabel!
    @IBOutlet weak var LoungeMembersCountLabel: UILabel!
    @IBOutlet weak var interestedpeopleLable: UILabel!
    @IBOutlet weak var LoungeViewsLabel: UILabel!
    @IBOutlet weak var AnonymouseLoungeImage: UIImageView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var backgroundLoungeView: UIView!
    @IBOutlet weak var remineImageCountLabel: UILabel!
    
    @IBOutlet weak var otherImagesStack: UIStackView!
    @IBOutlet weak var usersImagesStackView: UIStackView!
    var callBackJoin: (()->())?
    var callBackNotification: ((UIButton)->())?
    var callBackShare: (()->())?
   
    override func awakeFromNib() {
        super.awakeFromNib()
//        backgroundLoungeView.setGradientBackgroundForCreatedCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - @IBACtion
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
        callBackNotification?(sender)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
            callBackShare?()
    }
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        callBackJoin?()
    }
}
