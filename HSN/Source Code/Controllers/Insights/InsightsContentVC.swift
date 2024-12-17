//
//  InsightsContentVC.swift
//  HSN
//
//  Created by Mac02 on 07/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
var selectedFilter = 1
var selectedFilterStartDate = ""
var selectedFilterEndDate = ""
class InsightsContentVC: UIViewController {
    @IBOutlet weak var tableViewPosts: UITableView!
    @IBOutlet weak var collectionViewPosts: UICollectionView!
    @IBOutlet weak var constraintCollectionViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var labelOverviewTotal: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var constraintTableViewHeigh: NSLayoutConstraint!
    
    var homeFeed:[HomeFeedModel] = []{
        didSet{
            self.tableViewPosts.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                self.constraintTableViewHeigh.constant = self.tableViewPosts.contentSize.height
            })
        }
    }
    var totalCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewPosts.delegate = self
        self.tableViewPosts.dataSource = self
        tableViewPosts.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellReuseIdentifier: DocumentVC.identifier)
        tableViewPosts.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableViewPosts.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableViewPosts.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableViewPosts.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableViewPosts.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        tableViewPosts.register(UINib(nibName: FindExpertTVC.identifier, bundle: nil), forCellReuseIdentifier: FindExpertTVC.identifier)
        
        tableViewPosts.isUserInteractionEnabled = false
        tableViewPosts.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    func getFilterType(index:Int)->String{
        switch index{
        case 1:
            return "this week"
        case 2:
            return "previous month"
        case 3:
            return "this year"
        default: return "this week"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        globalApis.getInsights(contentType: 1, filterType: selectedFilter, from: "", to: "", completion: {
            data  in
            self.homeFeed = data["posts"] as! [HomeFeedModel]
            self.totalCount =  data["totalCount"] as? Int ?? 0
            self.labelOverviewTotal.text = "\(self.totalCount) Posts \(self.getFilterType(index: selectedFilter))"
            
           
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonCreatePostTapped(_ sender: Any) {
    }
    @IBAction func buttonOverViewTapped(_ sender: Any) {
    }
    
}
//extension InsightsContentVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return posts.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InsightPostGridCVC.identifier, for: indexPath) as! InsightPostGridCVC
//        let obj = posts[indexPath.row]
//            cell.labelViews.text = obj.total_view_posts_count.isEmpty ? "0" : obj.total_view_posts_count
//        constraintCollectionViewHeigh.constant = collectionViewPosts.contentSize.height
//
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.collectionViewPosts.frame.width/3.15, height: 125)
//    }
//
//
//
//}
extension InsightsContentVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRowHome(numberofRow: homeFeed.count)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if homeFeed.indices.contains(indexPath.row){
            let obj = homeFeed[indexPath.row]
          
            switch Int.getInt(obj.is_post_type){
            case 7:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.parent = self
                cell.updateCell(data: obj, type: .findExpert, isShared: false, cameFrom: .homeFeed,isInsights: true)
                
                return cell
            case 6:
                switch Int.getInt(obj.share_post?.is_post_type){
                case 7:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.parent = self
                    cell.updateCell(data: obj, type: .findExpert, isShared: true,cameFrom: .homeFeed,isInsights: true)
                    
                    return cell
                case 5:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    if homeFeed.indices.contains(indexPath.row){
                        let obj = homeFeed[indexPath.row]
                        cell.parent = self
                        cell.updateCell(data: obj, type: .poll, isShared:true,cameFrom: .homeFeed,isInsights: true)
                       
                    }
                    return cell
                    
                
                case 1,2,3,4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.parent = self
                    cell.updateCell(data: obj, type: .media, isShared:true,cameFrom: .homeFeed,isInsights: true)
                    
                    return cell
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.parent = self
                    cell.updateCell(data: obj, type: .text,isShared:true,cameFrom: .homeFeed,isInsights: true)
                    
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                    cell.parent = self
                    cell.updateCell(data: obj, type: .text, isShared: true,cameFrom: .homeFeed,isInsights: true)
                            
                        return cell
                }
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                if homeFeed.indices.contains(indexPath.row){
                    let obj = homeFeed[indexPath.row]
                    cell.parent = self
                    cell.updateCell(data: obj, type: .poll, cameFrom: .homeFeed,isInsights: true)
                    
                }
                return cell
            case 1,2,3,4:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.parent = self
                cell.updateCell(data: obj, type: .media, cameFrom: .homeFeed,isInsights: true)
                
                return cell
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.parent = self
                cell.updateCell(data: obj, type: .text, cameFrom: .homeFeed,isInsights: true)
               
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
                cell.parent = self
                cell.updateCell(data: obj, type: .text, cameFrom: .homeFeed,isInsights: true)
                       
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
        self.homeFeed.forEach{
            $0.isSelected = false
        }
        homeFeed[indexPath.row].isSelected = true
        self.tableViewPosts.reloadData()
    }
}
extension InsightsContentVC{
}
