//
//  GroupAboutHeader.swift
//  HSN
//
//  Created by Prashant Panchal on 15/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class GroupAboutHeader: UIView {

    @IBOutlet weak var labelGroupVisibility: UILabel!
    @IBOutlet weak var labelCreatedOn: UILabel!
    @IBOutlet weak var labelAboutGroup: UILabel!
    @IBOutlet weak var labelRules: UILabel!
    @IBOutlet weak var labelOverviewSubLableHeading: UILabel!
    @IBOutlet weak var labelAboutHeading: UILabel!
    @IBOutlet weak var labelAboutIndustryHeading: UILabel!
    @IBOutlet weak var viewPageDetails: UIView!
    @IBOutlet weak var viewGroupDetails: UIView!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelPageIndustry: UILabel!
    @IBOutlet weak var labelPageBusinessType: UILabel!
    @IBOutlet weak var labelPageCompanySize: UILabel!
    @IBOutlet weak var labelUrl: UILabel!
    
    private var hasCameFrom:HasCameFrom?
    var parentVC:UIViewController?
     private var data:HSNGroupModel?
    private var pageData:CompanyPageModel?
   
    class func viewInstance()->GroupAboutHeader{
        let view = UINib(nibName: "GroupAboutHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GroupAboutHeader
        return view
    }
    func initialSetup(_ hasCameFrom:HasCameFrom, userData:HSNGroupModel?, parentVC:ViewGroupVC,selectedTab:Int = 0){
        self.data = userData
        self.parentVC = parentVC
        if let obj = userData{
            self.labelGroupVisibility.text = obj.discoverability == "1" ? "Listed" : "Unlisted"
            self.labelRules.text = obj.rules
            let date = parentVC.getDateFromCreatedAtString(dateString: String.getString(obj.created_at))
            let bookingDateFormatter = DateFormatter()
            bookingDateFormatter.timeStyle = .none
            bookingDateFormatter.dateStyle = .long
            bookingDateFormatter.dateFormat = "d/MM/yyyy HH:mm a"
            self.labelCreatedOn.text = "\(bookingDateFormatter.string(from:date))"
            self.labelAboutGroup.text = obj.about
            self.viewGroupDetails.isHidden = false
            self.viewPageDetails.isHidden = true
            
            
        }
        
//        switch hasCameFrom{
//        case .viewGroup:
//            self.buttonEdit.isHidden = true
//        case .viewGroupAdmin:
//            self.buttonEdit.isHidden = false
//        case .editGroup:
//            self.buttonEdit.isHidden = false
//        default:break
//        }
    }
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
            self.labelCreatedOn.text = "\(bookingDateFormatter.string(from:date))"
            self.labelAboutGroup.text = obj.description
            self.labelLocation.text = obj.location.joined(separator: ",")
            self.labelPageIndustry.text = obj.industry
            self.labelPageBusinessType.text = obj.business_type
            self.labelPageCompanySize.text = obj.company_size
            self.labelUrl.text = obj.website_url
            self.viewPageDetails.isHidden = false
            self.viewGroupDetails.isHidden = true
            self.labelOverviewSubLableHeading.text = "Page Owner"
            self.labelGroupVisibility.text = obj.user?.full_name
            self.labelAboutHeading.text = "About Page"
            
            
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
extension UIViewController{
    func getDateFromCreatedAtString(dateString:String)->Date{

        
        let dateFormatter = DateFormatter()
        //2021-01-19 021-01-19 13:10:42
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
        let date = dateFormatter.date(from:dateString) ?? Date()
        return date
    }
    
    func getDateFromTimestamp(dateString:String)->Date{
        
        let time = TimeInterval(Int(dateString) ?? 0) / 1000
        let date = Date(timeIntervalSince1970: time)
    
        return date
    }
}
