//
//  ReactionsListVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ReactionsListVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSelected: UIView!
    
    
    var nav:UINavigationController?
    var data:HomeFeedModel?
    
    var selectedIndex = 0
    var headerEmojis:[ReactionsHeaderModel] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }
    var reactionsUsers:[ReactionsListModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    var reactionsUsersSelected:[ReactionsListModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()

    }
    
    func setupData(){
        if let obj = data{
          //  self.headerEmojis  = obj.count_reaction_like.map{ReactionsHeaderModel(isSelected: false, count: String.getString($0), image: getEmojiImage(index: Int.getInt($0)-1), name: getEmojiNames(index: Int.getInt($0)-1))}
            
            headerEmojis = []
            for (index,val) in obj.count_reaction_like.enumerated(){
                self.headerEmojis.append(ReactionsHeaderModel(isSelected: false, count: obj.count_reaction_like_count[index], image: getEmojiImage(index: Int.getInt(val)-1), name:val))
                
            }
            
            
            self.headerEmojis.insert(ReactionsHeaderModel(isSelected: true, count: "All", image: #imageLiteral(resourceName: "calories"), name: "All"), at: 0)
            self.collectionView.reloadData()
        }
        globalApis.getAllReactionsUsers(postId: String.getString(data?.id), postMode: data?.postMode ?? .user,  completion: {data in
            self.reactionsUsers = data
        })
    }
    func getFilteredReactions(index:Int)->[ReactionsListModel]{
        return reactionsUsers.filter{$0.like_type == headerEmojis[index].name}
    }
    
    func getEmojiImage(index:Int)->UIImage{
        switch index{
        case 0:
            return UIImage(named: "post_liked")!
        case 1:
            return UIImage(named: EmojisNames.clap)!
        case 2:
            return UIImage(named: EmojisNames.handHeart)!
        case 3:
            return UIImage(named: EmojisNames.heart)!
        case 4:
            return UIImage(named: EmojisNames.light)!
        case 5:
            return UIImage(named: EmojisNames.thinking)!
        default:return UIImage()
        }
    }
    func getEmojiNames(index:Int)->String{
        switch index{
        case 0:
            return "Like"
        case 1:
            return  "Clap"
        case 2:
            return  "Support"
        case 3:
            return  "Love"
        case 4:
            return "Interesting"
        case 5:
            return "Thinking"
        default:return "None"
        }
    }
    func setupTableView(){
        self.tableView.tableFooterView = UIView()
      //  self.tableView.register(UINib(nibName: HomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: HomeSearchTVC.identifier)
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 

}
extension ReactionsListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0{
            return reactionsUsers.count
        }
        else{
            return reactionsUsersSelected.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchTVC.identifier, for: indexPath) as! HomeSearchTVC
        if let obj = selectedIndex == 0 ? reactionsUsers[indexPath.row].user : reactionsUsersSelected[indexPath.row].user{
            cell.labelUserName.text = obj.full_name.capitalized
            cell.labelProfession.text = obj.employee_type.capitalized.isEmpty ? ("Unknown") : (obj.employee_type.capitalized)
            cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            cell.imageReaction.isHidden = false
            cell.imageReaction.image = getEmojiImage(index:Int.getInt( selectedIndex == 0 ? reactionsUsers[indexPath.row].like_type : reactionsUsersSelected[indexPath.row].like_type)-1)
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ReactionsListVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(headerEmojis.count):6666")
        return headerEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionsHeaderCVC.identifier, for: indexPath) as! ReactionsHeaderCVC
        let obj = headerEmojis[indexPath.row]
        if obj.isSelected {
            
            cell.viewIsSelected.isHidden = false
        }
        else{
            cell.viewIsSelected.isHidden = true
        }
        cell.imageEmoji.isHidden = indexPath.row == 0 ? true : false
        cell.imageEmoji.image = obj.image
        cell.labelCount.text = obj.count
        cell.labelCount.font = indexPath.row == 0 ? UIFont.init(name: "SFProDisplay-Bold", size: 14.0) :  UIFont.init(name: "SFProDisplay-Regular", size: 14.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.headerEmojis.forEach{$0.isSelected = false}
        self.headerEmojis[indexPath.row].isSelected = true
        self.selectedIndex = indexPath.row
        self.reactionsUsersSelected = self.getFilteredReactions(index:selectedIndex)
        self.collectionView.reloadData()
    }
}

class ReactionsHeaderCVC:UICollectionViewCell{
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var imageEmoji: UIImageView!
    @IBOutlet weak var viewIsSelected: UIView!
    
}
