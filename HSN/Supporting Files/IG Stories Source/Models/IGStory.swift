//
//  IGStory.swift
//
//  Created by Ranjith Kumar on 9/8/17
//  Copyright (c) DrawRect. All rights reserved.
//

import Foundation

public class IGStory: Codable {
    // Note: To retain lastPlayedSnapIndex value for each story making this type as class
    public var snapsCount: Int {
        return snaps.count
    }
    
    // To hold the json snaps.
    private var _snaps: [IGSnap]
    
    // To carry forwarding non-deleted snaps.
    public var snaps: [IGSnap] {
        return _snaps.filter{!($0.isDeleted)}
    }
    public var internalIdentifier: String{
        get{
            String.getString(id).isEmpty ? "0" : String.getString(id)
        }
    }
    var id:Int?
    public var lastUpdated: Int {
        get{
           return Int( Date().unixTimestamp)
        }
    }
    public var user:IGUser{
        get{
            IGUser(full_name: self.full_name,profile_pic: self.profile_pic)
        }
    }
    var lastPlayedSnapIndex = 0
    var isCompletelyVisible = false
    var isCancelledAbruptly = false
    
    var full_name: String
    var profile_pic: String

    
    
    enum CodingKeys: String, CodingKey {
        //case snapsCount = "snaps_count"
        case _snaps = "my_story"
        
        case id = "id"
        //case lastUpdated = "last_updated"
        
        
        //case my_story = "my_story"
        case full_name = "full_name"
      
        case profile_pic = "profile_pic"
       
        
    }
}

extension IGStory: Equatable {
    public static func == (lhs: IGStory, rhs: IGStory) -> Bool {
        return lhs.internalIdentifier == rhs.internalIdentifier
    }
}
