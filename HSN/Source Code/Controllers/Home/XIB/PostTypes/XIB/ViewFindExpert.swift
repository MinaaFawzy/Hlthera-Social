//
//  ViewFindExpert.swift
//  HSN
//
//  Created by Prashant Panchal on 04/01/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ViewFindExpert: UIView {
  
    @IBOutlet weak var labelFindExpertHeading: UILabel!
    @IBOutlet weak var labelFindExpertLocation: UILabel!
    @IBOutlet weak var labelFindExpertType: UILabel!
    
    
    
    
    func initialSetup(isShared:Bool,data:HomeFeedModel,vc:UIViewController){
        if isShared{
            self.labelFindExpertHeading.text = data.share_post?.question
            self.labelFindExpertLocation.text = String.getString(data.share_post?.city_name) + ", " + String.getString(data.share_post?.state_name) + ", " + String.getString(data.share_post?.country_name)
            self.labelFindExpertType.text = "Recommendation Needed"
        }
        else{
            self.labelFindExpertHeading.text = data.question
            self.labelFindExpertLocation.text = data.city_name + ", " + data.state_name + ", " + data.country_name
            self.labelFindExpertType.text = "Recommendation Needed"
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
