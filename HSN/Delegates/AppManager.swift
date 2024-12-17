//
//  AppManager.swift
//  PydeYa
//
//  Created by Fluper on 10/02/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

typealias POSTJSON = [String: Any]

class AppManager :  NSObject  {
    
    static let sharedInstanse = AppManager()
    
    // MARK: - func for login root controllers
    func movetoLogin() {
        //        guard let vc = UIStoryboard.init(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        //        let navVC = UINavigationController.init(rootViewController: vc)
        //        navVC.isNavigationBarHidden = true
        //        kSharedAppDelegate?.window?.makeKeyAndVisible()
        //        kSharedAppDelegate?.window?.rootViewController = navVC
    }
    
    func movetoHome() {
        //        guard let vc = UIStoryboard.init(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeTabBarViewController") as? HomeTabBarViewController else { return }
        //        let navVC = UINavigationController.init(rootViewController: vc)
        //        navVC.isNavigationBarHidden = true
        //        kSharedAppDelegate?.window?.makeKeyAndVisible()
        //        kSharedAppDelegate?.window?.rootViewController = navVC
    }
    
    func movetoTaxiHome() {
        //        guard let vc = UIStoryboard.init(name: "Home", bundle: .main).instantiateViewController(withIdentifier: "HomeTabBarViewController") as? HomeTabBarViewController else { return }
        //        vc.selectedIndex = 4
        //        let navVC = UINavigationController.init(rootViewController: vc)
        //        navVC.isNavigationBarHidden = true
        //        kSharedAppDelegate?.window?.makeKeyAndVisible()
        //        kSharedAppDelegate?.window?.rootViewController = navVC
    }
    
    //func logOut() {
    //        kSharedInstance.userModel = nil
    //        kSharedInstance.userModel = TKUserModel.init()
    //        self.movetoLogin()
    //    }
}


