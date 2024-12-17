//
//  ParcelPushModel.swift
//  ViewedApp
//
//  Created by Varun on 13/09/19.
//  Copyright © 2019 fluper. All rights reserved.
//

import Foundation
import UIKit

enum ViewedPushStatus: String {
    
    
    case VIDEO_CALL_INCOMING
    case VIDEO_CALL_DISCONNECT
    case VIDEO_CALL_REJECT
    case VIDEO_CALL_ACCEPT
    case GROUP_VIDEO_CALL_INCOMING
    case GROUP_VIDEO_CALL_DISCONNECT
    case GROUP_VIDEO_CALL_REJECT
    case GROUP_VIDEO_CALL_ACCEPT
    case AUDIO_CALL_INCOMING
    case AUDIO_CALL_DISCONNECT
    case AUDIO_CALL_REJECT
    case AUDIO_CALL_ACCEPT
    case GROUP_AUDIO_CALL_INCOMING
    case GROUP_AUDIO_CALL_DISCONNECT
    case GROUP_AUDIO_CALL_REJECT
    case GROUP_AUDIO_CALL_ACCEPT
    case MESSAGE
    case EXTEND_REQUEST_ACCEPT
    case EXTEND_REQUEST_REJECT
    case none
    init(_ status: String) {
        
        switch status {
        case "VIDEO_CALL_INCOMING":
            self = .VIDEO_CALL_INCOMING
        case "VIDEO_CALL_DISCONNECT":
            self = .VIDEO_CALL_DISCONNECT
        case "VIDEO_CALL_REJECT":
            self = .VIDEO_CALL_REJECT
        case "VIDEO_CALL_ACCEPT":
            self = .VIDEO_CALL_ACCEPT
        case "GROUP_VIDEO_CALL_INCOMING":
            self = .GROUP_VIDEO_CALL_INCOMING
        case "GROUP_VIDEO_CALL_DISCONNECT":
            self = .GROUP_VIDEO_CALL_DISCONNECT
        case "GROUP_VIDEO_CALL_REJECT":
            self = .GROUP_VIDEO_CALL_REJECT
        case "GROUP_VIDEO_CALL_ACCEPT":
                self = .GROUP_VIDEO_CALL_ACCEPT
        case "AUDIO_CALL_INCOMING":
            self = .AUDIO_CALL_INCOMING
        case "AUDIO_CALL_DISCONNECT":
            self = .AUDIO_CALL_DISCONNECT
        case "AUDIO_CALL_REJECT":
            self = .AUDIO_CALL_REJECT
        case "AUDIO_CALL_ACCEPT":
            self = .AUDIO_CALL_ACCEPT
        case "GROUP_AUDIO_CALL_INCOMING":
                self = .GROUP_AUDIO_CALL_INCOMING
        case "GROUP_AUDIO_CALL_DISCONNECT":
                self = .GROUP_AUDIO_CALL_DISCONNECT
        case "GROUP_AUDIO_CALL_REJECT":
                self = .GROUP_AUDIO_CALL_REJECT
        case "GROUP_AUDIO_CALL_ACCEPT":
                self = .GROUP_AUDIO_CALL_ACCEPT
        case "MESSAGE":
            self = .MESSAGE
        case "EXTEND_REQUEST_ACCEPT":
            self = .EXTEND_REQUEST_ACCEPT
        case "EXTEND_REQUEST_REJECT":
            self = .EXTEND_REQUEST_REJECT
        default:
            self = .none
            
        }
    }
}

//MARK: - OnJezPushModel -

class ViewedPushModel: NSObject {
    lazy var notificationCount: String = "0"
    lazy var notificationType = ViewedPushStatus.none
    lazy var notificationID:String = ""
    lazy var profilePic:String = ""
    var messagedata:GetMessageModel?
    init?(withDictionary dictNotification: [AnyHashable : Any]) {
         let notiDict = kSharedInstance.getDictionary(dictNotification["aps"])
        super.init()
        if (dictNotification["notificationType"] != nil) {
            self.notificationType = ViewedPushStatus(String.getString(dictNotification["notificationType"]))
        }else {
            self.notificationType = ViewedPushStatus(String.getString(dictNotification["gcm.notification.notificationType"]))
        }
        self.notificationCount = String.getString(notiDict["badge"])
        self.notificationID = String.getString(dictNotification["order_id"])
//        let jsonDic = kSharedAppDelegate.convertToDictionary(text: String.getString(notiDict["alert"]))
//        print(jsonDic ?? [:])
        self.messagedata = GetMessageModel.init(param: kSharedInstance.getDictionary(dictNotification))
    }
}

 class GetMessageModel{
    
    var call_status: String?
    var fullName      : String?
    var message : String?
    var notificationType: String?
    var profilePic: String?
    var sendBy: String?
    var sendTo: String?
    var title: String?
    var id:String?
    var body:String?
    var group_id: String?
    var call_id: String?
    var booking_id:String?
    init(){}
    
    init(param: [String: Any]) {
        self.id = String.getString(param["gcm.message_id"])
        if (param["call_status"] != nil) {
            self.call_status = String.getString(param["call_status"])
        }else {
            self.call_status = String.getString(param["gcm.notification.call_status"])
        }
        if (param["name"] != nil) {
            self.fullName = String.getString(param["name"])
        }else {
            self.fullName = String.getString(param["gcm.notification.name"])
        }
        if (param["message"] != nil) {
            self.message = String.getString(param["message"])
        }else {
            self.message = String.getString(param["gcm.notification.message"])
        }
        if (param["type"] != nil) {
            self.notificationType = String.getString(param["type"])
        }else {
            self.notificationType = String.getString(param["gcm.notification.type"])
        }
        self.profilePic = String.getString(param["profileImage"])
        if (param["sendBy"] != nil) {
            self.sendBy = String.getString(param["sendBy"])
        }else {
            self.sendBy = String.getString(param["gcm.notification.sendBy"])
        }
        if (param["sendTo"] != nil) {
            self.sendTo = String.getString(param["sendTo"])
        }else {
            self.sendTo = String.getString(param["gcm.notification.sendTo"])
        }
        self.title = String.getString(param["title"])
        self.body = String.getString(param["body"])
        if (param["group_id"] != nil) {
            self.group_id = String.getString(param["group_id"])
        }else {
            self.group_id = String.getString(param["gcm.notification.group_id"])
        }
        if (param["callId"] != nil) {
            self.call_id = String.getString(param["callId"])
        }else {
            self.call_id = String.getString(param["gcm.notification.callId"])
        }
        if (param["booking_id"] != nil) {
            self.booking_id = String.getString(param["booking_id"])
        }else {
            self.booking_id = String.getString(param["gcm.notification.booking_id"])
        }
        
    }
}
