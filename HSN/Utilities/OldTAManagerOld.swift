//
//  NetworkManagerOld.swift
//  Hlthera
//
//  Created by Prashant Panchal on 24/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import Foundation
import Alamofire

//let baseURL      = "http://52.0.212.19:8080/"
let imageBaseURL = kBucketUrl
//let baseURL = "http://15.207.30.218"
//let baseURL = "http://yo-100.com/"
public enum ErrorTypes: Error {
    case noNetwork, requestSuccess, requestFailed, requestCancelled
}

public class NetworkManager {
    
    struct Keys {
        static let image            = "image"
        static let imageName        = "imageName"
        static let document         = "document"
        static let documentName     = "documentName"
        static let video            = "video"
        static let videoName        = "videoName"
    }
    
    internal static let shared: NetworkManager = {
        return NetworkManager()
    }()
    
    // method for requestAPI
    
    func request(serviceName: String, method: HTTPMethod, parameters: Dictionary<String, Any>, completion: @escaping(_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> Void) {
        
        //statement to ensure network connectivity
        guard let isNetworkReachable    = NetworkReachabilityManager.init()?.isReachable else {
            return
        }
        
        if isNetworkReachable {
            
            let headers             : [String: String]      = self.getHeaders()
            let serviceURL          : String                = self.getServiceUrl(serviceName: serviceName)
            var encoding            : ParameterEncoding     = URLEncoding.default
            let params              : String                = self.getPrintableParamsFromJson(postData: parameters)
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            // switch to ensure encoding format
            switch method {
            case .get,.delete:
                encoding    = URLEncoding.default
            case .post:
                encoding    = JSONEncoding.prettyPrinted
                break;
            case .put, .patch:
                encoding    = JSONEncoding.default
            default:
                break;
            }
            
            let dataRequest: DataRequest    = Alamofire.request(serviceURL, method: method, parameters: parameters, encoding: encoding, headers: headers)
            dataRequest.responseJSON(completionHandler: {(dataResponse) in
                switch dataResponse.result {
                case .success(let json):
                    print_debug(items: "Success with JSON: \(json)")
                    print_debug(items: "Success with Status Code: \(String(describing: dataResponse.response?.statusCode))")
                    let statusCode  = dataResponse.response?.statusCode ?? 0
                    if statusCode   == 5000 {
                        
                    } else {
                        let responseDict = self.getResponseDictionaryFromData(data: dataResponse.data!)
                        completion(responseDict.responseData, responseDict.error, ErrorType.requestSuccess, dataResponse.response?.statusCode)
                    }
                case .failure(let error):
                    print_debug(items: "json error: \(error.localizedDescription)")
                    if error.localizedDescription == "cancelled" {
                        completion(nil, error, .requestCancelled, dataResponse.response?.statusCode)
                    } else {
                        completion(nil, error, .requestFailed, dataResponse.response?.statusCode)
                    }
                }
            })
            
        } else {
            completion(nil, nil, .noNetwork, nil)
        }
    }
    
    func requestLinkedinEmail(token: String, completion: @escaping(_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> Void) {
        
        //statement to ensure network connectivity
        guard let isNetworkReachable = NetworkReachabilityManager.init()?.isReachable else {
            return
        }
        
        if isNetworkReachable {
            
            let headers             : [String: String]      = self.getLinkedinHeader(token)
            let serviceURL          : String                = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"
            print_debug(items: "Connecting to Host with URL \(serviceURL)")
            
            let dataRequest: DataRequest    = Alamofire.request(serviceURL, encoding: URLEncoding.default, headers: headers)
            
            dataRequest.responseJSON(completionHandler: {(dataResponse) in
                switch dataResponse.result {
                case .success(let json):
                    print_debug(items: "Success with JSON: \(json)")
                    print_debug(items: "Success with Status Code: \(String(describing: dataResponse.response?.statusCode))")
                    let statusCode  = dataResponse.response?.statusCode ?? 0
                    if statusCode   == 5000 {
                        // CommonUtils.showNotification(message: CommonAlert.sessionExpired)
                    } else {
                        let responseDict = self.getResponseDictionaryFromData(data: dataResponse.data!)
                        completion(responseDict.responseData, responseDict.error, ErrorType.requestSuccess, dataResponse.response?.statusCode)
                    }
                case .failure(let error):
                    print_debug(items: "json error: \(error.localizedDescription)")
                    if error.localizedDescription == "cancelled" {
                        completion(nil, error, .requestCancelled, dataResponse.response?.statusCode)
                    } else {
                        completion(nil, error, .requestFailed, dataResponse.response?.statusCode)
                    }
                }
            })
            
        } else {
            completion(nil, nil, .noNetwork, nil)
        }
    }
    
    func requestMultiParts(serviceName: String, method: HTTPMethod, arrImages: [Dictionary<String, Any>], video: Dictionary<String, Any>, document: Array<Dictionary<String, Any>> = [[:]], parameters: Dictionary<String, Any>, completionClosure: @escaping (_ result: Any?, _ error: Error?, _ errorType: ErrorType, _ statusCode: Int?) -> ()) -> Void {
        
        guard let isNetworkReachable    = NetworkReachabilityManager.init()?.isReachable else {
            return
        }
        
        if isNetworkReachable {
            
            let headers             : [String: String]      = self.getHeaders()
            let serviceURL          : String                = self.getServiceUrl(serviceName: serviceName)
            let params              : String                = self.getPrintableParamsFromJson(postData: parameters)
            print_debug(items: "Connecting to Host with URL \(kBASEURL)\(serviceName) with parameters: \(params)")
            
            Alamofire.upload(multipartFormData:{ (multipartFormData: MultipartFormData) in
                for (key,value) in parameters {
                    
                    if key == "posted_picture_ids[]" {
                        for loc in kSharedInstance.getStringArray(value) {
                            multipartFormData.append(self.convertToData(loc),withName: key)
                        }
                    } else {
                        multipartFormData.append(self.convertToData(value),withName: key)
                    }
                }
                
                let videoDic    = kSharedInstance.getDictionary(video)
                //let videoData   = videoDic["video"] as? Data
               
                
//                if videoData != nil {
//                    multipartFormData.append(videoData!, withName: videoDic["videoName"] as! String, fileName: "messagevideo.mp4", mimeType: "video/mp4")
//                }
                if let videoData = videoDic["video"] as? URL {
                    multipartFormData.append(videoData,
                                             withName: videoDic["videoName"] as! String,
                                             fileName: "messagevideo.mp4",
                                             mimeType: "video/mp4")
                }
                if let videoData = videoDic["recordedAudio"] as? URL {
                    
//                    multipartFormData.append(videoData,
//                                             withName: videoDic["recordedAudioName"] as! String,
//                                             fileName: "messagevideo.mp4",
//                                             mimeType: "video/mp4")
                    multipartFormData.append(videoData, withName: String.getString(videoDic["recordedAudioName"]), fileName: String.getString(NSNumber.getNSNumber(message: self.getCurrentTimeStamp()).intValue) + "audiofile.m4a", mimeType: "audio/m4a")
                }
                //document section
                let documentDic = kSharedInstance.getDictionaryArray(withDictionary: document)
                for docs in documentDic {
                    
                    if let docURL = docs["document"] as? URL {
                        do{
                            let data = try Data.init(contentsOf: docURL)
                            
                            multipartFormData.append(data, withName: docs["documentName"] as! String, fileName: "document.pdf", mimeType: "application/pdf")
                        } catch(let error) {
                        }
                    }
                }
                
                for dictImage in arrImages {
                    let validDict = kSharedInstance.getDictionary(dictImage)
                    if let image = validDict["image"] as? UIImage {
                        if let imageData: Data = image.jpegData(compressionQuality: 0.5) {
                            multipartFormData.append(imageData,
                                                     withName   : String.getString(validDict["imageName"]),
                                                     fileName   :String.getString(validDict["imageName"]) + String.getString(NSNumber.getNSNumber(message:      self.getCurrentTimeStamp()).intValue) + ".jpeg",
                                                     mimeType   : "image/jpeg")
                        }
                    }
                }
                
            }, to                   : serviceURL,
               method               : method,
               headers              :headers,
               encodingCompletion   : { (encodingResult: SessionManager.MultipartFormDataEncodingResult) in
                switch encodingResult {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.responseJSON(completionHandler: { (Response) in
                        print_debug(items: "Status code :- \(Response.response?.statusCode ?? 0)")
                        let response = self.getResponseDictionaryFromData(data: Response.data!)
                        completionClosure(response.responseData, response.error, .requestSuccess, Response.response?.statusCode)
                    })
                case .failure(let error):
                    completionClosure(nil, error, .requestFailed, 200)
                }
            })
        } else {
            completionClosure(nil, nil, .noNetwork, nil)
        }
    }
    
    /** returns header details */
    private func getHeaders() -> Dictionary<String, String> {
        let headers: [String: String] = ["accessToken" : String.getString(kSharedUserDefaults.getLoggedInAccessToken())]
        print_debug(items: "with accessToken: \(String.getString(kSharedUserDefaults.getLoggedInAccessToken()))")
        return headers
    }
    
    private func getLinkedinHeader(_ token: String) -> Dictionary<String, String> {
        let headers: [String: String] = [kAccessToken : String.getString(kSharedUserDefaults.getLoggedInAccessToken()),
                                         "Authorization" : "Bearer \(token)"]
        return headers
    }
    
    private func getPrintableParamsFromJson(postData: Dictionary<String, Any>) -> String {
        do {
            let jsonData        = try JSONSerialization.data(withJSONObject: postData, options:JSONSerialization.WritingOptions.prettyPrinted)
            let theJSONText     = String(data:jsonData, encoding:String.Encoding.ascii)
            return theJSONText ?? ""
        } catch let error as NSError {
            print_debug(items: String.getString(error))
            return ""
        }
    }
    
    private func getServiceUrl(serviceName: String) -> String {
        if serviceName.contains("http") {
            return serviceName
        } else {
            return kBASEURL + serviceName
        }
    }

    /** Convert responseData to jsonObject */
    func getResponseDictionaryFromData(data: Data) -> (responseData: Dictionary<String, Any>?, error: Error?) {
        do {
            let dataResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            print_debug(items: "Success with JSON: \(String(describing: dataResponse))")
            return (responseData: dataResponse, error: nil)
        } catch let error {
            return (responseData: nil, error: error)
        }
    }
    
    private func convertToData(_ value:Any) -> Data {
        if let str =  value as? String {
            return String.getString(str).data(using: String.Encoding.utf8)!
        } else if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
            return jsonData
        } else {
            return Data()
        }
    }
    
    private func getCurrentTimeStamp()-> TimeInterval {
        return NSDate().timeIntervalSince1970.rounded();
    }
}

func print_debug(items: String) {
    print(items)
}
