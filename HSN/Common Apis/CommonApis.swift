//
//  CommonApis.swift
//  HSN
//
//  Created by Prashant Panchal on 17/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

var globalApis = CommonApis.shared

class CommonApis: Loadable {
    
    static let shared = CommonApis()
    
    func getInvitations(completion: @escaping ([InvitationsModel], [InvitationsModel]) -> ()) {
        CommonUtils.showHudWithNoInteraction(show: true)
        //isLoading(true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.invitations,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
//            self.isLoading(false)
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    let invitationsRequestSent =  kSharedInstance.getArray(dictResult["invitation_request_sent"])
                    let invitationsRequestReceived =  kSharedInstance.getArray(dictResult["invitation_request_receive"])
                    let sentReq = invitationsRequestSent.map{InvitationsModel(data: (kSharedInstance.getDictionary($0)))}
                    let recReq = invitationsRequestReceived.map{InvitationsModel(data: (kSharedInstance.getDictionary($0)))}
                    completion(sentReq,recReq)
                default:
                    showAlertMessage.toast(with: String.getString(dictResult["message"]), isDanger: true)
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.toast(with: AlertMessage.kDefaultError, isDanger: true)
            }
        }
    }
    
    func favoriteUnfavoritePost(postId: String, status: Bool, completion: @escaping (Bool)->()) {
        CommonUtils.showHudWithNoInteraction(show: false)
        let params: [String: Any] = [ApiParameters.post_id: postId,
                                     ApiParameters.is_post_favourite: status ? "1" : "0"]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.favourite_unfavourite_post_list,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let status = String.getString(dictResult["is_post_favourite"]) == "1" ? true : false
                    completion(status)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func favoriteUnfavoriteCandidate(params : [String : Any],completion: @escaping (Bool)->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.favourite_unfavourite_candidate,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let status = String.getString(dictResult["is_post_favourite"]) == "1" ? true : false
                    completion(status)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func favoriteUnfavoriteJob(jobId:String,status:Bool,completion: @escaping (Bool)->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [ApiParameters.company_job_id:jobId,
                                   ApiParameters.is_favourite:status ? "1" : "0"]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.favourite_unfavourite_job,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    //let status = String.getString(dictResult["is_post_favourite"]) == "1" ? true : false
                    completion(status)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func applyJob(data:[String:Any],completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = data
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.apply_company_job,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    //let status = String.getString(dictResult["is_post_favourite"]) == "1" ? true : false
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func createJobAlert(id:String,title:String,location:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [ApiParameters.company_id:id,
                                   ApiParameters.job_title:title,
                                   ApiParameters.location:location]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.notify_job,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    //let status = String.getString(dictResult["is_post_favourite"]) == "1" ? true : false
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getProfile(
        id: String,
        filterType: Int = -1,
        isSelf: Bool = false,
        completion: @escaping (UserProfileModel)->()
    ) {
        CommonUtils.showHudWithNoInteraction(show: true)
//        isLoading(true)
        let params: [String: Any] = [:]
        let apiUrl = ServiceName.user_profile+"?user_id=\(id)"+"&post_type[]=\(String.getString(filterType))"
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: apiUrl ,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
//            self.isLoading(false)
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    let profile =  UserProfileModel(data: kSharedInstance.getDictionary(dictResult["user_profile"]))
                    if id == UserData.shared.id{
                        UserData.shared.saveData(data:kSharedInstance.getDictionary(dictResult["user_profile"]) )
                    }
                    completion(profile)
                default:
                    break
                    //self.toast(with: String.getString(dictResult["message"]))
                    //showAlertMessage.toast(with: String.getString(dictResult["message"]), isDanger: true)
                }
            } else if errorType == .noNetwork {
                showAlertMessage.toast(with: AlertMessage.kNoInternet, isDanger: true)
            } else {
                showAlertMessage.toast(with: AlertMessage.kDefaultError, isDanger: true)
            }
        }
    }
    func getCompanyProfile(id:String,type:Int = 0,completion: @escaping (CompanyPageModel)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.company_id:id,
                                   ApiParameters.post_type:String.getString(type)]
        let apiUrl = ServiceName.company_page
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: apiUrl ,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  CompanyPageModel(data: kSharedInstance.getDictionary(dictResult["company_page"]))
                    
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getConnections(sortType:String = "",searchText:String = "",completion: @escaping ([InvitationsModel])->()){
//        CommonUtils().isLoading(true)
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = ServiceName.my_connecation + "?name=" + searchText + "&sort_by=" + sortType
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url.replacingOccurrences(of: " ", with: "+"),
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
//            CommonUtils().isLoading(false)
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["my_connecation"])
                    let connections =  kSharedInstance.getArray(data["data"])
                    let connectionsModel = connections.map{InvitationsModel(data: (kSharedInstance.getDictionary($0)))}
                    completion(connectionsModel)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAdmins(pageId : String, completion: @escaping ([CandidateDetailsModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = "\(ServiceName.adminList)?company_id=\(pageId)"
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName:url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    //let data =  kSharedInstance.getDictionary(dictResult["my_connecation"])
                    let connections =  kSharedInstance.getArray(dictResult["data"])
                    let connectionsModel = connections.map{CandidateDetailsModel(data: (kSharedInstance.getDictionary($0)))}
                    completion(connectionsModel)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getRecommendedUsers(completion: @escaping ([RecommendedUsersModel], [RecommendedUsersModel]) -> ()) {
        CommonUtils.showHudWithNoInteraction(show: true)
        //isLoading(true)
        let params:[String: Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.new_users,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            //self.isLoading(false)
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    kBucketUrl = String.getString(dictResult["base_url"])
                    let recommended =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    let recent =  kSharedInstance.getArray(dictResult["recently_added_users"])
                    completion(recommended.map{ RecommendedUsersModel(data: (kSharedInstance.getDictionary($0)))},recent.map{RecommendedUsersModel(data: (kSharedInstance.getDictionary($0)))})
                default:
                    //showAlertMessage.alert(message: String.getString(dictResult["message"]))
                    showAlertMessage.toast(with: String.getString(dictResult["message"]), isDanger: true)
                }
            } else if errorType == .noNetwork {
                //showAlertMessage.alert(message: AlertMessage.kNoInternet)
                showAlertMessage.toast(with: AlertMessage.kNoInternet, isDanger: true)
            } else {
                //showAlertMessage.alert(message: AlertMessage.kDefaultError)
                showAlertMessage.toast(with: AlertMessage.kDefaultError, isDanger: true)
            }
        }
    }
    
    func acceptConnectionRequest(id: String, completion: @escaping () -> ()) {
        CommonUtils.showHudWithNoInteraction(show: true)
//        isLoading(true)
        let params: [String: Any] = ["sender_id": id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.accept_connecation_request,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
//            self.isLoading(false)
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    //showAlertMessage.alert(message: String.getString(dictResult["message"]))
                    showAlertMessage.toast(with: String.getString(dictResult["message"]), isDanger: true)
                }
            } else if errorType == .noNetwork {
                //showAlertMessage.alert(message: AlertMessage.kNoInternet)
                showAlertMessage.toast(with: AlertMessage.kNoInternet, isDanger: true)
            } else {
                //showAlertMessage.alert(message: AlertMessage.kDefaultError)
                showAlertMessage.toast(with: AlertMessage.kDefaultError, isDanger: true)
            }
        }
    }
    
    
    func addUserAsAdmin(params: [String: Any], completion: @escaping () -> ()) {
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.addAdminList,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    
    func acceptRejectGroupRequest(id: String, type: Int, groupId: String, memberId: String, join_group: String = "0", completion: @escaping ()->()) {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [
            ApiParameters.id: id,
            ApiParameters.group_id: groupId,
            ApiParameters.type: String.getString(type),
            ApiParameters.member_id: memberId,
            ApiParameters.join_group: join_group
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.group_accept,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func makeConnection(id: String, completion: @escaping () -> ()) {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [ApiParameters.recipient_id:id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.make_connecation,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func removeConnection(id:String, completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.user_id:id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.remove_my_connecation,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func deletePost(id:String, type:Int,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.post_id :id,
                                   ApiParameters.type:String.getString(type)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.delete_post_comment,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func deleteStory(id:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.story_id :id,
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.delete_story,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func deleteModule(id:String, type:Int,completion: @escaping ()->()){
        //1 for company spotlight,2 company photos, 3 testimonials
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.id :id,
                                   ApiParameters.type:String.getString(type)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.delete_company_life_module,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func deletePage(id:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.id :id,
                                   ApiParameters.is_delete:String.getString("1")]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.add_company,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func deletePageEvent(id:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.company_event + "/\(id)",
                                                   requestMethod: .DELETE,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func deletePageLifeOrProduct(type:PageMediaType,id:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        var url = ""
        var reqType:kHTTPMethod = .POST
        if type == .lifeMedia{
            params = [ApiParameters.company_lifes_id :id]
            url = ServiceName.delete_company_life
            reqType = .POST
        }
        else if type == .productMedia{
            params = [ApiParameters.id :id,
                      ApiParameters.is_delete:String.getString("1")]
            url = ServiceName.add_company_product
            reqType = .POST
        }
        
        else{
            params = [:]
            url = ServiceName.view_job + id
            reqType = .DELETE
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod:reqType ,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func rejectConnectionRequest(id: String, type: rejectionType, completion: @escaping () -> ()) {
        CommonUtils.showHudWithNoInteraction(show: true)
//        isLoading(true)
        let params: [String: Any] = ["sender_id": id]
        var url = ServiceName.reject_connecation_request_from_sender
        switch type {
        case .receiver:
            url = ServiceName.reject_connecation_request_from_receiver
        case .sender:
            url = ServiceName.reject_connecation_request_from_sender
        default: break
        }
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
//            self.isLoading(false)
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    
                    completion()
                default:
                    //showAlertMessage.alert(message: String.getString(dictResult["message"]))
                    showAlertMessage.toast(with: String.getString(dictResult["message"]), isDanger: true)
                }
            } else if errorType == .noNetwork {
                //showAlertMessage.alert(message: AlertMessage.kNoInternet)
                showAlertMessage.toast(with: AlertMessage.kNoInternet, isDanger: true)
            } else {
                //showAlertMessage.alert(message: AlertMessage.kDefaultError)
                showAlertMessage.toast(with: AlertMessage.kDefaultError, isDanger: true)
            }
        }
    }
    
    func likeUnlikePost(postId:String,isPostLike:Bool,type:likeType,emojiType:Int, postMode : Post, completion: @escaping (Int,Int,[String],[String])->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [ApiParameters.is_post_like:isPostLike ? "1" : "0",
                                   ApiParameters.post_id:postId,
                                   ApiParameters.type: type == .post ? "1" : "2",
                                   ApiParameters.like_type:String.getString(emojiType)]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: postMode == .user ? ServiceName.like_dislike_post : ServiceName.admin_post_like,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    let totalLikes = Int.getInt(dictResult["total_likes"])
                    let isPostLike = Int.getInt(dictResult["is_post_like"])
                    let reactions = String.getString(dictResult["count_reaction_like"]).components(separatedBy: ",")
                    let reactions_count = String.getString(dictResult["count_reaction_like_count"]).components(separatedBy: ",")
                    completion(totalLikes,isPostLike,reactions,reactions_count)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func answerPollApi(postId:String,answerId:String, completion: @escaping (Int,String,[PollModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.answer_id:answerId,
                                   ApiParameters.post_id:postId]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.votes_on_pollPost,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    let pollAnswers = data.map{PollModel(data: kSharedInstance.getDictionary($0))}
                    let totalVotes = Int.getInt(dictResult["ttl_votes"])
                    let answeredId = String.getString(dictResult["answer_id"])
                    
                    completion(totalVotes,answeredId,pollAnswers)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func followUnfollowApi(userId:String,isFollowing:Bool, isConnectedWithMe:String,completion: @escaping (Int,Bool)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.user_id:userId,
                                   ApiParameters.is_following:isFollowing ? "1" : "0",
                                   ApiParameters.is_connected_with_me : isConnectedWithMe]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.follow_unfollow_user,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    let pollAnswers = data.map{PollModel(data: kSharedInstance.getDictionary($0))}
                    let totalFollowers = Int.getInt(dictResult["follower_count"])
                    let status = String.getString(dictResult["is_following"]) == "1" ? true : false
                    
                    completion(totalFollowers,status)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func followUnfollowPageApi(pageId:String,isFollowing:Bool,completion: @escaping (Int,Bool)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.company_id:pageId,
                                   ApiParameters.is_follow:isFollowing ? "1" : "0"
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.follow_company,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    let pollAnswers = data.map{PollModel(data: kSharedInstance.getDictionary($0))}
                    let is_follow = String.getString(dictResult["is_follow"]) == "1" ? true : false
                    let total_follower_counts = Int.getInt(dictResult["total_follower_counts"])
                    let status = String.getString(dictResult["is_following"]) == "1" ? true : false
                    
                    completion(total_follower_counts,is_follow)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func blockUserApi(userId:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.user_id:userId,
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.block_user,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    let pollAnswers = data.map{PollModel(data: kSharedInstance.getDictionary($0))}
                    let totalFollowers = Int.getInt(dictResult["follower_count"])
                    let status = String.getString(dictResult["is_following"]) == "1" ? true : false
                    
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func sendEventInvitationApi(type:HasCameFrom,userIds:[String],eventId:String,companyId:String?,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        //type = 1 for user event, 2 for company event
        var params:[String:Any] = [ApiParameters.event_id:eventId,
                                   
                                   ApiParameters.users_id:userIds,
        ]
        var url = ServiceName.send_invitation
        
        
        
        switch type{
        case .viewCompanyEvent,.viewEventCompanyAdmin:
            url = ServiceName.send_company_invitation
            
            params[ApiParameters.company_id] = String.getString(companyId)
        case .viewEvent,.viewEventAdmin:
            url =  ServiceName.send_invitation
            
        default:
            url =  ServiceName.send_invitation
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    let pollAnswers = data.map{PollModel(data: kSharedInstance.getDictionary($0))}
                    let totalFollowers = Int.getInt(dictResult["follower_count"])
                    let status = String.getString(dictResult["is_following"]) == "1" ? true : false
                    
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func joinEvent(type:HasCameFrom,eventId:String,companyId:String?,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [ApiParameters.id:eventId
        ]
        var url = ServiceName.join_event
        switch type{
        case .viewCompanyEvent,.viewEventCompanyAdmin:
            url = ServiceName.join_company_event
            
            params[ApiParameters.company_id] = String.getString(companyId)
        case .viewEvent,.viewEventAdmin:
            url =  ServiceName.join_event
            
        default:
            url =  ServiceName.join_event
        }
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    
                    let pollAnswers = data.map{PollModel(data: kSharedInstance.getDictionary($0))}
                    let totalFollowers = Int.getInt(dictResult["follower_count"])
                    let status = String.getString(dictResult["is_following"]) == "1" ? true : false
                    
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func sendGroupInvitationApi(userIds:[String],groupId:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [
            ApiParameters.group_id:groupId,
            ApiParameters.users_id:userIds,
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.send_group_invitation,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    let pollAnswers = data.map{PollModel(data: kSharedInstance.getDictionary($0))}
                    let totalFollowers = Int.getInt(dictResult["follower_count"])
                    let status = String.getString(dictResult["is_following"]) == "1" ? true : false
                    
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func sendNotification(_ request : [String : Any],completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.send_notification,
                                                   requestMethod: .POST,
                                                   requestParameters: request, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["user_poll"])
                    
                    
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func uploadMedia(type:PageMediaType,image:[UIImage] = [],video:URL? = nil,isVideo:Bool = false,completion: @escaping ([String])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        var params:[String:Any] = [ApiParameters.type:type == .lifeMedia ?  "2" : "1"]
        //        if hasCameFrom == .editPage{
        //            params[ApiParameters.id] = self.pageId
        //            params[ApiParameters.is_delete] = "0"
        //
        //        }
        
        var images:[[String:Any]] = []
        var document:[String:Any] = [:]
        var video:[String:Any] = [ApiParameters.kvideo :video , ApiParameters.kvideoName : ApiParameters.product_media]
        
        images = image.map{["imageName":ApiParameters.product_media,"image":$0]}
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.upload_product_media, method: .post, arrImages: images, video: video,document: [document],  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  dictResult["media_path"] as? [String] ?? []
                    
                    
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func uploadResume(fileURL:URL,completion: @escaping (String)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        let params:[String:Any] = [:]
        //        if hasCameFrom == .editPage{
        //            params[ApiParameters.id] = self.pageId
        //            params[ApiParameters.is_delete] = "0"
        //
        //        }
        
        let images:[[String:Any]] = []
        let document:[String:Any] = ["documentName":ApiParameters.resume,"document":fileURL]
        let video:[String:Any] = [:]
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.upload_resume, method: .post, arrImages: images, video: video,document: [document],  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  dictResult["resume_path"] as? String ?? ""
                    completion(data)
                    
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func commentOnPostApi(postId:String,comment:String,tagPeople:String,media:Any,isReplyId:String, gif : String, postMode : Post, completion: @escaping (CommentModel)->()){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        
        var params:[String:Any] = [ApiParameters.comment:comment,
                                   ApiParameters.post_id:postId,
                                   ApiParameters.tagPeople:tagPeople,
                                   ApiParameters.gif_url:gif]
        if !isReplyId.isEmpty{
            params[ApiParameters.reply_id] = isReplyId
        }
        if postMode == .admin {
            params[ApiParameters.reply_id] = isReplyId == "" ? "0" : isReplyId
        }
        
        var image:[String:Any] = [:]
        var document:[String:Any] = [:]
        var video:[String:Any] = [:]
        if gif == "" {
            if media is UIImage{
                image = ["imageName":ApiParameters.picture,"image":media]
            }
        }
        else if media is URL{
            let imageExtensions = ["png", "jpg", "gif","jpeg"]
            let documentExtensions = ["pdf"]
            //...
            // Iterate & match the URL objects from your checking results
            let url: URL = media as! URL
            let pathExtention = url.pathExtension
            if imageExtensions.contains(pathExtention){}
            else if documentExtensions.contains(pathExtention){
                document = ["documentName":ApiParameters.mediaUpload,"document":media]
            }else{
                video = [ApiParameters.kvideo : media, ApiParameters.kvideoName : ApiParameters.mediaUpload]
            }
        }
        
        NetworkManager.shared.requestMultiParts(serviceName: postMode == .user ? ServiceName.comment_on_post : ServiceName.admin_post_comment, method: .post, arrImages: [image], video: video,document: [document],  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    let comment = CommentModel(data: kSharedInstance.getDictionary(data))
                    
                    
                    completion(comment)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllComments(postId:String,page:Int, filter : Int, postMode : Post, completion: @escaping ([CommentModel],Int,Int,Int,String)->()){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        //  let url = ServiceName.get_post_comment + "?page=\(String.getString(page))&post_id="+postId + "&filter=\(filter)"
        
        var url = (postMode == .user ? ServiceName.get_post_comment : ServiceName.admin_get_comment) + "?page=\(String.getString(page))&post_id="+postId + "&filter=\(filter)"
        
        if postMode == .admin {
            url = url + "&limit=10"
        }
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let comments = kSharedInstance.getDictionary(dictResult["comments"])
                    let data =  kSharedInstance.getArray(comments["data"])
                    let commentsData = data.map{CommentModel(data: kSharedInstance.getDictionary($0))}
                    let firstPage = 1
                    let lastPage = Int.getInt(comments["last_page"])
                    
                    let totalComments = Int.getInt(comments["total"])
                    let status = Int.getInt(dictResult["is_post_like"])
                    let totalLikes = Int.getInt(dictResult["total_likes_count"])
                    
                    completion(commentsData,lastPage,totalComments,status,String.getString(totalLikes))
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllGroups(completion: @escaping ([GroupListingModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = ServiceName.all_group_list
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    let activeGroups = kSharedInstance.getArray(data["data"]).map{GroupListingModel(data: kSharedInstance.getDictionary($0))}
                    //  let requestGroups = kSharedInstance.getArray(dictResult["request_groups"]).map{GroupListingModel(data: kSharedInstance.getDictionary($0))}
                    completion(activeGroups)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getGroupsList(completion: @escaping ([GroupListingModel],[GroupListingModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.group_list
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let activeGroups = kSharedInstance.getArray(dictResult["active_groups"]).map{GroupListingModel(data: kSharedInstance.getDictionary($0))}
                    let requestGroups = kSharedInstance.getArray(dictResult["request_groups"]).map{GroupListingModel(data: kSharedInstance.getDictionary($0))}
                    completion(activeGroups,requestGroups)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllPages(completion: @escaping ([CompanyPageModel],[CompanyPageModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.company_follow_by_me
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let createdByMe = kSharedInstance.getArray(dictResult["company_pages_created_by_me"]).map{CompanyPageModel(data: kSharedInstance.getDictionary($0))}
                    let following = kSharedInstance.getArray(dictResult["company_pages_follow_by_me"]).map{CompanyPageModel(data: kSharedInstance.getDictionary(kSharedInstance.getDictionary($0)["company"]))}
                    completion(createdByMe,following)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllCompanyPages(completion: @escaping ([CompanyPageModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.total_company_page
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let createdByMe = kSharedInstance.getArray(dictResult["company_pages_follow_by_me"]).map{CompanyPageModel(data: kSharedInstance.getDictionary($0))}
                    //   let following = kSharedInstance.getArray(dictResult["company_pages_follow_by_me"]).map{CompanyPageModel(data: kSharedInstance.getDictionary(kSharedInstance.getDictionary($0)["company"]))}
                    completion(createdByMe)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllEvents(completion: @escaping ([EventListModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.event_list
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let events = kSharedInstance.getArray(dictResult["data"]).map{EventListModel(data: kSharedInstance.getDictionary($0))}
                    let requestGroups = kSharedInstance.getArray(dictResult["requestGroups"]).map{GroupListingModel(data: kSharedInstance.getDictionary($0))}
                    completion(events)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func getPageProductsLife(type:PageMediaType,pageId:String,completion: @escaping ([PageProductModel],[PageLifeModel],[JobModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        var url = ""
        var reqType:kHTTPMethod = .GET
        switch type{
        case .lifeMedia:
            url = ServiceName.company_life_list + "?company_id="+pageId
        case .productMedia:
            url = ServiceName.company_product_list + "?company_id="+pageId
        case .jobMedia:
            url = ServiceName.jobsByCompany
            params = [ApiParameters.company_id:pageId]
            reqType = .POST
        default:
            break
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: reqType,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let products = kSharedInstance.getArray(dictResult["data"]).map{PageProductModel(data: kSharedInstance.getDictionary($0))}
                    let lifes = kSharedInstance.getArray(dictResult["data"]).map{PageLifeModel(data: kSharedInstance.getDictionary($0))}
                    let jobs = kSharedInstance.getArray(dictResult["data"]).map{JobModel(data: kSharedInstance.getDictionary($0))}
                    
                    completion(products,lifes,jobs)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func getAllPageEvents(pageId:String,completion: @escaping ([EventListModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = ServiceName.get_company_events
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let events = kSharedInstance.getArray(dictResult["data"]).map{EventListModel(data: kSharedInstance.getDictionary($0))}
                    
                    completion(events)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func getGroup(id:String,completion: @escaping (HSNGroupModel)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.group_id:id]
        var url = ServiceName.view_group
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = HSNGroupModel(data: kSharedInstance.getDictionary(dictResult["group"]))
                    let requestGroups = kSharedInstance.getArray(dictResult["requestGroups"]).map{GroupListingModel(data: kSharedInstance.getDictionary($0))}
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func getJob(id:String,completion: @escaping (JobModel)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = ServiceName.view_job + id
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = JobModel(data: kSharedInstance.getDictionary(dictResult["data"]))
                    //let requestGroups = kSharedInstance.getArray(dictResult["requestGroups"]).map{GroupListingModel(data: kSharedInstance.getDictionary($0))}
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    
    func getAllJobs(filter:[String:Any],completion: @escaping ([JobModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = filter
        var url = ServiceName.allJobs
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getArray(dictResult["data"]).map{JobModel(data:kSharedInstance.getDictionary($0)) }
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllJobsByCompany(id:String,completion: @escaping ([JobModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.company_id:id]
        var url = ServiceName.jobsByCompany
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getArray(dictResult["data"]).map{JobModel(data:kSharedInstance.getDictionary($0)) }
                    
                    
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllFavouriteJobs(jobTitle:String,completion: @escaping ([JobModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = ServiceName.allFavoriteJobs + "?job_title=\(jobTitle)"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getArray(dictResult["data"]).map{JobModel(data:kSharedInstance.getDictionary($0)) }
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getCandidatesList(companyId:String, jobId : String, completion: @escaping ([CandidateDetailsModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        // http://localhost/hlthera-social-network-backend/api/company_job/get-apply-user?company_id=2&company_job_id=1
        
        let url = ServiceName.allCandidatesList + "?company_id=\(companyId)&company_job_id=\(jobId)"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getArray(dictResult["data"]).map{CandidateDetailsModel(data:kSharedInstance.getDictionary($0)) }
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getFavoriteCandidatesList(completion: @escaping ([CandidateDetailsModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        // http://localhost/hlthera-social-network-backend/api/company_job/get-apply-user?company_id=2&company_job_id=1
        
        let url = ServiceName.favoriteJobList
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getArray(dictResult["data"]).map{CandidateDetailsModel(data:kSharedInstance.getDictionary($0)) }
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    
    
    func getEvent(type:HasCameFrom,id:String,completion: @escaping (EventModel)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        var url = ""
        var reqType:kHTTPMethod = .GET
        switch type{
        case .viewCompanyEvent,.viewEventCompanyAdmin:
            url = ServiceName.view_company_event
            reqType = .POST
            params = [ApiParameters.event_id:id]
        case .viewEvent,.viewEventAdmin:
            url = ServiceName.view_event + "?id="+id
            reqType = .GET
        default:
            url = ServiceName.view_event + "?id="+id
            reqType = .GET
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod:  reqType,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = EventModel(data: kSharedInstance.getDictionary(dictResult["event"]))
                    
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllUsers(searchText string:String,completion: @escaping ([AllUserModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = (ServiceName.homeSearch+"?name="+string).replacingOccurrences(of: " ", with: "+")
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    let users = data.map{AllUserModel(data: kSharedInstance.getDictionary($0))}
                    completion(users)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllLeaders(completion: @escaping ([AllUserModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.user_list_for_company_leader
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    let users = data.map{AllUserModel(data: kSharedInstance.getDictionary($0))}
                    completion(users)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllReactionsUsers(postId id:String, postMode : Post, completion: @escaping ([ReactionsListModel])->()){
        
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = postMode == . user ? [ApiParameters.post_id:id,
                                                        ApiParameters.recent_user:"0"] : [ApiParameters.post_id:id]
        
        
        let url = postMode == . user ? ServiceName.reactionsList : "\(ServiceName.total_reaction)?post_id=\(id)"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: postMode == . user ? .POST : .GET,
                                                   requestParameters: postMode == . user ? params : [:], withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["users_react_on_post"])
                    let users = data.map{ReactionsListModel(data: kSharedInstance.getDictionary($0))}
                    completion(users)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getMyHashTags(completion: @escaping ([HashTagModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
//        isLoading(true)
        let params:[String:Any] = [:]
        let url = ServiceName.follow_unfollow_list_hashTag
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            guard let self = self else { return }
            CommonUtils.showHudWithNoInteraction(show: false)
//            self.isLoading(false)
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let dict = kSharedInstance.getDictionary(dictResult["data"])
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    let tags = data.map{HashTagModel(data: kSharedInstance.getDictionary($0))}
                    completion(tags)
                default: break
                    //self.toast(with: String.getString(dictResult["message"]), isDanger: false)
                    //showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllLoungeNotification(page:Int,completion: @escaping ([NotificationModel],[NotificationModel],Int,Int,Int,Int)->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [:]
        let url = ServiceName.lounge_notification + "?page=\(String.getString(page))"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let newNotificationsData = kSharedInstance.getDictionary(dictResult["data"])
                    let oldNotificationsData = kSharedInstance.getDictionary(dictResult["notify_erlier"])
                    
                    let newNotificationsArr =  kSharedInstance.getArray(newNotificationsData["data"])
                    let oldNotificationsArr =  kSharedInstance.getArray(oldNotificationsData["data"])
                    let newNotifications = newNotificationsArr.map{NotificationModel(data: kSharedInstance.getDictionary($0))}
                    let oldNotifications = oldNotificationsArr.map{NotificationModel(data: kSharedInstance.getDictionary($0))}
                    let newlastPage = Int.getInt(newNotificationsData["last_page"])
                    
                    let newTotal = Int.getInt(newNotificationsData["total"])
                    let oldlastPage = Int.getInt(newNotificationsData["last_page"])
                    
                    let oldTotal = Int.getInt(newNotificationsData["total"])
                    completion(newNotifications,oldNotifications,newlastPage,newTotal,oldlastPage,oldTotal)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func markAllNotificationsAsRead(markAllRead:Bool,id:String = "",completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = ["mark_all_read":markAllRead ? "1" : "",
                                   ApiParameters.id:id]
        let url = ServiceName.notifymarkread_countread
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    let tags = data.map{ HashTagModel(data: kSharedInstance.getDictionary($0)) }
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getAllNotifications(page: Int, completion: @escaping ([NotificationModel], [NotificationModel], Int, Int, Int, Int) -> ()) {
        CommonUtils.showHudWithNoInteraction(show: false)
        let params: [String: Any] = [:]
        let url = ServiceName.notify_list + "?page=\(String.getString(page))"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let newNotificationsData = kSharedInstance.getDictionary(dictResult["notify_new"])
                    let oldNotificationsData = kSharedInstance.getDictionary(dictResult["notify_erlier"])
                    
                    let newNotificationsArr =  kSharedInstance.getArray(newNotificationsData["data"])
                    let oldNotificationsArr =  kSharedInstance.getArray(oldNotificationsData["data"])
                    let newNotifications = newNotificationsArr.map{NotificationModel(data: kSharedInstance.getDictionary($0))}
                    let oldNotifications = oldNotificationsArr.map{NotificationModel(data: kSharedInstance.getDictionary($0))}
                    let newlastPage = Int.getInt(newNotificationsData["last_page"])
                    
                    let newTotal = Int.getInt(newNotificationsData["total"])
                    let oldlastPage = Int.getInt(newNotificationsData["last_page"])
                    
                    let oldTotal = Int.getInt(newNotificationsData["total"])
                    completion(newNotifications,oldNotifications,newlastPage,newTotal,oldlastPage,oldTotal)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getListingData(type: listingData, completion: @escaping ([ListingDataModel]) -> ()) {
        var url = ServiceName.listing_data
        switch type {
        case .degree:
            url = ServiceName.listing_data   + "?type=3"
        case .industry:
            url = ServiceName.listing_data  + "?type=1"
        case .organization:
            url = ServiceName.listing_data   + "?type=2"
        case .company:
            url = ServiceName.listing_data + "?type=4"
        }
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    let listData = data.map{ListingDataModel(data: kSharedInstance.getDictionary($0))}
                    completion(listData)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func deleteEvent(id:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.id:id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.delete_event,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["recommanded_users"])
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func deleteProfileData(type:profileData,id:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [ApiParameters.id:id,
        ]
        
        switch type{
        case .education:
            params[ApiParameters.type] = "2"
        case .certificate:
            params[ApiParameters.type] = "3"
        case .experience:
            params[ApiParameters.type] = "1"
        }
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.delete_exp,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    let users = data.map{AllUserModel(data: kSharedInstance.getDictionary($0))}
                    completion()
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getInsights(contentType:Int,filterType:Int,from:String,to:String,completion:@escaping (([String:Any])->())){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.insight_tabs:String.getString(contentType),
                                   ApiParameters.filter_type:String.getString(filterType),
                                   ApiParameters.from:from,
                                   ApiParameters.to:to]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.insight_promotation_post,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    if contentType == 1{
                        let data =  kSharedInstance.getDictionary(dictResult["data"])
                        let posts = kSharedInstance.getArray(data["promotation_posts"]).map{HomeFeedModel(data: kSharedInstance.getDictionary($0))}
                        let totalCount = Int.getInt(String.getString(data["promotation_post_counts"]))
                        completion(["posts":posts,"totalCount":totalCount])
                        
                    }
                    else if contentType == 2 {
                        let data =  kSharedInstance.getDictionary(dictResult["data"])
                        let allData = kSharedInstance.getArray(data["data"]).map{InsightsActivityModel(data: kSharedInstance.getDictionary($0))}
                        let interactionData = kSharedInstance.getArray(data["interation__data"]).map{InsightsActivityModel(data: kSharedInstance.getDictionary($0))}
                        let promotionPostCounts = String.getString(data["promotation_post_counts"])
                        let reachedPostCounts = String.getString(data["reached_post_counts"])
                        let reachedImpressionCount = String.getString(data["reached_impression_post_counts"])
                        let profileVisitCount = String.getString(data["profile_visit_count"])
                        let websiteClickCounts = String.getString(data["website_click_counts"])
                        let moreMessagesCount = String.getString(data["more_messages_count"])
                        completion(["allData":allData,
                                    "interactionData":interactionData,
                                    "promotionPostCounts":promotionPostCounts,
                                    "reachedPostCounts":reachedPostCounts,
                                    "reachedImpressionCount":reachedImpressionCount,
                                    "profileVisitCount":profileVisitCount,
                                    "websiteClickCounts":websiteClickCounts,
                                    "moreMessagesCount":moreMessagesCount,
                                    
                                   ])
                        
                    }
                    else if contentType == 3 {
                        let data =  kSharedInstance.getDictionary(dictResult["data"])
                        let followers = kSharedInstance.getArray(data["followers"]).map{InsightsActivityModel(data: kSharedInstance.getDictionary($0))}
                        
                        let totalFollowersCount = String.getString(data["total_follower_counts"])
                        let totalUnfollowedCount = String.getString(data["total_unfollowed_you_counts"])
                        let totalFollowedCount = String.getString(data["total_followed_you_counts"])
                        let totalUsers = String.getString(data["total_users"])
                        let totalFemaleUsers = String.getString(data["total_female_users"])
                        let totalMaleUsers = String.getString(data["total_male_users"])
                        let followUsersFromLocation = kSharedInstance.getArray(data["follow_users_from_location"])
                        let userMaleFemaleAge = kSharedInstance.getArray(data["user_male_female_age"])
                        completion(["followers":followers,
                                    "totalFollowersCount":totalFollowersCount,
                                    "totalUnfollowedCount":totalUnfollowedCount,
                                    "totalFollowedCount":totalFollowedCount,
                                    "totalUsers":totalUsers,
                                    "totalFemaleUsers":totalFemaleUsers,
                                    "totalMaleUsers":totalMaleUsers,
                                    "followUsersFromLocation":followUsersFromLocation,
                                    "userMaleFemaleAge":userMaleFemaleAge,
                                    
                                   ])
                    }
                    //self.interests = data.map{InterestModel(data: kSharedInstance.getDictionary($0))}
                    //self.collectionViewInterests.reloadData()
                default:
                    showAlertMessage.toast(with: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.toast(with: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getPlans(completion: @escaping ([PlanModel],PlanModel?)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.plans
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let activePlanData = kSharedInstance.getDictionary(dictResult["active_plan"])
                    let activePlan = PlanModel(data: activePlanData)
                    let plans =  kSharedInstance.getArray(dictResult["plans"])
                    let data = plans.map{PlanModel(data: (kSharedInstance.getDictionary($0)))}
                    completion(data,activePlanData.isEmpty ? nil : activePlan)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func initializeStripeGateway(amount:String,completion: @escaping (String,String,String,String)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.currencyType:"AED",
                                   ApiParameters.amount:amount]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.payment_intent,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    let paymentIntent = String.getString(dictResult["paymentIntent"])
                    let ephemeralKey = String.getString(dictResult["ephemeralKey"])
                    let customer = String.getString(dictResult["customer"])
                    let publishableKey = String.getString(dictResult["publishableKey"])
                    completion(paymentIntent,ephemeralKey,customer,publishableKey)
                default:
                    print(String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func verifyStripePayment(paymentIntent:String,completion: @escaping (String,String)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.paymentIntent:paymentIntent]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.retrieve_payment_intent,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    
                    let customerId = String.getString(dictResult["charge_id"])
                    let refId = String.getString(dictResult["balance_transaction"])
                    completion(customerId, refId)
                    
                default:
                    print(String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    //    func initializeStripeGateway(amount:String,isSaveCard:Bool,token:String,completion: @escaping (String,String)->()){
    //        CommonUtils.showHudWithNoInteraction(show: true)
    //        let params:[String:Any] = [ApiParameters.currencyType:"AED",
    //                                   ApiParameters.amount:amount,
    //                                   ApiParameters.stripeToken:token,
    //                                   ApiParameters.is_card_save:isSaveCard ? "1" : "0"]
    //
    //        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.stripe_payment,
    //                                                   requestMethod: .POST,
    //                                                   requestParameters: params, withProgressHUD: false)
    //        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
    //
    //            CommonUtils.showHudWithNoInteraction(show: false)
    //
    //            if errorType == .requestSuccess {
    //
    //                let dictResult = kSharedInstance.getDictionary(result)
    //
    //                switch Int.getInt(statusCode) {
    //
    //                case 200:
    //                    let data =  kSharedInstance.getDictionary(dictResult["data"])
    //                    let customerId = String.getString(data["id"])
    //                    let refId = String.getString(data["balance_transaction"])
    //
    //                    completion(customerId, refId)
    //
    //
    //                default:
    //                    print(String.getString(dictResult["message"]))
    //                }
    //            } else if errorType == .noNetwork {
    //                showAlertMessage.alert(message: AlertMessage.kNoInternet)
    //            } else {
    //                showAlertMessage.alert(message: AlertMessage.kDefaultError)
    //            }
    //        }
    //    }
    
    func getHomeLoungeRooms(completion: @escaping ([RoomModel])->()){
//        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [:]
        let url = ServiceName.chat_room_list
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
//            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let rooms =  kSharedInstance.getArray(dictResult["chat_room_list"])
                    let data = rooms.map{RoomModel(data: (kSharedInstance.getDictionary($0)))}
                    completion(data)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    // MARK: -  New Events Api
    func getPublicEventbyFilter(filter_type:String,completion: @escaping ([EventListByFilterModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = "\(ServiceName.public_event_list)?\("filter_type=\(filter_type)")"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let events = kSharedInstance.getArray(dictResult["data"]).map{EventListByFilterModel(data: kSharedInstance.getDictionary($0))}
                    completion(events)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func eventInterest(event_id:String,is_interest:Bool,interest_type:String,completion: @escaping (String)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.event_id:event_id,
                                   ApiParameters.is_interest:is_interest ? "1" : "0",
                                   ApiParameters.interest_type:interest_type]
        
        let url = ServiceName.event_interest
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let eventsInterest = String.getString(dictResult["is_interest"])
                    completion(eventsInterest)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getInterestedEventList(eventId:String,completion: @escaping ([EventInterestedListModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = "\(ServiceName.event_interested)?\("event_id=\(eventId)")"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let events = kSharedInstance.getArray(dictResult["users"]).map{EventInterestedListModel(data: kSharedInstance.getDictionary($0))}
                    completion(events)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getEventInterestList(completion: @escaping ([InterestedEventListModel])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.my_event_interested
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let events = kSharedInstance.getArray(dictResult["data"]).map{InterestedEventListModel(data: kSharedInstance.getDictionary($0))}
                    completion(events)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    //Post Exclusive
    func getExclusivePosts(_ status : Int, completion: @escaping ([String:Any])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        // http://localhost/hlthera-social-network-backend/api/company_job/get-apply-user?company_id=2&company_job_id=1
        
        let url = "\(ServiceName.exlusive_post)?status=\(status)"
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    
                    //  let data = kSharedInstance.getArray(dictResult["data"]).map{CandidateDetailsModel(data:kSharedInstance.getDictionary($0)) }
                    completion(dictResult)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func sharePost(_ params : [String: Any], completion: @escaping ([String:Any])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.admin_share_post,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let events = kSharedInstance.getArray(dictResult["data"])
                    //.map{ InterestedEventListModel(data: kSharedInstance.getDictionary($0)) }
                    completion(dictResult)
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
    func getExclusivePlan(completion: @escaping ([String:Any])->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.active_exclusive,
                                                   requestMethod: .GET,
                                                   requestParameters: [:], withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let active_plan = kSharedInstance.getDictionary(dictResult["active_plan"])
                    completion(active_plan)
                default: break
                    //self.toast(with: String.getString(dictResult["message"]), isDanger: false)
                    //showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
}
