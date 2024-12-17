//
//  EasyApplyContactInfoVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
var applyJobData:[String:Any] = [:]
class EasyApplyContactInfoVC: UIViewController {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var textFieldEmailAddress: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageCountryCode: UIImageView!
    var data:JobModel = JobModel(data: [:])
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelName.text = UserData.shared.full_name
        self.labelProfession.text = UserData.shared.employee_type
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        applyJobData = [:]

        // Do any additional setup after loading the view.
    }
    
    func validateFields(){
        if String.getString(textFieldEmailAddress.text).isEmpty{
            CommonUtils.showToast(message: "Please enter email")
            return
        }
        if String.getString(textFieldPhone.text).isEmpty{
            CommonUtils.showToast(message: "Please enter phone")
            return
        }
        
        applyJobData[ApiParameters.company_id] = data.company_id
        applyJobData[ApiParameters.company_job_id] = data.id
        applyJobData[ApiParameters.kemail] = String.getString(self.textFieldEmailAddress.text)
        applyJobData[ApiParameters.kMobileNumber] = String.getString(self.textFieldPhone.text)
        applyJobData[ApiParameters.kcountryCode] = String.getString(self.buttonCountryCode.titleLabel?.text)
        if let vc = self.parent{
            if let pvc = vc as? PageViewControllerJobs{
                pvc.changeViewController(index: 1, direction: .forward)
                if let parentOfPVC = pvc.parent{
                    if let ppvc = parentOfPVC as? ApplyJobVC{
                        ppvc.selectScreen(index: 1)
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonCountryCodeTapped(_ sender: Any) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
        }
    }
    @IBAction func buttonNextTapped(_ sender: Any) {
        validateFields()
    }
    
}
