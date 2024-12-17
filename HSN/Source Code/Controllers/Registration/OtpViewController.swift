//
//  OtpVerificationViewController.swift
//  Hlthera
//
//  Created by Akash on 26/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class OtpViewController: UIViewController, UITextFieldDelegate {
    //MARK:- @IBOutlets
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    @IBOutlet weak var viewThird: UIView!
    @IBOutlet weak var viewFourth: UIView!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var textFieldFirst: UITextField!
    @IBOutlet weak var textFieldSecond: UITextField!
    @IBOutlet weak var textFieldThird: UITextField!
    @IBOutlet weak var textFieldFourth: UITextField!
    //@IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    
    
    var hasCameFrom: HasCameFrom = .none
    var subHeading = "Please type the verification code sent to +919878767676"
    var seconds = 90 //timer for OTP
    var timer = Timer()
    var userName: String?
    var id = ""
    var mobileNumber: String = ""
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        sendOTP()
    }
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.initialSetup()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    //MARK:- Functions
    private func initialSetup() {
        //self.runTimer()
      //  btnResend.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6823529412, alpha: 1), for: .normal)
        btnResend.setTitleColor(#colorLiteral(red: 0.1215686275, green: 0.2470588235, blue: 0.4078431373, alpha: 1), for: .normal)
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        textFieldFirst.delegate = self
        textFieldSecond.delegate = self
        textFieldThird.delegate = self
        textFieldFourth.delegate = self
        viewFirst.drawShadow()
        viewSecond.drawShadow()
        viewThird.drawShadow()
        viewFourth.drawShadow()
        switch hasCameFrom {
        case .forgotPass,.signUp:
            self.lblSubHeading.text = "Please type the verification code sent to \(String.getString(subHeading))"
        default:
            break
        }
    }
    //MARK:- OTP TIMER
//    func runTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
//    }
    
//    @objc func updateTimer(){
//        self.seconds -= 1
//        if seconds >= 0{
//            btnResend.isUserInteractionEnabled = false
//            //btnResend.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6823529412, alpha: 1), for: .normal)
//            btnResend.setTitleColor(#colorLiteral(red: 0.1215686275, green: 0.2470588235, blue: 0.4078431373, alpha: 1), for: .normal)
//            if seconds < 10{
//                lblTimer.text = "00:0\(seconds)"
//            }else{
//                lblTimer.text = "00:\(seconds)"
//            }
//        }else{
//            btnResend.isUserInteractionEnabled = true
//            btnResend.setTitleColor(#colorLiteral(red: 0.1215686275, green: 0.2470588235, blue: 0.4078431373, alpha: 1), for: .normal)
//            timer.invalidate()
//        }
//    }
    func sumbitBtnTapped(hasCameFrom:HasCameFrom){
        
        switch hasCameFrom {
        case .login:
            let alert = UIAlertController(title: "Alert", message: "Coming Soon", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        //kSharedSceneDelegate?.moveToHomeScreen()
        case .forgotPass:
            guard let nextVc = self.storyboard?.instantiateViewController(identifier: CreatePasswordViewController.getStoryboardID()) as? CreatePasswordViewController else {return}
           
            
            self.navigationController?.pushViewController(nextVc, animated: true)
        case .signUp:
//            guard let nextVc = self.storyboard?.instantiateViewController(identifier: ThankyouPopUpViewController.getStoryboardID()) as? ThankyouPopUpViewController else {return}
//            nextVc.modalTransitionStyle = .crossDissolve
//            nextVc.modalPresentationStyle = .overFullScreen
//            nextVc.callback = {
////                guard let nextvc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: AccountTypeVC.getStoryboardID()) as? AccountTypeVC else { return }
////                self.navigationController?.pushViewController(nextvc, animated: true)
            guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: AccountTypeVC.getStoryboardID()) as? AccountTypeVC else { return }
            self.navigationController?.pushViewController(nextvc, animated: true)
//            }
//            self.navigationController?.present(nextVc, animated: true)
        
        default:
            return
        }
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackTapped(_ sender: UIButton) {
        if hasCameFrom == .forgotPass{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            kSharedAppDelegate?.moveToLoginScreen()
        }
    }
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        otpApi()
    }
    @IBAction func btnResendTapped(_ sender: UIButton) {
        resendOtpApi()
    }
}
extension OtpViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Range.length == 1 means,clicking backspace
        if (range.length == 0){
            if textField == textFieldFirst {
                textFieldSecond?.becomeFirstResponder()
            }
            if textField == textFieldSecond {
                textFieldThird?.becomeFirstResponder()
            }
            if textField == textFieldThird {
                textFieldFourth?.becomeFirstResponder()
            }
            if textField == textFieldFourth {
                textFieldFourth?.resignFirstResponder()
            }
            textField.text? = string
            return false
        }else if (range.length == 1) {
            if textField == textFieldFourth {
                textFieldThird?.becomeFirstResponder()
            }
            if textField == textFieldThird {
                textFieldSecond?.becomeFirstResponder()
            }
            if textField == textFieldSecond {
                textFieldFirst?.becomeFirstResponder()
            }
            if textField == textFieldFirst {
                textFieldFirst?.resignFirstResponder()
            }
            textField.text? = ""
            return false
        }
        return true
    }
    func textFieldBorder(){
        self.viewFirst.borderWidth = self.textFieldFirst.isFirstResponder ? 1:0
        self.viewFirst.borderColor = self.textFieldFirst.isFirstResponder ? #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1):.clear
        self.textFieldFirst.textColor = self.textFieldFirst.isFirstResponder ? #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1):#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        self.viewSecond.borderWidth = self.textFieldSecond.isFirstResponder ? 1:0
        self.viewSecond.borderColor = self.textFieldSecond.isFirstResponder ? #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1):.clear
        self.textFieldSecond.textColor = self.textFieldSecond.isFirstResponder ? #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1):#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        self.viewThird.borderWidth = self.textFieldThird.isFirstResponder ? 1:0
        self.viewThird.borderColor = self.textFieldThird.isFirstResponder ? #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1):.clear
        self.textFieldThird.textColor = self.textFieldThird.isFirstResponder ? #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1):#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
        self.viewFourth.borderWidth = self.textFieldFourth.isFirstResponder ? 1:0
        self.viewFourth.borderColor = self.textFieldFourth.isFirstResponder ? #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1):.none
        self.textFieldFourth.textColor = self.textFieldFourth.isFirstResponder ? #colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1):#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1)
    }
    //MARK:-UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBorder()
    }
}

extension OtpViewController {
    
    func sendOTP() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let sendOTPParams: [String: Any] = [ApiParameters.user_id: Int(id) ?? 10]
        TANetworkManager.sharedInstance.requestApi(withServiceName: "sendOTP",
                                                   requestMethod: .POST,
                                                   requestParameters: sendOTPParams,
                                                   withProgressHUD: false)
        { result, error, errorType, statusCode in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                showAlertMessage.toast(with: String.getString(dictResult["message"]), isDanger: false)
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func otpApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let otp = String.getString(self.textFieldFirst.text) + String.getString(self.textFieldSecond.text) + String.getString(self.textFieldThird.text) + String.getString(self.textFieldFourth.text)
        let params: [String: Any] = [ApiParameters.kotp:otp, ApiParameters.user_id: Int(id) ?? 10]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.verifyotp,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getDictionary(dictResult["user_data"])
                    UserData.shared.saveData(data: data)
                    self.sumbitBtnTapped(hasCameFrom:self.hasCameFrom)
                    
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

extension OtpViewController {
    func resendOtpApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let otp = String.getString(self.textFieldFirst.text) + String.getString(self.textFieldSecond.text) + String.getString(self.textFieldThird.text) + String.getString(self.textFieldFourth.text)
        let params:[String:Any] = [ApiParameters.user_id:id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.resendOtp,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let alert = UIAlertController(title: "OTP Resent Successfully", message: nil, preferredStyle: .alert)
                   let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    self.seconds = 90
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
}
