//
//  PageLifeModuleTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 01/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVKit

class PageLifeModuleTVC: UITableViewCell {
    @IBOutlet weak var textFieldSubtitle: UITextField!
    @IBOutlet weak var switchVisibility: UISwitch!
    @IBOutlet weak var textViewContent: IQTextView!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var imageModuleMedia: UIImageView!
    @IBOutlet weak var buttonDeleteModuleMedia: UIButton!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var labelModuleHeading: UILabel!
    @IBOutlet weak var buttonDeleteModule: UIButton!
    var parent:UINavigationController?
    var moduleVideoURL:URL?
    var uploadCallback:(()->())?
    var deleteCallback:(()->())?
    var visibilityCallback:((Bool)->())?
    var deleteModuleCallback:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonUploadMainTapped(_ sender: Any) {
     uploadCallback?()
    }
    @IBAction func buttonDeleteTapped(_ sender: Any) {
       deleteCallback?()
    }
    @IBAction func buttonPlayTapped(_ sender: Any) {
        if let url = moduleVideoURL{
            let videoURL = url
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            parent?.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else{
            CommonUtils.showToast(message: "Video not uploaded")
            return
        }
    }
    @IBAction func switchVisibilityTapped(_ sender: UISwitch) {
        visibilityCallback?(sender.isOn)
    }
    @IBAction func buttonDeleteModuleTapped(_ sender: Any) {
        deleteModuleCallback?()
    }
    
}
