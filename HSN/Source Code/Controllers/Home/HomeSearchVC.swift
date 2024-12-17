//
//  HomeSearchVC.swift
//  Hlthera
//
//  Created by Prashant Panchal on 17/04/21.
//  Copyright © 2021 Fluper. All rights reserved.
//

import UIKit

class HomeSearchVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var users:[AllUserModel] = []
    var searchResults:[String] = []
    var recentSearches:[AllUserModel] = []
    var callback:((Int,AllUserModel?)->())?
    var hasCameFrom:HasCameFrom = .searchHome
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(hexString: "#F5F7F9")
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#8794AA")])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor(hexString: "#8794AA")
            }
        }
        tableView.register(UINib(nibName: HomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: HomeSearchTVC.identifier)
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        let searchField = self.searchBar.searchTextField
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        if let clearButton = searchField.value(forKey: "_clearButton") as? UIButton{
            clearButton.addTarget(self, action: #selector(buttonCrossTapped(_:)), for: .touchUpInside)
        }
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.recentSearches = kSharedUserDefaults.getSavedSuggestions()
        self.tableView.reloadData()
    }
              
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
        
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }

    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HomeSearchVC:UITableViewDelegate,UITableViewDataSource{
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section{
        case 0:
            return tableView.createHeaderViewBtn(text: "Recent Searches", btnTitle: "Clear", withBackgroundColor: false, color: #colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1),titleColor: #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1),trailing: 0,font: UIFont(name: "SFProDisplay-Bold", size: 16)!, completion: { sender in
                kSharedUserDefaults.updateSavedSuggestions(suggestions: [])
                self.dismiss(animated: true, completion: nil)
                
            })
            
          
        case 1:
            return tableView.createHeaderView(text: "Results",color: UIColor(named: "5")!)
        default: return tableView.createHeaderView(text: "")
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section{
        case 0:
            return recentSearches.isEmpty ? 0 : 30
        case 1:
            return users.isEmpty ? 0 : 30
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return recentSearches.isEmpty ? 0 : recentSearches.count
        case 1:
            return users.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchTVC.identifier,for: indexPath) as! HomeSearchTVC
        if indexPath.section == 0{
            if recentSearches.indices.contains(indexPath.row){
                let obj = recentSearches[indexPath.row]
                if obj.is_company{
                    cell.labelUserName.text = obj.page_name.capitalized
                    cell.labelProfession.text = obj.business_name.capitalized.isEmpty ? ("Unkown") : (obj.business_name.capitalized)
                    cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                }
                else{
                    cell.labelUserName.text = obj.full_name.capitalized
                    cell.labelProfession.text =
                    obj.employee_type.capitalized.isEmpty ? ("Unkown") : (obj.employee_type.capitalized)
                    cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                }
            }
        }
        else{
            if users.indices.contains(indexPath.row){
                let obj = users[indexPath.row]
                if obj.is_company{
                    cell.labelUserName.text = obj.page_name.capitalized
                    cell.labelProfession.text = obj.business_name.capitalized.isEmpty ? ("Unkown") : (obj.business_name.capitalized)
                    cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                }else{
                    cell.labelUserName.text = obj.full_name.capitalized
                    cell.labelProfession.text = obj.employee_type.capitalized.isEmpty ? ("Unkown") : (obj.employee_type.capitalized)
                    cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile_pic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                }
                
            }
        }
          
            
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      
            return users.isEmpty && !String.getString(searchBar.text).isEmpty ? 50 : 00
       
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 15, y: (view.frame.height/2) - 8, width: view.frame.width-15, height: 15))
        view.addSubview(label)
        label.text = "No data found"
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true,completion: {
          
            if indexPath.section == 0{
                self.callback?(0,self.recentSearches[indexPath.row])
            }
            else{
                if self.recentSearches.filter({$0.id == self.users[indexPath.row].id}).isEmpty{
                    self.recentSearches.append(self.users[indexPath.row])
                    kSharedUserDefaults.updateSavedSuggestions(suggestions: self.recentSearches)
                }
                
                self.callback?(0,self.users[indexPath.row])
            }
               
                
          

        })
    }
    
    
}
extension HomeSearchVC:UISearchBarDelegate{
    func hideSearch(){
        self.users = []
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.searchApi(searchText)
            })
        }
        else{
            self.users = []
            self.tableView.reloadData()
        }
       
    }
   
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if String.getString(searchBar.text) != ""{
            searchApi(String.getString(searchBar.text))
        }else{
            hideSearch()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearch()
    }
    @objc func buttonCrossTapped(_ sender:Any){
        hideSearch()
    }

    
}
extension HomeSearchVC{
    func searchApi(_ string:String){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        let params:[String : Any] = [:]
        
        var url = String.getString(ServiceName.homeSearch+"?name="+string).replacingOccurrences(of: " ", with: "+")
        
        
       
        TANetworkManager.sharedInstance.requestApi(withServiceName:url,                                                   requestMethod: .GET,
                                                   requestParameters:params, withProgressHUD: false)
        {[weak self](result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    if !String.getString(self?.searchBar.text).isEmpty{
                        self?.users = kSharedInstance.getArray(dictResult["data"]).map{AllUserModel(data: kSharedInstance.getDictionary($0))}
                    }
                    else{
                        self?.users = []
                        self?.tableView.reloadData()
                    }
                    self?.tableView.reloadData()
                default:
                    CommonUtils.showToast(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                CommonUtils.showToast(message: kNoInternetMsg)
                
            } else {
                CommonUtils.showToast(message: kDefaultErrorMsg)
            }
        }
    }
}

