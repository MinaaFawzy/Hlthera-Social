//
//  PageAboutView.swift
//  HSN
//
//  Created by user206889 on 11/24/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageAboutView: UIView {
    @IBOutlet weak var labelTotalFollowers: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelCall: UILabel!
    @IBOutlet weak var labelWebsite: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    
    private var hasCameFrom:HasCameFrom?
    var parentVC:UIViewController?
    private var pageData:CompanyPageModel?
   
   
  
    func initialSetup(_ hasCameFrom:HasCameFrom, userData:CompanyPageModel?, parentVC:UIViewController,selectedTab:Int = 0){
        self.pageData = userData
        self.parentVC = parentVC
        if let obj = userData{
            //self.labelGroupVisibility.text = obj.discoverability == "1" ? "Listed" : "Unlisted"
            //self.labelRules.text = obj.rules
            let date = parentVC.getDateFromCreatedAtString(dateString: String.getString(obj.created_at))
            let bookingDateFormatter = DateFormatter()
            bookingDateFormatter.timeStyle = .none
            bookingDateFormatter.dateStyle = .long
            bookingDateFormatter.dateFormat = "d/MM/yyyy HH:mm a"
           // self.labelCreatedOn.text = "\(bookingDateFormatter.string(from:date))"
            self.labelDescription.text = obj.description
            self.labelWebsite.text = obj.website_url
            self.labelType.text = obj.business_type
            self.labelTotalFollowers.text = obj.total_followers_count + " Followers"
            
            
        }
        
//        switch hasCameFrom{
//        case .viewPage:
//            self.buttonEdit.isHidden = true
//        case .viewPageAdmin:
//            self.buttonEdit.isHidden = false
//        case .editGroup:
//            self.buttonEdit.isHidden = false
//        default:break
//        }
    }

    
    
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
