//
//  SettingsHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 22/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SettingsHeaderView: UIView {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    func updateData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            self.viewHeader.setGradientSettingsBackground()
        })
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
//        globalApis.getProfile(id: UserData.shared.id, completion: { data in
//            self.data  = data
//            self.imageProfile.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
//            self.labelName.text = UserData.shared.first_name.capitalized + " " + UserData.shared.last_name.capitalized
//            self.labelAddress.text = UserData.shared.location.isEmpty ? "Unknown Location" : UserData.shared.location
//        })
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func buttonViewProfileTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
        vc.hasCameFrom = .editProfile
//        vc.data = data
//
//        self.navigationController?.pushViewController(vc, animated: true)
       
    }

}
