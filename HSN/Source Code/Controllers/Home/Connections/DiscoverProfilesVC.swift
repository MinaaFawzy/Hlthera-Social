//
//  MyNetworkVC.swift
//  HSN
//
//  Created by Prashant Panchal on 04/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class DiscoverProfilesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var collectionViewRecommended: UICollectionView!
//    @IBOutlet weak var constraintRecommendedHeight: NSLayoutConstraint!
//    @IBOutlet weak var constraintRecentlyHeight: NSLayoutConstraint!
//    @IBOutlet weak var collectionViewRecently: UICollectionView!
    var headerSections = ["Recommended profiles for you","Recently Added Profiles"]
    var recentlyAddedUsers:[RecommendedUsersModel] = [] {
        didSet{
//            recentlyAddedUsers.isEmpty ? (constraintRecentlyHeight.constant = 200) : ( constraintRecentlyHeight.constant = CGFloat((ceil(Float(recentlyAddedUsers.count)/2.0)*236.5)))
//            self.collectionViewRecently.reloadData()
            
        
        }
    }
    var recommendedUsers:[RecommendedUsersModel] = [] {
        didSet{
//            recommendedUsers.isEmpty ? (constraintRecommendedHeight.constant = 200) : ( constraintRecommendedHeight.constant = CGFloat((ceil(Float(recommendedUsers.count)/2.0)*236.5)))
//            self.collectionViewRecommended.reloadData()
           
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupCollectionView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCollectionView(){
        
//        collectionViewRecently.register(UINib(nibName: PeopleCVC.identifier, bundle: nil), forCellWithReuseIdentifier: PeopleCVC.identifier)
//        collectionViewRecommended.register(UINib(nibName: PeopleCVC.identifier, bundle: nil), forCellWithReuseIdentifier: MyConnectionsTVC.identifier)
        tableView.register(UINib(nibName: MyConnectionsTVC.identifier, bundle: nil), forCellReuseIdentifier: MyConnectionsTVC.identifier)
    }
    
    func fetchData(){
        globalApis.getRecommendedUsers(){ recommendedUsers,recentUsers in
            self.recommendedUsers = recommendedUsers
            self.recentlyAddedUsers = recentUsers
            self.tableView.reloadData()
        }
    }
    
}
//extension DiscoverProfilesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == collectionViewRecommended{
//            return collectionView.numberOfRow(numberofRow: recommendedUsers.count)
//        }else{
//            return collectionView.numberOfRow(numberofRow: recentlyAddedUsers.count)
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleCVC.identifier, for: indexPath) as! PeopleCVC
//        if collectionView == collectionViewRecommended{
//            cell.updateCell(data: recommendedUsers[indexPath.row])
//            cell.connectCallback = {
//                globalApis.makeConnection(id: self.recommendedUsers[indexPath.row].id, completion: {
//                    self.moveToPopUp(text: "Request Sent Successfully"){
//                        globalApis.getRecommendedUsers(){ recommendUsers,recentUsers in
//                            self.recommendedUsers = recommendUsers
//                            self.recentlyAddedUsers = recentUsers
//                        }
//                    }
//                })
//            }
//            cell.closeCallback = {
//                self.recommendedUsers.remove(at: indexPath.row)
//                self.collectionViewRecommended.reloadData()
//
//            }
//        }else{
//            cell.updateCell(data: recentlyAddedUsers[indexPath.row])
//            cell.connectCallback = {
//                globalApis.makeConnection(id: self.recentlyAddedUsers[indexPath.row].id, completion: {
//                    self.moveToPopUp(text: "Request Sent Successfully"){
//                        globalApis.getRecommendedUsers(){ recommendUsers,recentUsers in
//                            self.recommendedUsers = recommendUsers
//                            self.recentlyAddedUsers = recentUsers
//                        }
//                    }
//                })
//            }
//            cell.closeCallback = {
//                self.recentlyAddedUsers.remove(at: indexPath.row)
//                self.collectionViewRecently.reloadData()
//
//            }
//        }
//
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == collectionViewRecommended{
//            globalApis.getProfile(id: self.recommendedUsers[indexPath.row].id, completion: {user in
//                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
//                vc.data = user
//                self.navigationController?.pushViewController(vc, animated: true)
//            })
//        }else{
//            globalApis.getProfile(id: self.recentlyAddedUsers[indexPath.row].id, completion: {user in
//                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
//                vc.data = user
//                self.navigationController?.pushViewController(vc, animated: true)
//            })
//        }
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width/2.065, height: 226.5)
//    }
//
//
//}
extension DiscoverProfilesVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 1
       
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
//            return tableView.createHeaderViewSingleBtn(text: "Manage My Connections",withBackgroundColor: false, font: UIFont(name: "Corben-Regular", size: 16)!,completion: { sender in
//                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: MyConnectionsVC.getStoryboardID()) as? MyConnectionsVC else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            })
            return tableView.createHeaderView(text: "Recommended profiles for you",color: UIColor(named: "5")!,backgroundColor: .white)//#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1))
        case 1:
            
            //return tableView.createHeaderView(text:"Invitations",color: UIColor(named: "5")!,backgroundColor: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1),font: UIFont(name: "Corben-Regular", size: 16)!)
//            return tableView.createHeaderViewBtn(text: "Invitations", btnTitle: "View All", withBackgroundColor: false, color: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1),titleColor: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1),trailing: 0,font: UIFont(name: "SFProDisplay-Bold", size: 16)!, completion: { sender in
//                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: InvitationsVC.getStoryboardID()) as? InvitationsVC else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            })
            return tableView.createHeaderView(text: "Recently Added Profiles",color: UIColor(named: "5")!,backgroundColor:.white)//#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1))
        
        default:return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return recommendedUsers.isEmpty ? 0 : 40
        case 1:
            return recentlyAddedUsers.isEmpty ? 0 : 40
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyConnectionsTVC.identifier, for: indexPath) as! MyConnectionsTVC
            cell.updateCell(data:recommendedUsers,nav: self.navigationController)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyConnectionsTVC.identifier, for: indexPath) as! MyConnectionsTVC
            cell.updateCell(data:recentlyAddedUsers,nav: self.navigationController)
            return cell
        default: return UITableViewCell()
        }
        
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            if recommendedUsers.indices.contains(indexPath.row) && !recommendedUsers.isEmpty{
                let label = UILabel()
                  let obj = recommendedUsers[indexPath.row]
              
                 
                  var height: CGFloat = 30

                     //we are just measuring height so we add a padding constant to give the label some room to breathe!
                      var padding: CGFloat = 20

                      //estimate each cell's height
                      let text = String.getString(obj.full_name).capitalized
                  height = estimateFrameForText(text: text).height + padding + 204
                      
                      
                //  204 + label.frame.height
                          // width that you want
                 var temp = ceil(Float(recommendedUsers.count)/2.0)
                return recommendedUsers.isEmpty ? (200) : CGFloat((temp*Float(height)))
            }
            else{
                return 200
            }
            //return recommendedUsers.isEmpty ? (200) : CGFloat((ceil(Float(recommendedUsers.count)/2.0)*236.5))
        case 1:
            
            if recentlyAddedUsers.indices.contains(indexPath.row) && !recentlyAddedUsers.isEmpty{
                let label = UILabel()
                  let obj = recentlyAddedUsers[indexPath.row]
              
                 
                  var height: CGFloat = 30

                     //we are just measuring height so we add a padding constant to give the label some room to breathe!
                      var padding: CGFloat = 20

                      //estimate each cell's height
                      let text = String.getString(obj.full_name).capitalized
                  height = estimateFrameForText(text: text).height + padding + 204
                      
                      
                //  204 + label.frame.height
                          // width that you want
                 var temp = ceil(Float(recentlyAddedUsers.count)/2.0)
                return recentlyAddedUsers.isEmpty ? (200) : CGFloat((temp*Float(height)))
            }
            else{
                return 200
            }
            
            
           
       
        default:
            return UITableView.automaticDimension
        }
            
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0,1:
            globalApis.getProfile(id: String.getString(indexPath.section == 0 ? self.recommendedUsers[indexPath.row].id : self.recentlyAddedUsers[indexPath.row].id), completion: {user in
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                vc.data = user
                vc.id = user.id
                vc.hasCameFrom = .viewProfile
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
        default:
            return
        }
    }
    
    
}
extension UIViewController{
     func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 100

        let size = CGSize(width: 200, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)]

        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}
