//
//  AppsNetworkManager swift
//  Shubham Kaliyar
//
//  Created by Shubham Kaliyar on 17/09/19.
//  Copyright © 2019 Shubham Kaliyar. All rights reserved.



import Foundation
import UIKit
import SVProgressHUD
import AVFoundation
import Alamofire


//MARK:- Globle Variable for AppsNetworkManagerInstanse
let AppsNetworkManagerInstanse = AppsNetworkManager.sharedInstanse
let iimageCache = NSCache<NSString, AnyObject>()



//MARK:-Class For Network Manager For Api Send And Retrived Data To/From Server

public class AppsNetworkManager{
    
    /**
     A shared instance of `AppsNetworkManagerInstanse`, used by top-level UllSessions request methods, and suitable for use directly
     for any ad hoc requests.
     */
    
    internal static let sharedInstanse :AppsNetworkManager  = AppsNetworkManager()
    
    // MARK:- Func for Single part Api
    /**
     *  Initiates HTTPS or HTTP request over |HttpsMEthods| method and returns call back in success and failure block.
     *
     *  @param serviceurl  name of the service
     *  @param method       method type like Get and Post
     *  @param postData     parameters
     *  @param responeBlock call back in block
     */
    
    
    
    
    func requestApi(parameters : Dictionary<String , String>, serviceurl:String , methodType:httpMethod, completionClosure: @escaping (_ result: Any?) -> ()) -> Void {
        
        //MARK:- Check the network availability
        //        if  NetworkReachabilityManager()?.isReachable != true {
        //            showAlertMessage.alert(message: AlertMessage.knoNetwork)
        //        }
        
        
        //MARK:-Show Progress bar Hud
        self.showHudWithNoInteraction(show: true)
        
        //MARK:-Fatch URL From Strings
        let urlString = AppsNetworkManagerConstants.baseUrl + serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20")) else { return }
        print("Connecting to Host with URL \(urlString) with parameters: \(parameters)")
        
        let accessToken = kSharedUserDefaults.getLoggedInAccessToken()
        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: methodType.rawValue == httpMethod.get.rawValue ?  [:] : parameters , options: []) else {
            return
        }
        request.httpBody = httpBody
        request.setValue(accessToken, forHTTPHeaderField: AppsNetworkManagerConstants.accessToken)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request){(data , response , error) in
            print("Details: \(String(describing: data)) --- ResponseIs: \(String(describing: response)) --- ErrorIs \(String(describing: error))")
            
            self.showHudWithNoInteraction(show: false)
            
            guard error == nil else {
                //MARK:-  In Case of No Internet "Request failed with error: The Internet connection appears to be offline."
                let returnMessage = "RequestFailed :->  \(String(describing: error!.localizedDescription))"
                //MARK:-  --> Show snackbar in case of no internet connection for reload page case
                DispatchQueue.main.async { self.alert(message: returnMessage)}
                return
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                guard  let httpsresponse = response as? HTTPURLResponse else {return}
                let statusCode = httpsresponse.statusCode
                do {
                    let data = try JSONSerialization.jsonObject(with: data, options: [])
                    let response = kSharedInstance.getDictionary(data)
                    print(response)
                    switch statusCode{
                    case 200 :
                        DispatchQueue.main.async {completionClosure(response["data"])}
                    case 401:
                        DispatchQueue.main.async {
                            self.alert(message: String.getString(response[ApiParameters.message]))
                        }
                    default:
                        DispatchQueue.main.async { self.alert(message: String.getString(response[ApiParameters.message])) }
                    }
                } catch {
                    DispatchQueue.main.async { self.alert(message: String.getString(error))}
                }
            }
            
        }.resume()
    }
    
    
    //Func for Post Api MultiPart Api to send  image ,Video and File
    /**
     *  Upload multiple images and videos via multipart
     * @param send image into perticular Key
     *  @param serviceurl  name of the service
     *  @param videosArray  array having videos file path
     *  @param postData     parameters
     *  @param responeBlock call back in block
     */
    
    func requestMultipartApi(parameters : Dictionary<String , Any> , serviceurl:String , methodType:httpMethod, completionClosure: @escaping (_ result: Any?) -> ()) -> Void{
        //MARK:- fetch Url For Apia
        self.showHudWithNoInteraction(show: true)
        let urlString = AppsNetworkManagerConstants.baseUrl + serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20")) else { return }
        
        
        print("Connecting to Host with URL \(urlString) with parameters: \(parameters)")
        
        
        //MARK:- Fatch the Access Tokan And Create Header
        let accessToken = kSharedUserDefaults.getLoggedInAccessToken()
        var request = URLRequest(url: url)
        
        request.httpMethod = methodType.rawValue
        request.setValue(accessToken, forHTTPHeaderField: kAccessToken)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        //MARK:-  Boundary For Multipart Api
        let boundary =  "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! createBody(parameters: parameters, boundary: boundary, mimeType: "image/jpeg/png/jpg/docx/doc/mp4/mov/movie")
        
        
        URLSession.shared.dataTask(with: request){(data , response , error) in
            print("Details: \(String(describing: data)) --- ResponseIs: \(String(describing: response)) --- ErrorIs \(String(describing: error))")
            self.showHudWithNoInteraction(show: false)
            
            guard error == nil else {
                //MARK:-  In Case of No Internet "Request failed with error: The Internet connection appears to be offline."
                let returnMessage = "RequestFailed :->  \(String(describing: error!.localizedDescription))"
                //MARK:-  --> Show snackbar in case of no internet connection for reload page case
                DispatchQueue.main.async { self.alert(message: String.getString(returnMessage))}
                return
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                guard  let httpsresponse = response as? HTTPURLResponse else {return}
                let statusCode = httpsresponse.statusCode
                do {
                    let data = try JSONSerialization.jsonObject(with: data, options: [])
                    let response = kSharedInstance.getDictionary(data)
                    print(response)
                    switch statusCode{
                    case 200 :
                        completionClosure(response[kResponse])
                    case 401:
                        self.alert(message: String.getString(response[ApiParameters.message]))
                    default:
                        DispatchQueue.main.async { self.alert(message: String.getString(response[ApiParameters.message]))}
                    }
                    
                } catch {
                    DispatchQueue.main.async { self.alert(message: String.getString(error))}
                }
            }
            
        }.resume()
    }
    
    
    
    //MARK:- Func for Create Body for multipart Api to append Video and images
    func createBody(parameters: [String: Any], boundary: String, mimeType: String) throws -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if(value is String || value is NSString) {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            } else if let imagValue = value as? UIImage {
                let r = arc4random()
                let filename = "image\(r).jpg" //MARK:  put your imagename in key
                let data: Data = imagValue.jpegData(compressionQuality: 0.5)!
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
                
            }else if value is [String: String] {
                var body1 = Data()
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                for (keyy, valuee) in (value as? [String: String])! {
                    body1.append("--\(boundary)\r\n")
                    body1.append("Content-Disposition: form-data; name=\"\(keyy)\"\r\n\r\n")
                    body1.append("\(valuee)\r\n")
                }
                
                body.append(body1)
                
            } else if let images = value as? [UIImage] {
                
                for image in images {
                    let r = arc4random()
                    let filename = "image\(r).jpg" //MARK:  put your imagename in key
                    let data: Data = image.jpegData(compressionQuality: 0.5)!
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                    
                }
            } else if let videoData = value as? Data { //MARK:  it is Used for Video and pdf send to the server
                let r = arc4random()
                let filename = "\(key)\(r).mov" //MARK:  Put you image Name in key
                let data : Data = videoData
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.append("\r\n")
            } else if let multipleData = value as? [Data] { //MARK:  It is used for Multiple Data to api
                for filedata in multipleData {
                    let r = arc4random()
                    let filename = "\(key)\(r).mov" //MARK:-  put your imagename in key
                    let data: Data = filedata
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                    
                }
            }
        }
        body.append("--\(boundary)--\r\n")
        return body
    }
    
}




//MARK:- Class For Shared Utilities For AppsNetworkManagerInstanse
extension AppsNetworkManager {
    
    //MARK:- Func For Show Hud
    func showHudWithNoInteraction(show: Bool) {
        if show {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0))
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK: - Show Alert For Error
    func alert(message:String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel, handler: nil)
        alert.addAction(action1)
        UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
    }
    
}


//MARK:- Constant for Api For Url Sessions
struct AppsNetworkManagerConstants {
    static let baseUrl               = "18.217.107.168:3010/user/"
    static let baseUrlForimage       = "http://13.235.174.90/"
    
    static let accessToken           = "accessToken"
    
}

//MARK:- Enum For httpsMethos

enum httpMethod: String {
    case get  = "GET"
    case post = "POST"
    case put  = "PUT"
}





//MARK: - Extension for Downlode Image Using URl Sessions
extension UIImageView {
    
    //MARK:- Func for downlode image
    func downlodeImage(serviceurl:String , placeHolder: UIImage?,cache:Bool = true) {
        
        self.image = placeHolder
        let urlString = serviceurl
        guard let url = URL(string: urlString.replacingOccurrences(of:  " ", with: "%20")) else { return }
        
        //MARK:- Check image Store in Cache or not
      
            if let cachedImage = iimageCache.object(forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString) {
                if  let image = cachedImage as? UIImage {
                    self.image = image
                    print("Find image on Cache : For Key" , urlString.replacingOccurrences(of: " ", with: "%20"))
                    return
                }
            }
       
       
        
        print("Conecting to Host with Url:-> \(url)")
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.image = placeHolder
                    return
                }
            }
            if data == nil {
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                return
            }
           
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        iimageCache.removeAllObjects()
                        self.image = image
                        iimageCache.setObject(image, forKey: urlString.replacingOccurrences(of: " ", with: "%20") as NSString)
                    }
                

            }
        }).resume()
    }
}

//MARK:- Extension of Data For Apped String
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
