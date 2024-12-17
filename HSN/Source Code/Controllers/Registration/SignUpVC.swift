//
//  SignUpViewController.swift
//  Hlthera
//
//  Created by Akash on 26/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import DropDown

class SignUpVC: UIViewController, UITextFieldDelegate {
  
    //MARK: - IBOutlet
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var switchTerms: UISwitch!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet var passwordTF:UITextField!
    @IBOutlet weak var btnEyePass: UIButton!
    @IBOutlet weak var imageCountryCode: UIImageView!
    @IBOutlet weak var constraintViewDividerWidth: NSLayoutConstraint!
    @IBOutlet weak var btnCountryCodeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintTextFieldLeading: NSLayoutConstraint!
    
    
    //MARK: - VARIABLES
    var languageId = "1"
    var dropDown = DropDown()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - Functions
    private func initialSetup(){
       // switchRemember.transform = CGAffineTransform(scaleX:0.65, y: 0.65)
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.layer.cornerRadius = 30
//        imageCountryCode.isHidden = true
//        self.buttonCountryCode.isHidden = true
//         btnCountryCodeWidthConstraint.constant = 0
        constraintViewDividerWidth.constant = 0
        constraintTextFieldLeading.constant = -1.5
        switchTerms.transform = CGAffineTransform(scaleX: 0.70, y: 0.65)
//        buttonCountryCode.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        phoneTF.delegate = self
        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
       
//        emailPhoneTF.placeholder(text: "Enter Email", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
//        passwordTF.placeholder(text: "Enter Password", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))

        if UIScreen.main.bounds.height > 800{
           // ScrollView.isScrollEnabled = false
        }
        else {
           // ScrollView.isScrollEnabled = true
        }
        //insuranceCompanyApi()
//        confirmPasswordTF.isSecureTextEntry = false
//        passwordTF.isSecureTextEntry = false
     

        //country code picker
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                   let dialCode = kSharedInstance.getCountryCallingCode(countryRegionCode: countryCode)
                   buttonCountryCode.setTitle("+971", for: .normal)
                   print(String.getString(Locale.current.regionCode))
               }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordTF.textContentType = .none
    }
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        if !String.getString(textField.text).isNumberContains(){
//            self.buttonCountryCode.isHidden = true
//             btnCountryCodeWidthConstraint.constant = 0
//            constraintViewDividerWidth.constant = 0
//            constraintTextFieldLeading.constant = -1.5
//           // imageEmail.isHidden = false
//            imageCountryCode.isHidden = true
//
//        }else {
//          //  imageEmail.isHidden = true
//            imageCountryCode.isHidden = false
//            self.buttonCountryCode.isHidden = false
//            constraintViewDividerWidth.constant = 2
//            constraintTextFieldLeading.constant = 10
//            btnCountryCodeWidthConstraint.constant = 70
//
//        }
//    }
    
    //MARK: - Actions
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCountryCodeTapped(_ sender: UIButton) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
            
        }
        
    }
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        if String.getString(self.emailTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEnterEmail)
            return
        }  else if String.getString(self.phoneTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEnterMobile)
            return
        } else if String.getString(self.passwordTF.text).isEmpty{
            showAlertMessage.alert(message: Notifications.kEnterPassword)
            return
        } else if String.getString(self.passwordTF.text).count < 8{
            showAlertMessage.alert(message: Notifications.kPasswordRange)
            return
        } else if !switchTerms.isOn{
            showAlertMessage.alert(message: Notifications.kAcceptCond)
            return
        }
//        else if !String.getString(emailPhoneTF.text).isNumber() && !String.getString(emailPhoneTF.text).isEmail() {
//            showAlertMessage.alert(message: Notifications.kEnterValidMobileNumber)
//        }else if String.getString(emailPhoneTF.text).isEmail() && !String.getString(emailPhoneTF.text).isNumber() {
//            showAlertMessage.alert(message: Notifications.kEnterValidEmailId)
//        }
       // self.validationField()
        
       signUpApi()
     
        
    }
    @IBAction func btnEyeEnterPassTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEyePass.isSelected{self.passwordTF.isSecureTextEntry = false}
        else{self.passwordTF.isSecureTextEntry = true}
    }
    
    @IBAction func switchRememberTapped(_ sender: UISwitch) {
        sender.isOn = !sender.isOn
    }
    @IBAction func switchTermsTapped(_ sender: UISwitch) {
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: WorkViewController.getStoryboardID()) as? WorkViewController else {return}
//        self.navigationController?.pushViewController(nextVc, animated: true)
        guard let nextVc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
        nextVc.pageTitleString = "Company Terms & Conditions"
        nextVc.url = kBASEURL + "privacy_policy"
//        nextVc.url = kBASEURL + "company_term_condition"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
   
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kLoginVc) as? LoginVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}
//MARK:-signUpApi
extension SignUpVC {
    func signUpApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [
//if signup with email or phone
//            ApiParameters.kMobileNumber: String.getString(emailPhoneTF.text).isEmail() ? "" :                          String.getString(emailPhoneTF.text),
//            ApiParameters.kemail:String.getString(emailPhoneTF.text).isEmail() ? String.getString(emailPhoneTF.text) : "",
//            ApiParameters.klogin_type:String.getString(emailPhoneTF.text).isEmail() ? "2" : "1",
            ApiParameters.kMobileNumber: String.getString(phoneTF.text),
            ApiParameters.kemail : String.getString(emailTF.text),
            ApiParameters.klogin_type : "2"
        ]

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.check_mobile_email_exists,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?)  in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:

                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(data[kAccessToken]))
                    kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                    //UserData.shared.saveData(data: data)
                    guard let nextVc = self.storyboard?.instantiateViewController(identifier: WelcomePageVC.getStoryboardID()) as? WelcomePageVC else {return}
                    nextVc.email = String.getString(self.emailTF.text)
                    nextVc.password = String.getString(self.passwordTF.text)
                    nextVc.countryCode = String.getString(self.buttonCountryCode.titleLabel?.text)
                    nextVc.phone = String.getString(self.phoneTF.text)
                    self.navigationController?.pushViewController(nextVc, animated: true)

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

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}
extension UIView{
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
       let gradient = CAGradientLayer()
       gradient.frame = frame
       gradient.colors = colors.map{$0.cgColor}
       self.layer.addSublayer(gradient)
      }
}
