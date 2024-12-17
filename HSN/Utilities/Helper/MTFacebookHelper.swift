//
//   MTFacebookHelper.swift
//   MTFacebookHelper
//
//   Created by       Mohammmad Tahir on 27/05/17.
//   Copyright © 2017 Mohammmad Tahir. All rights reserved.
//  https://github.com/Tahir91

//
//import UIKit
//import FBSDKLoginKit
//
//// MARK: - Public
//
//public typealias Json = ([String:Any]?)
//public typealias FacebookUserClosure = (((FaceBookUser), Error?) -> (Void))?
//
///// MARK: - FaceBookUser Modal-
//
//public struct FaceBookUser {
//  private (set) var email:           String?
//  private (set) var facebookId:      String?
//  private (set) var gender:          String?
//  private (set) var firstName:       String?
//  private (set) var lastName:        String?
//  private (set) var profileImageUrl: String?
//  private (set) var fullName:        String?
//
//  init(with facebookUser: Json) {
//    self.email           = String(any:facebookUser?["email"])
//    self.facebookId      = String(any:facebookUser?["id"])
//    self.gender          = String(any:facebookUser?["gender"])
//    self.firstName       = String(any:facebookUser?["first_name"])
//    self.lastName        = String(any:facebookUser?["last_name"])
//    self.fullName        = "\(String(any:firstName)) \(String(any:lastName))"
//    defer {
//      let dic = (facebookUser?["picture"] as? [String:Any] ?? [:])["data"] as? [String:Any] ?? [:]
//      self.profileImageUrl = String(any:dic["url"])
//    }
//  }
//}
//
//// MARK: - MTFacebookHelper
//
//final class MTFacebookHelper: NSObject {
//  // MARK: - Private
//  fileprivate var instance      : MTFacebookHelper? = nil
//  fileprivate var facebookUser  : FacebookUserClosure = nil
//  fileprivate var json          : Json = nil
//  // MARK: - Public Initializer -
//
//  override init() {
//    super.init()
//    LoginManager().logOut()
//    self.instance = self
//  }
//
//  // MARK: - Public
//
//  public func loginToFacebook(onController controller: UIViewController? = nil, closure: FacebookUserClosure) -> Void {
//
//    let viewC = controller ?? self.topMostController()
//    self.facebookUser = closure
//    LoginManager().logIn(permissions: ["email","public_profile"], from: viewC) {(result, err) in
//      if err != nil {
//        self.invokeClosure(withUser: nil, error: err)
//        return
//      }
//      self.loginToFacebookData({ (user, error) -> (Void) in
//        if err != nil {
//          self.invokeClosure(withUser: nil, error: err)
//          return
//        }
//        self.invokeClosure(withUser: user, error: err)
//      })
//    }
//  }
//
//  // MARK: - Private
//
//  fileprivate func topMostController() -> UIViewController? {
//    var topController =  UIApplication.shared.windows.first?.rootViewController
//   
//    if topController == nil {
//      topController = UIApplication.shared.keyWindow?.rootViewController
//    }
//    while (topController?.presentedViewController) != nil {
//      topController = topController?.presentedViewController
//    }
//    return topController
//  }
//
//
//  // MARK - Private -
//
//  fileprivate func invokeClosure(withUser user: Json, error err: Error?) -> Void {
//    DispatchQueue.main.async {
//      self.facebookUser?(FaceBookUser.init(with: user),nil)
//      self.instance = nil
//    }
//  }
//
//  // MARK: - Private
//
//  fileprivate func loginToFacebookData(_ closure: ((Json, Error?) -> Void)?) -> Void {
//    
//    GraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, last_name, email, gender, picture.width(200).height(200),birthday"]).start {(connection, result, err) in
//        if err != nil {
//          closure?(nil,err)
//          return
//        }
//        let dic = (result as? Dictionary<String, Any>) ?? [:]
//        closure?(dic,nil)
//    }
//  }
//
//    deinit {
//        NSLog("MTFacebookHelper deinit")
//    }
//
//}// end
//
//
////// MARK:- Extension String
////extension String {
////
////    init(any anyValue:Any?) {
////        self = ""
////        if let str = anyValue as? String {
////            self = String(format: "%@", str).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
////        } else if let num = anyValue as? NSNumber {
////            self = String(format: "%@", num).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
////        }
////    }
////
////}
