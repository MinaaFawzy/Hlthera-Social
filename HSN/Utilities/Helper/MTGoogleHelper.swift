//
//  MTGoogleLogin.swift
//  Agafos
//
//  Created by Mohammad Tahir on 07/09/17.
//  Copyright © 2017 Tahir. All rights reserved.
//
//import GoogleSignIn
//
/////MARK: - GoogleUser Modal-
//
//public struct GoogleUser {
//  
//  private (set) var email:           String?
//  private (set) var userId:          String?
//  private (set) var tokenId:         String?
//  private (set) var name:            String?
//  private (set) var firstName:       String?
//  private (set) var lastName:        String?
//  private (set) var profileImageUrl: String?
//  private (set) var fullName:        String?
//  
//  init(with googleUser:GIDGoogleUser?) {
//    
//    self.email           = String(any:googleUser?.profile.email).localised()
//    self.userId          = String(any:googleUser?.userID).localised()
//    self.tokenId         = String(any:googleUser?.authentication.idToken).localised()
//    self.name            = String(any:googleUser?.profile.name).localised()
//    self.firstName       = String(any:googleUser?.profile.givenName).localised()
//    self.lastName        = String(any:googleUser?.profile.familyName).localised()
//    self.profileImageUrl = String(any:googleUser?.profile.imageURL(withDimension: 1280).absoluteString)
//    self.fullName        = "\(String(any:firstName)) \(String(any:lastName))".localised()
//    
//  }
//}
//
////MARK - Public Closure -
//public typealias GoogleSignInClosure = (((GoogleUser?),Error?) -> (Void))?
//
//
////MARK:- MTGoogleHelper -
//final class MTGoogleHelper: NSObject {
//  
//  //MARK - fileprivate -
//  
//  fileprivate var instance: MTGoogleHelper? = nil
//  
//  fileprivate var googleDidSignIn: GoogleSignInClosure = nil
//  
//  //MARK - Public Initializer -
//  override init() {
//    super.init()
//    
//    GIDSignIn.sharedInstance().delegate = self
//    GIDSignIn.sharedInstance().delegate = self
//    self.instance = self
//  }
//  
//  /**
//   
//   * @param null
//   * @return null
//   * Closure User Modal or Error
//   
//   */
//  
//  //MARK - Public -
//  public func loginToGoogle(_ handler: GoogleSignInClosure) -> Void {
//    
//    GIDSignIn.sharedInstance().signOut()
//    GIDSignIn.sharedInstance().signIn()
//    self.googleDidSignIn = handler
//  }
//  
//  
//  //MARK - Private -
//  
//  fileprivate func invokeClosure(withUser user: GIDGoogleUser?, error err: Error?) -> Void {
//    
//    DispatchQueue.main.async {
//      
//      self.googleDidSignIn?(GoogleUser.init(with: user),err)
//      self.instance = nil
//    }
//  }
//  
//  
//  fileprivate func topMostController() -> UIViewController? {
//    
//    var topController =  UIApplication.shared.windows.first?.rootViewController
//    
//    if topController == nil {
//      
//      topController = UIApplication.shared.keyWindow?.rootViewController
//    }
//    
//    while ((topController?.presentedViewController) != nil) {
//      
//      topController = topController?.presentedViewController;
//    }
//    
//    return topController
//  }
//  
//  
//  deinit { NSLog("MTGoogleHelper deinit") }
//  
//}//end
//
////MARK: - GIDSignInDelegate - GIDSignInUIDelegate -
//
//extension MTGoogleHelper: GIDSignInDelegate {
//  
//  func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//    
//  }
//  
//  func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//    
//    DispatchQueue.main.async {
//      
//      self.topMostController()?.present(viewController, animated: true, completion: nil)
//    }
//  }
//  
//  func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//    
//    viewController.dismiss(animated: true, completion: {
//      self.invokeClosure(withUser: nil, error: nil)
//    })
//  }
//  
//  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//    
//    if error != nil {
//      
//      self.invokeClosure(withUser: nil, error: error)
//      return
//    }
//    
//    self.invokeClosure(withUser: user, error: error)
//    
//  }
//  
//  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//    
//    self.invokeClosure(withUser: nil, error: nil)
//  }
//}//end
//
////MARK: - Extension MTGoogleHelper
//extension String {
//  
//  func localised() -> String {
//    
//    return NSLocalizedString(self, comment: self)
//  }
//  
//  init(any anyValue: Any?) {
//    self = ""
//    if let stringValue = anyValue as? String {
//      self = String(format: "%@", stringValue).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    } else if let numberValue = anyValue as? NSNumber {
//      self = String(format: "%@", numberValue).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    }
//  }
//}
