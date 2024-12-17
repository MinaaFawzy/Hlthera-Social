//
//  IGUser.swift
//
//  Created by Ranjith Kumar on 9/8/17
//  Copyright (c) DrawRect. All rights reserved.
//

import Foundation

public class IGUser {
    internal init(full_name: String = "",profile_pic: String = "") {
        self.full_name = full_name
        self.profile_pic = profile_pic
        
    }
    
    public let internalIdentifier: String = ""
    public var name: String {
        get{
            self.full_name
            
        }
    }
    public var picture:String {
        get{
            kBucketUrl + profile_pic
        }
    }
    
    
    var full_name: String = ""
    var profile_pic: String = ""
    
    
    
    
    
//    enum CodingKeys: String, CodingKey {
//        case internalIdentifier = "id"
//        case name = "name"
//        case picture = "picture"
//    }
}
