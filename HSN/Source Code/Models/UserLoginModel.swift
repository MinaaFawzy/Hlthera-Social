import UIKit
import Kingfisher
import AVKit


class UserData {
    
    static var shared = UserData()
    
    var first_name = ""
    var last_name = ""
    var email = ""
    var country_code = ""
    var mobile_number = ""
    var id = ""
    var is_register = false
    var is_otp_verified = false
    var is_typeWork_filled = false
    var title = ""
    var employee_type = ""
    var company_name = ""
    var location = ""
    var start_date = ""
    var end_date = ""
    var is_currently_working_in_role = false
    var country = ""
    var state = ""
    var city = ""
    var is_profile_pic_uploaded = false
    var profile_pic = ""
    var social_id  = ""
    var login_type = ""
    var headline = ""
    var industries = ""
    var username = ""
    var interests:[InterestModel] = []
    var full_name = ""
    
    private init() {
        let data: [String:Any] = kSharedUserDefaults.getLoggedInUserDetails()
        saveData(data: data)
    }
    
    func saveData(data: [String: Any]) {
        first_name = String.getString(data["first_name"])
        last_name = String.getString(data["last_name"])
        full_name = String.getString(data["full_name"])
        id = "\(data["id"] ?? 0)"
        mobile_number = String.getString(data["mobile_number"])
        email = String.getString(data["email"])
        country_code = String.getString(data["country_code"])
        is_register = String.getString(data["is_register"]) == "0" ? false : true
        is_otp_verified = String.getString(data["is_otp_verified"]) == "0" ? false : true
        is_typeWork_filled = String.getString(data["is_typeWork_filled"]) == "0" ? false : true
        title = String.getString(data["title"])
        employee_type = String.getString(data["employee_type"])
        company_name = String.getString(data["company_name"])
        profile_pic = String.getString(data["profile_pic"])
        location = String.getString(data["location"])
        start_date = String.getString(data["start_date"])
        end_date = String.getString(data["end_date"])
        is_currently_working_in_role = String.getString(data["is_currently_working_in_role"]) == "0" ? false : true
        country = String.getString(data["country"])
        state = String.getString(data["state"])
        city = String.getString(data["city"])
        headline = String.getString(data["headline"])
        is_profile_pic_uploaded = String.getString(data["is_profile_pic_uploaded"]) == "0" ? false : true
        self.industries = String.getString(data["industries"])
        social_id  = String.getString(data["social_id"])
        login_type = String.getString(data["login_type"])
        
        interests = kSharedInstance.getArray(data["interests"]).map{InterestModel(data: kSharedInstance.getDictionary($0))}
        username = String.getString(data["username"])
        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
        kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(data["access_token"]))
        
    }
}

class CountriesStatesCitiesModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.sortname = String.getString(data["sortname"])
        self.name = String.getString(data["name"])
        self.phonecode = String.getString(data["phonecode"])
        self.country_id = String.getString(data["country_id"])
    }
    
    var id = ""
    var sortname = ""
    var name = ""
    var phonecode = ""
    var country_id = ""
}
class TopicsModel {
    internal init(data:[String:Any]) {
        self.topicId = String.getString(data["topic_id"])
        self.topicName = String.getString(data["topic_name"])
        self.interests = kSharedInstance.getArray(data["post_pic"]).map{InterestModel(data: kSharedInstance.getDictionary($0))}
    }
    
    var topicId = ""
    var interests: [InterestModel]
    var topicName = ""
    var isSelected = false
}

class InterestModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        
        self.name = String.getString(data["name"])
        self.picture =  kBucketUrl + String.getString(data["picture"])
        
    }
    
    var id = ""
    var picture = ""
    var name = ""
    var isSelected = false
    
}

//class StoriesModel{
//    internal init(data:[String:Any]) {
//        self.first_name = String.getString(data["first_name"])
//        self.last_name = String.getString(data["last_name"])
//        self.profile_pic = String.getString(data["profile_pic"])
//        self.email = String.getString(data["email"])
//        self.mobile_number = String.getString(data["mobile_number"])
//        self.profile_pic = String.getString(data["profile_pic"])
//        self.employee_type = String.getString(data["employee_type"])
//        self.my_story = kSharedInstance.getArray(data["my_story"]).map{IGStory(data: kSharedInstance.getDictionary($0))}
//       self.other_story = kSharedInstance.getArray(data["other_story"]).map{IGStory(data: kSharedInstance.getDictionary($0))}
//        self.my_story = my_story(data: kSharedInstance.getArray(data["my_story"]) as? [[String:Any]] ?? [], user: data)
//        self.other_story = IGStory(data: kSharedInstance.getArray(data["other_story"]) as? [[String:Any]] ?? [], user: data)
//
//
//    }
//
//    var first_name = ""
//    var last_name = ""
//    var email = ""
//    var mobile_number = ""
//    var profile_pic = ""
//    var employee_type = ""
//    var my_story:IGStory?
//    var other_story:IGStory?
//}

class CelebrationImageModel {
    internal init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.celebration_type = String.getString(data["celebration_type"])
        self.celebration_image = String.getString(data["celebration_image"])
    }
    
    var id = ""
    var celebration_type = ""
    var celebration_image = ""
    var isSelected = false
}
class StoryModel {
    internal init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.picture = String.getString(data["picture"])
        self.description = String.getString(data["description"])
    }
    
    var id = ""
    var picture = ""
    var description = ""
}
class ExploreOptionsModel {
    internal init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.is_count = String.getString(data["is_count"])
        self.activeImage = String.getString(data["image"])
        self.inActiveImage = String.getString(data["inactive_image"])
        
        
    }
    func downloadData() {
        if !self.activeImage.isEmpty {
            KingfisherManager.shared.retrieveImage(with: URL(string: kBucketUrl + self.activeImage)!, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.localImageActive = value.image
                case .failure(let error):
                    print("Error: \(error)")
                    
                    self.localImageActive = nil
                }
            }
            
        }
        if !self.inActiveImage.isEmpty {
            KingfisherManager.shared.retrieveImage(with: URL(string: kBucketUrl + self.inActiveImage)!, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.localImageInActive = value.image
                case .failure(let error):
                    print("Error: \(error)")
                    
                    self.localImageInActive = nil
                }
            }
            
        }
    }
    
    
    
    var id = ""
    var name = ""
    var activeImage = ""
    var inActiveImage = ""
    var created_at = ""
    var updated_at = ""
    var is_count = ""
    
    var localImageActive:UIImage? = nil
    var localImageInActive:UIImage? = nil
    var isSelected = false
    
}

class HomeFeedModel {
    init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.is_post_type = String.getString(data["is_post_type"])
        self.celebrate_type = String.getString(data["celebrate_type"])
        self.description = String.getString(data["description"])
        self.hashTag = kSharedInstance.getArray(data["hashTag"]).map{HashTagModel(data: kSharedInstance.getDictionary($0))}
        self.recipient_id = String.getString(data["ecipient_id"])
        self.postType = String.getString(data["postType"])
        self.date_of_post = String.getString(data["date_of_post"])
        self.share_with = String.getString(data["share_with"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.user_first_name = String.getString(data["user_first_name"])
        self.user_last_name = String.getString(data["user_last_name"])
        self.user_full_name = String.getString(data["user_full_name"])
        self.user_profile_pic = String.getString(data["user_profile_pic"])
        self.post_pic = kSharedInstance.getArray(data["post_pic"]).map{PostPicModel(data: kSharedInstance.getDictionary($0))}
        self.poll_ans_id = String.getString(data["poll_ans_id"])
        self.poll_duration = String.getString(data["poll_duration"])
        self.question = String.getString(data["question"])
        self.group_id = String.getString(data["group_id"])
        self.user_poll = kSharedInstance.getArray(data["user_poll"]).map{PollModel(data: kSharedInstance.getDictionary($0))}
        self.total_comments_count = String.getString(data["total_comments_count"])
        self.total_likes_count = String.getString(data["total_likes_count"])
        self.total_poll_votes = String.getString(data["ttl_poll_votes"])
        self.poll_remaining_time = String.getString(data["poll_remaining_time"])
        self.is_poll_open = String.getString(data["is_poll_open"]) == "1" ? true : false
        self.is_post_like = String.getString(data["is_post_like"])
        let temp = (data["share_post"]) as? [String:Any] ?? [:]
        self.share_post = temp.isEmpty ? (nil) : (HomeFeedModel(data: kSharedInstance.getDictionary(data["share_post"])))
        self.tag_people = kSharedInstance.getArray(data["tag_people"]).map{AllUserModel(data: kSharedInstance.getDictionary($0))}
        self.city_name = String.getString(data["city_name"])
        self.state_name = String.getString(data["state_name"])
        self.country_name = String.getString(data["country_name"])
        self.post_share_count = String.getString(data["post_share_count"])
        self.is_favourite = String.getString(data["is_favourite"]) == "1" ? true : false
        self.count_reaction_like = String.getString(data["count_reaction_like"]).components(separatedBy: ",")
        self.count_reaction_like_count = String.getString(data["count_reaction_like_count"]).components(separatedBy: ",")
        self.is_post_edited = String.getString(data["is_post_edited"]) == "1" ? true : false
        self.is_post_promotion = String.getString(data["is_post_promotion"]) == "1" ? true : false
        self.is_company_post = String.getString(data["is_company_post"]) == "1" ? true : false
        self.company_detail = CompanyPageModel(data: kSharedInstance.getDictionary(data["company_detail"]))
        self.promotion_post =  PromotionPostModel(data: kSharedInstance.getDictionary(data["promotion_post"]))
        self.target_audience_type = String.getString(data["target_audience_type"])
        self.total_view_posts_count = String.getString(data["total_view_posts_count"])
        self.unread_count = String.getString(data["unread_count"])
        let adminPosts = kSharedInstance.getDictionaryArray(withDictionary: data["admin_all_posts"])
        if adminPosts.count > 0 {
            let post = adminPosts.first
            self.media = String.getString(post?["media"])
            self.is_post_type = self.media == "" ? "0" : "1"
            self.postMode = .admin
            self.total_likes_count = String.getString(data["get_all_like_user_count"])
            self.total_comments_count = String.getString(data["post_comment_count"])
            let type_post = kSharedInstance.getDictionary(data["type_post"])
            self.title = String.getString(data["title"]) //String.getString(type_post["name"])
            let isLike = kSharedInstance.getDictionary(data["is_post_like"])
            self.is_post_like = String.getString(isLike["like_type"])
        }else if String.getString(data["title"]) != "" {
            self.postMode = .admin
            self.title = String.getString(data["title"])
        }
        if let like_type = data["like_type"] as? Array<Int>{
            self.likeType = like_type
        }
        else if let like_type = data["like_type"] as? Array<String>{
            self.likeType =  like_type.map({Int.getInt($0)})
        }
        else{
            let typeDict = kSharedInstance.getArray(withDictionary: data["like_type"])
            for like in typeDict {
                let like_type = Int.getInt(like["like_type"])
                self.likeType.append(like_type)
            }
            self.likeType = self.likeType.unique
        }
    }
    
    func downloadData() {
        self.post_pic = self.post_pic.map{ PostPicModel(id: $0.id, post_id: $0.post_id, picture: $0.picture, created_at: $0.created_at, updated_at: $0.updated_at)}
        if !self.user_profile_pic.isEmpty {
            KingfisherManager.shared.retrieveImage(with: URL(string: kBucketUrl + self.user_profile_pic)!, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.userProfilePic = value.image
                case .failure(let error):
                    print("Error: \(error)")
                    self.userProfilePic = nil
                }
            }
            
        }
    }
    var group_id = ""
    var id = ""
    var user_id = ""
    var is_post_type = ""
    var celebrate_type = ""
    var description = ""
    var hashTag:[HashTagModel] = []
    var recipient_id = ""
    var postType = ""
    var date_of_post = ""
    var share_with = ""
    var created_at = ""
    var updated_at = ""
    var user_first_name = ""
    var user_last_name = ""
    var user_profile_pic = ""
    var userProfilePic:UIImage?
    var post_pic:[PostPicModel] = []
    var poll_duration = ""
    var poll_remaining_time = ""
    var is_poll_open = false
    var question = ""
    var total_poll_votes = ""
    var user_poll:[PollModel] = []
    var total_comments_count = ""
    var total_likes_count = ""
    var is_post_like = ""
    var share_post:HomeFeedModel?
    var poll_ans_id = ""
    var tag_people:[AllUserModel] = []
    var city_name = ""
    var state_name = ""
    var country_name = ""
    var post_share_count = ""
    var is_favourite = false
    var is_post_edited = false
    var count_reaction_like:[String] = []
    var count_reaction_like_count:[String] = []
    var isSelected = false
    var is_post_promotion = false
    var is_company_post = false
    var company_detail:CompanyPageModel?
    var promotion_post:PromotionPostModel?
    var target_audience_type = ""
    var total_view_posts_count = ""
    var user_full_name = ""
    var unread_count = ""
    var media = ""
    var likeType = [Int]()
    var title : String = ""
    var postMode : Post = .user
}

class PromotionPostModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.post_id = String.getString(data["post_id"])
        self.user_id = String.getString(data["user_id"])
        self.promotion_goal_type = String.getString(data["promotion_goal_type"])
        self.promotion_goal = String.getString(data["promotion_goal"])
        self.target_audience_type = String.getString(data["target_audience_type"])
        self.location = String.getString(data["location"])
        self.interest = String.getString(data["interest"])
        self.gender = String.getString(data["gender"])
        self.age_group_from = String.getString(data["age_group_from"])
        self.age_group_to = String.getString(data["age_group_to"])
        self.budget = String.getString(data["budget"])
        self.audience_reach = String.getString(data["audience_reach"])
        self.price = String.getString(data["price"])
        self.tax = String.getString(data["tax"])
        self.total_amount = String.getString(data["total_amount"])
        self.tran_ref = String.getString(data["tran_ref"])
        self.cart_id = String.getString(data["cart_id"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.ttl_post_views = String.getString(data["ttl_post_views"])
        self.post_view_by_me = String.getString(data["post_view_by_me"])
        self.is_poll_open = String.getString(data["is_poll_open"])
        self.post_remaining_time = String.getString(data["post_remaining_time"])
    }
    
    var id = ""
    var post_id = ""
    var user_id = ""
    var promotion_goal_type = ""
    var promotion_goal = ""
    var target_audience_type = ""
    var location = ""
    var interest = ""
    var gender = ""
    var age_group_from = ""
    var age_group_to = ""
    var budget = ""
    var audience_reach = ""
    var price = ""
    var tax = ""
    var total_amount = ""
    var tran_ref = ""
    var cart_id = ""
    var created_at = ""
    var updated_at = ""
    var ttl_post_views = ""
    var post_view_by_me = ""
    var is_poll_open = ""
    var post_remaining_time = ""
}
class HashTagModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
    }
    
    var id = ""
    var name = ""
}
class HomeFeedShareModel {
    internal init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.is_post_type = String.getString(data["is_post_type"])
        self.celebrate_type = String.getString(data["celebrate_type"])
        self.description = String.getString(data["description"])
        self.hashTag = String.getString(data["hashTag"])
        self.recipient_id = String.getString(data["ecipient_id"])
        self.postType = String.getString(data["postType"])
        self.date_of_post = String.getString(data["date_of_post"])
        self.share_with = String.getString(data["share_with"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.user_first_name = String.getString(data["user_first_name"])
        self.user_last_name = String.getString(data["user_last_name"])
        self.user_profile_pic = String.getString(data["user_profile_pic"])
        self.post_pic = kSharedInstance.getArray(data["post_pic"]).map{PostPicModel(data: kSharedInstance.getDictionary($0))}
        self.poll_ans_id = String.getString(data["poll_ans_id"])
        self.poll_duration = String.getString(data["poll_duration"])
        self.question = String.getString(data["question"])
        self.user_poll = kSharedInstance.getArray(data["user_poll"]).map{PollModel(data: kSharedInstance.getDictionary($0))}
        self.total_comments_count = String.getString(data["total_comments_count"])
        self.total_likes_count = String.getString(data["total_likes_count"])
        self.is_post_like = String.getString(data["is_post_like"]) == "1" ? true : false
        self.share_post = kSharedInstance.getDictionary(data["share_post"]).isEmpty ? false : true
        self.tag_people = kSharedInstance.getArray(data["tag_people"]).map{AllUserModel(data: kSharedInstance.getDictionary($0))}
    }
    
    var id = ""
    var user_id = ""
    var is_post_type = ""
    var celebrate_type = ""
    var description = ""
    var hashTag = ""
    var recipient_id = ""
    var postType = ""
    var date_of_post = ""
    var share_with = ""
    var created_at = ""
    var updated_at = ""
    var user_first_name = ""
    var user_last_name = ""
    var user_profile_pic = ""
    var userProfilePic = UIImage()
    var post_pic:[PostPicModel] = []
    var poll_duration = ""
    var question = ""
    var user_poll:[PollModel] = []
    var total_comments_count = ""
    var total_likes_count = ""
    var is_post_like = false
    var share_post:Bool?
    var poll_ans_id = ""
    var tag_people:[AllUserModel] = []
    
}
class PollModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.post_id = String.getString(data["post_id"])
        self.answer = String.getString(data["answer"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.ans_percentage = String.getString(data["ans_percentage"])
    }
    
    var id = ""
    var post_id = ""
    var answer = ""
    var created_at = ""
    var updated_at = ""
    var ans_percentage = ""
}
class PostPicModel{
    internal init(id: String = "", post_id: String = "", picture: String = "", created_at: String = "", updated_at: String = "") {
        self.id = id
        self.post_id = post_id
        self.picture = picture
        self.created_at = created_at
        self.updated_at = updated_at
        self.url = URL(string: kBucketUrl + picture)!
        if let url = url{
            let pathExtention = url.pathExtension
            if imageExtensions.contains(pathExtention)
            {
                if !picture.isEmpty{
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            self.downloadedVideoImage = value.image
                        case .failure(let error):
                            print("Error: \(error)")
                            self.downloadedVideoImage = nil
                        }
                    }
                }
            }
            else if documentExtensions.contains(pathExtention)
            {
                
            }else
            {
                //            AVAsset(url:url).generateThumbnail { [weak self] (image) in
                //                           DispatchQueue.main.async {
                //                               guard let image = image else { return }
                //                            self?.downloadedVideoImage = image
                //                           }
                //                       }
                //            VideoPickerHelper.shared.thumbnil(url: url, completionClosure: {image in
                //
                //            })
                AVAsset(url:url).generateThumbnail { [weak self] (image) in
                    DispatchQueue.main.async {
                        guard let image = image else { return }
                        self?.downloadedVideoImage = image
                    }
                }
            }
        }
        else{
            self.downloadedVideoImage = nil
        }
    }
    
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.post_id = String.getString(data["post_id"])
        self.picture = String.getString(data["picture"])
        
        
        let url = URL(string: kBucketUrl + picture)!
        let pathExtention = url.pathExtension
        self.downloadedVideoImage = nil
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    
    var id = ""
    var post_id = ""
    var picture = ""
    var downloadedVideoImage:UIImage?
    var created_at = ""
    var updated_at = ""
    var url:URL?
    
    let imageExtensions = ["png", "jpg", "gif","jpeg"]
    let documentExtensions = ["pdf","rtf","txt"]
    //...
    // Iterate & match the URL objects from your checking results
    
    
}
class AllUserModel:Codable{
    var first_name = ""
    var last_name = ""
    var full_name = ""
    var email = ""
    var country_code = ""
    var mobile_number = ""
    var id = ""
    var profile_pic = ""
    var employee_type = ""
    var isSelected = false
    var company_id = ""
    var follow_by_user = ""
    var page_name = ""
    var location = ""
    var is_company = false
    var business_name = ""
    
    
    
    init(data:[String:Any]){
        first_name = String.getString(data["first_name"])
        last_name = String.getString(data["last_name"])
        full_name = String.getString(data["full_name"])
        id = String.getString(data["id"])
        mobile_number = String.getString(data["mobile_number"])
        email = String.getString(data["email"])
        country_code = String.getString(data["country_code"])
        employee_type = String.getString(data["employee_type"])
        profile_pic = String.getString(data["profile_pic"])
        page_name = String.getString(data["page_name"])
        location = String.getString(data["location"])
        is_company = String.getString(data["is_company"]) == "1" ? true : false
        business_name = String.getString(data["business_name"])
        company_id = String.getString(data["company_id"])
        follow_by_user = String.getString(data["follow_by_user"])
    }
}
class CompanyPageModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.business_type = String.getString(data["business_type"])
        self.website_url = String.getString(data["website_url"])
        self.page_name = String.getString(data["page_name"])
        self.description = String.getString(data["description"])
        self.industry = String.getString(data["industry"])
        self.company_type = String.getString(data["company_type"])
        self.company_size = String.getString(data["company_size"])
        self.location = String.getString(data["location"]).components(separatedBy:",")
        self.profile_pic = String.getString(data["profile_pic"])
        self.cover_pic = String.getString(data["cover_pic"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.total_followers_count = String.getString(data["total_followers_count"])
        self.total_posts_count = String.getString(data["total_posts_count"])
        self.company_page_created_by_me = String.getString(data["company_page_created_by_me"]) == "1" ? true : false
        self.company_post = kSharedInstance.getArray(data["company_post"]).map{HomeFeedModel(data: kSharedInstance.getDictionary($0))}
        self.business_name = String.getString(data["business_name"])
        self.total_followers = kSharedInstance.getArray(data["total_followers"]).map{AllUserModel(data: kSharedInstance.getDictionary($0))}
        self.user = AllUserModel(data: kSharedInstance.getDictionary(data["user"]))
        self.company_page_follow_by_me = String.getString(data["company_page_follow_by_me"]) == "1" ? true : false
        
        let adminList = kSharedInstance.getArray(withDictionary: data["get_company_admin"])
        self.adminUsers = adminList.map({AdminUser(data: $0)})
        
    }
    
    var id = ""
    var user_id = ""
    var business_type = ""
    var website_url = ""
    var page_name = ""
    var description = ""
    var industry = ""
    var company_type = ""
    var company_size = ""
    var location:[String] = []
    var profile_pic = ""
    var cover_pic = ""
    var created_at = ""
    var updated_at = ""
    var total_followers_count  = ""
    var total_posts_count = ""
    var company_page_created_by_me = false
    var company_post:[HomeFeedModel] = []
    var business_name = ""
    var company_page_follow_by_me = false
    
    
    var total_followers:[AllUserModel] = []
    var user:AllUserModel?
    var adminUsers = [AdminUser]()
    
}


class AdminUser{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.company_id = String.getString(data["company_id"])
        self.parent_user_id = String.getString(data["parent_user_id"])
        self.created_at = String.getString(data["created_at"])
        self.user =  AllUserModel(data: kSharedInstance.getDictionary(data["company_page_admin"]))
        
    }
    
    var id = ""
    var user_id = ""
    var company_id = ""
    var parent_user_id = ""
    var created_at = ""
    var user : AllUserModel?
}

class RecipientModel{
    var recipient_id = ""
    var connection_on = ""
    var status = ""
    var user:AllUserModel?
    var isSelected = false
    init(data:[String:Any]){
        recipient_id = String.getString(data["recipient_id"])
        connection_on = String.getString(data["connection_on"])
        status = String.getString(data["status"])
        user = AllUserModel(data: kSharedInstance.getDictionary(data["user"]))
    }
}
class RecommendedUsersModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.first_name = String.getString(data["first_name"])
        self.last_name = String.getString(data["last_name"])
        self.full_name = String.getString(data["full_name"])
        self.email = String.getString(data["email"])
        self.employee_type = String.getString(data["employee_type"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.mutual_connecation = String.getString(data["mutual_connecation"])
    }
    
    var id = ""
    var first_name = ""
    var last_name = ""
    var full_name = ""
    var email = ""
    var employee_type = ""
    var profile_pic = ""
    var mutual_connecation = ""
}

class InvitationsModel {
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.recipient_id = String.getString(data["recipient_id"])
        self.connection_on = String.getString(data["connection_on"])
        self.status = String.getString(data["status"])
        self.user = RecommendedUsersModel(data: kSharedInstance.getDictionary(data["user"]))
    }
    
    var id = ""
    var recipient_id = ""
    var connection_on = ""
    var status = ""
    var user:RecommendedUsersModel?
    
}
class UserProfileModel {
    internal init(data:[String:Any]) {
        self.company_name = String.getString(data["company_name"])
        self.id = String.getString(data["id"])
        self.account_type = Int.getInt(data["account_type"])
        //        self.first_name = String.getString(data["first_name"])
        //        self.last_name = String.getString(data["last_name"])
        self.full_name = String.getString(data["full_name"])
        self.email = String.getString(data["email"])
        self.country_code = String.getString(data["country_code"])
        self.mobile_number = String.getString(data["mobile_number"])
        self.otp = String.getString(data["otp"])
        self.is_register = String.getString(data["is_register"])
        self.is_otp_verified = String.getString(data["is_otp_verified"])
        self.is_typeWork_filled = String.getString(data["is_typeWork_filled"])
        self.access_token = String.getString(data["access_token"])
        self.employee_type = String.getString(data["employee_type"])
        self.country = String.getString(data["country"])
        self.state = String.getString(data["state"])
        self.city = String.getString(data["city"])
        self.is_profile_pic_uploaded = String.getString(data["is_profile_pic_uploaded"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.cover_pic = String.getString(data["cover_pic"])
        self.device_token = String.getString(data["device_token"])
        self.device_type = String.getString(data["device_type"])
        self.social_id = String.getString(data["social_id"])
        self.login_type = String.getString(data["login_type"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.location = String.getString(data["location"])
        self.headline = String.getString(data["headline"])
        self.industries = data["industries"] as? [String] ?? []
        self.connecation_userid = String.getString(data["connecation_userid"])
        self.connecation_count = String.getString(data["connecation_count"])
        self.is_connected_withme = String.getString(data["is_connected_withme"])
        self.country_name = String.getString(data["country_name"])
        self.state_name = String.getString(data["state_name"])
        self.city_name = String.getString(data["city_name"])
        self.is_following = String.getString(data["is_following"]) == "1" ? true : false
        self.follower_count = String.getString(data["follower_count"])
        self.address = String.getString(data["u_address"])
        self.profile_complete = String.getString(data["profile_complete"])
        self.user_post = kSharedInstance.getArray(data["user_post"]).map{HomeFeedModel(data: kSharedInstance.getDictionary($0))}
        self.user_company_experience = kSharedInstance.getArray(data["user_company_experience"]).map{ExperienceModel(data: kSharedInstance.getDictionary($0))}
        //     self.user_company_experience = self.user_company_experience.reversed()
        self.user_certificate = kSharedInstance.getArray(data["user_certificate"]).map{CertificateModel(data: kSharedInstance.getDictionary($0))}
        self.user_education = kSharedInstance.getArray(data["user_education"]).map{EducationModel(data: kSharedInstance.getDictionary($0))}
        self.recommend_user = kSharedInstance.getArray(data["recommend_user"]).map{RatingRecommendModel(data: kSharedInstance.getDictionary($0))}
        self.user_rating = kSharedInstance.getArray(data["user_rating"]).map{RatingRecommendModel(data: kSharedInstance.getDictionary($0))}
        self.is_user_verified = String.getString(data["is_user_verified"]) == "1" ? true : false
    }
    
    var account_type = 0
    var id = ""
    var first_name = ""
    var last_name = ""
    var full_name = ""
    var email = ""
    var country_code = ""
    var mobile_number = ""
    var otp = ""
    var is_register = ""
    var is_otp_verified = ""
    var is_typeWork_filled = ""
    var access_token = ""
    var employee_type = ""
    var country = ""
    var state = ""
    var city = ""
    var is_profile_pic_uploaded = ""
    var profile_pic = ""
    var device_token = ""
    var device_type = ""
    var social_id = ""
    var login_type = ""
    var created_at = ""
    var updated_at = ""
    var location  = ""
    var connecation_count = ""
    var is_connected_withme = ""
    var user_company_experience:[ExperienceModel] = []
    var user_education:[EducationModel] = []
    var user_certificate:[CertificateModel] = []
    var recommend_user:[RatingRecommendModel] = []
    var user_rating:[RatingRecommendModel] = []
    var user_post:[HomeFeedModel] = []
    var connecation_userid = ""
    var is_following = false
    var follower_count = ""
    var headline = ""
    var industries:[String] = []
    var cover_pic = ""
    var company_name = ""
    var city_name = ""
    var state_name = ""
    var country_name = ""
    var address = ""
    var profile_complete = ""
    var is_user_verified = false
    
}
class ExperienceModel {
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.title = String.getString(data["title"])
        self.employement_type = String.getString(data["employement_type"])
        self.company_name = String.getString(data["company_name"])
        self.location = String.getString(data["location"])
        self.is_currently_working_in_role = String.getString(data["is_currently_working_in_role"])
        self.start_date = String.getString(data["start_date"])
        self.end_date = String.getString(data["end_date"])
        self.share_with_network = String.getString(data["share_with_network"])
        self.is_medical_professional = String.getString(data["is_medical_professional"])
        self.created_at = String.getString(data["created_at"])
        self.total_experience = String.getString(data["total_experience"])
        
    }
    
    var id = ""
    var user_id = ""
    var title = ""
    var employement_type = ""
    var company_name = ""
    var location = ""
    var is_currently_working_in_role = ""
    var start_date = ""
    var end_date = ""
    var share_with_network = ""
    var is_medical_professional = ""
    var created_at = ""
    var total_experience = ""
}



class RatingRecommendModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.from = String.getString(data["from"])
        self.to_user = String.getString(data["to_user"])
        self.description = String.getString(data["description"])
        self.type = String.getString(data["type"])
        self.rating = String.getString(data["rating"])
        self.time = String.getString(data["time"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.user = AllUserModel(data: kSharedInstance.getDictionary(data["user"]))
    }
    
    var id = ""
    var from = ""
    var to_user = ""
    var description = ""
    var type = ""
    var rating = ""
    var time = ""
    var created_at = ""
    var updated_at = ""
    var user:AllUserModel?
}
class CommentModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.post_id = String.getString(data["post_id"])
        self.user_id = String.getString(data["user_id"])
        self.comment = String.getString(data["comment"])
        self.tag_people = kSharedInstance.getArray(data["tag_people"]).map{AllUserModel(data: kSharedInstance.getDictionary($0))}
        self.picture = String.getString(data["picture"])
        self.comment_date = String.getString(data["comment_date"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.user = AllUserModel(data: kSharedInstance.getDictionary(data["user"]))
        self.is_comment_like_by_user = String.getString(data["is_comment_like_by_user"]) == "0" ? false : true
        self.total_replies_count = String.getString(data["total_replies_count"])
        self.total_likes_count = String.getString(data["total_likes_count"])
        self.reply_id = String.getString(data["reply_id"])
        let temp = kSharedInstance.getArray(data["replies"])
        self.replies = temp.isEmpty ? [] : (temp.map{CommentModel(data: kSharedInstance.getDictionary($0))})
        self.count_reaction_like =  String.getString(data["count_reaction_like"])
        let typeDict = kSharedInstance.getArray(withDictionary: data["like_type"])
        for like in typeDict {
            let like_type = Int.getInt(like["like_type"])
            self.likeType.append(like_type)
        }
        self.likeType = self.likeType.unique
    }
    
    var id = ""
    var post_id = ""
    var user_id = ""
    var comment = ""
    var tag_people:[AllUserModel] = []
    var picture = ""
    var comment_date = ""
    var created_at = ""
    var updated_at = ""
    var is_comment_like_by_user = false
    var total_replies_count = ""
    var total_likes_count = ""
    var reply_id = ""
    var replies:[CommentModel] = []
    var user:AllUserModel?
    var isReplyExpand = false
    var count_reaction_like = ""
    var likeType = [Int]()
}
class EducationModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.school_name = String.getString(data["school_name"])
        self.degree = String.getString(data["degree"])
        self.field_of_study = String.getString(data["field_of_study"])
        self.start_date = String.getString(data["start_date"])
        self.end_date = String.getString(data["end_date"])
        self.is_completed = String.getString(data["is_completed"])
        self.grade = String.getString(data["grade"])
        self.description = String.getString(data["description"])
        self.share_with_network = String.getString(data["share_with_network"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    var id = ""
    var user_id = ""
    var school_name = ""
    var degree = ""
    var field_of_study = ""
    var start_date = ""
    var end_date = ""
    var is_completed = ""
    var grade = ""
    var description = ""
    var share_with_network = ""
    var created_at = ""
    var updated_at = ""
}
class CertificateModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.certificate = String.getString(data["certificate"])
        self.org_name = String.getString(data["org_name"])
        self.is_certificate_expire = String.getString(data["is_certificate_expire"]) == "0" ? false : true
        self.start_date = String.getString(data["start_date"])
        self.end_date = String.getString(data["end_date"])
        self.share_with_network = String.getString(data["share_with_network"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    
    
    var id = ""
    var user_id = ""
    var certificate = ""
    var org_name = ""
    var is_certificate_expire = false
    var start_date = ""
    var end_date = ""
    var share_with_network = ""
    var created_at = ""
    var updated_at = ""
}
class ListingDataModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
        self.type = String.getString(data["type"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    var id = ""
    var name = ""
    var type = ""
    var created_at = ""
    var updated_at = ""
}
class GroupListingModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.group_id = String.getString(data["group_id"])
        self.user_id = String.getString(data["user_id"])
        self.group_status = String.getString(data["group_status"])
        self.is_admin = String.getString(data["is_admin"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.group_members = String.getString(data["group_members"])
        self.join_users = kSharedInstance.getArray(data["join_users"]).map{AllUserModel(data:kSharedInstance.getDictionary($0))}
        let groupDict = kSharedInstance.getDictionary(data["group"])
        if groupDict.count == 0 {
            self.group =  GroupNameModel(data:groupDict)
            self.group?.id = String.getString(data["id"])
            self.group?.name = String.getString(data["name"])
            self.group?.group_pic = String.getString(data["group_pic"])
        }else {
            self.group =  GroupNameModel(data:groupDict)
        }
    }
    
    var id = ""
    var group_id = ""
    var user_id = ""
    var group_status = ""
    var is_admin = ""
    var created_at = ""
    var updated_at = ""
    var group_members = ""
    var join_users:[AllUserModel] = []
    var group:GroupNameModel?
    var isSelected = false
}
class GroupNameModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
        self.group_pic = String.getString(data["group_pic"])
    }
    
    var id = ""
    var name = ""
    var group_pic = ""
}
class Contacts{
    var id:String?
    var profilePicture:String?
    var firstName:String?
    var LastName:String?
    var mobileNumber:String?
    var email:String?
    var lastMessage:String?
    var lastMessageTime:String?
    init(data:[String:Any]){
        self.id = String.getString(data["id"])
        self.profilePicture = String.getString(data["profilePicturePath"])
        self.firstName = String.getString(data["firstName"])
        self.LastName = String.getString(data["lastName"])
        self.mobileNumber = String.getString(data["mobileNumber"])
        self.email = String.getString(data["email"])
        let lastMessageDict = kSharedInstance.getDictionary(data["lastChatMessage"])
        self.lastMessage = String.getString(lastMessageDict["text"])
        self.lastMessageTime = ""
    }
}

class HSNGroupModel{
    internal init(data:[String:Any]) {
        self.about = String.getString(data["about"])
        self.cover_pic = String.getString(data["cover_pic"])
        self.created_at = String.getString(data["created_at"])
        self.discoverability = String.getString(data["discoverability"])
        self.group_created_by = GroupCreatedByModel(data: kSharedInstance.getDictionary(data["group_created_by"]))
        self.group_members = kSharedInstance.getArray(data["group_members"]).map{GroupUserModel(data: kSharedInstance.getDictionary($0))}
        self.group_pic = String.getString(data["group_pic"])
        self.id = String.getString(data["id"])
        self.industries = String.getString(data["industries"])
        self.location = String.getString(data["location"])
        self.name = String.getString(data["name"])
        self.permission = String.getString(data["permission"])
        self.rules = String.getString(data["rules"])
        self.total_group_members_count = String.getString(data["total_group_members_count"])
        self.updated_at = String.getString(data["updated_at"])
        self.user = GroupUserModel(data:  data["user"] as? [String:Any] == nil ? (kSharedInstance.getDictionary(data["c_user"]))  : (kSharedInstance.getDictionary(data["user"])) )
        self.user_id = String.getString(data["user_id"])
        self.user_post = kSharedInstance.getArray(data["user_post"]).map{HomeFeedModel(data: kSharedInstance.getDictionary($0))}
    }
    
    var about = ""
    var cover_pic = ""
    var created_at = ""
    var discoverability = ""
    var group_created_by:GroupCreatedByModel?
    var group_members:[GroupUserModel] = []
    var group_pic = ""
    var id  = ""
    var industries  = ""
    var location  = ""
    var name  = ""
    var permission  = ""
    var rules  = ""
    var total_group_members_count = ""
    var updated_at = ""
    var user:GroupUserModel?
    var user_id = ""
    var user_post:[HomeFeedModel] = []
    
}
class GroupCreatedByModel{
    internal init(data:[String:Any]) {
        self.first_name = String.getString(data["first_name"])
        self.id = String.getString(data["id"])
        self.last_name = String.getString(data["last_name"])
        self.profile_pic = String.getString(data["profile_pic"])
    }
    
    var first_name = ""
    var id = ""
    var last_name = ""
    var profile_pic = ""
}
class GroupUserModel{
    internal init(data:[String:Any]) {
        self.first_name = String.getString(data["first_name"])
        self.full_name = String.getString(data["full_name"])
        self.group_id = String.getString(data["group_id"])
        self.group_status = String.getString(data["group_status"])
        self.is_admin = String.getString(data["is_admin"]) == "1" ? true : false
        self.last_name = String.getString(data["last_name"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.user_id = String.getString(data["user_id"])
    }
    
    var first_name = ""
    var full_name = ""
    var group_id = ""
    var group_status = ""
    var is_admin = false
    var last_name = ""
    var profile_pic = ""
    var user_id = ""
    
}
class EventListModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.event_id = String.getString(data["event_id"])
        self.company_id = String.getString(data["company_id"])
        self.user_id = String.getString(data["user_id"])
        self.event_status = String.getString(data["event_status"])
        self.is_orgnizer = String.getString(data["is_orgnizer"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.event = EventDetailsModel(data: kSharedInstance.getDictionary(data["event"]).isEmpty ? kSharedInstance.getDictionary(data["company_event"]) : kSharedInstance.getDictionary(data["event"]))
    }
    
    var id = ""
    var event_id = ""
    var company_id = ""
    var user_id = ""
    var event_status = ""
    var is_orgnizer = ""
    var created_at = ""
    var updated_at = ""
    var event:EventDetailsModel?
}
class EventDetailsModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.name = String.getString(data["name"])
        self.event_pic = String.getString(data["event_pic"])
        self.start_date = String.getString(data["start_date"])
        self.start_time = String.getString(data["start_time"])
        self.end_date = String.getString(data["end_date"])
        self.end_time = String.getString(data["end_time"])
        self.is_promoted = Int.getInt(data["is_promoted"])
    }
    
    var id = ""
    var name = ""
    var event_pic = ""
    var start_date = ""
    var start_time = ""
    var end_date = ""
    var end_time = ""
    var is_promoted = 0
}

class InterestUserListModel{
    internal init(data:[String:Any]) {
        self.full_name = String.getString(data["full_name"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.employee_type = String.getString(data["employee_type"])
        self.user_full_name = String.getString(data["user_full_name"])
        self.user_profile_pic = String.getString(data["user_profile_pic"])
        
    }
    
    var full_name = ""
    var profile_pic = ""
    var employee_type = ""
    var user_full_name = ""
    var user_profile_pic = ""
    
}
class EventMemberModel{
    internal init(data:[String:Any]) {
        self.created_at = String.getString(data["created_at"])
        self.event_id = String.getString(data["event_id"])
        self.event_status = String.getString(data["event_status"])
        self.first_name = String.getString(data["first_name"])
        self.full_name = String.getString(data["full_name"])
        self.id = String.getString(data["id"])
        self.is_orgnizer = String.getString(data["is_orgnizer"])
        self.last_name = String.getString(data["last_name"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.updated_at = String.getString(data["updated_at"])
        self.user_id = String.getString(data["user_id"])
    }
    
    var created_at = ""
    var event_id = ""
    var event_status = ""
    var first_name = ""
    var id = ""
    var is_orgnizer = ""
    var last_name = ""
    var profile_pic = ""
    var updated_at = ""
    var user_id = ""
    var full_name = ""
}
class EventModel{
    internal init(data:[String:Any]) {
        self.broadcast_link = String.getString(data["broadcast_link"])
        self.cover_pic = String.getString(data["cover_pic"])
        self.created_at = String.getString(data["created_at"])
        self.description = String.getString(data["description"])
        self.end_date = String.getString(data["end_date"])
        self.end_time = String.getString(data["end_time"])
        self.event_member = kSharedInstance.getArray(data["event_members"]).map{EventMemberModel(data: kSharedInstance.getDictionary($0))}
        self.event_orgnize_by = AllUserModel(data: kSharedInstance.getDictionary(data["event_orgnize_by"]))
        self.event_pic = String.getString(data["event_pic"])
        self.event_type = String.getString(data["event_type"])
        self.id = String.getString(data["id"])
        self.is_online_event = String.getString(data["is_online_event"])
        self.name = String.getString(data["name"])
        self.registration_link = String.getString(data["registration_link"])
        self.start_date = String.getString(data["start_date"])
        self.start_time = String.getString(data["start_time"])
        self.total_event_members_count = String.getString(data["total_event_members_count"])
        self.updated_at = String.getString(data["updated_at"])
        self.user = EventSingleUserModel(data: kSharedInstance.getDictionary(data["c_user"]))
        self.user_id = String.getString(data["user_id"])
        self.location = String.getString(data["location"])
        self.latitude = Double.getDouble(data["latitude"])
        self.longitude = Double.getDouble(data["longitude"])
    }
    
    var broadcast_link = ""
    var cover_pic = ""
    var created_at = ""
    var description = ""
    var end_date = ""
    var end_time = ""
    var event_member:[EventMemberModel] = []
    var event_orgnize_by:AllUserModel?
    var event_pic = ""
    var event_type = ""
    var id = ""
    var is_online_event = ""
    var name = ""
    var registration_link = ""
    var start_date = ""
    var start_time = ""
    var total_event_members_count = ""
    var updated_at = ""
    var user:EventSingleUserModel?
    var user_id = ""
    var location = ""
    var latitude = 0.0
    var longitude = 0.0
}
class EventSingleUserModel{
    internal init(data:[String:Any]) {
        self.event_id = String.getString(data["event_id"])
        self.event_status = String.getString(data["event_status"])
        self.first_name = String.getString(data["first_name"])
        self.is_orgnizer = String.getString(data["is_orgnizer"])
        self.last_name = String.getString(data["last_name"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.user_id = String.getString(data["user_id"])
    }
    
    var event_id = ""
    var event_status = ""
    var first_name = ""
    var is_orgnizer = ""
    var last_name = ""
    var profile_pic = ""
    var user_id = ""
}

class NotificationModel {
    var id = ""
    var sender_id = ""
    var receiver_id = ""
    var title = ""
    var message = ""
    var notify_type = ""
    var time = ""
    var type_id = ""
    var image_name = ""
    var created_at = ""
    var is_read = false
    var is_accepted = 0
    
    internal init(data:[String: Any]) {
        self.id = String.getString(data["id"])
        self.sender_id = String.getString(data["sender_id"])
        self.receiver_id = String.getString(data["receiver_id"])
        self.title = String.getString(data["itle"])
        self.message = String.getString(data["message"])
        self.notify_type = String.getString(data["notify_type"])
        self.time = String.getString(data["time"])
        self.type_id = String.getString(data["type_id"])
        self.image_name = String.getString(data["image_name"])
        self.created_at = String.getString(data["created_at"])
        self.is_read = String.getString(data["is_read"]) == "1" ? true : false
        self.is_accepted = Int.getInt(data["is_accepted"])
    }
}

class ReactionsHeaderModel {
    internal init(isSelected: Bool = false, count: String = "0", image: UIImage = UIImage(), name: String = "") {
        self.isSelected = isSelected
        self.count = count
        self.image = image
        self.name = name
    }
    
    var isSelected = false
    var count = "0"
    var image:UIImage = UIImage()
    var name = ""
    
}

class ReactionsListModel {
    internal init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.post_id =  String.getString(data["post_id"])
        self.user_id =  String.getString(data["user_id"])
        self.like_type  = String.getString(data["like_type"])
        self.user = AllUserModel(data: kSharedInstance.getDictionary(data["user"]))
    }
    
    var isSelected: Bool = false
    var id: String = ""
    var post_id: String = ""
    var user_id: String = ""
    var like_type: String = ""
    var count: String = "0"
    var user: AllUserModel?
}

class InsightsActivityModel {
    internal init(data: [String: Any]) {
        self.count = String.getString(data["count"])
        self.month = String.getString(data["month"])
        self.day = String.getString(data["day"])
    }
    
    var count = ""
    var month = ""
    var day = ""
}

class LoungeSuggestedModel {
    internal init(isSelected: Bool = false, image: UIImage = UIImage(), name: String = "") {
        self.isSelected = isSelected
        self.image = image
        self.name = name
    }
    var isSelected = false
    var image:UIImage = UIImage()
    var name = ""
    
}

class RoomModel {
    internal init(data: [String: Any]) {
        self.anonymousState = String.getString(data["anonymousState"]) == "1" ? true : false
        self.category = String.getString(data["category"])
        self.createdAt = String.getString(data["createdAt"])
        self.description = String.getString(data["description"])
        self.host = String.getString(data["host"])
        self.id = String.getString(data["id"])
        self.link = String.getString(data["link"])
        self.message = String.getString(data["message"])
        self.name = String.getString(data["name"])
        self.profile = String.getString(data["profile"])
        self.roomId = String.getString(data["roomId"])
        self.schedule = String.getString(data["schedule"]) == "1" ? true : false
        self.scheduleAt = String.getString(data["scheduleAt"])
        self.type = String.getString(data["type"])
        self.ongoing = String.getString(data["ongoing"]) == "1" ? true : false
        self.updateAt = String.getString(data["updateAt"])
        self.users =  kSharedInstance.getDictionary(data["users"]).map{RoomUserModel(data: kSharedInstance.getDictionary($0.value))}
        self.requestUsers =  kSharedInstance.getDictionary(data["request_users"]).map{RequestUserModel(data: kSharedInstance.getDictionary($0.value))}
        self.reacts =  kSharedInstance.getDictionary(data["react"]).map{LoungeReactsModel(data: kSharedInstance.getDictionary($0.value))}
        self.country = String.getString(data["country"])
        self.is_sponsered = Int.getInt(data["is_sponsered"])
        let currentUser = self.users.filter({$0.userId == UserData.shared.id})
        if currentUser.count > 0 {
            self.notificationsEnabled = currentUser.first?.notifications ?? false
        }
        
    }
    
    var country = ""
    var category = ""
    var createdAt = ""
    var description = ""
    var host = ""
    var id = ""
    var anonymousState = false
    var is_following = false
    var link = ""
    var message = ""
    var name = ""
    var profile = ""
    var roomId = ""
    var schedule = false
    var scheduleAt = ""
    var type = ""
    var updateAt = ""
    var ongoing = false
    var notificationsEnabled = false
    var users:[RoomUserModel] = []
    var requestUsers:[RequestUserModel] = []
    var reacts:[LoungeReactsModel] = []
    var isSelected = false
    var is_sponsered = 0
    
}

class LoungeReactsModel {
    internal init(data: [String: Any]) {
        self.type = String.getString(data["emoji"])
        self.name = String.getString(data["name"])
        self.userId = String.getString(data["userId"])
    }
    
    var type = ""
    var name = ""
    var userId = ""
    
}

class RoomUserModel {
    internal init(data: [String: Any]) {
        self.mic = String.getString(data["mic"]) == "1" ?  true : false
        self.name = String.getString(data["name"])
        self.profile = String.getString(data["profile"])
        self.isRemoved = String.getString(data["removed"]) == "1" ? true : false
        self.permission = String.getString(data["permission"]) == "1" ? true : false
        self.typeHost = String.getString(data["typeHost"])
        self.userId = String.getString(data["userId"])
        self.country = String.getString(data["country"])
        self.notifications = String.getString(data["notifications"]) == "1" ? true : false
    }
    
    var mic = false
    var name = ""
    var profile = ""
    var isRemoved = false
    var typeHost = ""
    var userId = ""
    var country = ""
    var permission = false
    var notifications = false
}

class RequestUserModel {
    internal init(data: [String: Any]) {
        
        self.name = String.getString(data["name"])
        self.profile = String.getString(data["profile"])
        self.permission = String.getString(data["permission"])
        self.id = String.getString(data["id"])
    }
    
    var name = ""
    var profile = ""
    var permission = ""
    var id = ""
}

class PlanModel {
    internal init(data: [String:Any]) {
        self.id = String.getString(data["id"])
        self.plan_type = String.getString(data["plan_type"])
        self.price = String.getString(data["price"])
        self.duration = String.getString(data["duration"])
        self.duration_type = String.getString(data["duration_type"])
        self.description = String.getString(data["description"])
        self.views_your_profile = String.getString(data["views_your_profile"])
        self.messages = String.getString(data["messages"])
        self.privates_groups = String.getString(data["privates_groups"])
        self.privates_events = String.getString(data["privates_events"])
        self.fitness_tracker = String.getString(data["fitness_tracker"])
        self.insights = String.getString(data["insights"])
        self.profile_booster = String.getString(data["profile_booster"])
        self.join_people_to_lounge = String.getString(data["join_people_to_lounge"])
        self.create_company = String.getString(data["create_company"])
        self.post_jobs = String.getString(data["post_jobs"])
        self.audio_chat = String.getString(data["audio_chat"])
        self.video_chat = String.getString(data["video_chat"])
        self.company_event = String.getString(data["company_event"])
        self.notification_related_area = String.getString(data["notification_related_area"])
        self.dynamic_candidate_suggestion = String.getString(data["dynamic_candidate_suggestion"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.title = String.getString(data["title"])
        self.purchase_date = String.getString(data["purchase_date"])
        self.expire_date = String.getString(data["expire_date"])
        self.currentPlan = CurrentPlanModel(data: kSharedInstance.getDictionary(data["current_plan"]))
        for (key,value) in data {
            switch key{
            case key where key == "messages" && !String.getString(value).isEmpty && String.getString(value) != "0" && !features.contains("\(value) " + "Messages") || String.getString(value) == "0" && !features.contains("Unlimited Messages"):
                if String.getString(value) == "0"{
                    self.features.append("Unlimited Messages")
                }
                else{
                    self.features.append("\(value) " + "Messages")
                }
                
                continue
            case key where key == "views_your_profile" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Profile Views"):
                self.features.append("Profile Views")
                continue
            case key where key == "privates_groups" && !String.getString(value).isEmpty && String.getString(value) != "0" && !features.contains("\(value) " + "Private Groups") || String.getString(value) == "0" && !features.contains("Unlimited Private Groups"):
                if String.getString(value) == "0"{
                    self.features.append("Unlimited Private Groups")
                }
                else{
                    self.features.append("\(value) " + "Private Groups")
                }
                
                continue
            case key where key == "privates_events" && !String.getString(value).isEmpty && String.getString(value) != "0" && !features.contains("\(value) " + "Private Events")  || String.getString(value) == "0" && !features.contains("Unlimited Private Events"):
                if String.getString(value) == "0"{
                    self.features.append("Unlimited Private Events")
                }
                else{
                    self.features.append("\(value) " + "Private Events")
                }
                
                continue
            case key where key == "fitness_tracker" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Fitness Tracker"):
                self.features.append("Fitness Tracker")
                continue
            case key where key == "insights" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Insights"):
                self.features.append("Insights")
                continue
            case key where key == "profile_booster" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Profile Booster"):
                self.features.append("Profile Booster")
                continue
            case key where key == "join_people_to_lounge" && !String.getString(value).isEmpty && String.getString(value) != "0" && !features.contains("\(value) " + "People allowed in lounge") || String.getString(value) == "0" && !features.contains("Unlimited People allowed in lounge"):
                self.features.append(String.getString(value) == "0" ? "Unlimited People allowed in lounge" : "\(value) " + "People allowed in lounge")
                continue
            case key where key == "create_company" && !String.getString(value).isEmpty && String.getString(value) != "0" && !features.contains("Create \(value) " + "companys") || String.getString(value) == "0" && !features.contains("Create Unlimited companys"):
                
                self.features.append(String.getString(value) == "0" ? "Create Unlimited companys" : "Create \(value) " + "companys")
                continue
            case key where key == "post_jobs" && !String.getString(value).isEmpty && String.getString(value) != "0" && !features.contains("\(value) " + "Post Jobs") || String.getString(value) == "0" && !features.contains("Create Unlimited Job Posts"):
                self.features.append(String.getString(value) == "0" ? "Create Unlimited Job Posts" : "\(value) " + "Post Jobs")
                
                continue
            case key where key == "audio_chat" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Audio Chats"):
                self.features.append("Audio Chats")
                continue
            case key where key == "video_chat" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Video Chats"):
                self.features.append("Video Chats")
                continue
            case key where key == "profile_booster" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Profile Booster"):
                self.features.append("Profile Booster")
                continue
            case key where key == "company_event" && !String.getString(value).isEmpty && String.getString(value) != "0" && !features.contains("\(value) " + "Company Event") || String.getString(value) == "0" && !features.contains("Unlimited Company Events"):
                self.features.append(String.getString(value) == "0" ? "Unlimited Company Events" : "\(value) " + "Company Event")
                
                continue
            case key where key == "notification_related_area" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Notification Related Area"):
                self.features.append("Notification Related Area")
                continue
            case key where key == "dynamic_candidate_suggestion" && !String.getString(value).isEmpty && String.getString(value) == "1" && !features.contains("Dynamic Candid Suggestion"):
                self.features.append("Dynamic Candid Suggestion")
                continue
            default:continue
                
                
                
            }
        }
        
    }
    
    var id = ""
    var plan_type = ""
    var price = ""
    var duration = ""
    var duration_type = ""
    var description = ""
    var views_your_profile = ""
    var messages = ""
    var privates_groups = ""
    var privates_events = ""
    var fitness_tracker = ""
    var insights = ""
    var profile_booster = ""
    var join_people_to_lounge = ""
    var create_company = ""
    var post_jobs = ""
    var audio_chat = ""
    var video_chat = ""
    var company_event = ""
    var notification_related_area = ""
    var dynamic_candidate_suggestion = ""
    var created_at = ""
    var updated_at = ""
    var title = ""
    var purchase_date = ""
    var expire_date = ""
    
    
    var currentPlan:CurrentPlanModel = CurrentPlanModel(data: [:])
    var features:[String] = []
}
class CurrentPlanModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.plan_type = String.getString(data["plan_type"])
        self.title = String.getString(data["title"])
    }
    
    var id = ""
    var plan_type = ""
    var title = ""
    
}
class PageProductModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.company_id = String.getString(data["company_id"])
        self.product_name = String.getString(data["product_name"])
        self.product_url = String.getString(data["product_url"])
        self.website_url = String.getString(data["website_url"])
        self.tagline = String.getString(data["tagline"])
        self.industry = String.getString(data["industry"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.product_media = String.getString(data["product_media"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    var id = ""
    var company_id = ""
    var product_name = ""
    var product_url = ""
    var website_url = ""
    var tagline = ""
    var industry = ""
    var profile_pic = ""
    var product_media = ""
    var created_at = ""
    var updated_at = ""
}

class PageLifeModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.company_id = String.getString(data["company_id"])
        self.view_name = String.getString(data["view_name"])
        self.pixel_tracker_url = String.getString(data["pixel_tracker_url"])
        self.media = String.getString(data["media"])
        self.image_url_link = String.getString(data["image_url_link"])
        self.company_leader_headline = String.getString(data["company_leader_headline"])
        self.company_leader_content = String.getString(data["company_leader_content"])
        self.members_of_company_leader = String.getString(data["members_of_company_leader"])
        self.company_leader_visibility = String.getString(data["company_leader_visibility"]) == "1" ? true : false
        self.company_photos_visibility = String.getString(data["company_photos_visibility"]) == "1" ? true : false
        self.company_testimonials_visibility = String.getString(data["company_testimonials_visibility"]) == "1" ? true : false
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.company_lifes_id = String.getString(data["company_lifes_id"])
        self.company_leader_name =  kSharedInstance.getArray(data["company_leader_name"]).map{AllUserModel(data: kSharedInstance.getDictionary($0))}
        self.company_spot_light =  kSharedInstance.getArray(data["company_spot_light"]).map{PageSpotlightModuleModel(data: kSharedInstance.getDictionary($0))}
        self.company_photos = kSharedInstance.getArray(data["company_photos"]).map{PagePhotosModel(data: kSharedInstance.getDictionary($0))}
        self.company_testimonial =
        kSharedInstance.getArray(data["company_testimonial"]).map{PageTestimonialModel(data: kSharedInstance.getDictionary($0))}
    }
    
    
    
    var id = ""
    var company_id = ""
    var view_name = ""
    var pixel_tracker_url = ""
    var media = ""
    var image_url_link = ""
    var company_leader_headline = ""
    var company_leader_content = ""
    var members_of_company_leader = ""
    var company_leader_visibility = true
    var company_photos_visibility = true
    var company_testimonials_visibility = true
    var created_at = ""
    var updated_at = ""
    var company_lifes_id = ""
    var company_leader_name:[AllUserModel] = []
    var company_spot_light: [PageSpotlightModuleModel] = []
    var company_photos:[PagePhotosModel] = []
    var company_testimonial:[PageTestimonialModel] = []
}
class PageSpotlightModuleModel{
    
    
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.company_lifes_id = String.getString(data["company_lifes_id"])
        self.media = String.getString(data["media"])
        self.caption = String.getString(data["caption"])
        self.title = String.getString(data["title"])
        self.content = String.getString(data["content"])
        self.url_link = String.getString(data["url_link"])
        self.spotlight_visibility = String.getString(data["spotlight_visibility"]) == "1" ? true : false
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    var id = ""
    var company_lifes_id = ""
    var media = ""
    var caption = ""
    var title = ""
    var content = ""
    var url_link = ""
    var spotlight_visibility = true
    var created_at = ""
    var updated_at = ""
    var moduleVideoURL:URL?
    var moduleImage:UIImage?
    var moduleVisibility:Bool = true
}
class PagePhotosModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.company_lifes_id = String.getString(data["company_lifes_id"])
        self.media = String.getString(data["media"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
    }
    
    var id = ""
    var company_lifes_id = ""
    var media = ""
    var created_at = ""
    var updated_at = ""
}
class PageTestimonialModel{
    internal init(data:[String:Any]) {
        self.id = String.getString(data["id"])
        self.company_lifes_id = String.getString(data["company_lifes_id"])
        self.employee_id = String.getString(data["employee_id"])
        self.employee_quote = String.getString(data["employee_quote"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.employee_name = AllUserModel(data: kSharedInstance.getDictionary(data["employee_name"]))
    }
    
    var id = ""
    var company_lifes_id = ""
    var employee_id = ""
    var employee_quote = ""
    var created_at = ""
    var updated_at = ""
    var employee_name:AllUserModel?
    
}

class JobModel {
    internal init(data: [String: Any]) {
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.company_id = String.getString(data["company_id"])
        self.job_title = String.getString(data["job_title"])
        self.facility = String.getString(data["facility"])
        self.location = String.getString(data["location"])
        self.latitude = String.getString(data["latitude"])
        self.longitude = String.getString(data["longitude"])
        self.apply_type = String.getString(data["apply_type"])
        self.website_link = String.getString(data["website_link"])
        self.job_description = String.getString(data["job_description"])
        self.employement_type = String.getString(data["employement_type"])
        self.skill_required = String.getString(data["skill_required"]).components(separatedBy: ",") as? [String] ?? []
        self.industry_id = String.getString(data["industry_id"])
        self.posted_date = String.getString(data["posted_date"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.is_favourite = String.getString(data["is_favourite"]) == "1" ? true : false
        self.is_job_apply_by_currentuser = String.getString(data["is_job_apply_by_currentuser"]) == "1" ? true : false
        self.company = CompanyPageModel(data: kSharedInstance.getDictionary(data["company"]))
        self.industry = GroupNameModel(data: kSharedInstance.getDictionary(data["industry"]))
        if !kSharedInstance.getArray(data["similar_jobs"]).isEmpty {
            self.similar_jobs = kSharedInstance.getArray(data["similar_jobs"]).map{JobModel(data: kSharedInstance.getDictionary($0))}
        }
    }
    
    var id = ""
    var user_id = ""
    var company_id = ""
    var job_title = ""
    var facility = ""
    var location = ""
    var latitude = ""
    var longitude = ""
    var apply_type = ""
    var website_link = ""
    var job_description = ""
    var employement_type = ""
    var skill_required:[String] = []
    var industry_id = ""
    var posted_date = ""
    var created_at = ""
    var updated_at = ""
    var is_favourite = false
    var is_job_apply_by_currentuser = false
    var similar_jobs: [JobModel] = []
    var company: CompanyPageModel?
    var industry: GroupNameModel?
}


class EventListByFilterModel {
    internal init(data: [String: Any]) {
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.name = String.getString(data["name"])
        self.cover_pic = String.getString(data["cover_pic"])
        self.event_pic = String.getString(data["event_pic"])
        self.start_date = String.getString(data["start_date"])
        self.start_time = String.getString(data["start_time"])
        self.end_date = String.getString(data["end_date"])
        self.end_time = String.getString(data["end_time"])
        self.description = String.getString(data["description"])
        self.is_online_event = Int.getInt(data["is_online_event"])
        self.registration_link = String.getString(data["registration_link"])
        self.broadcast_link = String.getString(data["broadcast_link"])
        self.event_type = String.getString(data["event_type"])
        self.location = String.getString(data["location"])
        self.total_event_views_count = Int.getInt(data["total_event_views_count"])
        self.total_event_interested_count = Int.getInt(data["total_event_interested_count"])
        self.is_interest = Int.getInt(data["is_interest"]) == 1 ? true : false
        self.is_promoted = Int.getInt(data["is_promoted"]) == 1 ? true : false
        self.interest_type = String.getString(data["interest_type"])
    }
    
    var id:Int?
    var user_id:Int?
    var name = ""
    var cover_pic = ""
    var event_pic = ""
    var start_date = ""
    var start_time = ""
    var end_date = ""
    var end_time = ""
    var description = ""
    var is_online_event:Int?
    var registration_link = ""
    var broadcast_link = ""
    var event_type = ""
    var location = ""
    var total_event_views_count :Int?
    var total_event_interested_count :Int?
    var is_interest = false
    var is_promoted = false
    var interest_type = ""
}

class InterestedEventListModel {
    internal init(data: [String: Any]) {
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.name = String.getString(data["name"])
        self.cover_pic = String.getString(data["cover_pic"])
        self.event_pic = String.getString(data["event_pic"])
        self.start_date = String.getString(data["start_date"])
        self.start_time = String.getString(data["start_time"])
        self.end_date = String.getString(data["end_date"])
        self.end_time = String.getString(data["end_time"])
        self.description = String.getString(data["description"])
        self.is_online_event = Int.getInt(data["is_online_event"])
        self.registration_link = String.getString(data["registration_link"])
        self.broadcast_link = String.getString(data["broadcast_link"])
        self.event_type = String.getString(data["event_type"])
        self.location = String.getString(data["location"])
        self.total_event_views_count = Int.getInt(data["total_event_views_count"])
        self.total_event_interested_count = Int.getInt(data["total_event_interested_count"])
        self.is_interest = Int.getInt(data["is_interest"]) == 1 ? true : false
        self.is_promoted = Int.getInt(data["is_promoted"]) == 1 ? true : false
        self.interest_type = String.getString(data["interest_type"])
        self.iterested_users = kSharedInstance.getArray(data["iterested_users"]).map{EventInterestedUserModel(data: kSharedInstance.getDictionary($0))}
    }
    
    var id:Int?
    var user_id:Int?
    var name = ""
    var cover_pic = ""
    var event_pic = ""
    var start_date = ""
    var start_time = ""
    var end_date = ""
    var end_time = ""
    var description = ""
    var is_online_event:Int?
    var registration_link = ""
    var broadcast_link = ""
    var event_type = ""
    var location = ""
    var total_event_views_count :Int?
    var total_event_interested_count :Int?
    var is_interest = false
    var is_promoted = false
    var interest_type = ""
    var iterested_users:[EventInterestedUserModel] = []
}

class EventInterestedUserModel{
    internal init(data:[String:Any]) {
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.event_id = Int.getInt(data["event_id"])
        self.interest_type = String.getString(data["interest_type"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        
    }
    
    var id:Int?
    var user_id:Int?
    var event_id:Int?
    var interest_type = ""
    var created_at = ""
    var updated_at = ""
    
}

class EventInterestedListModel{
    internal init(data:[String:Any]) {
        self.id = Int.getInt(data["id"])
        self.user_id = Int.getInt(data["user_id"])
        self.event_id = Int.getInt(data["event_id"])
        self.interest_type = String.getString(data["interest_type"])
        self.created_at = String.getString(data["created_at"])
        self.updated_at = String.getString(data["updated_at"])
        self.user = UserDetailsModel(data: kSharedInstance.getDictionary(data["user"]))
    }
    
    var id:Int?
    var user_id:Int?
    var event_id:Int?
    var interest_type = ""
    var created_at = ""
    var updated_at = ""
    var user:UserDetailsModel?
}

class UserDetailsModel{
    internal init(data:[String:Any]) {
        self.id = Int.getInt(data["id"])
        self.full_name = String.getString(data["full_name"])
        self.email = String.getString(data["email"])
        self.employee_type = String.getString(data["employee_type"])
        self.profile_pic = String.getString(data["profile_pic"])
        self.user_full_name = String.getString(data["user_full_name"])
        self.user_profile_pic = String.getString(data["user_profile_pic"])
        self.mobile_number = String.getString(data["mobile_number"])
        
    }
    var id:Int?
    var full_name = ""
    var email = ""
    var employee_type = ""
    var profile_pic = ""
    var user_full_name = ""
    var user_profile_pic = ""
    var mobile_number = ""
    
}


class CandidateDetailsModel {
    internal init(data: [String: Any]) {
        self.apply_date_time = Int.getInt(data["apply_date_time"])
        self.company_id = String.getString(data["company_id"])
        self.company_job_id = String.getString(data["company_job_id"])
        self.id = String.getString(data["id"])
        self.user_id = String.getString(data["user_id"])
        self.is_favourite = String.getString(data["is_fav"]) == "0" ? true : false
        self.resume_doc = String.getString(data["resume_doc"])
        self.skills = String.getString(kSharedInstance.getStringArray(data["skills"]).first)
        self.total_experience = String.getString(data["total_experience"])
        self.mobile_number = String.getString(data["mobile_number"])
        self.user = UserDetailsModel(data: kSharedInstance.getDictionary(data["user"]))
    }
    var apply_date_time: Int?
    var company_id = ""
    var company_job_id = ""
    var id = ""
    var user_id = ""
    var is_favourite = false
    var resume_doc = ""
    var skills = ""
    var total_experience = ""
    var user: UserDetailsModel?
    var mobile_number = ""
}
