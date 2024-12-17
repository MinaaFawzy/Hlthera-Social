//
//  NameVC.swift
//  HSN
//
//  Created by Kartikeya on 09/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class NameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var imageCheck: UIImageView!
    
    var email = ""
    var phone = ""
    var password = ""
    var countryCode = ""
    var fullName = ""
    var gender = ""
    var DOB = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        textFieldUsername.delegate = self
        imageCheck.isHidden = true
        
    }
    
        
}

//MARK: - IBActions
extension NameVC {
    
    @IBAction private func buttonCrossTapped(_ sender:UIButton){
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
        kSharedAppDelegate?.moveToHomeScreen()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonNextTapped(_ sender:UIButton){
        if String.getString(textFieldUsername.text).isEmpty {
            CommonUtils.showToast(message: "Please enter Username")
            return
        }
        
        if imageCheck.isHidden {
            CommonUtils.showToast(message: "Please enter different Username")
            return
        }
        signUpApi()
    }

}
extension NameVC {
    
    func signUpApi() {
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String:Any] = [
            ApiParameters.kfullName: fullName,
            ApiParameters.kcountryCode: countryCode,
//            ApiParameters.kdeviceToken: kSharedUserDefaults.getDeviceToken(),
            ApiParameters.kdeviceToken: "1",
            ApiParameters.kdevice_type: "2",
            ApiParameters.kPassword: password,
            ApiParameters.username: String.getString(textFieldUsername.text),
            ApiParameters.kMobileNumber: phone ,
            ApiParameters.klogin_type: "2",
            ApiParameters.kemail: email,
            ApiParameters.kdob: DOB,
           ApiParameters.kGender: gender
        ]
        
//        if emailPhone.isEmail() {
//        } else {
//            params[ApiParameters.klogin_type] = "1"
//            params[ApiParameters.kMobileNumber] = emailPhone
//        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.signup,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getDictionary(dictResult["user_data"])
                    UserData.shared.saveData(data: data)
                    let alert = UIAlertController(title: "Signed Up Successfully!", message: nil, preferredStyle: .alert)
                    let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel) { [weak self] _ in
                        guard let self = self else { return }
//                        guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: AccountTypeVC.getStoryboardID()) as? AccountTypeVC else { return }
//                        self.navigationController?.pushViewController(nextvc, animated: true)
                        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as? OtpViewController else { return }
                        nextVC.subHeading =  "\(self.countryCode)" + "\(self.phone)"
                        nextVC.id = UserData.shared.id
                        nextVC.hasCameFrom = .signUp
                        nextVC.mobileNumber = self.phone
                        self.navigationController?.pushViewController(nextVC, animated: true)
//                        guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "OtpViewController") as? OtpViewController else { return }
//                        nextvc.subHeading = self.emailPhone
//                        nextvc.id = String.getString(data["id"])
//                        nextvc.hasCameFrom = .signUp
//                        nextvc.mobileNumber = self.textFieldMobileNumber.text ?? ""
//                        self.navigationController?.pushViewController(nextvc, animated: true)
                    }
                    alert.addAction(action1)
                    UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
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
    
    func checkUsername(text: String, completion: @escaping ((Bool) -> ())) {
//        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [ApiParameters.kusername: String.getString(textFieldUsername.text)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.checkUserName,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
//            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = String.getString(dictResult["message"]).lowercased() == "no" ? true : false
                    self.imageCheck.image = data ?  UIImage.init(named: "username_check_mark") : UIImage.init(named: "close_red")
                    completion(data)
                    
                    
                default:
                    let data = String.getString(dictResult["message"]).lowercased() == "no" ? true : false
                    self.imageCheck.image = data ?  UIImage.init(named: "username_check_mark") : UIImage.init(named: "close_red")
//                    showAlertMessage.alert(message: "User Name already exists")
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}

extension NameVC {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == textFieldUsername && !textFieldUsername.text!.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.checkUsername(text: textField.text ?? "", completion: { [weak self] status in
                    guard let self = self else { return }
                    self.imageCheck.isHidden = false
                })
            })
        }
    }
}

extension String {
    func validateName() ->Bool {
        let passwordRegix = "[A-Za-z ]{2,30}"
        let passwordText  = NSPredicate(format:"SELF MATCHES %@",passwordRegix)
        return passwordText.evaluate(with:self)
    }
}
