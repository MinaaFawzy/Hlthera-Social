//
//  Chat_Helper.swift
//  RippleApp
//
//  Created by Mohd Aslam on 30/04/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import AVKit
import AVFoundation
import PDFKit

extension Array {
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        return result
    }
    //self.MessageObjList = self.MessageObjList.removingDuplicates(byKey: { $0.SendingTime })
}

class Chat_hepler {
    
    
    //MARK:- Object for Chat Halper
    static let Shared_instance = Chat_hepler()
    var Databasereference: DatabaseReference!
    var dicResponce:[String:Any]?
    var Messageclass = [MessageClass]()
    var ChatBackupOnetoOne = [ChatbackupOnetoOne]()
    var ResentUser = [ResentUsers]()
    var recentUsers:[RecentUsersListModel] = []
    var userState :UsersState?
    var receiverprofile_image:String?
    var readmessagesCountCheck = false
    let resentReferense = Database.database().reference().child(Parameters.ResentMessage)
    let privateMessageReference = Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages)
    let callReference = Database.database().reference().child(Parameters.Call)
    let typingReferense = Database.database().reference().child(Parameters.typingStat)
    
    // MARK: - Function For Send message one to one Chat
    func SendMessage(dic: Dictionary<String, Any>, recentDic: Dictionary<String, Any>, Senderid: String, Receiverid: String) {
        let node = Int.getInt(Senderid) < Int.getInt(Receiverid) ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" :  "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        let messageData = kSharedInstance.getDictionary(dic)
        // messageData["chat_id"] = String.getString(node)
        
        if String.getString(node) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        let ref =  Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).childByAutoId()
        // let refRecentChat =  Database.database().reference().child(Parameters.message).child(Parameters.recentChats).child(Senderid).child(Receiverid).childByAutoId()
        let autoKey = "\(String.getString(ref.key))"
        //refRecentChat.setValue(kSharedInstance.getDictionary(kSharedInstance.getDictionary(recentDic)))
        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(autoKey).setValue(kSharedInstance.getDictionary(messageData))
        
        DispatchQueue.main.async {
            self.sendChatMessageAPI(friend_id: Receiverid, message: String.getString(messageData[Parameters.content]), chat_id: node, timeStamp: "", message_id: autoKey)
        }
    }
    
    
    
    //MARK:- Func For Receive Message for One To One Chat
    func Receivce_message(Senderid :String , Receiverid:String , message:@escaping (_ result: [MessageClass]? , _ chatBackup : [ChatbackupOnetoOne]?, _ success: Bool, _ isExist: Bool) -> ()) -> Void {
        self.Messageclass.removeAll()
        self.ChatBackupOnetoOne.removeAll()
        let node = Int.getInt(Senderid) < Int.getInt(Receiverid) ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" : "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if String.getString(node) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).observe(.value) { (snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                //self.Messageclass.removeAll()
                
                if let nav = UIApplication.shared.windows.first?.rootViewController as? UINavigationController{
                    //let vc = nav.viewControllers
                    let vc = nav.viewControllers.last
                    if vc?.isKind(of: ChatViewController.self) ?? false {
                        //   #anapadega
                        MessageList.saveMessages(result: msgs, userId: Receiverid)
                    }
                }
                
                
                //                else {
                //
                //                msgs.forEach {(key, value) in
                //                    let dic = kSharedInstance.getDictionary(value)
                //                     let chatId       = String.getString(dic[Parameters.chat_id])
                //                    let messageId = String.getString(key)
                //
                //                    if !chatId.isEmpty && !messageId.isEmpty {
                //                    Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(chatId).child(messageId).child(Parameters.status).observeSingleEvent(of: .value, with: { (SnapShot) in
                //                        if SnapShot.exists() {
                //                            let status = SnapShot.value as? String  ?? ""
                //                            if status != "seen" {
                //                                Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(chatId).child(messageId).updateChildValues([Parameters.status : "sent"])
                //                            }
                //
                //                        }
                //                    })
                //                    }
                //                  }
                //                }
                message(self.Messageclass, self.ChatBackupOnetoOne, true, true)
            }else {
                MessageList.deleteMessagesForUser(userid: node)
                message(self.Messageclass, self.ChatBackupOnetoOne, true, false)
            }
        }
        
        
        
        message(self.Messageclass, self.ChatBackupOnetoOne, false, false)
    }
    
    func Receivce_Unread_message(Senderid :String , Receiverid:String, message:@escaping (_ isExist: Bool) -> ()) {
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" : "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if String.getString(node) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).queryOrdered(byChild: Parameters.status).queryEqual(toValue: "not_seen").observe(.value) { (snapshot) in
            
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                guard let vc = UIApplication.topViewController() else { return }
                if vc .isKind(of: ChatViewController.self) {
                    //MessageList.saveUnreadMessages(result: msgs, userId: Receiverid)
                }
                else {
                    
                    msgs.forEach {(key, value) in
                        let dic = kSharedInstance.getDictionary(value)
                        let chatId       = String.getString(dic[Parameters.chat_id])
                        let messageId = String.getString(key)
                        
                        if !chatId.isEmpty && !messageId.isEmpty {
                            Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(chatId).child(messageId).child(Parameters.status).observeSingleEvent(of: .value, with: { (SnapShot) in
                                if SnapShot.exists() {
                                    let status = SnapShot.value as? String  ?? ""
                                    if status != "seen" {
                                        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(chatId).child(messageId).updateChildValues([Parameters.status : "sent"])
                                    }
                                    
                                }
                            })
                        }
                    }
                }
                message(true)
            }
            
        }
        message(false)
        
    }
    
    func Receivce_Delivered_message(Senderid :String , Receiverid:String, message:@escaping (_ isExist: Bool) -> ()) {
        
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" : "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if String.getString(node) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).queryOrdered(byChild: Parameters.status).queryEqual(toValue: "sent").observe(.value) { (snapshot) in
            
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                guard let vc = UIApplication.topViewController() else { return }
                if vc .isKind(of: ChatViewController.self) {
                    
                    MessageList.saveUnreadMessages(result: msgs, userId: Receiverid)
                }
                message(true)
            }
        }
        message(false)
    }
    
    //MARK:- Func For send Resent Users and retrived data On resent Users Submit Data to Users Every User Submit 2 Node Data Sender and Receiver
    func ResentUser(lastmessage:String, Receiverid:String , Senderid :String  , name:String , lastTimestamp: Int64,type:String) {
        
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let userSenderId = UserData.shared.id
        if String.getString(userSenderId) == Parameters.emptyString || String.getString(Receiverid) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        
        let dic = [ Parameters.from: String.getString(UserData.shared.id),
                    Parameters.last_message: String.getString(lastmessage),
                    Parameters.name: String.getString(name),
                    Parameters.node_id : String.getString(""),
                    Parameters.readMessage : String.getString("1") ,
                    Parameters.readonly : false,
                    Parameters.status : String.getString(""),
                    Parameters.timestamp:String.getString(lastTimestamp),
                    Parameters.to:Receiverid,
                    Parameters.type:type,
                    Parameters.unread:"",
                    
                    
        ] as [String : Any]
        
        
        
        
        Database.database().reference().child(Parameters.Message).child(Parameters.ResentMessage).child(String.getString( "\(String.getString(UserData.shared.id))")).child(String.getString("\(String.getString(Receiverid))")).updateChildValues(kSharedInstance.getDictionary(dic))
        Database.database().reference().child(Parameters.Message).child(Parameters.ResentMessage).child(String.getString( "\(String.getString(Receiverid))")).child(String.getString("\(String.getString(UserData.shared.id))")).updateChildValues(kSharedInstance.getDictionary(dic))
        
        //Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(userSenderId))")).updateChildValues(dicuser)
        
    }
    //    func ResentUser(lastmessage:String, Receiverid:String , Senderid :String  , name:String , profile_image:String , readState :String, isMsgSend: Bool, lastTimestamp: Int64, msgReceiverId: String, unreadCount: Int, friendStatus: Bool, callStatus: String = "0") {
    //
    //        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
    //        let userSenderId = String.getString(userDetails[Parameters.user_id])
    //        if String.getString(userSenderId) == Parameters.emptyString || String.getString(Receiverid) == Parameters.emptyString {
    //            print(Parameters.alertmessage)
    //            return
    //        }
    //
    //
    //        let dic = [ Parameters._id: String.getString(Receiverid),
    //                    Parameters.name: String.getString(name),
    //                    Parameters.profile_image: String.getString(profile_image),
    //                    Parameters.lastmessage : String.getString(lastmessage),
    //                    Parameters.timeStamp : String.getString(lastTimestamp) ,
    //                    Parameters.readState : String.getString(readState),
    //                    Parameters.senderid : String.getString(Senderid),
    //                    Parameters.receiverid : String.getString(msgReceiverId),
    //                    Parameters._friend : friendStatus,
    //                    Parameters.call_status: callStatus
    //        ] as [String : Any]
    //
    //        let unreadDict = [Receiverid: unreadCount]
    //
    //        let dicuser = [Parameters._id: String.getString(userDetails[Parameters.user_id]),
    //                       Parameters.name: String.getString("\(String.getString(userDetails["name"]))"),
    //                       Parameters.profile_image: String.getString(userDetails["profilePicture"]),
    //                       Parameters.lastmessage : String.getString(lastmessage),
    //                       Parameters.timeStamp : String.getString(lastTimestamp) ,
    //                       Parameters.readState : String.getString(readState),
    //                       Parameters.senderid : String.getString(Senderid),
    //                       Parameters.receiverid : String.getString(msgReceiverId),
    //                       Parameters.unread_count: unreadDict,
    //                       Parameters._friend : friendStatus
    //        ] as [String : Any]
    //
    //
    //        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(userSenderId))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).updateChildValues(dic)
    //
    //        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(userSenderId))")).updateChildValues(dicuser)
    //
    //    }
    
    func changeStatusFromBackground() {
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let userIdStr = String.getString(userDetails[Parameters.user_id])
        if userIdStr == "" {
            return
        }
        Database.database().reference().child(Parameters.ResentMessage).child("user_" + userIdStr).observeSingleEvent(of: .value) { [weak self](snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                
                msgs.forEach {(key, value) in
                    let dic = kSharedInstance.getDictionary(value)
                    
                    let Senderid = String.getString(dic[Parameters.senderid])
                    let Receiverid = String.getString(dic[Parameters.receiverid])
                    
                    var friendId = Receiverid
                    if Receiverid == userIdStr {
                        friendId = Senderid
                    }
                    if !friendId.isEmpty {
                        
                        Chat_hepler.Shared_instance.getUeadCountForAConversation(Senderid: friendId, Receiverid: userIdStr) { (count, success) in
                            if success {
                                if count > 0 {
                                    Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(friendId))")).child(String.getString("user_" + "\(String.getString(userIdStr))")).observeSingleEvent(of: .value) { (snapshot) in
                                        if snapshot.exists() {
                                            Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(friendId))")).child(String.getString("user_" + "\(String.getString(userIdStr))")).updateChildValues([Parameters.readState : "sent"])
                                        }
                                    }
                                    
                                    self?.readAllMessageFromBackground(Senderid: userIdStr, Receiverid: friendId)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func readAllMessageFromBackground(Senderid :String , Receiverid:String) {
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" : "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if String.getString(node) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                
                msgs.forEach {(key, value) in
                    let dic = kSharedInstance.getDictionary(value)
                    let deleteStr = String.getString(dic[Parameters.isDeleted])
                    if deleteStr == "" {
                        self.readPerticularMsgFromBackground(data: dic, Senderid: Senderid, Receiverid: Receiverid, uid: String.getString(key))
                    }
                    
                }
            }
            
        }
        
    }
    
    func readPerticularMsgFromBackground(data: [String: Any], Senderid :String , Receiverid:String, uid: String)  {
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" : "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if String.getString(node) == Parameters.emptyString || String.getString(Senderid) == Parameters.emptyString || String.getString(Receiverid) == Parameters.emptyString || String.getString(uid) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        let msgSenderId  = String.getString(data[Parameters.senderid])
        let status = String.getString(data["status"])
        
        if status == "not_seen" || status == "sent" || status == "" {
            if msgSenderId.count > 1 {
                Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(uid).child(Parameters.senderid).observeSingleEvent(of: .value, with: { (SnapShot) in
                    if SnapShot.exists() {
                        let str = SnapShot.value as? String ?? ""
                        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
                        if str != String.getString(userDetails[Parameters.user_id]) && str.count > 1{
                            
                            Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(uid).updateChildValues([Parameters.status : "sent"])
                            
                            NotificationCenter.default.post(name: NSNotification.Name(Notifications.kChatNotificationReceived), object: nil)
                            
                        }
                    }
                })
                
                
            }
        }
        
    }
    
    func readPerticularMsgInForeround(data: [String: Any])  {
        let messageId = String.getString(data["message_id"])
        let chatId = String.getString(data["chat_id"])
        let senderId = String.getString(data["sender_id"])
        let receiverId = String.getString(data["friend_id"])
        //let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        //let userid = String.getString(userDetails[APIKeys.user_id])
        
        if chatId == "" || messageId == "" || receiverId == ""{
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(Notifications.kChatNotificationReceived), object: nil)
        
        Chat_hepler.Shared_instance.Receivce_Unread_message(Senderid: senderId, Receiverid: receiverId) { (isExist) in
            
        }
        
        //Private Message
        //        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(chatId).child(messageId).child(Parameters.status).observeSingleEvent(of: .value, with: { (SnapShot) in
        //            if SnapShot.exists() {
        //                let status = SnapShot.value as? String  ?? ""
        //                if status != "seen" {
        //                    Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(chatId).child(messageId).updateChildValues([Parameters.status : "sent"])
        //                }
        //
        //            }
        //        })
        
        //Recent Message
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(senderId))")).child(String.getString("user_" + "\(String.getString(receiverId))")).child(Parameters.readState).observeSingleEvent(of: .value, with: { (SnapShot) in
            if SnapShot.exists() {
                let status = SnapShot.value as? String  ?? ""
                if status != "seen" {
                    Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(senderId))")).child(String.getString("user_" + "\(String.getString(receiverId))")).updateChildValues([Parameters.readState : "sent"])
                }
                
            }
        })
        
    }
    func AllUsers(users:@escaping (_ result: [String:Any]?) -> ()){
        
        Database.database().reference().child(Parameters.Message).child(Parameters.users).observe(.value) { [weak self](snapshot) in
            if snapshot.exists() {
                let data = kSharedInstance.getDictionary(snapshot.value)
                
                guard let vc = UIApplication.shared.windows.first?.rootViewController as? UINavigationController else {
                    return
                }
                
                if let topVC = vc.topViewController?.isKind(of: MessagesVC.self){
                    
                    users(data)
                    
                    //NotificationCenter.default.post(name: NSNotification.Name(Notifications.kChatNotificationReceived), object: nil)
                    
                }
                
            }
        }
    }
    //MARK:- Func For Resent Users retrived on Recent Screen user User Id
    
    
    func Resent_Users(userid:String , message:@escaping (_ result: [ResentUsers]?) -> ()) -> Void{
        if userid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        self.ResentUser.removeAll()
        //Database.database().reference().child(Parameters.ResentMessage).child("user_" + "\(String.getString(userid))")
        Database.database().reference().child(Parameters.Message).child(Parameters.recentChats).child("\(String.getString(userid))").observe(.value) { [weak self](snapshot) in
            if snapshot.exists() {
                var msgs:[String:Any] = [:]
                
                if let dic = snapshot.value as? [String:Any]{
                    msgs = dic
                }
                else{
                    if let arr = snapshot.children.allObjects as? [DataSnapshot] {
                        msgs = [:]
                        arr.forEach{msgs[$0.key] = $0.value}
                        
                    }
                    
                }
                
                
                
                
                self?.ResentUser.removeAll()
                guard let vc = UIApplication.shared.windows.first?.rootViewController as? UINavigationController else {
                    return
                }
                
                if let topVC = vc.topViewController?.isKind(of: MessagesVC.self){
                    
                    ResentUsers.saveRecentUser1(result: msgs)
                    //NotificationCenter.default.post(name: NSNotification.Name(Notifications.kChatNotificationReceived), object: nil)
                    
                }
                
                msgs.forEach {(key, value) in
                    let dic = kSharedInstance.getDictionary(value)
                    let sendId = String.getString(dic["from"])
                    let recId = String.getString(dic["to"])
                    if recId.count > 1 {
                        var friendId = recId
                        if userid == recId {
                            friendId = sendId
                        }
                        if !(vc .isKind(of: ChatViewController.self)) {
                            let unreadDic = kSharedInstance.getDictionary(dic[Parameters.unread_count])
                            var count = 0
                            unreadDic.forEach {(key, value) in
                                count = Int.getInt(value)
                            }
                            //                            if count > 0 {
                            //                                Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(friendId))")).child(String.getString("user_" + "\(String.getString(userid))")).observeSingleEvent(of: .value) { (snapshot) in
                            //                                    if snapshot.exists() {
                            //                                        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(friendId))")).child(String.getString("user_" + "\(String.getString(userid))")).updateChildValues([Parameters.readState : "sent"])
                            //                                    }
                            //                                }
                            //
                            //                                //Messages
                            //                                Chat_hepler.Shared_instance.Receivce_Unread_message(Senderid: userid, Receiverid: String.getString(friendId)) { (isExist) in
                            //
                            //                                }
                            //
                            //                                //                                 Chat_hepler.Shared_instance.Receivce_message(Senderid: userid, Receiverid: String.getString(friendId)) { (value, ChatBackUp, success, isExist)  in
                            //                                //
                            //                                //                                }
                            //                            }
                        }
                        
                    }
                    
                }
            }else {
                ResentUsers.deleteChatListForUser(userid: String.getString(userid))
            }
            
            message(self?.ResentUser)
        }
    }
    
    
    /*/MARK:- Func For Resent Users retrived on Recent Screen user User Id
     
     func Resent_UsersList(userid:String , message:@escaping (_ result: [ResentUsers]?) -> ()) -> Void{
     
     if userid == Parameters.emptyString {
     print(Parameters.alertmessage)
     return
     }
     
     self.ResentUser.removeAll()
     Database.database().reference().child(Parameters.Users).observe(.value) { [weak self](snapshot) in
     if snapshot.exists() {
     let msgs = kSharedInstance.getDictionary(snapshot.value)
     self?.ResentUser.removeAll()
     msgs.forEach {(key, value) in
     let dic = kSharedInstance.getDictionary(value)
     self?.ResentUser.append(ResentUsers(userdata: dic))
     self?.ResentUser.sort { $0.SendingTime > $1.SendingTime }
     }
     }
     message(self?.ResentUser)
     }
     }*/
    
    
    //MARK:- Func For Check User State For Online And Ofline State and Submit Data on Firebase On Self Node
    func OnlineState(State : Bool) {
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        if String.getString(userDetails[Parameters.user_id]) == Parameters.emptyString {
            //CommonUtils.showNotification(message: Parameters.alertmessage)
            print(Parameters.alertmessage)
            return
        }
        
        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
        let dicuser  :[String : Any] = [ Parameters._id: String.getString(userDetails[Parameters.user_id]),
                                         Parameters.name: String.getString("\(String.getString(userDetails[Parameters.name]))"),
                                         Parameters.profile_image: String.getString(userDetails["profilePicture"]),
                                         "online" :  State ,
                                         "timestamp" : String.getString(timeStamp) ,
                                         "profile_status" : String.getString("")]
        
        Database.database().reference().child(Parameters.UserState).child(String.getString("user_" + "\(String.getString(userDetails[Parameters.user_id]))")).updateChildValues(kSharedInstance.getDictionary(dicuser))
    }
    
    
    
    //MARK:- Func For checkUserOnlineStateObserver
    func  checkUserOnlineStateObserver(userid:String , message:@escaping (_ id: String, _ status: Bool , _ timeStamp:String) -> ()) -> Void{
        if userid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        Database.database().reference().child(Parameters.UserState).child("user_" + "\(userid)").observe( .value) { (snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                let status = UsersState(userid: String.getString(msgs[Parameters._id]), lastmessage: String.getString(msgs[Parameters.lastmessage]), time: String.getString(msgs[Parameters.timeStamp]), name: String.getString(msgs[Parameters.name]), imageUrl: String.getString(msgs[Parameters.profile_image]), isOnline: String.getString(msgs[Parameters.OnlineState]), blockUsers: kSharedInstance.getStringArray(msgs[Parameters.blockUsers]))
                message(status.userid ?? Parameters.emptyString, (status.isOnline ?? Parameters.emptyString) == "0" ? false : true, String.getString(status.SendingTime))
            }
        }
    }
    
    //MARK:- Function For Delete  chat node from both side
    func deleteChatNode(Senderid :String , Receiverid:String) {
        if String.getString(Senderid) == Parameters.emptyString || String.getString(Receiverid) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        let node = Int.getInt(Senderid) < Int.getInt(Receiverid) ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" :  "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if node == Parameters.emptyString {
            return
        }
        print("node =============== \(node)")
        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).removeValue { error, _ in
            print(error?.localizedDescription ?? "")
        }
        Database.database().reference().child(Parameters.Message).child(Parameters.ResentMessage).child(Senderid).child(Receiverid).removeValue { error, _ in
            print(error?.localizedDescription ?? "")
        }
        
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).removeValue { error, _ in
            print(error?.localizedDescription ?? "")
        }
        
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).removeValue { error, _ in
            print(error?.localizedDescription ?? "")
        }
    }
    
    //MARK:- Function For Delete  message One to One Only Delete Perticular Messege
    func deleteMessage(Senderid :String , Receiverid:String , uid:String) {
        
        if String.getString(Senderid) == Parameters.emptyString || String.getString(Receiverid) == Parameters.emptyString || String.getString(uid) == Parameters.emptyString {
            //CommonUtils.showNotification(message: Parameters.alertmessage)
            print(Parameters.alertmessage)
            return
        }
        
        let node = Int.getInt(Senderid) < Int.getInt(Receiverid) ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" :  "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        
        if node == Parameters.emptyString {
            return
        }
        var isDeleted = String()
        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(uid).removeValue()
        //        Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).observeSingleEvent(of: .value, with: { (SnapShot) in
        //            if SnapShot.exists() {
        //                isDeleted.isEmpty ? Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(uid).child(Parameters.isDeleted).setValue(Senderid) :  Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(uid).child(Parameters.isDeleted).setValue("\(isDeleted)_\(Senderid)")
        //            }
        //        })
    }
    
    
    
    //MARK:- Function For Star   message One to One Only Star Perticular Message
    func starMessage(Senderid :String , Receiverid:String , uid:String) {
        
        if String.getString(Senderid) == Parameters.emptyString || String.getString(Receiverid) == Parameters.emptyString || String.getString(uid) == Parameters.emptyString {
            //CommonUtils.showNotification(message: Parameters.alertmessage)
            print(Parameters.alertmessage)
            return
        }
        
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" :  "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        var starmessage = String()
        Database.database().reference().child(Parameters.Message).child(node).child(uid).child(Parameters.starmessage).observe(.value) { (snapshot) in
            if snapshot.exists() {
                starmessage = String.getString(snapshot.value)
                print(starmessage)
            }
        }
        Database.database().reference().child(Parameters.Message).child(node).observeSingleEvent(of: .value, with: { (SnapShot) in
            if SnapShot.exists() {
                starmessage.isEmpty ? Database.database().reference().child(Parameters.Message).child(node).child(uid).child(Parameters.starmessage).setValue(Senderid) :  Database.database().reference().child(Parameters.Message).child(node).child(uid).child(Parameters.starmessage).setValue("\(starmessage)_\(Senderid)")
            }
        })
    }
    
    
    
    //MARK:- Function For Read message Count ForScreen Batch
    func readMessage(Senderid :String , Receiverid:String , readstate:String , counters:@escaping (_ result: Int) -> ()) {
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" : "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if node == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        var countreadMessage = 0
        
        Database.database().reference().child(Parameters.Message).child(node).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                countreadMessage = 0
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                msgs.forEach {(key, value) in
                    let dic = kSharedInstance.getDictionary(value)
                    let isDeleted =  String.getString(dic[Parameters.isDeleted]).components(separatedBy: Parameters.saparaterString)
                    let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
                    if !(isDeleted.contains(String.getString(userDetails[Parameters.user_id]))) {
                        countreadMessage += 1
                    }
                }
            }
            counters(Int(countreadMessage) - Int.getInt(readstate))
        })
    }
    
    
    //MARK:- Function For Read message Count For Resent Screen Batch Only Read Messages
    
    func seenMessageCount( Receiverid:String , Senderid :String , readState :String) {
        if Receiverid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        if Senderid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        Database.database().reference().child(Parameters.ResentMessage).child(Senderid).child(Receiverid).updateChildValues([Parameters.readState:readState])
    }
    
    
    
    //MARK:- Func for Clear All Messages From One to One Chat
    func ClearChat(msgclass:[MessageClass] , Senderid:String, Receiverid:String) {
        
        if Receiverid == Parameters.emptyString || Senderid == Parameters.emptyString{
            print(Parameters.alertmessage)
            return
        }
        
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" :  "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if node == Parameters.emptyString {
            return
        }
        for index in msgclass {
            let uid = index.uid
            var isDeleted = String()
            privateMessageReference.child(node).child(uid ?? "").child(Parameters.isDeleted).observe(.value) { (snapshot) in
                if snapshot.exists() {
                    isDeleted = String.getString(snapshot.value)
                }
            }
            privateMessageReference.child(node).observeSingleEvent(of: .value, with: { (SnapShot) in
                if SnapShot.exists() {
                    isDeleted.isEmpty ? self.privateMessageReference.child(node).child(uid ?? "").child(Parameters.isDeleted).setValue(Senderid) :  self.privateMessageReference.child(node).child(uid ?? "").child(Parameters.isDeleted).setValue("\(isDeleted)_\(Senderid)")
                }
            })
        }
        
        
        
        
    }
    
    func removeFromresent(Senderid:String, Receiverid:String) {
        resentReferense.child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).observeSingleEvent(of: .value, with: { (SnapShot) in
            if SnapShot.exists() {
                self.resentReferense.child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(Parameters.lastmessage).setValue("")
            }
        })
    }
    
    func blockUnblocFromRecent(Senderid:String, Receiverid:String, status: Bool) {
        
        resentReferense.child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).observeSingleEvent(of: .value, with: { (SnapShot) in
            if SnapShot.exists() {
                self.resentReferense.child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(Parameters.blockUsers).setValue(status ? "" : String.getString(Senderid))
            }
        })
        
        resentReferense.child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).observeSingleEvent(of: .value, with: { (SnapShot) in
            if SnapShot.exists() {
                self.resentReferense.child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).child(Parameters.blockUsers).setValue(status ? "" : String.getString(Senderid))
            }
        })
    }
    
    func  getBlockStatus(Senderid:String, Receiverid:String, message:@escaping (_ status: String) -> ()) -> Void{
        
        resentReferense.child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(Parameters.blockUsers).observe(.value) { (snapshot) in
            if snapshot.exists() {
                let val = String.getString(snapshot.value)
                message(val)
            }
        }
    }
    
    
    //MARK:- Func for One to One Chat BackUp from remove isDeleted ID from Chat messages
    func ChatBackUpOneToOne(msgclass:[ChatbackupOnetoOne] , Senderid:String, Receiverid:String) {
        if Receiverid == Parameters.emptyString || Senderid == Parameters.emptyString{
            print(Parameters.alertmessage)
            return
        }
        
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" :  "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        for  index in msgclass {
            let uid = index.uid
            var isDeleted = [String]()
            Database.database().reference().child(Parameters.Message).child(node).child(uid ?? "").child(Parameters.isDeleted).observe(.value) { (snapshot) in
                if snapshot.exists() {
                    isDeleted = String.getString(snapshot.value).components(separatedBy: Parameters.saparaterString)
                    
                    if (isDeleted.index{$0 == String.getString(Senderid)} != nil) {
                        isDeleted.remove(at: isDeleted.index{$0 == String.getString(Senderid)}!)
                    }
                    
                    print(isDeleted)
                }
            }
            Database.database().reference().child(Parameters.Message).child(node).observeSingleEvent(of: .value, with: { (SnapShot) in
                if SnapShot.exists() {
                    
                    Database.database().reference().child(Parameters.Message).child(node).child(uid ?? "").child(Parameters.isDeleted).setValue("\(isDeleted.joined(separator: Parameters.saparaterString))")
                }
            })
        }
    }
    
    
    //MARK:- Func for Update User Model for Block Users
    func  UpdateUserModel(userid:String , message:@escaping (_ id: String, _ blockedUsers: [String]) -> ()) -> Void{
        if userid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        Database.database().reference().child(Parameters.UserState).child(userid).observe( .value) { (snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                let status = UsersState(userid: String.getString(msgs[Parameters._id]), lastmessage: String.getString(msgs[Parameters.lastmessage]), time: String.getString(msgs[Parameters.timeStamp]), name: String.getString(msgs[Parameters.name]), imageUrl: String.getString(msgs[Parameters.profile_image]), isOnline: String.getString(msgs[Parameters.OnlineState]), blockUsers: kSharedInstance.getStringArray(msgs[Parameters.blockUsers]))
                message(status.userid ?? Parameters.emptyString, (status.blockUsers ?? [Parameters.emptyString]))
            }
        }
    }
    
    
    
    //MARK:- Func for Block Users And Unblock Users
    
    func blockUnblockUser( Receiverid:String , Senderid :String , BlockCheck : Bool) {
        if Receiverid == Parameters.emptyString || Senderid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        var blockUsers = [String]()
        var blockreceiveruser : [String] = []
        Database.database().reference().child(Parameters.UserState).child(Senderid).child(Parameters.blockUsers).observeSingleEvent(of: .value, with:  { (snapshot) in
            if snapshot.exists() {
                blockUsers = kSharedInstance.getStringArray(snapshot.value)
                print(blockUsers)
                if !BlockCheck {
                    if (blockUsers.index{$0 == String.getString(Receiverid)} != nil) {
                        blockUsers.remove(at: blockUsers.index{$0 == String.getString(Receiverid)}!)
                    }
                }
                BlockCheck ? blockUsers.append(Receiverid) : print("")
                
                BlockCheck ? Database.database().reference().child(Parameters.UserState).child(Senderid).updateChildValues([Parameters.blockUsers : kSharedInstance.getStringArray(blockUsers)]) : Database.database().reference().child(Parameters.UserState).child(Senderid).updateChildValues([Parameters.blockUsers:kSharedInstance.getStringArray(blockUsers)])
            }else {
                BlockCheck ? blockUsers.append(Receiverid) : print("")
                
                BlockCheck ? Database.database().reference().child(Parameters.UserState).child(Senderid).updateChildValues([Parameters.blockUsers : kSharedInstance.getStringArray(blockUsers)]) : Database.database().reference().child(Parameters.UserState).child(Senderid).updateChildValues([Parameters.blockUsers:kSharedInstance.getStringArray(blockUsers)])
            }
        })
        
        Database.database().reference().child(Parameters.UserState).child(Receiverid).child(Parameters.blockUsers).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                blockreceiveruser = kSharedInstance.getStringArray(snapshot.value)
                print(blockreceiveruser)
                if !BlockCheck {
                    if (blockreceiveruser.index{$0 == String.getString(Senderid)} != nil) {
                        blockreceiveruser.remove(at: blockreceiveruser.index{$0 == String.getString(Senderid)}!)
                    }
                    BlockCheck ? blockreceiveruser.append(Senderid) : print("")
                    BlockCheck ? Database.database().reference().child(Parameters.UserState).child(Receiverid).updateChildValues([Parameters.blockUsers:kSharedInstance.getStringArray(blockreceiveruser)]) : Database.database().reference().child(Parameters.UserState).child(Receiverid).updateChildValues([Parameters.blockUsers: kSharedInstance.getStringArray(blockreceiveruser)])
                }
            } else {
                BlockCheck ? blockreceiveruser.append(Senderid) : print("")
                BlockCheck ? Database.database().reference().child(Parameters.UserState).child(Receiverid).updateChildValues([Parameters.blockUsers:kSharedInstance.getStringArray(blockreceiveruser)]) : Database.database().reference().child(Parameters.UserState).child(Receiverid).updateChildValues([Parameters.blockUsers: kSharedInstance.getStringArray(blockreceiveruser)])
            }
        })
        
    }
    
}


//MARK:- Extension for Chat_halper for Group Chat
extension Chat_hepler {
    
    //MARK:- Function For Create Group for Group Chat
    func CreateGroup(groupdic:Dictionary<String, Any> , userdic:[Any] , groupid:@escaping (_ id: String) -> ()) -> Void {
        var groupsDetails = groupdic
        let ref =  Database.database().reference().child(Parameters.Groups).childByAutoId()
        let autoKey = "group_" + "\(String.getString(ref.key))"
        let reference = Database.database().reference().child(Parameters.Groups)
        groupsDetails[Parameters._id] = String.getString(autoKey)
        
        
        let details:[String : Any] = [Parameters.information : kSharedInstance.getDictionary(groupsDetails) , Parameters.Users : kSharedInstance.getArray(userdic)]
        reference.child(autoKey).setValue(details)
        
        let resentDetails = ["id" : String.getString(autoKey) , "name" : String.getString(groupdic["group_name"]) , "profile_image" : "" , "readState" : "" , "receiverid" : "" , "senderid" : ""  , "timestamp" : String.getString(Int(Date().timeIntervalSince1970 * 1000)) , Parameters.CreatedBy : String.getString(autoKey)]
        
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(groupdic[Parameters.admin_id]))")).child(String.getString(groupsDetails[Parameters._id])).updateChildValues(resentDetails)
        groupid(autoKey)
        
        for users in userdic {
            let userdata = kSharedInstance.getDictionary(users)
            let id = String.getString(userdata["id"])
            Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(id))")).child(String.getString(groupsDetails[Parameters._id])).updateChildValues(resentDetails)
        }
        
    }
    
    
    
    //MARK:- Function For Send message to group Chat
    func SendMessagetoGroup(dic:Dictionary<String, Any> , Senderid :String , groupid:String ) {
        
        let node = String.getString(groupid)
        
        if node == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        Database.database().reference().child(Parameters.Message).child("GroupMessages").child(node).childByAutoId().setValue(kSharedInstance.getDictionary(dic))
    }
    
    
    
    //MARK:- Func For Receive Message from Group Chat
    func Receivce_messagefromGroup(groupid :String , message:@escaping (_ result: [MessageClass]?, _ chatbackup : [ChatbackupOnetoOne]?) -> ()) -> Void {
        self.Messageclass.removeAll()
        let node =  String.getString(groupid)
        if node == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        Database.database().reference().child(Parameters.Message).child("GroupMessages").child(node).observe(.value) { (snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                self.Messageclass.removeAll()
                
                self.ChatBackupOnetoOne.removeAll()
                msgs.forEach {(key, value) in
                    let dic = kSharedInstance.getDictionary(value)
                    let isDeleted =  String.getString(dic[Parameters.isDeleted]).components(separatedBy: Parameters.saparaterString)
                    let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
                    if !(isDeleted.contains(String.getString(userDetails[Parameters.user_id]))) {
                        //self.Messageclass.append(MessageClass(uid: String.getString(key), messageData: dic))
                        self.Messageclass.sort{ $0.SendingTime < $1.SendingTime }
                    } else {
                        self.ChatBackupOnetoOne.append(ChatbackupOnetoOne(uid: String.getString(key), messageData: dic))
                        self.ChatBackupOnetoOne.sort{ $0.SendingTime < $1.SendingTime }
                    }
                }
            }
            message(self.Messageclass , self.ChatBackupOnetoOne)
        }
    }
    
    
    
    //MARK:- Function For Updated Group Infromarion for Every users
    func  UpdateGroup(userid:String ,groupid :String, message:@escaping (_ result : GroupModel) -> ()) -> Void{
        
        if  groupid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        Database.database().reference().child(Parameters.Groups).child(groupid).observe( .value) { (snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                let status = GroupModel(userid: String.getString(msgs[Parameters._id]), name: String.getString(msgs[Parameters.name]), imageUrl: String.getString(msgs[Parameters.profile_image]), user: kSharedInstance.getArray(msgs[Parameters.Users]))
                message(status)
            }
        }
    }
    
    
    //MARK:- Func For send Resent Users For Group Chat  Create a Loop And Send Resend Users Information
    
    func GroupResentUser(lastmessage:String, groupid:String , adminid :String  , name:String , profile_image:String , readState :String) {
        
        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
        if  groupid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        let dic = [
            Parameters._id:      String.getString(groupid),
            Parameters.name:    String.getString(name),
            Parameters.profile_image: String.getString(profile_image),
            Parameters.lastmessage : String.getString(lastmessage),
            Parameters.timeStamp : String.getString(timeStamp) ,
            Parameters.CreatedBy : String.getString(groupid)
        ]
        
        self.UpdateGroup(userid: adminid, groupid: groupid) { (value) in
            for users in kSharedInstance.getArray(value.user) {
                let userData = kSharedInstance.getDictionary(users)
                Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(userData["id"]))")).child(String.getString(groupid)).updateChildValues(dic)
            }
        }
        
    }
    
    
    
    
    //MARK:- Func For seenUnseenmessageforGroup
    func seenUnseenmessageforGroup( groupid:String , adminid :String  , userid:String, readState :String) {
        
        if String.getString(groupid) == Parameters.emptyString || String.getString(adminid) == Parameters.emptyString{
            //CommonUtils.showNotification(message: Parameters.alertmessage)
            print(Parameters.alertmessage)
            return
        }
        
        Database.database().reference().child(Parameters.Groups).child(adminid).child(groupid).child(Parameters.UserSeenCount).child(userid).updateChildValues([Parameters.readState:readState])
    }
    
    
    
    
    
    //MARK:- Func for Delete message from group Only One
    func deletemessagefromgroup(groupid:String , uid :String , Senderid:String) {
        
        if String.getString(groupid) == Parameters.emptyString || String.getString(uid) == Parameters.emptyString{
            //CommonUtils.showNotification(message: Parameters.alertmessage)
            print(Parameters.alertmessage)
            return
        }
        
        var isDeleted = String()
        Database.database().reference().child(Parameters.Message).child("GroupMessages").child(groupid).child(uid).child(Parameters.isDeleted).observe(.value) { (snapshot) in
            if snapshot.exists() {
                isDeleted = String.getString(snapshot.value)
                print(isDeleted)
            }
        }
        Database.database().reference().child(Parameters.Message).child("GroupMessages").child(groupid).observeSingleEvent(of: .value, with: { (SnapShot) in
            if SnapShot.exists() {
                isDeleted.isEmpty ? Database.database().reference().child(Parameters.Message).child("GroupMessages").child(groupid).child(uid).child(Parameters.isDeleted).setValue(Senderid) :  Database.database().reference().child(Parameters.Message).child("GroupMessages").child(groupid).child(uid).child(Parameters.isDeleted).setValue("\(isDeleted)_\(Senderid)")
            }
        })
    }
    
    
    
    //MARK:- Func for Delete message from group Only One
    func starmessageIngroup(groupid:String , uid :String , Senderid:String) {
        if String.getString(groupid) == Parameters.emptyString || String.getString(uid) == Parameters.emptyString{
            //CommonUtils.showNotification(message: Parameters.alertmessage)
            print(Parameters.alertmessage)
            return
        }
        
        var starmessage = String()
        Database.database().reference().child(Parameters.Message).child(groupid).child(uid).child(Parameters.starmessage).observe(.value) { (snapshot) in
            if snapshot.exists() {
                starmessage = String.getString(snapshot.value)
                print(starmessage)
            }
        }
        Database.database().reference().child(Parameters.Message).child(groupid).observeSingleEvent(of: .value, with: { (SnapShot) in
            if SnapShot.exists() {
                starmessage.isEmpty ? Database.database().reference().child(Parameters.Message).child(groupid).child(uid).child(Parameters.starmessage).setValue(Senderid) :  Database.database().reference().child(Parameters.Message).child(groupid).child(uid).child(Parameters.starmessage).setValue("\(starmessage)_\(Senderid)")
            }
        })
    }
    
    
    //MARK:- Func for Clear All Messages From group
    func ClearChatFromGroup(msgclass:[MessageClass] , Senderid:String, groupid:String) {
        for  index in msgclass {
            let uid = index.uid
            var isDeleted = String()
            Database.database().reference().child(Parameters.Message).child(groupid).child(uid ?? "").child(Parameters.isDeleted).observe(.value) { (snapshot) in
                if snapshot.exists() {
                    isDeleted = String.getString(snapshot.value)
                    print(isDeleted)
                }
            }
            Database.database().reference().child(Parameters.Message).child(groupid).observeSingleEvent(of: .value, with: { (SnapShot) in
                if SnapShot.exists() {
                    isDeleted.isEmpty ? Database.database().reference().child(Parameters.Message).child(groupid).child(uid ?? "").child(Parameters.isDeleted).setValue(Senderid) :  Database.database().reference().child(Parameters.Message).child(groupid).child(uid ?? "").child(Parameters.isDeleted).setValue("\(isDeleted)_\(Senderid)")
                }
            })
        }
    }
    
    //MARK:- One to One Call
    func addOneToOneCalltoFirebase(callDic:Dictionary<String, Any> , callId:@escaping (_ id: String) -> ()) -> Void {
        var callDetails = callDic
        let call_id =  callReference.childByAutoId()
        let autoKey = "\(String.getString(call_id.key))"
        
        callDetails[Parameters.call_id] = String.getString(autoKey)
        callDetails[Parameters.isGroup] = "0"
        callDetails[Parameters.senderid] = UserData.shared.id
        callReference.child(autoKey).setValue(kSharedInstance.getDictionary(callDetails))
        callId(autoKey)
        
    }
    
    func updateGroupCallDataOnFirebase(callId: String, userId: String, callStatus: String) {
        
        callReference.child(callId).child(Parameters.Members).child("user_\(userId)").setValue(callStatus)
        
    }
    
    func updateCallDataOnFirebase(callId: String, callStatus: String) {
        
        callReference.child(callId).child(Parameters.call_status).setValue(callStatus)
        
    }
    
    func  getActiveGroupMembersInCall(callId :String, completion:@escaping (_ result : [String]) -> ()) -> Void{
        
        if  callId == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        callReference.child(callId).child(Parameters.Members).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let dict = kSharedInstance.getDictionary(snapshot.value)
                var members = [String]()
                dict.forEach {(key, value) in
                    
                    if key != UserData.shared.id{
                        members.append(key)
                    }
                    
                }
                completion(members)
            }
        }
    }
    
    func addGroupCalltoFirebase(groupdic:Dictionary<String, Any> , userdic:Dictionary<String, Any> , callId:@escaping (_ id: String) -> ()) -> Void {
        var groupsDetails = groupdic
        let call_id =  callReference.childByAutoId()
        let autoKey = "\(String.getString(call_id.key))"
        
        groupsDetails[Parameters.call_id] = String.getString(autoKey)
        groupsDetails[Parameters.Members] = kSharedInstance.getDictionary(userdic)
        groupsDetails[Parameters.isGroup] = "1"
        //let details:[String : Any] = [FirebaseKeys.call_info : kSharedInstance.getDictionary(groupsDetails) , FirebaseKeys.Members : kSharedInstance.getDictionary(userdic)]
        callReference.child(autoKey).setValue(groupsDetails)
        callId(autoKey)
    }
    //MARK:- Update typing state
    func updateTypingStat(receiverid: String, status: Int) {
        let loggedInUserid = UserData.shared.id
        typingReferense.child(String.getString(loggedInUserid)).child(receiverid).setValue(status)
    }
    
    func getTypingStat(receiverid: String, status:@escaping (_ result: Int?) -> ()) -> Void {
        let loggedInUserid = UserData.shared.id
        
        
        typingReferense.child(receiverid).child(String.getString(loggedInUserid)).observe(.value)  { (snapshot) in
            
            if snapshot.exists() {
                let val = Int.getInt(snapshot.value)
                status(val)
            }else {
                status(0)
            }
        }
    }
    
    //MARK:- Func for One to One Chat BackUp
    
    
    func ChatBackUpGroup(msgclass:[ChatbackupOnetoOne] , Senderid:String, groupid:String) {
        if groupid == Parameters.emptyString || Senderid == Parameters.emptyString{
            print(Parameters.alertmessage)
            return
        }
        for  index in msgclass {
            let uid = index.uid
            var isDeleted = [String]()
            Database.database().reference().child(Parameters.Message).child(groupid).child(uid ?? "").child(Parameters.isDeleted).observe(.value) { (snapshot) in
                if snapshot.exists() {
                    isDeleted = String.getString(snapshot.value).components(separatedBy: Parameters.saparaterString)
                    if (isDeleted.index{$0 == String.getString(Senderid)} != nil) {
                        isDeleted.remove(at: isDeleted.index{$0 == String.getString(Senderid)}!)
                    }
                    print(isDeleted)
                }
            }
            Database.database().reference().child(Parameters.Message).child(groupid).observeSingleEvent(of: .value, with: { (SnapShot) in
                if SnapShot.exists() {
                    Database.database().reference().child(Parameters.Message).child(groupid).child(uid ?? "").child(Parameters.isDeleted).setValue("\(isDeleted.joined(separator: "_"))")
                }
            })
        }
    }
    
    
    
    
    //MARK:- Function For Group Read Messages
    func readMessageforGroup(groupid :String , readstate:String , counters:@escaping (_ result: Int) -> ()) {
        if groupid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        var countreadMessage = 0
        Database.database().reference().child(Parameters.Message).child(groupid).observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                countreadMessage = 0
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                msgs.forEach {(key, value) in
                    let dic = kSharedInstance.getDictionary(value)
                    let isDeleted =  String.getString(dic[Parameters.isDeleted]).components(separatedBy: Parameters.saparaterString)
                    let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
                    if !(isDeleted.contains(String.getString(userDetails[Parameters.user_id]))) {
                        countreadMessage += 1
                    }
                }
            }
            counters(Int(countreadMessage) - Int.getInt(readstate))
        })
        
    }
    
    //Func for read perticular messgae
    func readperticularMessage(Senderid :String , Receiverid:String , array:[MessageClass] ) {
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let node = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" : "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        if String.getString(node) == Parameters.emptyString || String.getString(Senderid) == Parameters.emptyString || String.getString(Receiverid) == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        for i in 0..<array.count {
            
            let index = array[i]
            if index.isInvalidated {
                return
            }
            if Senderid != index.Senderid {
                
                Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(index.uid ?? "").child(Parameters.senderid).observeSingleEvent(of: .value) {
                    (snapshot) in
                    
                    if snapshot.exists() {
                        if let str = snapshot.value as? String {
                            if str.count > 1 {
                                if str != String.getString(userDetails[Parameters.user_id]) {
                                    Database.database().reference().child(Parameters.Message).child(Parameters.PrivateMessages).child(node).child(index.uid ?? "").updateChildValues([Parameters.status : "seen"])
                                }
                                
                                
                                if str != String.getString(userDetails[Parameters.user_id]) && (i == array.count - 1) {
                                    Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).observeSingleEvent(of: .value) { (snapshot) in
                                        if snapshot.exists() {
                                            Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).updateChildValues([Parameters.readState : "seen"])
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func readMessageCountForAConversation(Senderid :String , Receiverid:String) {
        let unreadDict = [Senderid: 0]
        
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(Parameters.unread_count).setValue(unreadDict)
            }
            
        }
    }
    
    func changeFriendStatusForAConversation(Senderid :String , Receiverid:String, status: Bool) {
        
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Senderid))")).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(Parameters._friend).setValue(status)
            }
        }
        
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).child(Parameters._friend).setValue(status)
            }
        }
    }
    
    
    func getUeadCountForAConversation(Senderid :String , Receiverid:String, unreadCount:@escaping (_ count: Int, _ success: Bool) -> ()) -> Void {
        var count = 0
        Database.database().reference().child(Parameters.ResentMessage).child(String.getString("user_" + "\(String.getString(Receiverid))")).child(String.getString("user_" + "\(String.getString(Senderid))")).child(Parameters.unread_count).observe(.value) { (snapshot) in
            if snapshot.exists() {
                guard let vc = UIApplication.topViewController() else { return }
                if vc .isKind(of: ChatViewController.self) {
                    let msgs = kSharedInstance.getDictionary(snapshot.value)
                    msgs.forEach {(key, value) in
                        count = Int.getInt(value)
                    }
                    unreadCount(count, true)
                }
                
            }
        }
        unreadCount(count, false)
    }
    
    //MARK:- Function For Group Read Messages from users perticular
    func  readMessagecountforGroupusers(adminid :String , groupid:String , userid:String , message:@escaping (_ id: String, _ status: String) -> ()) -> Void{
        if userid == Parameters.emptyString ||  groupid == Parameters.emptyString || adminid == Parameters.emptyString {
            print(Parameters.alertmessage)
            return
        }
        
        Database.database().reference().child(Parameters.Groups).child(adminid).child(groupid).child(Parameters.UserSeenCount).child(userid).observe( .value) { (snapshot) in
            if snapshot.exists() {
                let msgs = kSharedInstance.getDictionary(snapshot.value)
                message(groupid,  String.getString(msgs[Parameters.readState]))
            }else {
                
            }
        }
    }
    
}


//MARK:- Extension of Chat_Halper for get some data for Chat like timeStamp , thumbnil image
extension Chat_hepler{
    //MARK;- Func for Get time from Time Stamp
    func getTime(timeStamp :Double) ->String {
        let time = Double(timeStamp) / 1000
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return String.getString(localDate)
    }
    
    //MARK:- Func for get  ThumNil Image from Video
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
            print("Error for geting the thumnbnil image for Video ")
        }
        return nil
    }
    
    @available(iOS 11.0, *)
    func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
        guard let data = try? Data(contentsOf: url),
              let page = PDFDocument(data: data)?.page(at: 0) else {
            return nil
        }
        
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = width / pageSize.width
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale, height: pageSize.height * scale)
        return page.thumbnail(of: screenSize, for: .mediaBox)
    }
    
    func pdfThumbnailFromData(data: Data?, width: CGFloat = 240) -> UIImage? {
        // guard let data = try? Data(contentsOf: url),
        guard let pdfData = data else {
            return nil
        }
        if let page = PDFDocument(data: pdfData)?.page(at: 0) {
            let pageSize = page.bounds(for: .mediaBox)
            let pdfScale = width / pageSize.width
            let scale = UIScreen.main.scale * pdfScale
            let screenSize = CGSize(width: pageSize.width * scale, height: pageSize.height * scale)
            return page.thumbnail(of: screenSize, for: .mediaBox)
            
        }else {
            return nil
        }
    }
    
    func sendChatMessageAPI(friend_id: String, message: String, chat_id: String, timeStamp: String, message_id: String  = "") {
        
        //        let params : [String:String] = ["friend_id" : friend_id,
        //                                        "message" : message,
        //                                        "chat_id" : chat_id,
        //                                        "message_id" : message_id,
        //                                        "notification": "message",
        //                                        "title": ""]
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = ["message":message,
                                   "receiver_id":friend_id,
        ]
        let url = ServiceName.sendMessageNotification
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    let users = data.map{AllUserModel(data: kSharedInstance.getDictionary($0))}
                    // completion(users)
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

func getDictionaryTest(_ dictData: Any?) -> Dictionary<String, Any> {
    guard let dict = dictData as? Dictionary<String, Any> else {
        guard let arr = dictData as? [Any] else {
            return ["":""]
        }
        return getDictionaryTest(arr.count > 0 ? arr[0] : ["":""])
    }
    return dict
}
