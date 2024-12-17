//
//  SelectPromotionPostVC.swift
//  HSN
//
//  Created by Prashant Panchal on 07/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SelectPromotionPostVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var homeFeed:[HomeFeedModel] = []
    var lastPage = 0
    var firstPage = 0
    var currentPage = 1
    var isLoadingList = false
    var totalPost = 0
    var callbackDone:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellReuseIdentifier: DocumentVC.identifier)
        tableView.register(UINib(nibName: TextMediaPostTVC.identifier, bundle: nil), forCellReuseIdentifier: TextMediaPostTVC.identifier)
        tableView.register(UINib(nibName: PollPostTVC.identifier, bundle: nil), forCellReuseIdentifier: PollPostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTVC.identifier)
        tableView.register(UINib(nibName: SharePostTextMediaTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostTextMediaTVC.identifier)
        tableView.register(UINib(nibName: SharePostPollTVC.identifier, bundle: nil), forCellReuseIdentifier: SharePostPollTVC.identifier)
        tableView.register(UINib(nibName: FindExpertTVC.identifier, bundle: nil), forCellReuseIdentifier: FindExpertTVC.identifier)
      
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
   
    func updateData(){
        getHomeFeed(page: 0)
        
        
    }
    @IBAction func buttonSelectTapped(_ sender: Any) {
        if self.homeFeed.filter{$0.isSelected}.isEmpty{
            CommonUtils.showToast(message: "Please Select Post")
            return
        }
        else{
            
            self.dismiss(animated: true, completion: { [self] in
                let data = self.homeFeed.filter{$0.isSelected}
                callbackDone?(data[0].id ?? "")
            })
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
extension SelectPromotionPostVC:UITableViewDelegate,UITableViewDataSource{
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
        self.tableView.reloadData()
    }
    
  
        
        
       
       
    
}
extension SelectPromotionPostVC{
    
    func getHomeFeed(page:Int){
        
        
        globalApis.getProfile(id: UserData.shared.id, completion: { data in
            self.homeFeed  = data.user_post
            self.tableView.reloadData()
        })}
        
     
}
