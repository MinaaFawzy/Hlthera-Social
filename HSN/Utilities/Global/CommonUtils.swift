//
//  CommonUtils.swift
//  SwiftClasses
//
//  Created by Nitin Aggarwal on 6/11/17.
//  Copyright © 2020 Nitin Aggarwal. All rights reserved.
//

import Foundation
import UIKit
import FTIndicator
import SVProgressHUD
import AVFoundation
import Photos
import BSImagePicker

let kAlertTitle         = "Hlthera"
let kButtonTitle        = "Ok"
let kNoInternetMsg      = "Unable to connect to the Internet. Please try again."
let kDefaultErrorMsg    = "Something went wrong. Please try again."
let kchangeMobileNumber = "changeMobileNumber"
let kProfilePicURL      = "http://18.221.78.86/mehoro/images/"


class CommonUtils: Loadable {
    
    // MARK: - Alert Controller Methods
    
    // To show alert controller for no internet available.
    static func showAlertForInternetUnavailable() {
        CommonUtils.showAlert(title: kAlertTitle,
                              message: kNoInternetMsg,
                              buttonTitle: kButtonTitle) { (_) in
        }
    }
    
    // To show alert controller for under development.
    static func showAlertForUnderDevelopment() {
        CommonUtils.showAlert(title: kAlertTitle,
                              message: "Under Development",
                              buttonTitle: kButtonTitle) { (_) in
        }
    }
    
    // To show alert controller for any error.
    static func showAlertForDefaultError() {
        CommonUtils.showAlert(title: kAlertTitle,
                              message: kDefaultErrorMsg,
                              buttonTitle: kButtonTitle) { (_) in
        }
    }
        
    // To show alert controller with single button and call back to receiver.
    static func showAlert(title: String,
                          message: String,
                          buttonTitle: String,
                          completion: @escaping(_ buttonTitle: String?) -> ()) -> Void {
        
        let alertController = UIAlertController(title: title.count>0 ? title: kAlertTitle,
                                                message: message.count>0 ? message: "Message",
                                                preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: buttonTitle.count>0 ? buttonTitle: kButtonTitle,
                                          style: .default,
                                          handler: { (alert) in
                                            print("Alert button tapped")
                                            completion(alert.title!)
        })
        
        alertController.addAction(defaultAction)
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        nav?.present(alertController, animated: true, completion: nil)
    }
    
    // To show alert controller with two button and call back to receiver.
    static func showAlert(title: String,
                          message: String,
                          refrence:UIViewController? = UIApplication.shared.windows.first?.rootViewController ,
                          firstTitle: String,
                          secondTitle: String,isSecondCancel:Bool = false,
                          completion: @escaping(_ buttonTitle: String?) -> ()) -> Void {
        
        let alertController = UIAlertController(title: title.count>0 ? title: kAlertTitle,
                                                message: message.count>0 ? message: "Message",
                                                preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstTitle.count>0 ? firstTitle: kButtonTitle, style: .default, handler: { (alert) in
                                            print(alert.title!)
                                            completion(alert.title!)
        })
        
        let secondAction = UIAlertAction(title: secondTitle.count>0 ? secondTitle: kButtonTitle,
                                         style: isSecondCancel ? .cancel : .default,
                                         handler: { (alert) in
                                            print(alert.title!)
            isSecondCancel ? (alertController.dismiss(animated: true, completion: nil)) : completion(alert.title!)
        })
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
//        let nav = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        refrence?.present(alertController, animated: true, completion: nil)
    }
    static func showDeleteAlert(title: String,
                                message: String,btnTitle:String = "Delete",
                          completion: @escaping() -> ()) -> Void {
        
        let alertController = UIAlertController(title: title.count>0 ? title: kAlertTitle,
                                                message: message.count>0 ? message: "Message",
                                                preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: btnTitle , style: .destructive, handler: { (alert) in
                                            print(alert.title!)
                                            completion()
        })
        
        let secondAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (alert) in
            alertController.dismiss(animated: true, completion: nil)
                                            
        })
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
//        let nav = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    // To show alert controller with two button and call back to receiver.
    static func showAlertToPickImageOption(completion: @escaping(_ index: Int?) -> ()) -> Void {
        
        let alertController = UIAlertController(title: nil,
                                                message: "Please select an option to pick an image.",
                                                preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "Camera",
                                        style: .default,
                                        handler: { (alert) in
                                            completion(0)
        })
        
        let secondAction = UIAlertAction(title: "Gallery",
                                         style: .default,
                                         handler: { (alert) in
                                            completion(1)
        })
        
        let thirdAction = UIAlertAction(title: "Cancel",
                                        style: .cancel,
                                        handler: { (alert) in
                                            completion(2)
        })
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        nav?.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Toast Popup Methods
    
    // To show toast popup with message.
    static func showToast(message: String) {
        FTIndicator.showNotification(withTitle: kAlertTitle,
                                     message: message.count>0 ? message: "Message")
    }
    
    // To show toast popup for no internet available.
    static func showToastForInternetUnavailable() {
        FTIndicator.showNotification(withTitle: kAlertTitle,
                                     message: kNoInternetMsg)
    }
    
    // To show toast popup for under development.
    static func showToastForUnderDevelopment() {
        FTIndicator.showNotification(withTitle: kAlertTitle,
                                     message: "Under Development")
    }
    
    // To show toast popup for any error.
    static func showToastForDefaultError() {
        FTIndicator.showNotification(withTitle: kAlertTitle,
                                     message: kDefaultErrorMsg)
    }
    
    
    // MARK: - HUD Methods
    
    static func showHud(show: Bool) {
        if show == true {
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0))
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    static func showHudWithNoInteraction(show: Bool) {
        if show {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0))
            //SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).withAlphaComponent(1))
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    static func getClassName(vc: UIViewController) -> String {
        return NSStringFromClass(vc.classForCoder).components(separatedBy:".").last!
    }
    
    
    // MARK: - Other Methods
    
    static func animate(view: UIView) {
        let expendTransform = CGAffineTransform.init(scaleX: 1.15, y: 1.15)
        view.transform = expendTransform
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.40,
                       initialSpringVelocity: 0.15,
                       options: .curveEaseOut,
                       animations: {
                        view.transform = expendTransform.inverted()
        }) { (finished) in
            
        }
    }
    
    
    static func makeConversationKey(senderId : Int , receiverId: Int) -> String {
        
        if senderId < receiverId {
            return "conversation_\(senderId)_\(receiverId)"
        } else {
            return "conversation_\(receiverId)_\((senderId))"
        }
        
    }
    
    static func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("Family= [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    static func getCountryCallingCode(code:String) -> String {
        let dictCodes: [AnyHashable: Any] = [
            "IL" : "972",
            "AF" : "93",
            "AL" : "355",
            "DZ" : "213",
            "AS" : "1","AD" : "376","AO" : "244","AI" : "1","AG" : "1","AR" : "54","AM" : "374","AW" : "297","AU" : "61","AT" : "43","AZ" : "994","BS" : "1",
            "BH" : "973","BD" : "880","BB" : "1","BY" : "375","BE" : "32","BZ" : "501","BJ" : "229","BM" : "1","BT" : "975","BA" : "387","BW" : "267",
            "BR" : "55","IO" : "246","BG" : "359","BF" : "226","BI" : "257","KH" : "855","CM" : "237","CA" : "1","CV" : "238","KY" : "345","CF" : "236",
            "TD" : "235","CL" : "56","CN" : "86","CX" : "61","CO" : "57","KM" : "269","CG" : "242","CK" : "682","CR" : "506","HR" : "385","CU" : "53","CY" : "537","CZ" : "420","DK" : "45","DJ" : "253","DM" : "1",
            "DO" : "1","EC" : "593","EG" : "20","SV" : "503","GQ" : "240","ER" : "291","EE" : "372","ET" : "251","FO" : "298","FJ" : "679","FI" : "358","FR" : "33","GF" : "594","PF" : "689","GA" : "241","GM" : "220","GE" : "995","DE" : "49","GH" : "233","GI" : "350","GR" : "30",
            "GL" : "299","GD" : "1","GP" : "590","GU" : "1","GT" : "502","GN" : "224","GW" : "245","GY" : "595","HT" : "509","HN" : "504","HU" : "36","IS" : "354","ID" : "62","IQ" : "964","IE" : "353","IT" : "39",
            "JM" : "1","JP" : "81","JO" : "962","KZ" : "77","KE" : "254","KI" : "686","KW" : "965","KG" : "996","LV" : "371","LB" : "961","LS" : "266","LR" : "231","LI" : "423","LT" : "370","LU" : "352","MG" : "261","MW" : "265","MY" : "60","MV" : "960","ML" : "223","MT" : "356","MH" : "692","MQ" : "596","MR" : "222","MU" : "230","YT" : "262","MX" : "52","MC" : "377","MN" : "976","ME" : "382","MS" : "1",
            "MA" : "212","MM" : "95","NA" : "264","NR" : "674","NP" : "977","NL" : "31","AN" : "599","NC" : "687","NZ" : "64","NI" : "505","NE" : "227",
            "NG" : "234","NU" : "683","NF" : "672","MP" : "1","NO" : "47","OM" : "968","PK" : "92","PW" : "680","PA" : "507","PG" : "675","PY" : "595","PE" : "51","PH" : "63","PL" : "48","PT" : "351","PR" : "1",
            "QA" : "974","RO" : "40","RW" : "250","WS" : "685","SM" : "378","SA" : "966","SN" : "221","RS" : "381","SC" : "248","SL" : "232",
            "SG" : "65","SK" : "421","SI" : "386","SB" : "677","ZA" : "27","GS" : "500","ES" : "34","LK" : "94","SD" : "249","SR" : "597","SZ" : "268",
            "SE" : "46","CH" : "41","TJ" : "992","TH" : "66","TG" : "228","TK" : "690","TO" : "676","TT" : "1","TN" : "216","TR" : "90","TM" : "993",
            "TC" : "1","TV" : "688","UG" : "256","UA" : "380","AE" : "971","GB" : "44","US" : "1","UY" : "598","UZ" : "998","VU" : "678","WF" : "681",
            "YE" : "967", "ZM" : "260","ZW" : "263","BO" : "591","BN" : "673",
            "CC" : "61","CD" : "243","CI" : "225","FK" : "500","GG" : "44","VA" : "379","HK" : "852","IR" : "98","IM" : "44","JE" : "44","KP" : "850",
            "KR" : "82","LA" : "856","LY" : "218","MO" : "853","MK" : "389","FM" : "691","MD" : "373","MZ" : "258","PS" : "970","PN" : "872","RE" : "262","RU" : "7","BL" : "590","SH" : "290","KN" : "1","LC" : "1",
            "MF" : "590","PM" : "508","VC" : "1","ST" : "239","SO" : "252",
            "SJ" : "47","SY" : "963","TW" : "886","TZ" : "255","TL" : "670","VE" : "58","VN" : "84","VG" : "1","VI" : "1","IN":"91","AQ":"672","EH":"212","UM":"1","CW":"599","SS":"211","Bes":"599","TF":"262"]
        return String.getString("+\(dictCodes[code] ?? "00")")
        
    }
    
    
    
    
    static func getThumbnailImage(forUrl url: URL) -> UIImage? {
        
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) ,
                                                                actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    static func getAttributedString(boldString: String,
                                    otherString: String,
                                    fontSize: CGFloat) -> NSAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont.init(name: "SFUIDisplay-Bold", size: fontSize)]
        let attributedString = NSMutableAttributedString(string: boldString, attributes:(attrs as Any as! [NSAttributedString.Key : Any]))
        let normalString = NSMutableAttributedString(string:otherString)
        attributedString.append(normalString)
        return attributedString
    }
    
    static func height(withConstrainedWidth width: CGFloat, font: UIFont, text: String) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    
    //MARK: - Formatter Methods
    static func localToUTC(date:String, fromFormat: String, toFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    static func UTCToLocal(date: String, fromFormat: String, toFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        return dateFormatter.string(from: dt!)
    }
    
    class func convertToJSONData(_ value:Any) -> Data {
        
        if let str =  value as? String {
            return String.getString(str).data(using: String.Encoding.utf8)!
            
        } else if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
            return jsonData
            
        } else {
            return Data()
        }
    }
    
    static func getDayNameFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    static func imagePickerCamera(viewController:UIViewController){
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
         imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePicker.sourceType = .camera
            
            viewController.present(imagePicker, animated: true, completion: {
                
                imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                
            })
            
        }
            
        else {
            
            FTIndicator.showToastMessage("Camera not found ")
            
        }
    }
    static func imagePickerGallery(viewController:UIViewController){
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
         imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
            
            viewController.present(imagePicker, animated: true, completion: {
                
                imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                
            })
    }
    // function for image picker
    static func imagePicker(viewController:UIViewController){
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
         imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source ", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action :UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                imagePicker.sourceType = .camera
                
                viewController.present(imagePicker, animated: true, completion: {
                    
                    imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    
                })
                
            }
                
            else {
                
                FTIndicator.showToastMessage("Camera not found ")
                
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action :UIAlertAction) in imagePicker.sourceType = .photoLibrary
            
            viewController.present(imagePicker, animated: true, completion: {
                
                imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                
            })
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
            
            nil))
        
        viewController.present(actionSheet, animated: true, completion: nil )
        
    }
    
    
    //function for opening camera
    
    static func openCamera(viewController:UIViewController){
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        // imagePicker.allowsEditing = true
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePicker.sourceType = .camera
            
            viewController.present(imagePicker, animated: true, completion: {
                
                imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                
            })
            
        }
            
        else {
            
            FTIndicator.showToastMessage("Camera not found ")
            
        }
        
    }
    //Used in Chat
    static func getDocumentsDirectoryUrl() -> URL  {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func getFileUrl(fileName: String) -> URL {
        let filePath = getDocumentsDirectoryUrl().appendingPathComponent(fileName)
        return filePath
    }
    
    
    static func getDocumentDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let docsDir = paths[0];
        return docsDir
    }
    
    
    class func saveFileToDocumentDirectory(url: URL?, fileName: String, completionHandler: @escaping (Bool?) -> ()){
        
        if url != nil {
            do {
                let data = try Data(contentsOf: url!)
                let fileManager = FileManager.default
                let path = getDocumentDirectoryPath() + fileName
                let isDownloaded = fileManager.createFile(atPath: path as String, contents: data, attributes: nil)
                if isDownloaded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        completionHandler(true)
                    })
                }
            } catch {
                print_debug(items:"Unable to load data: \(error)")
                completionHandler(false)
            }
        }else {
            completionHandler(false)
        }
        
    }
    
    class func moveFileFrom(sourcePath: URL?, destinationPath: URL?) {
        DispatchQueue.global().async {
            if destinationPath != nil {
               do {
                   let fileManager = FileManager.default
                   try fileManager.moveItem(at: sourcePath!, to: destinationPath!)
               } catch {
                   print_debug(items:"Unable to load data: \(error)")
               }
        }
        }
    }
    class func requestAuthorization(completion: @escaping ()->Void) {
             if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                 PHPhotoLibrary.requestAuthorization { (status) in
                     DispatchQueue.main.async {
                         completion()
                     }
                 }
             } else if PHPhotoLibrary.authorizationStatus() == .authorized{
                 completion()
             }
         }
    
    class func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
            requestAuthorization {
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetCreationRequest.forAsset()
                    request.addResource(with: .video, fileURL: outputURL, options: nil)
                }) { (result, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Saved successfully")
                        }
                        completion?(error)
                    }
                }
            }
        }
    
    class func saveFile(url: String, fileName: String, completion: @escaping(_ path: String?) -> ()) -> Void {
        if url.isEmpty {
            return
        }
        DispatchQueue.global().async {
            let profileurl = String(describing: url.replacingOccurrences(of: " ", with: "%20")).replacingOccurrences(of: "\\", with: "/")
            
            do {
                let fileData = try Data(contentsOf: URL(string: profileurl)! as URL)
                let fileManager = FileManager.default
                let filePath = CommonUtils.getDocumentDirectoryPath() + "/\(fileName)"
                let isDownloaded = fileManager.createFile(atPath: filePath as String, contents: fileData, attributes: nil)
                if isDownloaded {
                    completion(filePath)
                }else {
                    completion("")
                }
            } catch {
                print("Unable to load data: \(error)")
                completion("")
            }
        }
    }
    
    class func downloadVideo(url: String) {
         let videpUrl = URL(string: url)
         if videpUrl != nil {
             
             CommonUtils.showHudWithNoInteraction(show: true)
             DispatchQueue.global(qos: .background).async {
                 if let urlData = NSData(contentsOf: videpUrl!){
                     let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                     let filePath="\(documentsPath)/tempVideo.mp4"
                     urlData.write(toFile: filePath, atomically: true)
                     if let videoUrl = URL(string: filePath) {
                     
                     CommonUtils.saveVideoToAlbum(videoUrl) { (error) in
                         
                         if error == nil {
                             CommonUtils.showToast(message: "Video saved successfully")
                             
                             if FileManager.default.fileExists(atPath: filePath) {
                                 do {
                                     try FileManager.default.removeItem(atPath: filePath)
                                 } catch {
                                     
                                 }
                             }
                         }
                         CommonUtils.showHudWithNoInteraction(show: false)
                     }
                   }
                 }
             }
         }
     }
    
    
}







