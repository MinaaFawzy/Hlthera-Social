//
//  CandidateProfileEduCell.swift
//  HSN
//
//  Created by Apple on 06/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class CandidateProfileEduCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var experience : ExperienceModel? {
        didSet{
            lblTitle.text = experience?.title
            lblDescription.text = experience?.company_name.capitalized
//            cell.labelProfession.text = obj.employement_type.capitalized
//            cell.labelTotalExperience.text = obj.total_experience.isEmpty ? "Unknown" : obj.total_experience
            lblTime.text = String.getString(experience?.start_date) + " - " + String.getString(experience?.end_date)
        }
    }
    
    var education : EducationModel? {
        didSet{
            lblTitle.text = education?.degree.capitalized
            lblDescription.text = education?.school_name.capitalized
            lblTime.text = String.getString(education?.start_date) + " - " + String.getString(education?.end_date)
        }
    }
    
//    cell.labelTitle.text = obj.degree.capitalized
//    cell.labelLocatino.text = obj.school_name.capitalized
//    cell.labelProfession.text = obj.field_of_study.capitalized
//    cell.labelDate.text = obj.start_date + " - " + obj.end_date

}

class CandidateHeaderCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
