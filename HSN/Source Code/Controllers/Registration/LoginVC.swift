//
//  LoginVC.swift
//  Hlthera
//
//  Created by Akash on 23/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices


class LoginVC: UIViewController,UITextFieldDelegate{
    //MARK: - IBOutlets
   // @IBOutlet weak var imageEmail: UIImageView!
    @IBOutlet weak var constraintViewDividerWidth: NSLayoutConstraint!
    @IBOutlet weak var imageCountryCode: UIImageView!
    @IBOutlet var emailTf: UITextField!
    @IBOutlet weak var btnCountryCodeWidthConstraint: NSLayoutConstraint!
    @IBOutlet var passwordTf:UITextField!
    @IBOutlet var btnExploreGuest:UIButton!
    @IBOutlet weak var buttonCountryCode: UIButton!
    @IBOutlet var btnEye:UIButton!
    @IBOutlet weak var constraintTextFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewConteny: UIView!
    @IBOutlet weak var switchRemember: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    var email:String?
    var mobile:String?
    let buttonFBLogin = FBLoginButton()
    
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.initialSetup()
    }

    //MARK: - functions
    func initialSetup(){
        kSharedUserDefaults.setExclusiveActive(isActive: false)
        viewConteny.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewConteny.layer.cornerRadius = 30
       
        switchRemember.transform = CGAffineTransform(scaleX:0.70, y: 0.65)
       // imageEmail.image = #imageLiteral(resourceName: "e_mail")
        //imageEmail.isHidden = true
        imageCountryCode.isHidden = true
        self.buttonCountryCode.isHidden = true
         btnCountryCodeWidthConstraint.constant = 0
        constraintViewDividerWidth.constant = 0
        constraintTextFieldLeading.constant = -1.5
       // imageEmail.isHidden = false
        imageCountryCode.isHidden = true
        
        if UIScreen.main.bounds.height > 800{
            scrollView.isScrollEnabled = false
        }
        else {
            scrollView.isScrollEnabled = true
        }
        
        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        emailTf.placeholder(text: "Enter E-mail", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        passwordTf.placeholder(text: "Enter Password", color: #colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1))
        emailTf.delegate = self
        buttonFBLogin.permissions = ["public_profile", "email"]
        buttonFBLogin.delegate = self
        buttonFBLogin.isHidden = true
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().delegate = self
        
        if !kSharedUserDefaults.getSavedPassword().isEmpty{
            let data = kSharedUserDefaults.getSavedPassword()
            self.emailTf.text = String.getString(data["email"])
//            checkEmailPhone(text: emailTf.text)
            self.passwordTf.text = String.getString(data["pass"])
            //self.buttonCountryCode.setTitle(String.getString(data["countryCode"]), for: .normal)
            self.switchRemember.isOn = true
            
        }
        else{
            self.emailTf.text = ""
            self.passwordTf.text = ""
            self.switchRemember.isOn = false
            
        }
        
//        if kSharedUserDefaults.isFaceIdEnable() && kSharedUserDefaults.isUserLoggedIn(){
//            kSharedAppDelegate?.loginWithFaceId(completion: { status in
//                if status == 1{
//                    kSharedAppDelegate?.moveToHomeScreen()
//                }
////                else if status == 0{
////                    kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
////
////                }
////                else{
////                    kSharedUserDefaults.setUserLoggedIn(userLoggedIn: false)
////
////                }
//            })
//        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
  
//    func checkEmailPhone(text:String?) {
//        if !String.getString(text).isNumberContains(){
//            self.buttonCountryCode.isHidden = true
//             btnCountryCodeWidthConstraint.constant = 0
//            constraintViewDividerWidth.constant = 0
//            constraintTextFieldLeading.constant = -1.5
//           // imageEmail.isHidden = false
//            imageCountryCode.isHidden = true
//
//
//        }else {
//          //  imageEmail.isHidden = true
//            imageCountryCode.isHidden = false
//            self.buttonCountryCode.isHidden = false
//            constraintViewDividerWidth.constant = 2
//            constraintTextFieldLeading.constant = 10
//            btnCountryCodeWidthConstraint.constant = 70
//        }
//    }
    
    }
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//            checkEmailPhone(text: textField.text)
//    }

    func getUserProfile(token: AccessToken?, userId: String?) {
            let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
            graphRequest.start { _, result, error in
                if error == nil {
                    let data: [String: AnyObject] = result as! [String: AnyObject]
                    
                    // Facebook Id
                    if let facebookId = data["id"] as? String {
                        print("Facebook Id: \(facebookId)")
                    } else {
                        print("Facebook Id: Not exists")
                    }
                    //sample comment
                    // Facebook First Name
                    if let facebookFirstName = data["first_name"] as? String {
                        print("Facebook First Name: \(facebookFirstName)")
                    } else {
                        print("Facebook First Name: Not exists")
                    }
                    
                    // Facebook Middle Name
                    if let facebookMiddleName = data["middle_name"] as? String {
                        print("Facebook Middle Name: \(facebookMiddleName)")
                    } else {
                        print("Facebook Middle Name: Not exists")
                    }
                    
                    // Facebook Last Name
                    if let facebookLastName = data["last_name"] as? String {
                        print("Facebook Last Name: \(facebookLastName)")
                    } else {
                        print("Facebook Last Name: Not exists")
                    }
                    
                    // Facebook Name
                    if let facebookName = data["name"] as? String {
                        print("Facebook Name: \(facebookName)")
                    } else {
                        print("Facebook Name: Not exists")
                    }
                    
                    // Facebook Profile Pic URL
                    let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                    print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                    
                    // Facebook Email
                    if let facebookEmail = data["email"] as? String {
                        print("Facebook Email: \(facebookEmail)")
                    } else {
                        print("Facebook Email: Not exists")
                    }
                    
                    print("Facebook Access Token: \(token?.tokenString ?? "")")
                    
                    
                    self.logInRequest(id: String.getString(data["id"]), name: String.getString(data["name"]), email: String.getString(data["email"]), loginType: 1)
                    
                    
                } else {
                     
                    print("Error: Trying to get user's info")
                }
            }
        }

    //MARK:- @IBAction
    @IBAction func buttonBackTapped(_ sender: Any) {
        for controller in self.navigationController?.viewControllers ?? []{
            if controller.isKind(of: WalkthroughVC.self){
                self.navigationController?.popToViewController(controller, animated:true)
                return
            }
        }
        guard let vc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: WalkthroughVC.getStoryboardID()) as? WalkthroughVC else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEyeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.btnEye.isSelected{self.passwordTf.isSecureTextEntry = false}
        else{self.passwordTf.isSecureTextEntry = true}
    }
    @IBAction func btnCountryCodeTapped(_ sender: UIButton) {
        AppsCountryPickers.showController(referense: self)  { (selectedCountry) in
            self.buttonCountryCode.setTitle(selectedCountry?.countryCode, for: .normal)
            self.imageCountryCode.image = selectedCountry?.image
        }
    }
    @IBAction func btnForgotPassTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: ForgetPasswordViewController.getStoryboardID()) as? ForgetPasswordViewController else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        
        if String.getString(emailTf.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter Email/Mobile Number")
            return
        }
        else if String.getString(passwordTf.text).isEmpty{
            showAlertMessage.alert(message: "Please Enter Password")
            return
        }
       
//        if !switchRemember.isOn{
//            showAlertMessage.alert(message: "Please Accept Remember Password")
//            return
//        }
        logInRequest()
    }
    @IBAction func btnExploreGuestTapped(_ sender: UIButton) {
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: "HomeScrenViewController") as? HomeScrenViewController else {return}
//        self.navigationController?.pushViewController(nextVc, animated: true)
//        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
    }
    @IBAction func btnJoinNowTapped(_ sender: UIButton) {
//        guard let nextVc = self.storyboard?.instantiateViewController(identifier: Identifiers.kSignUpVC) as? SignUpViewController else {return}
//        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func buttonFacebookTapped(_ sender: Any) {
        buttonFBLogin.sendActions(for: .touchUpInside)
    }
    @IBAction func buttonGoogleTapped(_ sender: Any) {
      //  GIDSignIn.sharedInstance()?.signIn()
        // Comment by ankur
//        GIDSignIn.sharedInstance.signIn(with: GIDConfiguration(clientID: signInConfig), presenting: self) { user, error in
//           guard error == nil else { return }
//            if let user = user{
//                self.logInRequest(id: String.getString(user.userID), name: String.getString(user.profile?.name), email: String.getString(user.profile?.email), loginType: 2)
//            }
//
//           // If sign in succeeded, display the app's main content View.
//         }
    }
   
    @IBAction func buttonAppleTapped(_ sender: Any) {
        self.handleAuthorizationAppleIDButtonPress()
    }
    
    
}
//MARK:-LoginVCApi
extension LoginVC{
   
    func logInRequest(id:String,name:String,email:String,loginType:Int) {
        let params = [
            ApiParameters.kdevice_type:"2",
//            ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
            ApiParameters.kdeviceToken:"1",
            ApiParameters.klogin_type:String.getString(loginType),
            ApiParameters.ksocial_id:id,
            ApiParameters.kFirstName:name,
            ApiParameters.klastName:"",
            ApiParameters.kemail:email,
        ]
        loginInApi(params: params,url: ServiceName.socialSignin)
    }
    
    func logInRequest() {
        var params = [
            ApiParameters.kpassword:String.getString(self.passwordTf.text),
            ApiParameters.kdevice_type:"2",
//            ApiParameters.kdeviceToken:kSharedUserDefaults.getDeviceToken(),
            ApiParameters.kdeviceToken:"1",
            ApiParameters.kcountryCode:String.getString(buttonCountryCode.titleLabel?.text)]
          
        params[ApiParameters.kemail] = String.getString(emailTf.text)
        params[ApiParameters.klogin_type] = "2"

        //Login with phone or email
//        if String.getString(emailTf.text).isEmail(){
//            params[ApiParameters.kemail] = String.getString(emailTf.text)
//            params[ApiParameters.klogin_type] = "2"
//
//        }
//        else{
//            params[ApiParameters.kMobileNumber] = String.getString(emailTf.text)
//            params[ApiParameters.klogin_type] = "1"
//        }
       
        loginInApi(params: params,url:ServiceName.login)
    }
    
    func loginInApi(params:[String:Any],url:String){
   
        CommonUtils.showHudWithNoInteraction(show: true)
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    print(dictResult)
                    let data = kSharedInstance.getDictionary(dictResult["user_data"])
                    if self.switchRemember.isOn{
                        kSharedUserDefaults.setPasswordDetails(data: ["email":String.getString(self.emailTf.text),
                                                                      "pass":String.getString(self.passwordTf.text)])
                    }
                    else{
                        kSharedUserDefaults.setPasswordDetails(data: [:])
                    }
                    UserData.shared.saveData(data: data)
//                    if UserData.shared.is_otp_verified{
                        
                        if UserData.shared.is_typeWork_filled{
                            kSharedAppDelegate?.moveToHomeScreen()
                            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
                        }
                        else{
                            guard let nextVc = UIStoryboard(name: Storyboards.kHome, bundle: .none).instantiateViewController(withIdentifier: WorkViewController.getStoryboardID()) as? WorkViewController else {return}
                            nextVc.hasCameFrom = .createProfile
                            self.navigationController?.pushViewController(nextVc, animated: true)
                        }
                        //kSharedAppDelegate?.moveToHomeScreen()
//                    }
//                    else {
//                        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: OtpViewController.getStoryboardID()) as? OtpViewController else {return}
//                        nextVc.subHeading = UserData.shared.email.isEmpty ? UserData.shared.mobile_number  : UserData.shared.email
//                        nextVc.id = UserData.shared.id
//                        nextVc.hasCameFrom = .signUp
//                        self.navigationController?.pushViewController(nextVc, animated: true)
//                    }
                case 400:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                    
                    
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
extension LoginVC: LoginButtonDelegate{
   
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if result?.isCancelled ?? false {
            print("Cancelled")
            
                  
        } else if error != nil {
            print("ERROR: Trying to get login results")
        } else {
            print("Logged in")
            self.getUserProfile(token: result?.token, userId: result?.token?.userID)
            //print(result?.token?.userID)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Do something after the user pressed the logout button
        print("You logged out!")
        
    }
}
//extension LoginVC:GIDSignInDelegate{
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
//          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//            print("The user has not signed in before or they have since signed out.")
//
//          } else {
//            print("\(error.localizedDescription)")
//
//          }
//          return
//        }
//        self.logInRequest(id: String.getString(user.userID), name: String.getString(user.profile.name), email: String.getString(user.profile.email), loginType: 2)
//
//      // ...
//    }
//}
extension LoginVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    
    func handleAuthorizationAppleIDButtonPress() {
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
  }
  //MARK:- Apple delegates
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
          
//          self.isApple = "1"
//         self.appleModel = AppleModel.init(social:appleIDCredential.user, name: appleIDCredential.fullName?.givenName ?? "", email: appleIDCredential.email ?? "")
          
        //requestSocialSignUp(name: String.getString(appleIDCredential.fullName?.givenName), id: String.getString(appleIDCredential.user), profilePicUrl: " ", email: String.getString(appleIDCredential.email), type: 2)
        self.logInRequest(id: String.getString(appleIDCredential.user), name: String.getString(appleIDCredential.fullName), email: String.getString(appleIDCredential.email), loginType: 4)

      }
  }
  
  @available(iOS 13.0, *)
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
  }
  @available(iOS 13.0, *)
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
     return self.view.window!
  }
  
    
    
    
}
