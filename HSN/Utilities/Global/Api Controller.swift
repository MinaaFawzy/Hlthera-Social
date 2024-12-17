//
//  Api Controller.swift
//  Timeless Medicine
//
//  Created by fluper on 05/09/19.
//  Copyright © 2019 fluper. All rights reserved.
//

import Foundation

let ApiInstance = Apicontroller.shared_instance


class Apicontroller {
    //MARK;- Shared Instance
    static let shared_instance = Apicontroller()
    
    
    //Func for maltipart
    func postMulipartApi(parameters :Dictionary<String ,Any> , imagedic : [Dictionary<String ,Any>] , serviceName: String, completionClosure: @escaping (_ result: Any?) -> ()) -> Void {
        
        //            let image: [String: Any] = [
        //                "image"                                       : self.ProfileImage.image ?? #imageLiteral(resourceName: "icon_default-1"),
        //                "imageName"                                       : ApiParameters.profile_image
        //            ]
        
        
        CommonUtils.showHudWithNoInteraction(show: true)
        AlmofireApiInstanse.requestMultiPart(withServiceName  : serviceName ,   requestMethod  : .post,   requestImages  : imagedic,  requestVideos  : [:], requestData : parameters)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            guard self != nil else { return }
            if errorType == ErrorType.requestSuccess {
                let dicResponse     = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getDictionary(dicResponse[kResponse])
                    completionClosure(data)
                case 501:
                    showAlertMessage.alert(message: AlertMessage.Under_Development)
                default:
                    showAlertMessage.alert(message: "\(String.getString(dicResponse[ApiParameters.message])) 🎈")
                    
                }
            } else if errorType == ErrorType.noNetwork {
                showAlertMessage.alert(message: AlertMessage.knoNetwork)
            } else {
                showAlertMessage.alert(message: AlertMessage.knoNetwork)
            }
        }
    }
    
    
    
    
    //func For Single Part Api
    func postApi(parameters :Dictionary<String ,Any> ,serviceName: String, completionClosure: @escaping (_ result: Any?) -> ()) -> Void{
        
        CommonUtils.showHudWithNoInteraction(show: true)
        AlmofireApiInstanse.requestApi(withServiceName: serviceName, requestMethod: .POST, requestParameters: parameters, withProgressHUD: false)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            guard self != nil else { return }
            if errorType == ErrorType.requestSuccess {
                let dicResponse     = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = dicResponse[kResponse]
                    completionClosure(data)
                case 501:
                    showAlertMessage.alert(message: AlertMessage.Under_Development)
                default:
                    showAlertMessage.alert(message: "\(String.getString(dicResponse[ApiParameters.message])) 🎈")
                    break;
                }
            }
            else {
                showAlertMessage.alert(message: AlertMessage.knoNetwork)
            }
        }
    }
    //func For Single Part Api
    func getApi(parameters :Dictionary<String ,Any> ,serviceName: String, completionClosure: @escaping (_ result: Any?) -> ()) -> Void{
        
        CommonUtils.showHudWithNoInteraction(show: true)
        AlmofireApiInstanse.requestApi(withServiceName: serviceName, requestMethod: .GET, requestParameters: parameters, withProgressHUD: false)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            guard self != nil else { return }
            if errorType == ErrorType.requestSuccess {
                let dicResponse     = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = dicResponse["data"]
                    completionClosure(data)
                case 501:
                    showAlertMessage.alert(message: AlertMessage.Under_Development)
                default:
                    print("\(String.getString(dicResponse[ApiParameters.message])) 🎈")
                    showAlertMessage.alert(message: "\(String.getString(dicResponse[ApiParameters.message])) 🎈")
                    break;
                }
            }
            else {
                showAlertMessage.alert(message: AlertMessage.knoNetwork)
            }
        }
    }
    
}


