//
//  Exclusive.swift
//  HSN
//
//  Created by Apple on 01/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import Foundation
import Kingfisher

class ExclusivePost{

    var id = ""
    var category_id = ""
    var description = ""
    var is_block = ""
    var is_post_publish = ""
    var created_at = ""
    var updated_at = ""
    var post_comment_count = ""
    var all_like_user_count = ""
    var media = ""
    var likeType = [Int]()

    init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.category_id = String.getString(data["category_id"])
        self.description = String.getString(data["description"])
        self.is_block = String.getString(data["is_block"])
        self.is_post_publish = String.getString(data["is_post_publish"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.post_comment_count = String.getString(data["post_comment_count"])
        self.all_like_user_count = String.getString(data["get_all_like_user_count"])
        let adminPosts = kSharedInstance.getDictionaryArray(withDictionary: data["admin_posts"]).first
        self.media = String.getString(adminPosts?["media"])

        let typeDict = kSharedInstance.getArray(withDictionary: data["like_type"])
        for like in typeDict {
            let like_type = Int.getInt(like["like_type"])
            self.likeType.append(like_type)
        }
        self.likeType = self.likeType.unique
    }

    
}
