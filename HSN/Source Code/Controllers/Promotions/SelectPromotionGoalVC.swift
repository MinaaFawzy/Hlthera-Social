//
//  SelectPromotionGoalVC.swift
//  HSN
//
//  Created by fluper on 05/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
var promotionData:[String:Any] = [ApiParameters.promotion_goal_type:"",
                                  ApiParameters.promotion_goal:"",
                                  ApiParameters.target_audience_type:"",
                                  ApiParameters.location:"",
                                  ApiParameters.interest:"",
                                  ApiParameters.gender:"",
                                  ApiParameters.age_group_to:"",
                                  ApiParameters.age_group_from:"",
                                  ApiParameters.price:"",
                                  ApiParameters.duration:"",
                                  ApiParameters.audience_reach:"",
                                  ApiParameters.tax:"",
                                  ApiParameters.total_amount:"",
                                  ApiParameters.post_id:"",
                                  ApiParameters.tran_ref:"",
                                  ApiParameters.cart_id:""]
class SelectPromotionGoalVC: UIViewController {
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var viewUrl: UIView!
    @IBOutlet var buttonsGoalType: [UIButton]!
    @IBOutlet weak var textFieldWebsiteURL: UITextField!
    @IBOutlet weak var viewUsername: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewUrl.isHidden = true
        self.viewUsername.isHidden = true
        self.labelUsername.text = UserData.shared.username.isEmpty ? "@username" : "@" + UserData.shared.username
        // Do any additional setup after loading the view.
    }
    func validateFields(){
        if buttonsGoalType.filter({$0.isSelected}).isEmpty{
            CommonUtils.showToast(message: "Please select goal type")
            return
        }
         if buttonsGoalType[1].isSelected && String.getString(textFieldWebsiteURL.text).isEmpty{
            CommonUtils.showToast(message: "Please enter URL")
            return
        }
        if buttonsGoalType[1].isSelected && !String.getString(textFieldWebsiteURL.text).isEmpty && !String.getString(textFieldWebsiteURL.text).isURL(){
            CommonUtils.showToast(message: "Please enter valid URL")
            return
        }
        if let vc = self.parent{
            if let pvc = vc as? PageViewController{
                pvc.changeViewController(index: 1, direction: .forward)
                if let parentOfPVC = pvc.parent{
                    if let ppvc = parentOfPVC as? CreatePromotionPostVC{
                        ppvc.selectScreen(index: 1)
                    }
                }
            }
        }
    }
    func selectButton(index:Int){
        self.buttonsGoalType.forEach{
            $0.isSelected = false
        }
        self.buttonsGoalType[index].isSelected = true
        promotionData[ApiParameters.promotion_goal_type] = index + 1
        if index == 1{
            promotionData[ApiParameters.promotion_goal] = String.getString(textFieldWebsiteURL.text)
        }
        else{
            promotionData[ApiParameters.promotion_goal] = ""
        }
    }
    
    @IBAction func buttonSelectionTapped(_ sender: UIButton) {
        selectButton(index: sender.tag)
        switch sender.tag{
        case 0:
            viewUrl.isHidden = true
            viewUsername.isHidden = false
            
        case 1:
            viewUrl.isHidden = false
            viewUsername.isHidden = true
        case 2:
            viewUrl.isHidden = true
            viewUsername.isHidden = true
        default:break
        }
    }
    @IBAction func buttonNextTapped(_ sender: Any) {
      validateFields()
      
        
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
