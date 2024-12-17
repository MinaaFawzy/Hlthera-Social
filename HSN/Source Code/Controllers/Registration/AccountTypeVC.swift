//
//  AccountTypeVC.swift
//  HSN
//
//  Created by Prashant Panchal on 22/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class AccountTypeVC: UIViewController {
   
    
    @IBOutlet var buttonsAccountType: [UIButton]!
    @IBOutlet var viewsAccountType: [UIView]!
    
    var accountType: Int = 0
    var accountTypeSelected: Bool = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
    }
}

//MARK: - Actions
extension AccountTypeVC {
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
        kSharedAppDelegate?.moveToHomeScreen()
    }
    
    @IBAction func btnAccountTypeTapped(_ sender: UIButton) {
        accountTypeSelected = true
        accountType = sender.tag
        for i in 0...buttonsAccountType.count - 1 {
            if buttonsAccountType[i].isTouchInside {
                viewsAccountType[i].backgroundColor = UIColor().hexStringToUIColor(hex: "#CBE4FA")
            } else {
                viewsAccountType[i].backgroundColor = UIColor().hexStringToUIColor(hex: "#F5F7F9")
            }
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        if !accountTypeSelected {
            CommonUtils.showToast(message: "Please choose account tyoe")
            return
        }
        updateAccountType()
    }
}

//MARK: - Call api
extension AccountTypeVC {
    func updateAccountType() {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params: [String: Any] = [
            "user_id": UserData.shared.id,
            "account_type": accountType
        ]
        TANetworkManager.sharedInstance.requestApi(
            withServiceName: ServiceName.update_account_type,
            requestMethod: .POST,
            requestParameters: params,
            withProgressHUD: false
        ) {
            [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: LocationVC.getStoryboardID()) as? LocationVC else { return }
                    self.navigationController?.pushViewController(nextvc, animated: true)
//                    if self.accountType == 0 {
//                        guard let nextvc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController else { return }
//                        nextvc.workDetails = [
//                            "edit_id":UserData.shared.id
//                        ]
//                        nextvc.location = ""
//                        self.navigationController?.pushViewController(nextvc, animated: true)
//                    } else {
//                        guard let nextvc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "WorkViewController") as? WorkViewController else { return }
//                        nextvc.isMedicalProfessor  = true
//                        self.navigationController?.pushViewController(nextvc, animated: true)
//                    }
                    
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
