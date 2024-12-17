//
//  ChatViewController_Ext_Chat.swift
//  RippleApp
//
//  Created by Mohd Aslam on 30/04/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

//MARK:- Extension for  For send Data and receive data
extension ChatViewController {

    //MARK:- Func For Send Data
    func saveMessageLocallyInDatabase(mediaurl: String, mediatype: String, message: String, thumnilimageurl: String) {
        let timeStamp = Int(Date().timeIntervalSince1970 * 1000)
        let completeName = self.userDetails[Parameters.name] as? String ?? ""
        let Senderid = String.getString(self.userDetails[Parameters.user_id])
        let Receiverid = String.getString(self.receiverid)
        let chatId = Senderid < Receiverid ? "\(String.getString(Senderid))_\(String.getString(Receiverid))" :  "\(String.getString(Receiverid))_\(String.getString(Senderid))"
        
        let dict = ["Senderid" : Senderid,
                "Message": message,
                "SendingTime": timeStamp,
                "Receiverid": Receiverid,
                "isDeleted": "",
                "starmessage": "",
                "uid": "",
                "mediatype": mediatype,
                "Sendername": completeName,
                "thumnilimageurl": thumnilimageurl,
                "imageurl": "",
                "mediaurl": mediaurl,
                "status": "not_seen",
                "fileName": "",
                "groupName": "",
                "img_type": "",
                "chat_id": chatId
        ] as [String : Any]
        
        MessageClass.addNewMessageInList(msgDict: dict, userid: Receiverid)
        self.Messageclass = MessageList.fetchMessagesForUser(userid: receiverid) ?? []
        self.filterMessageArray()
        self.chatTblView.reloadData()
        self.scrollToBottom(animated : true)
    }
    
    func SendtextMessage() {
        //saveMessageLocallyInDatabase(mediaurl: "", mediatype: "text", message: String.getString(self.chatTextView.text), thumnilimageurl: "")
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        let dic: [String: Any] = [Parameters.senderid: String.getString(UserData.shared.id),
                   Parameters.sendername:String.getString(UserData.shared.full_name),
                   Parameters.content: String.getString(self.chatTextView.text) ,
                   Parameters.timeStamp : timeStamp ,
                   Parameters.receiverid  : String.getString(self.receiverid),
                   Parameters.mediatype : "text",
                   "profileImage":"",
                  ]
        if self.CreatedBy == Parameters.emptyString {
            if self.chatTextView.text?.isEmpty ?? true  {
                print("Emptty messages and return from group ")
                return
            }
            self.unread_count += 1
            Chat_hepler.Shared_instance.SendMessage(dic: kSharedInstance.getDictionary(dic),recentDic: kSharedInstance.getDictionary(dic), Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self.receiverid))
            
            //Func for resend users
            Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString(self.chatTextView.text), Receiverid: String.getString(self.receiverid), Senderid: String.getString(UserData.shared.id), name: String.getString(self.receivername), lastTimestamp: Int64(timeStamp),type: "text")
          
            //saveMessageLocallyInDatabase()
        } else {
            if self.chatTextView.text?.isEmpty ?? true {
                print("Empty messages and return from group")
                return
            }
            //Chat_hepler.Shared_instance.SendMessagetoGroup(dic: kSharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), groupid: String.getString(self.receiverid))
            //Chat_hepler.Shared_instance.GroupResentUser(lastmessage:  String.getString(self.chatTextView.text), groupid:  String.getString(self.receiverid) , adminid: String.getString(self.CreatedBy), name: String.getString(self.receiverid), profile_image: String.getString(self.receiverprofile_image), readState: "")
        }
        self.chatTextView.text = nil
        
        self.scrollToBottom(animated: true)
        //Chat_hepler.Shared_instance.updateTypingStat(receiverid: self.receiverid, status: 0)
    }

    // MARK: - Func For Send Data
    func ShareLocation() {
        /*
        let currentLocation = (UIApplication.shared.delegate as? AppDelegate)?.currentLocation
        let timeStamp = String.getString(Int(Date().timeIntervalSince1970 * 1000))
        let completeName = self.userDetails["name"] as? String ?? ""
        

    let dic = [Parameters.senderid: String.getString(self.userDetails[Parameters.user_id]), Parameters.content: String.getString(self.chatTextView.text) , Parameters.timeStamp : timeStamp , Parameters.receiverid  : String.getString(self.receiverid)  , Parameters.thumnilimageurl : "" , Parameters.mediatype : "location" ,  Parameters.isDeleted : "" ,  Parameters.sendername :  self.userDetails[Parameters.name] ,   Parameters.mediaurl :  "" , Parameters.groupid :  "",Parameters.groupname : "","from_name" : completeName, "to_name" : self.receivername , Parameters.location : sharedInstance.getDictionary(currentLocation)]
        
        if self.CreatedBy == Parameters.emptyString {

            Chat_hepler.Shared_instance.SendMessage(dic: sharedInstance.getDictionary(dic), Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid))
            //Func for resend users
            Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString("Location"), Receiverid: String.getString(self.receiverid), Senderid: String.getString(self.userDetails[Parameters.user_id]), name: String.getString(self.receivername), profile_image: String.getString(self.receiverprofile_image), readState: "sent", isMsgSend: true, lastTimestamp: timeStamp)
        }*/
    }
    
    //MARK:- Function for Receive Message
    func ReceiveMessage() {
        if self.CreatedBy == Parameters.emptyString {
            Chat_hepler.Shared_instance.Receivce_message(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid)) {[weak self] (value, ChatBackUp, success, isExist)  in
                if success {
                    CommonUtils.showHudWithNoInteraction(show: false)
                }
                if !isExist {
                    self?.Messageclass.removeAll()
                    self?.MessageObjList.removeAll()
                    self?.chatTblView.reloadData()
                    return
                }
                CommonUtils.showHudWithNoInteraction(show: false)
                if self?.isUserBlocked ?? false {
                    return
                }
                self?.refreshReceiverDetailOnFirebase()
            }
            /*
            Chat_hepler.Shared_instance.Receivce_Unread_message(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid)) { (isExist) in
                
                if !isExist {
                    return
                }
                if self.isUserBlocked {
                    return
                }
                self.refreshReceiverDetailOnFirebase()
            }
            Chat_hepler.Shared_instance.Receivce_Delivered_message(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid)) { (isExist) in
                
                if !isExist {
                    return
                }
                if self.isUserBlocked {
                    return
                }
                self.refreshReceiverDetailOnFirebase()
            }*/
        } else {
            
            Chat_hepler.Shared_instance.Receivce_messagefromGroup(groupid: String.getString(self.receiverid)) { (value ,  ChatBackUp)  in
                self.Messageclass.removeAll()
               // self.ChatBackup.removeAll()
                value != nil ? (self.Messageclass = value!) : print(Parameters.nomessagesdata)
                ChatBackUp != nil ? (self.ChatBackup = ChatBackUp!) : print(Parameters.nobackupdata)
                self.chatTblView.reloadData()
                self.scrollToBottom(animated : false)
            }
            
        }
    }
    
    func refreshReceiverDetailOnFirebase() {
        guard let vc = UIApplication.topViewController() else { return }
            if vc .isKind(of: ChatViewController.self) {
            
            self.Messageclass.removeAll()
            self.Messageclass =  MessageList.fetchMessagesForUser(userid: self.receiverid) ?? []
            
            
            //Chat_hepler.Shared_instance.readMessageCountForAConversation(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: self.receiverid)
            
            Chat_hepler.Shared_instance.readperticularMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), array: self.Messageclass)
            
                let msgSenser_id = String.getString(self.Messageclass.last?.Senderid)
                let msgReceiver_id = String.getString(self.Messageclass.last?.Receiverid)
            if !msgSenser_id.isEmpty && !msgReceiver_id.isEmpty {
                Chat_hepler.Shared_instance.ResentUser(lastmessage:  String.getString(self.Messageclass.last?.Message), Receiverid: String.getString(self.receiverid), Senderid: msgSenser_id, name: String.getString(self.receivername), lastTimestamp: Int64(self.Messageclass.last?.SendingTime ?? 0),type:String.getString(self.Messageclass.last?.mediatype))
            }
            
                self.filterMessageArray()
                self.chatTblView.reloadData()
                self.scrollToBottom(animated : true)

        }
    }
    
    func filterMessageArray() {
        self.MessageObjList.removeAll()
        var timeStampArray = [String]()
        
        self.Messageclass.forEach { (message) in
            let date = message.SendingTime.dateFromTimeStamp()
            let dateStr  = date.toString(withFormat: "MM/dd/yyyy")
            timeStampArray.append(dateStr)
        }
        
        let arr = Array(Set(timeStampArray))
        timeStampArray = arr
        
        for time in timeStampArray {
            let date1 = Date.dateFromString(date: time, withCurrentFormat: "MM/dd/yyyy")
            let timestamp = date1.toMillis() ?? 0
            var tmpArr = [MessageClass]()
            self.Messageclass.forEach { (message) in
                let date1 = message.SendingTime.dateFromTimeStamp()
                let dateStr1  = date1.toString(withFormat: "MM/dd/yyyy")
                if time == dateStr1 {
                    tmpArr.append(message)
                }
            }
            self.MessageObjList.append(MessageObject(time: timestamp, messageList: tmpArr))
            self.MessageObjList.sort{ $0.SendingTime < $1.SendingTime }
        }
    }
}
