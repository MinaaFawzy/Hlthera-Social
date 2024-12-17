//
//  ExclusivePostVC.swift
//  HSN
//
//  Created by Apple on 19/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ExclusivePostVC: UIViewController {

    @IBOutlet weak var btnHome: WSRoundButton!
    @IBOutlet weak var btnMedia: WSRoundButton!
    @IBOutlet weak var btnHomeReplies: WSRoundButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    var postType = 1
    var lastPage = 0
    var firstPage = 0
    var currentPage = 1
    var totalPost = 0
    var exclusivePosts = [HomeFeedModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,
                                  action: #selector(refresh(_:)),
                                  for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        getExclusivePosts()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(_ sender:UIRefreshControl){
         self.exclusivePosts.removeAll()                                                                                                      
         getExclusivePosts()                                                                                                                              
     }
    
    @IBAction func buttonBackTapped(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)               }
    
    @IBAction func selectTypeAction(_ sender: UIButton) {
        btnHome.isSelected = sender == btnHome ? true : false
        btnMedia.isSelected = sender == btnMedia ? true : false
        btnHomeReplies.isSelected = sender == btnHomeReplies ? true : false
        btnHome.setTitleColor(sender == btnHome ? .white : UIColor.init(hexString: "#385B8A") , for: .normal)
        btnMedia.setTitleColor(sender == btnMedia ? .white : UIColor.init(hexString: "#385B8A") , for: .normal)
        btnHomeReplies.setTitleColor(sender == btnHomeReplies ? .white : UIColor.init(hexString: "#385B8A") , for: .normal)
        btnHome.backgroundColor =  sender == btnHome ? UIColor.init(hexString: "#385B8A")  : .white
        btnMedia.backgroundColor =  sender == btnMedia ? UIColor.init(hexString: "#385B8A")  : .white
        btnHomeReplies.backgroundColor =  sender == btnHomeReplies ? UIColor.init(hexString: "#385B8A")  : .white
        postType = sender == btnHome ? 1 : 2
        self.exclusivePosts.removeAll()
        getExclusivePosts()
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

extension ExclusivePostVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exclusivePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextMediaPostTVC.identifier, for: indexPath) as! TextMediaPostTVC
        cell.parent = self
        cell.headerObj?.exclusiveHeaderView.isHidden = false
        if indexPath.row < exclusivePosts.count {
            cell.configure(type: .homeFeed, on: self, data: exclusivePosts[indexPath.row])
        }
        return cell
    }
}

extension ExclusivePostVC {
    
    func getExclusivePosts(){
        
        globalApis.getExclusivePosts(postType, completion: {
            dictResult in
            self.tableView.refreshControl?.endRefreshing()
            DispatchQueue.main.async {
                if self.exclusivePosts.isEmpty{
                    self.tableView.reloadData()
                }
                
                kBucketUrl = String.getString(dictResult["base_url"])
                var indexPathes: [IndexPath] = []
                let data = kSharedInstance.getDictionary(dictResult["data"])
                self.firstPage = Int.getInt(data["first_page"])
                self.lastPage = Int.getInt(data["last_page"])
                self.totalPost = Int.getInt(data["total"])
                let unreadCount = Int.getInt(data["unread_count"])
                kSharedInstance.getArray(data["data"]).forEach{
                    let indexPath = IndexPath(row:self.exclusivePosts.count,section:0)
                    self.exclusivePosts.append(HomeFeedModel(data: kSharedInstance.getDictionary($0)))
                    indexPathes.append(indexPath)
                }
                self.tableView.reloadData()
                CommonUtils.showHudWithNoInteraction(show: false)
            }
         //   self.tableView.reloadData()
        })
    }

}
                                                                                             
