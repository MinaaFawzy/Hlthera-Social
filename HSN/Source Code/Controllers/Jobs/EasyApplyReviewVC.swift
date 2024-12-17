//
//  EasyApplyReviewVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class EasyApplyReviewVC: UIViewController {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet weak var labelFileName: UILabel!
    @IBOutlet weak var imageCountryCode: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.labelName.text = UserData.shared.full_name
        self.labelProfession.text = UserData.shared.employee_type
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl+UserData.shared.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        self.textFieldEmail.text = String.getString(applyJobData[ApiParameters.kemail])
        self.textFieldPhone.text = String.getString(applyJobData[ApiParameters.kMobileNumber])
        self.buttonCountryCode.setTitle(String.getString(applyJobData[ApiParameters.kcountryCode]), for: .normal)
        self.labelFileName.text = String.getString(applyJobData[ApiParameters.resume_doc])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        globalApis.applyJob(data: applyJobData, completion: {
            self.moveToPopUp(text: "Job applied successfully!", completion: {
                kSharedAppDelegate?.moveToHomeScreen()
            })
        })
    }
    
}
