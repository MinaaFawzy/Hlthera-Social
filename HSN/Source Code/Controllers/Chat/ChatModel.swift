//
//  ChatModel.swift
//  RippleApp
//
//  Created by Mohd Aslam on 30/04/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import Foundation
import RealmSwift

let chatOldDays = 13

//MARK:- Class for messgaes For Chat Halper
class MessageClass: Object {
    @objc dynamic var Senderid :String?
    @objc dynamic var Sendername :String?
    @objc dynamic var Receiverid :String?
    @objc dynamic var Message:String?
    @objc dynamic var isDeleted:String?
    @objc dynamic var uid:String?
    @objc dynamic var SendingTime =  Int()
    @objc dynamic var isOnline = Int()
    @objc dynamic var mediatype:String?
    @objc dynamic var thumnilimageurl : String?
    //@objc dynamic var location : [String:Any]?
    @objc dynamic var starmessage:String?
    @objc dynamic var imageurl:String?
    @objc dynamic var mediaurl :String?
    @objc dynamic var status :  String?
    @objc dynamic var isSongPlayed = false
    @objc dynamic var fileName : String?
    @objc dynamic var mediaName :String = ""
    @objc dynamic var mediaSize :String = ""
    @objc dynamic var groupName : String?
    @objc dynamic var img_type : String?
    @objc dynamic var chat_id : String?
    
    class func addNewMessageInList(msgDict: Dictionary<String, Any>, userid: String) {
        
        let msgObj = MessageClass(value: msgDict)
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let loggedInUserid = String.getString(userDetails[Parameters.user_id])
        let chatId = loggedInUserid < userid ? "\(String.getString(loggedInUserid))_\(String.getString(userid))" : "\(String.getString(userid))_\(String.getString(loggedInUserid))"
        
        let realm = try? Realm()
        guard let result = realm?.objects(MessageList.self).filter("\(Parameters.chat_id) == %@", chatId) else { return }
        let obj1 = result.first ?? MessageList()
                        
        try? realm?.write {
            obj1.messages.append(msgObj)
        }
        
        if let result = realm?.objects(ResentUsers.self).filter("id == %@", userid) {
            if result.count > 0 {
                let obj = result[0]
                if !obj.isInvalidated {
                    try? realm?.write {
                        obj.last_message = msgDict["Message"] as? String ?? ""
                        //obj.timestamp = msgDict["timestamp"] as? String ?? ""
                        //obj.readState = "not_seen"
                    }
               }
            }
        }
    }
}

class MessageList: Object {
    
    @objc dynamic var chat_id :String?
    var messages = List<MessageClass>()
    
    override static func primaryKey() -> String? {
           return Parameters.chat_id
       }
}

extension MessageList {
    
    class func saveMessages(result:Dictionary<String, Any>, userId: String) {
        
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let loggedInUserid = String.getString(userDetails[Parameters.user_id])
        
        var tempArr = [Dictionary<String, Any>]()
        
        result.forEach {(key, value) in
            let messageData = kSharedInstance.getDictionary(value)
            
            let Senderid  = String.getString(messageData[Parameters.senderid])
            let Message  = String.getString(messageData[Parameters.content])
            let SendingTime = Int.getInt(messageData[Parameters.timeStamp])
            let Receiverid = String.getString(messageData[Parameters.receiverid])
            let isDeleted = String.getString(messageData[Parameters.isDeleted])
            let starmessage = String.getString(messageData[Parameters.starmessage])
            let uid = String.getString(key)
            let mediatype = String.getString(messageData[Parameters.mediatype])
            let Sendername = String.getString(messageData[Parameters.sendername])
            let thumnilimageurl = String.getString(messageData[Parameters.thumnilimageurl])
            //let location       = sharedInstance.getDictionary(messageData[Parameters.location])
            let imageurl       = String.getString(messageData[Parameters.mediaurl])
            let mediaurl       = String.getString(messageData[Parameters.mediaurl])
            let status         = String.getString(messageData["status"])
            let fileName       = String.getString(messageData[Parameters.fileName])
            let mediaName      = String.getString(messageData[Parameters.mediaName])
            let mediaSize      = String.getString(messageData[Parameters.mediaSize])
            let groupName      = String.getString(messageData[Parameters.groupName])
            let img_type       = String.getString(messageData[Parameters.img_type])
            let chat_id        = String.getString(messageData[Parameters.chat_id])
                        
            let dict = ["Senderid" : Senderid,
                        "Message": Message,
                        "SendingTime": SendingTime,
                        "Receiverid": Receiverid,
                        "isDeleted": isDeleted,
                        "starmessage": starmessage,
                        "uid": uid,
                        "mediatype": mediatype,
                        "Sendername": Sendername,
                        "thumnilimageurl": thumnilimageurl,
                        //"location": location,
                        "imageurl": imageurl,
                        "mediaurl": mediaurl,
                        "status": status,
                        "fileName": fileName,
                        "mediaName": mediaName,
                        "mediaSize": mediaSize,
                        "groupName": groupName,
                        "img_type": img_type,
                        "chat_id": chat_id
                ] as [String : Any]
            
            
            //let date1 = SendingTime.dateFromTimeStamp()
            //let diffInDays = (Calendar.current.dateComponents([.day], from: date1, to: Date()).day) ?? 0

            if isDeleted == "" {
                if Receiverid.count > 0 {
//                    if diffInDays > chatOldDays {
//                        deletePerticularMessage(msgId: uid)
//                    }else {
                        tempArr.append(dict)
                    //}
                }
            }else {
                let isDeleted =  isDeleted.components(separatedBy: Parameters.saparaterString)
                if !(isDeleted.contains(loggedInUserid)) {
                    if Receiverid.count > 0 {
//                        if diffInDays > chatOldDays {
//                            deletePerticularMessage(msgId: uid)
//                        }else {
                            tempArr.append(dict)
                        //}
                    }
                }
            }
        }
        if tempArr.count == 0 {
            return
        }
         let senderid  = String.getString(userId)
        let chatId = loggedInUserid < senderid ? "\(String.getString(loggedInUserid))_\(String.getString(senderid))" : "\(String.getString(senderid))_\(String.getString(loggedInUserid))"
        //Delete all messages for a user
        deleteMessagesForUser(userid: chatId)
       
        
        let dict = ["chat_id" : chatId,
                    "messages": tempArr
        ] as [String : Any]
        
        //Save messages for a user
        let realm = try? Realm()
        let resultList = realm?.objects(MessageList.self)
        let obj = MessageList(value: dict)
        let predicate = NSPredicate(format: "chat_id == %@", chatId)
        let filteredArr = resultList?.filter { predicate.evaluate(with: $0) }
        if filteredArr?.count ?? 0 > 0 {
            try? realm?.write ({
                realm?.add(obj, update: .all)
                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
            })
        }
        else {
            try? realm?.write ({
                realm?.add(obj, update: .error)
                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
            })
        }
        
    }
    
    
    class func saveUnreadMessages(result:Dictionary<String, Any>, userId: String) {
        
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let loggedInUserid = String.getString(userDetails[Parameters.user_id])
        
        var tempArr = [Dictionary<String, Any>]()
        
        let messages = MessageList.fetchMessagesForUser(userid: userId) ?? []
        messages.forEach { (object) in
            let Senderid  = String.getString(object.Senderid)
            let Message  = String.getString(object.Message)
            let SendingTime = Int.getInt(object.SendingTime)
            let Receiverid = String.getString(object.Receiverid)
            let isDeleted = String.getString(object.isDeleted)
            let starmessage = String.getString(object.starmessage)
            let uid = String.getString(object.uid)
            let mediatype = String.getString(object.mediatype)
            let Sendername = String.getString(object.Sendername)
            let thumnilimageurl = String.getString(object.thumnilimageurl)
            //let location       = sharedInstance.getDictionary(messageData[Parameters.location])
            let imageurl       = String.getString(object.imageurl)
            let mediaurl       = String.getString(object.mediaurl)
            let status         = String.getString(object.status)
            let fileName       = String.getString(object.fileName)
            let mediaName      = String.getString(object.mediaName)
            let mediaSize      = String.getString(object.mediaSize)
            let groupName       = String.getString(object.groupName)
            let img_type       = String.getString(object.img_type)
            let chat_id       = String.getString(object.chat_id)
                        
            let dict = ["Senderid" : Senderid,
                        "Message": Message,
                        "SendingTime": SendingTime,
                        "Receiverid": Receiverid,
                        "isDeleted": isDeleted,
                        "starmessage": starmessage,
                        "uid": uid,
                        "mediatype": mediatype,
                        "Sendername": Sendername,
                        "thumnilimageurl": thumnilimageurl,
                        //"location": location,
                        "imageurl": imageurl,
                        "mediaurl": mediaurl,
                        "status": status,
                        "fileName": fileName,
                        "mediaName": mediaName,
                        "mediaSize": mediaSize,
                        "groupName": groupName,
                        "img_type": img_type,
                        "chat_id": chat_id
                ] as [String : Any]
            
            tempArr.append(dict)
        }
        
        result.forEach {(key, value) in
            let messageData = kSharedInstance.getDictionary(value)
            
            let Senderid  = String.getString(messageData[Parameters.senderid])
            let Message  = String.getString(messageData[Parameters.content])
            let SendingTime = Int.getInt(messageData[Parameters.timeStamp])
            let Receiverid = String.getString(messageData[Parameters.receiverid])
            let isDeleted = String.getString(messageData[Parameters.isDeleted])
            let starmessage = String.getString(messageData[Parameters.starmessage])
            let uid = String.getString(key)
            let mediatype = String.getString(messageData[Parameters.mediatype])
            let Sendername = String.getString(messageData[Parameters.sendername])
            let thumnilimageurl = String.getString(messageData[Parameters.thumnilimageurl])
            //let location       = sharedInstance.getDictionary(messageData[Parameters.location])
            let imageurl       = String.getString(messageData[Parameters.mediaurl])
            let mediaurl       = String.getString(messageData[Parameters.mediaurl])
            let status         = String.getString(messageData["status"])
            let fileName       = String.getString(messageData[Parameters.fileName])
            let mediaName      = String.getString(messageData[Parameters.mediaName])
            let mediaSize      = String.getString(messageData[Parameters.mediaSize])
            let groupName       = String.getString(messageData[Parameters.groupName])
            let img_type       = String.getString(messageData[Parameters.img_type])
            let chat_id       = String.getString(messageData[Parameters.chat_id])
                        
            let dict = ["Senderid" : Senderid,
                        "Message": Message,
                        "SendingTime": SendingTime,
                        "Receiverid": Receiverid,
                        "isDeleted": isDeleted,
                        "starmessage": starmessage,
                        "uid": uid,
                        "mediatype": mediatype,
                        "Sendername": Sendername,
                        "thumnilimageurl": thumnilimageurl,
                        //"location": location,
                        "imageurl": imageurl,
                        "mediaurl": mediaurl,
                        "status": status,
                        "fileName": fileName,
                        "mediaName": mediaName,
                        "mediaSize": mediaSize,
                        "groupName": groupName,
                        "img_type": img_type,
                        "chat_id": chat_id
                ] as [String : Any]
            
            tempArr.append(dict)
        }
        if tempArr.count == 0 {
            return
        }
         let senderid  = String.getString(userId)
        let chatId = loggedInUserid < senderid ? "\(String.getString(loggedInUserid))_\(String.getString(senderid))" : "\(String.getString(senderid))_\(String.getString(loggedInUserid))"
        
        
        let dict = ["chat_id" : chatId,
                    "messages": tempArr
        ] as [String : Any]
        
        //Save messages for a user
        let realm = try? Realm()
        let resultList = realm?.objects(MessageList.self)
        let obj = MessageList(value: dict)
        let predicate = NSPredicate(format: "chat_id == %@", chatId)
        let filteredArr = resultList?.filter { predicate.evaluate(with: $0) }
        if filteredArr?.count ?? 0 > 0 {
            try? realm?.write ({
                realm?.add(obj, update: .all)
                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
            })
        }
        else {
            try? realm?.write ({
                realm?.add(obj, update: .error)
                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
            })
        }
        
    }
    
    class func deletePerticularMessage(msgId: String) {
        let realm = try? Realm()
        if let result = realm?.objects(MessageClass.self).filter("uid == %@", msgId) {
            if result.count > 0 {
                let obj = result[0]
                if !obj.isInvalidated {
                    try? realm?.write ({
                            realm?.delete(obj)
                    })
               }
            }
        }
    }
    
    class func emptyMessagesTableInDatabase() {
        let realm = try? Realm()
        if let result = realm?.objects(MessageClass.self) {
            try! realm?.write {
                if !result.isInvalidated {
                    try? realm?.write ({
                            realm?.delete(result)
                    })
                }
            }
        }
    }
    
    class func deleteMessagesForUser(userid: String) {
        let realm = try? Realm()
        if let result = realm?.objects(MessageList.self).filter("\(Parameters.chat_id) == %@", userid) {
            if result.count > 0 {
                let obj = result[0]
                if !obj.isInvalidated {
                    try? realm?.write ({
                            realm?.delete(obj)
                    })
               }
            }
        }
    }
    
    class func fetchMessagesForUser(userid: String) -> [MessageClass]? {
        
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let loggedInUserid = String.getString(UserData.shared.id)
        let chatId = loggedInUserid < userid ? "\(String.getString(loggedInUserid))_\(String.getString(userid))" : "\(String.getString(userid))_\(String.getString(loggedInUserid))"
        var resentList = [MessageClass]()
        let realm = try? Realm()
        guard let result = realm?.objects(MessageList.self).filter("\(Parameters.chat_id) == %@", chatId) else { return  resentList}
       let obj = result.first ?? MessageList()
               
        let array = Array(obj.messages)
        
        let sortedResult = array.sorted(by: { (model1, model2) -> Bool in
            model1.SendingTime <  model2.SendingTime
        })
        resentList = sortedResult
        return resentList
    
    }
 
    
    class func deleteAllDatabase() {
        let realm = try? Realm()
        try? realm?.write({
            realm?.deleteAll()
        })
    }
}

class MessageObject {
    var SendingTime =  Int()
    var messages = [MessageClass]()
    
    init(time :Int , messageList:[MessageClass]) {
        self.messages = messageList
        self.SendingTime = time
    }
}

//MARK:- Class for Chat Backup
class ChatbackupOnetoOne {
    var Senderid :String?
    var Receiverid :String?
    var Message:String?
    var isDeleted:String?
    var uid:String?
    var SendingTime =  Int()
    var isOnline = Int()
    var mediatype:String?
    var thumnilimageurl : String?
    var Sendername :String?
    var location : [String:Any]?

    init(uid :String , messageData:[String:Any]) {
        self.Senderid  = String.getString(messageData[Parameters.senderid])
        self.Message  = String.getString(messageData[Parameters.content])
        self.SendingTime = Int.getInt(messageData[Parameters.timeStamp])
        self.Receiverid = String.getString(messageData[Parameters.receiverid])
        self.isDeleted = String.getString(messageData[Parameters.isDeleted])
        self.uid = String.getString(uid)
        self.mediatype = String.getString(messageData[Parameters.mediatype])
        self.Sendername = String.getString(messageData[Parameters.sendername])
        self.thumnilimageurl = String.getString(messageData[Parameters.thumnilimageurl])
        self.location       = kSharedInstance.getDictionary(messageData[Parameters.location])
    }
}


//MARK:- Class for Resent Users

class ResentList: Object {
    
    @objc dynamic var user_id :String?
    var userList = List<ResentUsers>()
    
    override static func primaryKey() -> String? {
           return "user_id"
       }
}
//class RecentListModel{
//    internal init(data:[String:Any]) {
//        self.users = kSharedInstance.getArray(data[""])
//
//    }
//
//    var users:[RecentUsersListModel] = []
//
//}
class RecentUsersListModel{
    internal init(data:[String:Any]) {
        self.last_message = String.getString(data["last_message"])
        self.from = String.getString(data["from"])
        self.node_id = String.getString(data["node_id"])
        self.readMessage = String.getString(data["readMessage"])
        self.readonly = String.getString(data["readonly"])
        self.status = String.getString(data["status"])
        self.timestamp = String.getString(data["timestamp"])
        self.to = String.getString(data["to"])
        self.type = String.getString(data["type"])
        self.readState = String.getString(data["readState"])
        self.isOnline = String.getString(data["isOnline"]) == "1" ? true : false
        self.unread = String.getString(data["unread"])
    }
    
    var last_message:String?
    var from:String?
    var node_id:String?
    var readMessage:String?
    var readonly:String?
    var status:String?
    var timestamp:String?
    var to : String?
    var type :String?
    var readState :String?
    var isOnline :Bool = false
    var unread:String?
}

class RecentUsers: Object {
    @objc dynamic var Senderid :String?
    @objc dynamic var id :String?
    @objc dynamic var Receiverid :String?
    @objc dynamic var name :String?
    @objc dynamic var lastmessage:String?
    @objc dynamic var SendingTime =  Int()
    @objc dynamic var imageUrl :String?
    @objc dynamic var readState :String?
    @objc dynamic var isOnline :Bool = false
    @objc dynamic var type :String?
    @objc dynamic var CreatedBy:String?
    @objc dynamic var readCount:String?
    @objc dynamic var timeStamp:String?
    @objc dynamic var unread_count = Int()
    @objc dynamic var isFriend : Bool = true
    @objc dynamic var call_status: String?
    
//    override static func primaryKey() -> String? {
//        return Parameters._id
//    }
    
}
class AllUsers:Object{
    @objc dynamic var Image:String?
    @objc dynamic var id:String?
    @objc dynamic var is_online:String?
    @objc dynamic var name:String?
}
extension AllUsers{
    class func saveUsers(result:Dictionary<String,Any>){
        var tempArr = [Dictionary<String, Any>]()
        
        result.forEach {(key, value) in
        let userdata = kSharedInstance.getDictionary(value)
        let Image = String.getString(userdata["Image"])
        let id = String.getString(userdata["id"])
        let is_online = String.getString(userdata["is_online"])
        let name = String.getString(userdata["name"])
        
        let dict = ["Image" : Image,
                    "id": id,
                    "is_online": is_online,
                    "name": name,
                    
            ] as [String : Any]
        
           
            //let date1 = SendingTime.dateFromTimeStamp()
            //let diffInDays = (Calendar.current.dateComponents([.day], from: date1, to: Date()).day) ?? 0
//            if diffInDays > chatOldDays {
//                deleteRecordForUser(userid: friendId)
//            }else {
              
                    tempArr.append(dict)
                
            //}
            
        }
        
     
        
         
//         let dict = ["user_id" : loggedInUserid,
//                     "userList": tempArr
//         ] as [String : Any]
//
//         let realm = try? Realm()
//         let resultList = realm?.objects(ResentList.self)
//         let obj = ResentList(value: dict)
//         let predicate = NSPredicate(format: "user_id == %@", loggedInUserid)
//         let filteredArr = resultList?.filter { predicate.evaluate(with: $0) }
//         if filteredArr?.count ?? 0 > 0 {
//            try? realm?.write ({
//                realm?.add(obj, update: .all)
//                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
//            })
//         }
//         else {
//            try? realm?.write ({
//                realm?.add(obj, update: .error)
//                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
//            })
//         }
    }
}
class ResentUsers: Object{
    @objc dynamic var from:String?
    @objc dynamic var name:String?
    @objc dynamic var last_message:String?
    @objc dynamic var node_id:String?
    @objc dynamic var readMessage:String?
    @objc dynamic var readonly:String?
    @objc dynamic var status:String?
    @objc dynamic var timestamp:String?
    @objc dynamic var to:String?
    @objc dynamic var type:String?
    @objc dynamic var unread:String?
}
//Parameters.call_status
extension ResentUsers {
    
//    class func saveRecentUser(result:Dictionary<String, Any>) {
//             // print(Realm.Configuration.defaultConfiguration.fileURL)
//        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
//        let loggedInUserid = String.getString(userDetails[Parameters.user_id])
//
//        var tempArr = [Dictionary<String, Any>]()
//
//        result.forEach {(key, value) in
//        let userdata = kSharedInstance.getDictionary(value)
//        let Senderid = String.getString(userdata[Parameters.senderid])
//        let Receiverid = String.getString(userdata[Parameters.receiverid])
//        let lastmessage = String.getString(userdata[Parameters.lastmessage])
//        let SendingTime = Int.getInt(userdata[Parameters.timeStamp])
//        let name = String.getString(userdata[Parameters.name])
//        let imageUrl = String.getString(userdata[Parameters.profile_image])
//        let readState = String.getString(userdata[Parameters.readState])
//        let CreatedBy = String.getString(userdata[Parameters.CreatedBy])
//        let idStr = String.getString(userdata[Parameters._id])
//        let call_status = String.getString(userdata[Parameters.call_status])
//        var friend = Bool.getBool(userdata[Parameters._friend])
//        if userdata[Parameters._friend] == nil {
//            friend = true
//        }
//
//        let dic = kSharedInstance.getDictionary(userdata[Parameters.unread_count])
//        var count = 0
//        dic.forEach {(key, value) in
//            count = Int.getInt(value)
//        }
//
//        var friendId = Senderid
//        if loggedInUserid == Senderid {
//            friendId = Receiverid
//        }
//
//
//        let dict = ["Senderid" : Senderid,
//                    "Receiverid": Receiverid,
//                    "lastmessage": lastmessage,
//                    "SendingTime": SendingTime,
//                    "name": name,
//                    "imageUrl": imageUrl,
//                    "readState": readState,
//                    "CreatedBy": CreatedBy,
//                    "id": friendId,
//                    "unread_count":count,
//                    "isFriend": friend,
//                    "call_status": call_status
//            ] as [String : Any]
//
//            if friendId.count > 0 {
//            //let date1 = SendingTime.dateFromTimeStamp()
//            //let diffInDays = (Calendar.current.dateComponents([.day], from: date1, to: Date()).day) ?? 0
////            if diffInDays > chatOldDays {
////                deleteRecordForUser(userid: friendId)
////            }else {
//                if idStr != loggedInUserid {
//                    tempArr.append(dict)
//                }
//            //}
//            }
//        }
//
//        //Delete all chat list for a user
//         deleteChatListForUser(userid: loggedInUserid)
//
//
//         let dict = ["user_id" : loggedInUserid,
//                     "userList": tempArr
//         ] as [String : Any]
//
//         let realm = try? Realm()
//         let resultList = realm?.objects(ResentList.self)
//         let obj = ResentList(value: dict)
//         let predicate = NSPredicate(format: "user_id == %@", loggedInUserid)
//         let filteredArr = resultList?.filter { predicate.evaluate(with: $0) }
//         if filteredArr?.count ?? 0 > 0 {
//            try? realm?.write ({
//                realm?.add(obj, update: .all)
//                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
//            })
//         }
//         else {
//            try? realm?.write ({
//                realm?.add(obj, update: .error)
//                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
//            })
//         }
//
//
//    }
    class func saveRecentUser1(result:Dictionary<String, Any>) {
             // print(Realm.Configuration.defaultConfiguration.fileURL)
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let loggedInUserid = String.getString(UserData.shared.id)
        
        var tempArr = [Dictionary<String, Any>]()
        
        result.forEach {(key, value) in
            
            
            let userdata = kSharedInstance.getDictionary(value)
           
            let last_message = String.getString(userdata["last_message"])
            let node_id =  String.getString(userdata["node_id"])
            let readMessage =  String.getString(userdata["readMessage"])
            let readonly =  String.getString(userdata["readonly"])
            let status =  String.getString(userdata["status"])
            let timestamp =  String.getString(userdata["timestamp"])
            let to =  String.getString(userdata["to"])
            let from = String.getString(userdata["from"])
            let type =  String.getString(userdata["type"])
            let unread =  String.getString(userdata["unread"])
            let name =  String.getString(userdata["name"])
        
            var count = Int.getInt(userdata[Parameters.unread_count])
      
     
        
        var friendId = to
        if loggedInUserid == from {
            friendId = to
        }
        
        
        let dict = ["last_message" : last_message,
                    "node_id": node_id,
                    "readMessage": readMessage,
                    "readonly": readonly,
                    "status": status,
                    "timestamp": timestamp,
                    "to": to,
                    "from": from,
                    "type": type,
                    "unread":unread,
                    "count": count,
                    "name":name
            ] as [String : Any]
        
            if friendId.count > 0 {
            //let date1 = SendingTime.dateFromTimeStamp()
            //let diffInDays = (Calendar.current.dateComponents([.day], from: date1, to: Date()).day) ?? 0
//            if diffInDays > chatOldDays {
//                deleteRecordForUser(userid: friendId)
//            }else {
             //   if from != Userda {
                    tempArr.append(dict)
              //  }
            //}
            }
        }
        
        //Delete all chat list for a user
         deleteChatListForUser(userid: loggedInUserid)
        
         
         let dict = ["user_id" : loggedInUserid,
                     "userList": tempArr
         ] as [String : Any]
         
         let realm = try? Realm()
         let resultList = realm?.objects(ResentList.self)
         let obj = ResentList(value: dict)
    
         let predicate = NSPredicate(format: "user_id == %@", loggedInUserid)
         let filteredArr = resultList?.filter { predicate.evaluate(with: $0) }
         if filteredArr?.count ?? 0 > 0 {
            try? realm?.write ({
                realm?.add(obj, update: .all)
                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
            })
         }
         else {
            try? realm?.write ({
                realm?.add(obj, update: .error)
                NotificationCenter.default.post(name: NSNotification.Name("ChatNotificationReceived"), object: nil)
            })
         }
                        
    
    }
    
    //Fetch Resent User List
    class func fetchResentListFromDatabase() -> [ResentUsers]? {
        
        let userDetails = kSharedUserDefaults.getLoggedInUserDetails()
        let loggedInUserid = String.getString(userDetails[Parameters.user_id])
        
        var resentList = [ResentUsers]()
         let realm = try? Realm()
         guard let result = realm?.objects(ResentList.self).filter("user_id == %@", loggedInUserid) else { return  resentList}
        let obj = result.first ?? ResentList()
                
        let array = Array(obj.userList)
         
         let sortedResult = array.sorted(by: { (model1, model2) -> Bool in
            Int64(model1.timestamp ?? "0") >  Int64(model2.timestamp ?? "0")
         })
         resentList = sortedResult
        
        return resentList
    }
    
    class func emptyResentTableInDatabase() {
        let realm = try? Realm()
        if let result = realm?.objects(ResentUsers.self) {
            try! realm?.write {
                if !result.isInvalidated {
                    realm?.delete(result)
                }
            }
        }
    }
    
    class func deleteRecordForUser(userid: String) {
        let realm = try? Realm()
        if let result = realm?.objects(ResentUsers.self).filter("id == %@", userid) {
            if result.count > 0 {
                let obj = result[0]
                if !obj.isInvalidated {
                    try? realm?.write {
                        realm?.delete(obj)
                    }
               }
            }
        }
    }
    
    class func deleteChatListForUser(userid: String) {
        let realm = try? Realm()
        if let result = realm?.objects(ResentList.self).filter("user_id == %@", userid) {
            if result.count > 0 {
                let obj = result[0]
                if !obj.isInvalidated {
                    try? realm?.write {
                        realm?.delete(obj)
                    }
               }
            }
        }
    }
}

//MARK:- Class for User Information
class UsersState {
    var userid :String?
    var name :String?
    var lastmessage:String?
    var SendingTime =  Int()
    var imageUrl :String?
    var isOnline :String?
    var blockUsers :[String]?
    init(userid:String , lastmessage :String , time :String , name :String , imageUrl:String ,  isOnline:String , blockUsers:[String]) {
        self.userid = String.getString(userid)
        self.lastmessage = String.getString(lastmessage)
        self.SendingTime = Int.getInt(time)
        self.name = String.getString(name)
        self.imageUrl = String.getString(imageUrl)
        self.isOnline = String.getString(isOnline)
        self.blockUsers = kSharedInstance.getStringArray(blockUsers)
    }
}


//MARK:- Class for Group Model
class GroupModel {
    var userid :String?
    var name :String?
    var lastmessage:String?
    var imageUrl :String?
    var isOnline :String?
    var user :[Any]?
    init(userid:String   , name :String , imageUrl:String , user:[Any]){
        self.userid = String.getString(userid)
        self.name = String.getString(name)
        self.imageUrl = String.getString(imageUrl)
        self.user = user
    }
}
class VideoData {
    var thumbnilImage:UIImage?
    var videoUrl:URL?
    var videoData:Data?
    var videoTime:Float64?
    init() {  }
    
}
