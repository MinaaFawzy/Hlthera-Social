//
//  LoungeSendInvitationVC.swift
//  HSN
//
//  Created by Prashant Panchal on 19/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeSendInvitationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    var searchedResults:[AllUserModel] = []
    var recentSearches:[AllUserModel] = []{
        didSet{
           
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        searchBar.delegate = self
        let searchField = self.searchBar.searchTextField
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        if let clearButton = searchField.value(forKey: "_clearButton") as? UIButton{
            clearButton.addTarget(self, action: #selector(buttonCrossTapped(_:)), for: .touchUpInside)
        }
        //setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: HomeSearchTVC.identifier)
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func buttonInviteTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LoungeSendInvitationVC:UITableViewDelegate,UITableViewDataSource{
  
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isSearching{
            return searchedResults.count
        }
        else{
            return recentSearches.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchTVC.identifier,for: indexPath) as! HomeSearchTVC
        var obj:AllUserModel = AllUserModel(data: [:])
        if isSearching{
            obj = searchedResults[indexPath.row]
        }
        else{
            obj = recentSearches[indexPath.row]
        }
        cell.buttonSelection.isHidden = false
        cell.labelUserName.text = obj.full_name.capitalized
        cell.labelProfession.text = obj.employee_type.capitalized.isEmpty ? ("Unknown") : (obj.employee_type.capitalized)
        cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        cell.buttonSelection.isSelected = obj.isSelected
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching{
            //searchedResults.forEach{$0.isSelected = false}
            searchedResults[indexPath.row].isSelected = !searchedResults[indexPath.row].isSelected
        }
        else{
            //recentSearches.forEach{$0.isSelected = false}
            recentSearches[indexPath.row].isSelected = !recentSearches[indexPath.row].isSelected
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

extension LoungeSendInvitationVC:UISearchBarDelegate {
    
    func hideSearch(){
        searchBar.text = ""
        isSearching = false
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            isSearching = false
            self.tableView.reloadData()
        }
        else{
            isSearching = true
            searchedResults = self.recentSearches.filter{String.getString($0.first_name + " " +  $0.last_name).lowercased().prefix(searchText.count) == searchText.lowercased()}
            self.tableView.reloadData()
        }
    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearch()
    }
    
    @objc func buttonCrossTapped(_ sender:Any){
        hideSearch()
    }

}

extension LoungeSendInvitationVC{
    
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
