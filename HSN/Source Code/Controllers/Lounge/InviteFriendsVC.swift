//
//  InviteFriendsVC.swift
//  HSN
//
//  Created by Ankur on 04/07/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class InviteFriendsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    var searchedResults:[AllUserModel] = []
    var recentSearches:[AllUserModel] = []{
        didSet{
           
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        tableView.delegate = self
        tableView.dataSource = self
        viewMain.clipsToBounds = true
        viewMain.layer.cornerRadius = 20
        viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       
        tableView.register(UINib(nibName: LoungeInviteTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeInviteTVC.identifier)
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SearchContact(_ sender:UITextField) {
        if sender.text?.count == 0 {
            self.searchedResults = self.recentSearches
        }else{
            searchedResults = recentSearches.filter({ (text) -> Bool in
                let tmp:NSString = text.full_name as? NSString ?? ""
                let range = tmp.range(of: sender.text!, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        tableView.reloadData()
    }
}

extension InviteFriendsVC:UITableViewDelegate,UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoungeInviteTVC.identifier,for: indexPath) as! LoungeInviteTVC
     
        let obj = searchedResults[indexPath.row]
        cell.labelUserName.text = String.getString(obj.full_name).capitalized
        let strName = String.getString(obj.full_name).components(separatedBy: " ")
        if strName.count == 2{
           let fName = String(strName[0].prefix(1)).capitalized
           let lName = String(strName[1].prefix(1)).capitalized
            cell.labelShortName.text = "\(fName)\(lName)"
        }else{
            cell.labelShortName.text = String(strName[0].prefix(1)).capitalized
        }
        cell.buttonCallBack = {
            self.dismiss(animated: true)
        }
      
        cell.labelDescription.text = String.getString(obj.employee_type)
      
        cell.buttonCallBack = {
            
        }
       
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}

extension InviteFriendsVC{
    func getUsers(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
       
        
      
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.all_users,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                   
                    let data =  kSharedInstance.getArray(dictResult["all_users"])

                    self.recentSearches = data.map{AllUserModel(data: (kSharedInstance.getDictionary($0)))}
                    self.searchedResults = self.recentSearches
                    self.tableView.reloadData()
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

}
