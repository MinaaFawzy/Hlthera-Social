//
//  ExperienceTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 20/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ExperienceTVC: UITableViewCell {

    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: OwnTableView!
    var hasCameFrom:HasCameFrom = .viewProfile
    var type:profileData = .experience
    var refreshCallback:(()->())?
    var parentVC:UINavigationController?
    var experienceData:[ExperienceModel] = [] {
        didSet{
            self.tableView.reloadData()
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            experienceData.isEmpty ? (self.constraintTableViewHeight.constant = 0) : (self.constraintTableViewHeight.constant = CGFloat(95 * self.experienceData.count))
           // })
            //
            
           
        }
    }
    var educationData:[EducationModel] = []  {
        didSet{
            self.tableView.reloadData()
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            educationData.isEmpty ? (self.constraintTableViewHeight.constant = 0) : (self.constraintTableViewHeight.constant = CGFloat(95 * self.educationData.count))
           // })
            //
            
           
        }
    }
    var certificateData:[CertificateModel] = []  {
        didSet{
            self.tableView.reloadData()
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            certificateData.isEmpty ? (self.constraintTableViewHeight.constant = 0) : (self.constraintTableViewHeight.constant = CGFloat(95 * self.certificateData.count))
           // })
            //
            
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: EducationExperienceTVC.identifier, bundle: nil), forCellReuseIdentifier: EducationExperienceTVC.identifier)
        tableView.register(UINib(nibName: ExperienceDataTVC.identifier, bundle: nil), forCellReuseIdentifier: ExperienceDataTVC.identifier)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(data:[ExperienceModel],_ cameFrom:HasCameFrom = .viewProfile,parentVC:UINavigationController,type:profileData){
        self.experienceData = data
        self.hasCameFrom = cameFrom
        self.parentVC = parentVC
        self.type = type
    }
    func updateCell(data:[EducationModel],_ cameFrom:HasCameFrom = .viewProfile,parentVC:UINavigationController,type:profileData){
        self.educationData = data
        self.hasCameFrom = cameFrom
        self.parentVC = parentVC
        self.type = type
    }
    func updateCell(data:[CertificateModel],_ cameFrom:HasCameFrom = .viewProfile,parentVC:UINavigationController,type:profileData){
        self.certificateData = data
        self.hasCameFrom = cameFrom
        self.parentVC = parentVC
        self.type = type
    }
}
extension ExperienceTVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type{
        case .experience:
            return experienceData.count
        case .education:
            return educationData.count
        case .certificate:
            return certificateData.count
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch type{
        case .experience:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExperienceDataTVC.identifier, for: indexPath) as! ExperienceDataTVC
            hasCameFrom == .editProfile ? (cell.buttonEdit.isHidden = false) : (cell.buttonEdit.isHidden = true)
            if experienceData.indices.contains(indexPath.row){
                let obj = experienceData[indexPath.row]
                cell.labelTitle.text = obj.title
                cell.labelLocatino.text = obj.company_name.capitalized
                //" " + obj.location.capitalized
                cell.labelProfession.text = obj.employement_type.capitalized
                cell.labelTotalExperience.text = obj.total_experience.isEmpty ? "Unknown" : obj.total_experience
                cell.labelDate.text = obj.start_date + " - " + obj.end_date
                cell.imageCompany.downlodeImage(serviceurl: "", placeHolder: #imageLiteral(resourceName: "no_profile_image"))
                cell.editCallback = {
                    guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "WorkViewController") as? WorkViewController else { return }
                    nextvc.hasCameFrom = .updateProfile
                    nextvc.updateId = obj.id
                    nextvc.updateData = obj
                    self.parentVC?.pushViewController(nextvc, animated: true)
                }
            }
            return cell
        case .education:
            let cell = tableView.dequeueReusableCell(withIdentifier: EducationExperienceTVC.identifier, for: indexPath) as! EducationExperienceTVC
            hasCameFrom == .editProfile ? (cell.buttonEdit.isHidden = false) : (cell.buttonEdit.isHidden = true)
            if educationData.indices.contains(indexPath.row){
                let obj = educationData[indexPath.row]
                cell.labelTitle.text = obj.degree.capitalized
                cell.labelLocatino.text = obj.school_name.capitalized
                cell.labelProfession.text = obj.field_of_study.capitalized
                cell.labelDate.text = obj.start_date + " - " + obj.end_date
                cell.editCallback = {
                    guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "AddEditEducationVC") as? AddEditEducationVC else { return }
                    nextvc.hasCameFrom = .updateProfile
                    nextvc.updateId = obj.id
                    nextvc.data = obj
                    self.parentVC?.pushViewController(nextvc, animated: true)
                }
            }
            return cell
        case .certificate:
            let cell = tableView.dequeueReusableCell(withIdentifier: EducationExperienceTVC.identifier, for: indexPath) as! EducationExperienceTVC
            hasCameFrom == .editProfile ? (cell.buttonEdit.isHidden = false) : (cell.buttonEdit.isHidden = true)
            if certificateData.indices.contains(indexPath.row){
                let obj = certificateData[indexPath.row]
                cell.labelTitle.text = obj.certificate.capitalized
                cell.labelLocatino.text = obj.org_name.capitalized
                cell.labelProfession.text = obj.is_certificate_expire ?  "Certificate Expired" : "Certificate Active"
                cell.labelDate.text = obj.start_date + " - " + obj.end_date
                cell.editCallback = {
                    guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "AddEditCertificateVC") as? AddEditCertificateVC else { return }
                    nextvc.hasCameFrom = .updateProfile
                    nextvc.updateId = obj.id
                    nextvc.data = obj
                    self.parentVC?.pushViewController(nextvc, animated: true)
                }
            }
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                
                
                switch self.type{
                case .experience:
                    let obj = self.experienceData[indexPath.row]
                    globalApis.deleteProfileData(type: .experience, id: obj.id){
                        self.experienceData.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            CommonUtils.showToast(message: String.getString("Experience Deleted Successfully!"))
                        })
                    }
                case .education:
                    let obj = self.educationData[indexPath.row]
                    globalApis.deleteProfileData(type: .education, id: obj.id){
                        self.educationData.remove(at: indexPath.row)
                        self.tableView.reloadData()
                     
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            CommonUtils.showToast(message: String.getString("Education Deleted Successfully!"))
                        })
                    }
                case .certificate:
                    let obj = self.certificateData[indexPath.row]
                    globalApis.deleteProfileData(type: .certificate, id: obj.id){
                        self.certificateData.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            CommonUtils.showToast(message: String.getString("Certificate Deleted Successfully!"))
                        })
                    }
                }
                
             
               
                completionHandler(true)
            }
            deleteAction.image = #imageLiteral(resourceName: "bin")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
}
