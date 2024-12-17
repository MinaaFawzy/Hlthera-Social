//
//  ChatViewController_Ext_MediaChat.swift
//  RippleApp
//
//  Created by Mohd Aslam on 05/05/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

extension ChatViewController {
        
    //MARK:- Func for Send Image To server and save Data on Firebase
    func uploadImagesVideos(imageOrVideo:Any,isImage:Bool,isAudio:Bool = false){
        let params:[String:Any] = ["type":"2"]
        var video:[String:Any] = [:]
        var image:[String:Any] = [:]
        if isImage{
            let img = imageOrVideo as? UIImage
            
            image = ["imageName":"picture","image": img ?? UIImage()]
        }
        else if isAudio{
            let vid = imageOrVideo as! URL
            video = [ApiParameters.kRecordedAudio : vid, ApiParameters.kRecordedAudioName : "picture"]
        }
        else{
            let vid = imageOrVideo as! URL
            video = [ApiParameters.kvideo : vid, ApiParameters.kvideoName : "picture"]
        }
        CommonUtils.showHudWithNoInteraction(show: false)
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.upload_banner, method: .post, arrImages: [image], video: video,document: [[:]],  parameters: params)
                {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    kBucketUrl = "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/"
                    let mediaUrl =  kBucketUrl+String.getString(dictResult["img_url"])
                    
                    if isImage{
                        
                       
                        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
                        
                        let dic:[String:Any] = [Parameters.senderid: String.getString(UserData.shared.id),
                                   Parameters.sendername:String.getString(UserData.shared.full_name),
                                   Parameters.content: mediaUrl ,
                                   Parameters.timeStamp : timeStamp ,
                                   Parameters.receiverid  : String.getString(self?.receiverid),
                                   Parameters.mediatype : "photos",
                                   "profileImage":"",
                                  ]
                        
                        //let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Image") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "image" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : "UserData.shared.first_name", "to_name" : self.receivername , "img_type": "Camera", Parameters.status : "not_seen"]
                        //ana padega
                       
                        Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic),recentDic: kSharedInstance.getDictionary(dic), Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self?.receiverid))
                        Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString(mediaUrl), Receiverid: String.getString(self?.receiverid), Senderid: String.getString(UserData.shared.id), name: String.getString(self?.receivername), lastTimestamp: Int64(timeStamp),type: "photos")
                        //self.saveMessageLocallyInDatabase(mediaurl: mediaUrl, mediatype: "image", message: String.getString("Image"), thumnilimageurl: "")
                        //Func for resend users
                        //self.unread_count += 1
                        //Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Image"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: Int64(timeStamp) ?? 0, msgReceiverId: String.getString(self.receiverid), unreadCount: self.unread_count , friendStatus: self.isFriend )
                        
                    }
                    
                    else{
                        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
                        
                        let dic:[String:Any] = [Parameters.senderid: String.getString(UserData.shared.id),
                                   Parameters.sendername:String.getString(UserData.shared.full_name),
                                   Parameters.content: mediaUrl ,
                                   Parameters.timeStamp : timeStamp ,
                                   Parameters.receiverid  : String.getString(self?.receiverid),
                                   Parameters.mediatype : isAudio ? "audio" : "videos",
                                   "profileImage":"",
                                  ]
                        Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic),recentDic: kSharedInstance.getDictionary(dic), Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self?.receiverid))
                        Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString(mediaUrl), Receiverid: String.getString(self?.receiverid), Senderid: String.getString(UserData.shared.id), name: String.getString(self?.receivername), lastTimestamp: Int64(timeStamp),type: isAudio ? "audio" : "videos")
                        
                    }
                    
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

    
    //MARK:- Func for Send Video To server and save Data on Firebase for Video
    func uploadVideos(imageOrVideo:Any){
        var param:[String:Any]?
        
            param = ["vedio":(imageOrVideo as! VideoData).videoData,
                     "image":(imageOrVideo as! VideoData).thumbnilImage
            ]
        
        let url = ""
        AppsNetworkManagerInstanse.requestMultipartApi(parameters: param ?? [:], serviceurl: url, methodType: .post){result in
                
                let mediaDict = kSharedInstance.getDictionary(result)
                let mediaUrl = String.getString(mediaDict["chatDocumentPath"])
                let thumb = String.getString(mediaDict["image"])
                let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
                let completeName = self.userDetails[Parameters.name] as? String ?? ""
                
                let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Video") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : String.getString(thumb) , Parameters.mediatype : "video" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : self.receivername, "img_type": "", Parameters.status : "not_seen"]
              //  Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid))
                //self.saveMessageLocallyInDatabase(mediaurl: mediaUrl, mediatype: "video", message: String.getString("Video"), thumnilimageurl: thumb)
                //Func for resend users
                self.unread_count += 1
            //Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Video"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: Int64(timeStamp) ?? 0, msgReceiverId: String.getString(self.receiverid), unreadCount: self.unread_count, friendStatus: self.isFriend)
                
                print("Success")
        }
    }
    
    
    //MARK:- Func for Send Audio To server and save Data on Firebase for Audio
    func sendDocFile(fileURL :URL?){
        
        if fileURL != nil {
            do {
                let data = try Data(contentsOf: fileURL!)
                let docThumbnail = Chat_hepler.Shared_instance.pdfThumbnailFromData(data: data)
                
//                var param:[String:Any]?
//                param = ["document":data, "documentName": String.getString(doc)]
                let params:[String:Any] = ["type":"2"]
                
                let document:[String:Any] = ["documentName":"picture","document":fileURL]
                
                let url = ""
                
                NetworkManager.shared.requestMultiParts(serviceName: ServiceName.upload_banner, method: .post, arrImages: [], video: [:],document: [document],  parameters: params)
                {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let mediaUrl =  String.getString(dictResult["img_url"])
                    
                   
                    let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
                    
                    let dic:[String:Any] = [Parameters.senderid: String.getString(UserData.shared.id),
                               Parameters.sendername:String.getString(UserData.shared.full_name),
                               Parameters.content: mediaUrl ,
                               Parameters.timeStamp : timeStamp ,
                               Parameters.receiverid  : String.getString(self?.receiverid),
                               Parameters.mediatype : "doc",
                               "profileImage":"",
                              ]
                    
                    //let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Image") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "image" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : "UserData.shared.first_name", "to_name" : self.receivername , "img_type": "Camera", Parameters.status : "not_seen"]
                    //ana padega
                   
                    Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic),recentDic: kSharedInstance.getDictionary(dic), Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self?.receiverid))
                    Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString(mediaUrl), Receiverid: String.getString(self?.receiverid), Senderid: String.getString(UserData.shared.id), name: String.getString(self?.receivername), lastTimestamp: Int64(timeStamp),type: "doc")
                    
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }

                
                
                
                
//                {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//                    let data =  String.getString(dictResult["img_url"])
//
//                    let mediaDict = kSharedInstance.getDictionary(result)
//                    let mediaUrl = String.getString(mediaDict["chatDocumentPath"])
//                    let mediaThumbImage = String.getString(mediaDict["image"])
//                    let fileName =  fileURL?.lastPathComponent ?? ""
//
//                    let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
//                    let completeName = self.userDetails[Parameters.name] as? String ?? ""
//
//                    let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Document") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : mediaThumbImage , Parameters.mediatype : "document" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : self.receivername, "img_type": "", Parameters.status : "not_seen", Parameters.mediaName: fileName]
//                  //  Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid))
//                    //Func for resend users
//                    self.unread_count += 1
//                    //self.saveMessageLocallyInDatabase(mediaurl: mediaUrl, mediatype: "audio", message: String.getString("Audio"), thumnilimageurl: "")
//                   // Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Document"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: Int64(timeStamp) ?? 0, msgReceiverId: String.getString(self.receiverid), unreadCount: self.unread_count, friendStatus: self.isFriend)
//
//
//                        print("Success")
//                }
                
            } catch {
                print_debug(items:"Unable to load data: \(error)")
            }
        }else {
            
        }
        
        
    }
    func sendGif(url:String){
        
       
                    let mediaUrl =  url
                    
                   
                    let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
                    
                    let dic:[String:Any] = [Parameters.senderid: String.getString(UserData.shared.id),
                               Parameters.sendername:String.getString(UserData.shared.full_name),
                               Parameters.content: mediaUrl ,
                               Parameters.timeStamp : timeStamp ,
                               Parameters.receiverid  : String.getString(self.receiverid),
                               Parameters.mediatype : "gif",
                               "profileImage":"",
                              ]
                    
                    //let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString("Image") , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "image" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  String.getString(self.userDetails[Parameters.name] ),   Parameters.mediaurl :  mediaUrl , Parameters.groupid :  "",Parameters.groupname : "","from_name" : "UserData.shared.first_name", "to_name" : self.receivername , "img_type": "Camera", Parameters.status : "not_seen"]
                    //ana padega
                   
                    Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic),recentDic: kSharedInstance.getDictionary(dic), Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self.receiverid))
                    Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString(mediaUrl), Receiverid: String.getString(self.receiverid), Senderid: String.getString(UserData.shared.id), name: String.getString(self.receivername), lastTimestamp: Int64(timeStamp),type: "gif")
                    
              

                
                
                
                

         
        
        
    }
}
