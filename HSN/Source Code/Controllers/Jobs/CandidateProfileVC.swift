//
//  CandidateProfileVC.swift
//  HSN
//
//  Created by Apple on 06/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class CandidateProfileVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
       //     tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblResumeTitle: UILabel!
    
    var data:UserProfileModel?
    var userID = ""
    var candidate : CandidateDetailsModel?
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .leastNormalMagnitude
        } else {
            // Fallback on earlier versions
        }
        getProfile()

        //titleView.maskingCorner([.topLeft,.topRight], radius: 8.0)
        updateDate()
        // Do any additional setup after loading the view.
    }
    
    func updateDate() {
        self.tableView.estimatedSectionHeaderHeight = 0.1;
        
        if let obj = self.candidate {
            self.lblResumeTitle.text = obj.resume_doc
            lblName.text = obj.user?.full_name
            profileImage.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.user?.profile_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            lblDescription.text = "testing"
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func messageAction(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
        vc.receiverid = String.getString(self.candidate?.user?.id)
        vc.receivername = String.getString(self.candidate?.user?.full_name)
        vc.receiverprofile_image = kBucketUrl+String.getString(self.candidate?.user?.profile_pic)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func resumeAction(_ sender: Any) {
        
        guard let url = URL(string: "\(kBucketUrl)\(self.candidate?.resume_doc ?? "")")
        else { return }
        UIApplication.shared.open(url)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CandidateProfileVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.user_education.count == 0 ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return section == 0 ? 0 : (section == 1 ? (data?.user_company_experience.count ?? 0) : (data?.user_education.count ?? 0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CandidateProfileEduCell.identifier, for: indexPath) as! CandidateProfileEduCell
        switch indexPath.section {
        case 1:
            cell.experience = data?.user_company_experience[indexPath.row]
        case 2:
            cell.education = data?.user_education[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let vc = UIStoryboard(name: Storyboards.kJobs, bundle: nil).instantiateViewController(withIdentifier: ViewJobVC.getStoryboardID()) as? ViewJobVC else { return }
//        vc.jobId = self.data[indexPath.row].id
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return self.headerView
        }
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: CandidateHeaderCell.identifier) as? CandidateHeaderCell
        headerView?.lblTitle.text = section == 1 ? "Experience" : "Education"
        return headerView
    }
////
//   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//////        if section == 0 {
//////            return self.headerView
//////        }
//        let headerView = UIView(frame: CGRect(x: 25, y: 0, width: self.view.frame.width - 50 , height: 70))
//        let labelTitle = UILabel.init(frame: CGRect(x: 25, y: 0, width: self.view.frame.width, height: 50))
//        headerView.backgroundColor = UIColor.red//init(hexString: "#F5F7F9")
//        labelTitle.backgroundColor = UIColor.init(hexString: "#F5F7F9")
//        labelTitle.font = UIFont(name: "SFProDisplay-Bold", size: 14)
//        labelTitle.text = section == 1 ? "Experience" : "Education"
//        labelTitle.textColor = UIColor.init(hexString: "#4276C2")
//        headerView.addSubview(labelTitle)
//        return headerView
//   }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0  ? UITableView.automaticDimension : 50
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }

}

//MARK:- Get Candidate Profile
extension CandidateProfileVC {
    
    func getProfile(){
        globalApis.getProfile(id: userID, isSelf: true, completion: {
            profile in
            self.data = profile
            self.lblDescription.text = profile.headline
            self.tableView.reloadData()
           
        })
    }

    
}
