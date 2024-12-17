//
//  HappeningNowCollectionViewCell.swift
//  HSN
//
//  Created by Mukul Dixit on 12/05/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class HappeningNowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var buttonNotifications: UIButton!
    @IBOutlet weak var labelDiscription: UILabel!
    @IBOutlet weak var labelUserCount: UILabel!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var labelCreative: UILabel!
    @IBOutlet weak var labelRemainProfile: UILabel!
    @IBOutlet weak var imageProfileFourth: UIImageView!
    @IBOutlet weak var imageProfileThird: UIImageView!
    @IBOutlet weak var imageProfileSecond: UIImageView!
    @IBOutlet weak var imageProfileFirst: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet var imagesUser: [UIImageView]!
    @IBOutlet weak var labelSponsored: UILabel!
    
    var callbackNotifications: ((UIButton) -> ())?
    
    @IBAction func buttonNotifications(_ sender: UIButton) {
        callbackNotifications?(sender)
    }
    
}
