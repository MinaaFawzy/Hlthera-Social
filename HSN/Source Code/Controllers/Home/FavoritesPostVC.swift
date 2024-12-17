//
//  FavoritesPostVC.swift
//  HSN
//
//  Created by Prashant Panchal on 01/07/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class FavoritesPostVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var lastPage = 0
    var firstPage = 0
    var currentPage = 1
    var isLoadingList = false
    var totalPost = 0
    var homeFeed:[HomeFeedModel] = []
    var hasCameFrom:HasCameFrom = .homeFeed
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupCells()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        updateData()
    }
    func setupCells(){
       
        tableView.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellReuseIdentifier: DocumentVC.identifier)
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableView.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableView.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        tableView.register(UINib(nibName: FindExpertTVC.identifier, bundle: nil), forCellReuseIdentifier: FindExpertTVC.identifier)
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self,
                                  action: #selector(refresh(_:)),
                                  for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refresh(_ sender:UIRefreshControl)
     {
        updateData()
     }
    func updateData(){
      
        
        homeFeed = []
        currentPage = 1
        getHomeFeed(page: 1)
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension FavoritesPostVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRowHome(numberofRow: homeFeed.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if homeFeed.indices.contains(indexPath.row){
            let obj = homeFeed[indexPath.row]
            switch Int.getInt(obj.is_post_type){
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .findExpert, isShared: false ,cameFrom: self.hasCameFrom)
                return cell
            case 6:
                switch Int.getInt(obj.share_post?.is_post_type){
                case 7:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .findExpert, isShared: true,cameFrom: self.hasCameFrom)
                    return cell
                case 5:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    if homeFeed.indices.contains(indexPath.row){
                        let obj = homeFeed[indexPath.row]
                        cell.updateCell(data: obj, type: .poll, isShared:true,cameFrom: self.hasCameFrom)
                        cell.parent = self
                    }
                    return cell
                    
                
                case 1,2,3,4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .media, isShared:true,cameFrom: self.hasCameFrom)
                    cell.parent = self
                    return cell
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .text,isShared:true,cameFrom: self.hasCameFrom)
                    cell.parent = self
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.updateCell(data: obj, type: .text, isShared: true,cameFrom: self.hasCameFrom)
                            cell.parent = self
                        return cell
                }
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                if homeFeed.indices.contains(indexPath.row){
                    let obj = homeFeed[indexPath.row]
             
                    cell.updateCell(data: obj, type: .poll,cameFrom: self.hasCameFrom)
                    cell.parent = self
                }
                return cell
            case 1,2,3,4:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .media,cameFrom: self.hasCameFrom)
                cell.parent = self
                return cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom)
                cell.parent = self
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.updateCell(data: obj, type: .text,cameFrom: self.hasCameFrom)
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
    
    
}
extension FavoritesPostVC{
    func getHomeFeed(page:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = ""
        
            url = ServiceName.favourite_unfavourite_post_list
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { [self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            
           
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    kBucketUrl = String.getString(dictResult["base_url"])
                   kBucketUrl = "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/"
                    let data = kSharedInstance.getArray(dictResult["data"])
                    self.homeFeed = []
                    data.map{
                        self.homeFeed.append(HomeFeedModel(data: kSharedInstance.getDictionary($0)))
                    }
                    
                    CommonUtils.showHudWithNoInteraction(show: false)
                    DispatchQueue.main.async {
                        isLoadingList = false
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
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
}
