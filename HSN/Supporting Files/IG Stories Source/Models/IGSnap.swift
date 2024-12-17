//
//  IGSnap.swift
//
//  Created by Ranjith Kumar on 9/28/17
//  Copyright (c) DrawRect. All rights reserved.
//

import Foundation

public enum MimeType: String {
    case image
    case video
    case unknown
}
public class IGSnap: Codable {
    
    
    
    public var internalIdentifier: String{
        get{
            return String.getString(id)
        }
    }
    let id:Int
    public var mimeType: String {
        get{
            switch getMediaType(url: self.url){
            case 1:
                return  "image"
            case 3:
                return "video"
            default:
               return "unknown"
                
            }
                
        }
    }
    public var lastUpdated: String{
        get{
            return "15m"
        }
    }
    public var url: String{
        get{
            kBucketUrl + directoryURL
        }
    }
    var directoryURL:String
    // Store the deleted snaps id in NSUserDefaults, so that when app get relaunch deleted snaps will not display.
    public var isDeleted: Bool {
        set{
            UserDefaults.standard.set(newValue, forKey: internalIdentifier)
        }
        get{
            return UserDefaults.standard.value(forKey: internalIdentifier) != nil
        }
    }
    public var kind: MimeType {
        switch mimeType {
            case MimeType.image.rawValue:
                return MimeType.image
            case MimeType.video.rawValue:
                return MimeType.video
            default:
                return MimeType.unknown
        }
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        
        //case lastUpdated = "last_updated"
        case directoryURL = "picture"
    }
    func getMediaType(url:String)->Int{
        let imageExtensions = ["png", "jpg", "gif","jpeg"]
        let documentExtensions = ["pdf","txt","rtf"]
        let url: URL? = NSURL(fileURLWithPath: url) as URL
        let pathExtention = url?.pathExtension
        if imageExtensions.contains(pathExtention!)
        {
            return 1
        }
        else if documentExtensions.contains(pathExtention!)
        {
            return 2
        }
        else
        {
            return 3
        }
    }
}
