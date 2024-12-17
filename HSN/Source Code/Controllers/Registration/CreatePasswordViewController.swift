//
//  CreatePasswordViewController.swift
//  HSN
//
//  Created by Kartikeya on 09/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    @IBOutlet weak var textFieldNewPass: UITextField!
    @IBOutlet weak var textFieldConfirmPass: UITextField!
    @IBOutlet weak var btnEyeNewPass: UIButton!
    @IBOutlet weak var btnEyeReEnterPass: UIButton!
    
    
    var emailNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEyeNewPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyeNewPass.isSelected{self.textFieldNewPass.isSecureTextEntry = false}
            else{self.textFieldNewPass.isSecureTextEntry = true}
    }
    @IBAction func btnEyeReEnterPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyeReEnterPass.isSelected{self.textFieldConfirmPass.isSecureTextEntry = false}
            else{self.textFieldConfirmPass.isSecureTextEntry = true}
    }
    
    @IBAction func buttonCrossTapped(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonDoneTapped(_ sender:UIButton){
        resetPassApi()
       
    }

                          

}
extension CreatePasswordViewController{
    func resetPassApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.emailNumber:UserData.shared.mobile_number.isEmpty ? UserData.shared.email : UserData.shared.mobile_number,
            ApiParameters.kpassword:textFieldNewPass.text ?? "",
                                   ApiParameters.kConfirmPassword:textFieldConfirmPass.text ?? "",
                                   ApiParameters.kcountryCode:UserData.shared.country_code,
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.update_password,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    //UserData.shared.saveData(data: data)
                    guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                            self.navigationController?.pushViewController(nextvc, animated: true)
                    
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
