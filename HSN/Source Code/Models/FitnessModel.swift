//
//  FitnessModel.swift
//  HSN
//
//  Created by Shobhit Rastogi on 10/12/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import Foundation
class AllChallenges{

    var id : Int
    var user_id = ""
    var images = ""
    var name = ""
    var description = ""
    var goals = ""
    var start_date = ""
    var start_time = ""
    var created_at = ""
    var updated_at = ""
    var end_date = ""
    var end_time = ""
    var type = ""
    var category = ""
    var accepted_count : Int
    var userdata = [Userdata]()

    init(data:[String:Any]) {
        self.id = Int.getInt(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.description = String.getString(data["description"])
        self.images = String.getString(data["images"])
        self.name = String.getString(data["name"])
        self.goals = String.getString(data["goals"])
        self.start_date = String.getString(data["start_date"])
        self.start_time = String.getString(data["start_time"])
        self.end_date = String.getString(data["end_date"])
        self.end_time = String.getString(data["end_time"])
        self.type = String.getString(data["type"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.accepted_count = Int.getInt(data["accepted_count"])
        self.category = String.getString(data["category"])
        
        // let user  = kSharedInstance.getDictionaryArray(withDictionary: data["users"])
        //self.userdata = user.map{Userdata(data: $0)}
       // self.userdata = kSharedInstance.getArray(data["users"]).map{Userdata(data: kSharedInstance.getDictionary($0))}
        userdata = kSharedInstance.getArray(data["users"]).map{Userdata(data: kSharedInstance.getDictionary($0))}
    }

    
}

class Userdata{
    
    var id:Int
    var full_name:String
    var email:String
    var profile_pic:String
    var user_full_name:String
    var user_profile_pic:String
    
    init(data:[String:Any]) {
        self.id = Int.getInt(data["id"])
        self.full_name = String.getString(data["full_name"])
        self.email = String.getString(data["email"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.user_full_name = String.getString(data["user_full_name"])
        self.user_profile_pic = String.getString(data["user_profile_pic"])
        
    
    }
}
//                       "id": 4,
//                       "full_name": "Sanjay",
//                       "email": "sanjay@xyz.com",
//                       "profile_pic": "hlthera-social/profile_img/1663327558_52244.jpeg",
//                       "user_full_name": "Sanjay",
//                       "user_profile_pic": "hlthera-social/profile_img/1663327558_52244.jpeg"
//
