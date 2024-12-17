//
//  IGStories.swift
//  InstagramStories
//
//  Created by Ranjith Kumar on 9/8/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import Foundation

public class IGStories: Codable {
    public var otherStoriesCount: Int{
        get{
            self.otherStories.count
        }
    }
    public let otherStories: [IGStory]
    public var myStory: [IGStory] {
        get{ [story] }
    }
    
    public let story:IGStory
    public let base_url:String
    public let message:String
    public let company_data: [IGStory]
    public let other_company_story: [IGStory]
    
    
    
    enum CodingKeys: String, CodingKey {
        case base_url = "base_url"
        case message = "message"
        case otherStories = "other_story"
        case story = "my_data"
        case company_data = "company_data"
        case other_company_story = "other_company_story"
    }
    func copy() throws -> IGStories {
        let data = try JSONEncoder().encode(self)
        let copy = try JSONDecoder().decode(IGStories.self, from: data)
        return copy
    }
}

extension IGStories {
    func removeCachedFile(for urlString: String) {
        IGVideoCacheManager.shared.getFile(for: urlString) { (result) in
            switch result {
            case .success(let url):
                IGVideoCacheManager.shared.clearCache(for: url.absoluteString)
            case .failure(let error):
                debugPrint("File read error: \(error)")
            }
        }
    }
    static func removeAllVideoFilesFromCache() {
        IGVideoCacheManager.shared.clearCache()
    }
}
