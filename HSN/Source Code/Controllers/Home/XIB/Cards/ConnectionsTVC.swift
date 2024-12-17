//
//  ConnectionsTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ConnectionsTVC: UITableViewCell {
    var deleteCallback:(()->())?
    var moreCallback:(()->())?
    var sendMessageCallback:(()->())?
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var labelConnectionTime: UILabel!
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var constraintRemoveConnectionHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonMore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(data obj:InvitationsModel){
    if let user = obj.user{
        self.labelName.text = String.getString(obj.user?.full_name).capitalized
        self.labelProfession.text = user.employee_type.capitalized.isEmpty ? "Unknown" : user.employee_type.capitalized
        
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl + user.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        self.buttonMore.isHidden = true
        self.labelConnectionTime.text = "Connected " + formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.connection_on)), relativeTo: Date())
    }
        
    }
    func updateCell(data obj:GroupUserModel){

        self.buttonMore.isHidden = false
        self.labelName.text = String.getString(obj.full_name).capitalized
        self.labelProfession.text = "Unknown"
        
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        self.constraintRemoveConnectionHeight.constant = 0
       // self.labelConnectionTime.text = "Connected " + formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.first_name)), relativeTo: Date())
    
        
    }
    func updateCell(data obj:CompanyPageModel){

        self.buttonMore.isHidden = false
        self.labelName.text = String.getString(obj.page_name).capitalized
        self.labelProfession.text = obj.business_name
        
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        self.constraintRemoveConnectionHeight.constant = 0
       // self.labelConnectionTime.text = "Connected " + formatter.localizedString(for: Date(unixTimestamp: Double.getDouble(obj.first_name)), relativeTo: Date())
    
        
    }
    

    @IBAction func buttonSendMessageTapped(_ sender: Any) {
        sendMessageCallback?()
    }
    @IBAction func buttonRemoveTapped(_ sender: Any) {
        deleteCallback?()
    }
    @IBAction func buttonMoreTapped(_ sender: Any) {
        moreCallback?()
    }
    
    
}
