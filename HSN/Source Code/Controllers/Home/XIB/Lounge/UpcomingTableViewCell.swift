//
//  UpcomingTableViewCell.swift
//  HSN
//
//  Created by Mukul Dixit on 13/05/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var buttonNotification: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var labelDiscription: UILabel!
    @IBOutlet weak var viewMultipleImages: UIView!
    @IBOutlet var imagesUser:[UIImageView]!
    @IBOutlet weak var imageFirst: UIImageView!
    @IBOutlet weak var imageSecond: UIImageView!
    @IBOutlet weak var imageThird: UIImageView!
    @IBOutlet weak var imageFourth: UIImageView!
    @IBOutlet weak var labelRemainImages: UILabel!
    @IBOutlet weak var labelCreativity: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelViewers: UILabel!
    @IBOutlet weak var buttonJoin: UIButton!
    @IBOutlet weak var buttonSponsored: UIButton!
    @IBOutlet weak var viewIntrestedPeople: UIView!
    @IBOutlet weak var imageIntrestedPeopleFirst: UIImageView!
    @IBOutlet weak var imageIntrestedPeopleSecond: UIImageView!
    @IBOutlet weak var imageIntrestedPeopleThird: UIImageView!
    @IBOutlet weak var labelIntrestPeopleCount: UILabel!
    @IBOutlet weak var LabelPostViwersCount: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelSponsored: UILabel!
    var callbackJoin:(()->())?
    var callbackSponsored:(()->())?
    var callbackShare:(()->())?
    var callbackNotifications:((UIButton)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonNotifications(_ sender: UIButton) {
        callbackNotifications?(sender)
    }
    
    @IBAction func buttonShare(_ sender: UIButton) {
        callbackShare?()
    }
    
    @IBAction func buttonJoin(_ sender: UIButton) {
        callbackJoin?()
    }
    
    @IBAction func buttonSponsored(_ sender: UIButton) {
        callbackSponsored?()
    }
    
}
