//
//  LoungeParticipantsCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 19/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeParticipantsCVC: UICollectionViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelHost: UILabel!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    var callbackMic: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //labelName.isHidden = true
    }
    
    @IBAction func butttonMicTapped(_ sender: Any) {
        callbackMic?()
    }
    
}
