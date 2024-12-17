//
//  RateRecommendVC.swift
//  HSN
//
//  Created by Prashant Panchal on 20/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Cosmos
import IQKeyboardManagerSwift

class RateRecommendVC: UIViewController {
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProfession: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var constraintViewHeight: NSLayoutConstraint!
    var isRating = false
    var data:UserProfileModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        if isRating{
            viewRating.isHidden = false
            self.labelPageTitle.text = "Give a rate & review to " + String.getString(data?.first_name).capitalized
            textView.placeholder = "Write your review here...."
            constraintViewHeight.constant = 50
        }
        else{
            viewRating.isHidden = true
            self.labelPageTitle.text = "Write \(String.getString(data?.first_name.capitalized)) a recommendation"
            textView.placeholder = "Write your recommendation here...."
            constraintViewHeight.constant = 0
        }
        self.labelName.text = String.getString(data?.first_name.capitalized) + " " + String.getString(data?.last_name.capitalized)
        self.labelProfession.text = String.getString(data?.employee_type).isEmpty ? ("Unknown") : String.getString(data?.employee_type).capitalized
        self.imageProfile.downlodeImage(serviceurl: kBucketUrl + String.getString(data?.profile_pic), placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        if textView.text.isEmpty{
            CommonUtils.showToast(message: "Please Enter Text")
            return
        }
        rateRecommendUser(isRating: self.isRating)
    }

}
extension RateRecommendVC{
    func rateRecommendUser(isRating:Bool){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.user_id:String.getString(data?.id),ApiParameters.type:isRating ? "2" : "1",ApiParameters.description:String.getString(textView.text),ApiParameters.rating:viewRating.rating]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.recommand_rating,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["images"])
                    self.moveToPopUp(text: isRating ? "Rating saved successfully" : "Recommendation saved successfully", completion: {
                        globalApis.getProfile(id: String.getString(self.data?.id), completion: { profile in
                            for controller in self.navigationController?.viewControllers ?? []{
                                if controller.isKind(of: OtherUserProfileVC.self){
                                    let vc = controller as! OtherUserProfileVC
                                    vc.data = profile
                                    vc.id = profile.id
                                    vc.hasCameFrom = .viewProfile
                                    isRating ? (vc.selectedTab = 2) : (vc.selectedTab = 1)
                                    self.navigationController?.popToViewController(controller, animated: true)
                                    return
                                }
                            }
                            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                            vc.data = profile
                            vc.id = profile.id
                            vc.hasCameFrom = .viewProfile
                            isRating ? (vc.selectedTab = 2) : (vc.selectedTab = 1)
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        })
                    })
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}
