//
//  AppSettingsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 07/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import StoreKit
import Alamofire

class AppSettingsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Data Sources
    var array: [String] = [
        "About Us",
        "Privacy Policy",
        "Terms & Conditions",
        //"Help",
        //"FAQ's",
        "Contact Us",
        "Push notifications",
        //"Face ID",
        "Refer App",
        "Rate App",
        "Delete account",
        "Version",
        //"Change Language"
    ]
    
    var arrayIcons: [UIImage] = [
        UIImage(named:"about_us")!,
        UIImage(named:"privacy_policy")!,
        UIImage(named:"terms")!,
        //UIImage(named:"help-1")!,
        //UIImage(named:"faqs")!,
        UIImage(named:"st_contact_us")!,
        UIImage(named:"push_notifications")!,
        //UIImage(named:"face_detection")!,
        UIImage(named:"st_refer_app")!,
        UIImage(named:"Group 59368")!,
        UIImage(named:"st_delete_account")!,
        UIImage(named:"version")!,
        //UIImage(named:"changeLanguage")!
    ]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
        setStatusBar()
        setupTableView()
        handleFaceId()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: SettingsTVC.identifier, bundle: nil), forCellReuseIdentifier: SettingsTVC.identifier)
    }
    
    private func handleFaceId() {
        //kSharedAppDelegate?.isFaceIDSupported(completion: { status in
        //if status {
        //self.array = ["About Us","Privacy Policy","FAQ's","Push notifications","Face ID","Help","Rate App","Version","Contact Us","Refer App","Terms & Conditions"]
        //self.arrayIcons = [UIImage(named:"about_us")!,UIImage(named:"privacy_policy")!,UIImage(named:"faqs")!,UIImage(named:"push_notifications")!,UIImage(named:"face_detection")!,UIImage(named:"help-1")!,UIImage(named:"Group 59368")!,UIImage(named:"version")!,UIImage(named:"st_contact_us")!,UIImage(named:"st_refer_app")!,UIImage(named:"terms")!,UIImage(named:"my_save_address")!]
        //self.array = [
        //"About Us",
        //"Privacy Policy",
        //"Terms & Conditions",
        //"Help",
        //"FAQ's",
        //"Contact Us",
        //"Push notifications",
        //"Face ID",
        //"Refer App",
        //"Rate App",
        //"Delete account",
        //"Version",
        //"Change Language"
        //]
        //self.arrayIcons = [
        //UIImage(named:"about_us")!,
        //UIImage(named:"privacy_policy")!,
        //UIImage(named:"terms")!,
        //UIImage(named:"help-1")!,
        //UIImage(named:"faqs")!,
        //UIImage(named:"st_contact_us")!,
        //UIImage(named:"push_notifications")!,
        //UIImage(named:"face_detection")!,
        //UIImage(named:"st_refer_app")!,
        //UIImage(named:"Group 59368")!,
        //UIImage(named:"st_delete_account")!,
        //UIImage(named:"version")!,
        //UIImage(named:"changeLanguage")!
        //]
        //} else {
        //self.array = [
        //"About Us",
        //"Privacy Policy",
        //"Terms & Conditions",
        //"Help",
        //"FAQ's",
        //"Contact Us",
        //"Push notifications",
        //"Refer App","Rate App",
        //"Delete account",
        //"Version",
        //"Change Language"
        //]
        //self.arrayIcons = [
        //UIImage(named:"about_us")!,
        //UIImage(named:"privacy_policy")!,
        //UIImage(named:"terms")!,
        //UIImage(named:"help-1")!,
        //UIImage(named:"faqs")!,
        //UIImage(named:"st_contact_us")!,
        //UIImage(named:"push_notifications")!,
        //UIImage(named:"st_refer_app")!,
        //UIImage(named:"Group 59368")!,
        //UIImage(named:"st_delete_account")!,
        //UIImage(named:"version")!,
        //UIImage(named: "changeLanguage")!
        //]
        //}
        //})
    }
    
    private func askForRating() {
        if #available(iOS 14.0, *) {
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    private func createDeleteAccountRequest(completion: @escaping (() -> Void)) {
        let parameters: [String: Any] = [:]
        let headers: HTTPHeaders = ["accessToken": kSharedUserDefaults.getLoggedInAccessToken(), "Accept": "application/json"]

        Alamofire.request("http://api.hlthera.com/api/delete_account", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            completion()
        }
    }
    
}

// MARK: - Actions
extension AppSettingsVC {
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func logoutTapped(_ sender: Any) {
        kSharedAppDelegate?.moveToLoginScreen()
        
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension AppSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.identifier, for: indexPath) as! SettingsTVC
        cell.labelName.text = array[indexPath.row]
        cell.imageIcon.image = arrayIcons[indexPath.row]
        cell.imageDropDown.isHidden = true
        if indexPath.row == 4 {
            cell.switchOption.isHidden = false
            kSharedUserDefaults.isFaceIdEnable() ? (cell.switchOption.isOn = true) : (cell.switchOption.isOn = false)
            cell.callbackSwitch = { status in
                kSharedUserDefaults.setLoginWithFaceId(enable: status)
                self.tableView.reloadData()
            }
        } else {
            cell.switchOption.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // About us
        if indexPath.row == 0 {
            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
            nextVc.pageTitleString = "About Us"
            nextVc.url = kBASEURL + "about"
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        
        // Privacy policy
        if indexPath.row == 1 {
            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
            nextVc.pageTitleString = "Privacy Policy"
            nextVc.url = kBASEURL + "privacy_policy"
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        
        // Terms and Conditions
        if indexPath.row == 2 {
            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
            nextVc.pageTitleString = "Terms and Conditions"
            nextVc.url = kBASEURL + "term_condition"
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        
        // Contact Us
        if indexPath.row == 3 {
            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
        
        // Push notifications
        if indexPath.row == 4 {
            
        }
        // Face ID
//        if indexPath.row == 5 {
//
//        }
        // Refer App
        if indexPath.row == 5 {
            let textToShare = kAppName
            if let myWebsite = NSURL(string: "http://www.hlthera.com") {
                let objectsToShare = [textToShare, myWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
        // Rate App
        if indexPath.row == 6 {
            askForRating()
        }
        
        // Delete Account
        if indexPath.row == 7 {
            let alert = UIAlertController(title:"Delete Account", message: "Are you sure that you want to delete your account", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.createDeleteAccountRequest { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true, completion: nil)
                }
            }
            let action2 = UIAlertAction(title: "Cancle", style: .cancel) { [weak self] _ in
                guard let self = self else { return }
                    self.dismiss(animated: true, completion: nil)
                }
            alert.addAction(action2)
            alert.addAction(action1)
            UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
        }
        
        // Version
        if indexPath.row == 8 {
            let alert = UIAlertController(title:"HSN App", message: "Version 1.0", preferredStyle: .alert)
            let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action1)
            UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
        }
//
//        if indexPath.row == 4 {
//            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
//            nextVc.pageTitleString = "FAQ"
//            nextVc.url = kBASEURL + "faq"
//            self.navigationController?.pushViewController(nextVc, animated: true)
//        }
//        if indexPath.row == 6 && array.count == 11 || indexPath.row == 6 && array.count == 12 {
//            kSharedAppDelegate?.moveToHomeScreen(index: 3)
//        }
//
//        if indexPath.row == 10 && array.count == 11 || indexPath.row == 11 && array.count == 12 {
//            let alert = UIAlertController(title:"HSN App", message: "Version 1.0", preferredStyle: .alert)
//            let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel){_ in
//                self.dismiss(animated: true, completion: nil)
//            }
//            alert.addAction(action1)
//            UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
//        }
//
//        if indexPath.row == 5 && array.count == 11 || indexPath.row == 5 && array.count == 12 {
//            //            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
//            //            nextVc.pageTitleString = "Contact Us"
//            //            nextVc.url = kBASEURL + "contact_us"
//            //            self.navigationController?.pushViewController(nextVc, animated: true)
//            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else {return}
//            self.navigationController?.pushViewController(nextVc, animated: true)
//        }
//
//        if indexPath.row == 7 && array.count == 11 || indexPath.row == 8 && array.count == 12 {
//            let textToShare = kAppName
//            if let myWebsite = NSURL(string: "http://www.hlthera.com") {
//                let objectsToShare = [textToShare, myWebsite] as [Any]
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//                self.present(activityVC, animated: true, completion: nil)
//            }
//        }
//
//        if indexPath.row == 2 && array.count == 11 || indexPath.row == 2 && array.count == 12 {
//            guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
//            nextVc.pageTitleString = "Terms and Conditions"
//            nextVc.url = kBASEURL + "term_condition"
//            self.navigationController?.pushViewController(nextVc, animated: true)
//        }
//
//        if indexPath.row == 11 {
//            kSharedAppDelegate?.moveToHomeScreen()
//        }
    }
}

