//
//  ContactUsVC.swift
//  Hlthera
//
//  Created by Prashant on 15/12/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelWhatsapp: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        self.labelDescription.text = "Contact us"
        // getContactDetails()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Actions
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonChatTapped(_ sender: Any) {}

}

extension ContactUsVC {
    func getContactDetails() {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params: [String: Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:ServiceName.contactUs,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["contact_us"])
                    self.labelDescription.text = String.getString(data["content"]).html2String
                    self.labelEmail.text = String.getString(data["email"])
                    self.labelPhone.text = String.getString(data["contact"])
                    self.labelWhatsapp.text = String.getString(data["whatsapp"])
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
