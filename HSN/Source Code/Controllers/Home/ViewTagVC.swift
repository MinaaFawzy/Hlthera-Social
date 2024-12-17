//
//  ViewTagVC.swift
//  HSN
//
//  Created by Prashant Panchal on 22/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ViewTagVC: UIViewController {

    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelTagName: UILabel!
    @IBOutlet weak var labelTotalFollowers: UILabel!
    @IBOutlet weak var viewTag: UIView!
    @IBOutlet weak var tableViewFeed: UITableView!
    @IBOutlet weak var buttonFollow: UIButton!
    
    var homeFeed:[HomeFeedModel] = []
    var lastPage = 0
    var firstPage = 0
    var currentPage = 1
    var isLoadingList = false
    var totalPost = 0
    var tag = ""
    var tagId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        viewTag.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        viewTag.layer.cornerRadius = 15
        self.labelTagName.text = tag
        self.labelPageTitle.text = tag
        self.labelTotalFollowers.text = "100+ Followers"
        setupCells()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    func updateData(){
        homeFeed = []
        currentPage = 1
        getHomeFeed(page: 1)
    }
    func setupCells(){
       
        tableViewFeed.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellReuseIdentifier: DocumentVC.identifier)
        tableViewFeed.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableViewFeed.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableViewFeed.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableViewFeed.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableViewFeed.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self,
                                  action: #selector(refresh(_:)),
                                  for: .valueChanged)
         tableViewFeed.refreshControl = refreshControl
    }
    @objc func refresh(_ sender:Any){
        updateData()
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonFollowUnfollowTapped(_ sender: Any) {
        if buttonFollow.isSelected{
            followUnFollowTag(isFollow: false, tagId:tagId)
        }
        else{
            followUnFollowTag(isFollow: true, tagId:tagId)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ViewTagVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRowHome(numberofRow: homeFeed.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if homeFeed.indices.contains(indexPath.row){
            let obj = homeFeed[indexPath.row]
            switch Int.getInt(obj.is_post_type){
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .findExpert, isShared: false, cameFrom: .homeFeed)
                return cell
            case 6:
                switch Int.getInt(obj.share_post?.is_post_type){
                case 7:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .findExpert, isShared: true, cameFrom: .homeFeed)
                    return cell
                case 5:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    if homeFeed.indices.contains(indexPath.row){
                        let obj = homeFeed[indexPath.row]
                        cell.updateCell(data: obj, type: .poll, isShared:true, cameFrom: .homeFeed)
                        cell.parent = self
                    }
                    return cell
                case 1,2,3,4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .media, isShared:true, cameFrom: .homeFeed)
                    cell.parent = self
                    return cell
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .text,isShared:true,cameFrom: .homeFeed)
                    cell.parent = self
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .text, isShared: true,cameFrom: .homeFeed)
                            cell.parent = self
                        return cell
                }
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                if homeFeed.indices.contains(indexPath.row){
                    let obj = homeFeed[indexPath.row]
             
                    cell.updateCell(data: obj, type: .poll,cameFrom: .homeFeed)
                    cell.parent = self
                }
                return cell
            case 1,2,3,4:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .media,cameFrom: .homeFeed)
                cell.parent = self
                return cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .text,cameFrom: .homeFeed)
                cell.parent = self
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .text,cameFrom: .homeFeed)
                        cell.parent = self
                cell.isShared = false
                    return cell
            }
        }
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewPostVC.getStoryboardID()) as? ViewPostVC else { return }
        vc.data = homeFeed[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableViewFeed{
            if (((tableViewFeed.contentOffset.y + scrollView.frame.size.height + 50) > tableViewFeed.contentSize.height && !isLoadingList)){
                if self.homeFeed.count < self.totalPost {
                    self.isLoadingList = true
                    self.currentPage = self.currentPage+1
                    self.getHomeFeed(page: self.currentPage)
                }
            }
        }
        }
}
extension ViewTagVC{
    func getHomeFeed(page:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: (ServiceName.homePost+"?page=\(page)"+"&hash_tag="+tagId).replacingOccurrences(of: " ", with: "%"),
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            
           
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    kBucketUrl = String.getString(dictResult["base_url"])
                   
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    let hashTagData = kSharedInstance.getDictionary(dictResult["hash_tag"])
                    
                    self.firstPage = Int.getInt(data["first_page"])
                    self.lastPage = Int.getInt(data["last_page"])
                    self.totalPost = Int.getInt(data["total"])
                    self.labelTotalFollowers.text = String.getString(hashTagData["total_hashTag_followers_count"]) + " Followers"
                    buttonFollow.isSelected = String.getString(hashTagData["is_hashTag_followByme"]) == "1" ? true : false
                    if buttonFollow.isSelected{
                        buttonFollow.setTitle("Unfollow", for: .normal)
                    }
                    else{
                        buttonFollow.setTitle("Follow", for: .normal)
                    }
                    kSharedInstance.getArray(data["data"]).map{
                        self.homeFeed.append(HomeFeedModel(data: kSharedInstance.getDictionary($0)))
                    }
                    
                    CommonUtils.showHudWithNoInteraction(show: false)
                    DispatchQueue.main.async {
                        isLoadingList = false
                        self.tableViewFeed.reloadData()
                        self.tableViewFeed.refreshControl?.endRefreshing()
                    }
                default:
                    CommonUtils.showHudWithNoInteraction(show: false)
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    func followUnFollowTag(isFollow:Bool,tagId:String){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.hashTag_id:tagId,ApiParameters.is_follow:isFollow ? "1":"0"]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.follow_unfollow_list_hashTag,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { [self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            
           
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let res = String.getString(dictResult["is_follow"])
                    self.moveToPopUp(text: res == "1" ? "Tag Followed Successfully!" : "Tag Unfollowed Successfully!", completion: {
                        res == "1" ? (buttonFollow.setTitle("Unfollow", for: .normal)) : (buttonFollow.setTitle("Follow", for: .normal))
                        res == "1" ? (buttonFollow.isSelected = true) : (buttonFollow.isSelected = false)
                    })
                default:
                    CommonUtils.showHudWithNoInteraction(show: false)
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}
