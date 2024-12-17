//
//  ViewJobHeader.swift
//  HSN
//
//  Created by Prashant Panchal on 23/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewJobHeader: UIView {
    @IBOutlet weak var imageJobLogo: UIImageView!
    @IBOutlet weak var labelJobTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelTotalFollowers: UILabel!
    @IBOutlet weak var labelPostedDate: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelTotalEmployees: UILabel!
    @IBOutlet weak var labelConnections: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonEasyApply: UIButton!
    @IBOutlet weak var buttonCandidate: UIButton!
    
    var callbackSave:(()->())?
    var callbackApply:(()->())?
    var callbackCandidates:(()->())?
    var parentVC:UIViewController = UIViewController()
    
    func initialSetup( userData:JobModel?, parentVC:UIViewController){
    
        self.parentVC = parentVC
        updateData(data: userData)
        
        imageJobLogo.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageJobLogo.contentMode = UIView.ContentMode.scaleAspectFill
        
    }

    func updateData(data:JobModel?){
        if let obj = data{
            self.buttonCandidate.isHidden = obj.user_id == UserData.shared.id ? false : true
            self.labelJobTitle.text = obj.job_title
            self.labelLocation.text = obj.location
            self.labelConnections.text = obj.facility
            self.labelPostedDate.text = obj.posted_date
            self.labelType.text = obj.employement_type
            self.labelTotalEmployees.text = String.getString(obj.company?.company_size) + " Employees"
            self.labelDescription.text = obj.job_description
            if obj.is_job_apply_by_currentuser{
                self.buttonEasyApply.isUserInteractionEnabled = false
                self.buttonEasyApply.setTitle("Applied", for: .normal)
            }
            else{
                self.buttonEasyApply.isUserInteractionEnabled = true
                if obj.apply_type == "1"{
                    self.buttonEasyApply.setTitle("Apply", for: .normal)
                }
                else{
                    self.buttonEasyApply.setTitle("Easy Apply", for: .normal)
                }
            }
            let date = Date(unixTimestamp: Double.getDouble(obj.posted_date))
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            labelPostedDate.text = formatter.localizedString(for: date, relativeTo: Date())
            self.imageJobLogo.downlodeImage(serviceurl: String.getString(kBucketUrl + String.getString(obj.company?.profile_pic)), placeHolder: UIImage(named: "profile_placeholder"))
//            self.labelGroupName.text = obj.name
//            self.labelDescription.text = obj.about
//            self.buttonTotalMembers.setTitle(String.getString(obj.total_group_members_count) + " Members", for: .normal)
//                self.labelTotalMembersCount.text = "+" + String.getString(obj.total_group_members_count)
//            self.labelMembersNames.text = "Temp"
//
//            self.imageGroupIcon.kf.setImage(with: URL(string: kBucketUrl + obj.group_pic),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
//            self.imageCover.kf.setImage(with: URL(string: kBucketUrl + obj.cover_pic),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"))
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        callbackSave?()
    }
    @IBAction func buttonApplyTapped(_ sender: Any) {
        callbackApply?()
    }
    @IBAction func buttonCandidatesTapped(_ sender: Any) {
        callbackCandidates?()
    }
    
}
