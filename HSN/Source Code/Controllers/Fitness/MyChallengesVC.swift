//
//  MyChallengesVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 5/12/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class MyChallengesVC: UIViewController, UITextFieldDelegate {
    
    
    var idAccepted:Int = 0
    var SearchName:String? = ""
    @IBOutlet weak var viewMyChallenge: UIView!
    
    
    @IBOutlet weak var textFieldName: UITextField!
    
    
    @IBOutlet weak var viewSearchwithTextField: UIView!
    
    
    
    @IBOutlet weak var tableViewChallenge: UITableView!
    
    
    @IBOutlet weak var searchViewheightConstant: NSLayoutConstraint!
    var myFitness = [AllChallenges]()
    
    var MyFitness:[AllChallenges] = [] {
        didSet{
            tableViewChallenge.reloadData()
        }
    }
    
    override func viewDidLoad() {
        getMyChallenges(type: 1)
        DispatchQueue.main.async {
            self.viewMyChallenge.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
            
        }
        
        super.viewDidLoad()
        textFieldName.delegate = self
        self.tableViewChallenge.dataSource = self
        self.tableViewChallenge.dataSource = self
        
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let searchText  = textFieldName.text! + string
        //add matching text to array
        
        //  apiForSearchRequest(searchKey: String.getString(searchText))
        SearchApi(NameSearch:  String.getString(searchText))
        return true
    }
    
    
    @IBAction func buttonSearchActio(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            searchViewheightConstant.constant = 35
        }
        else{
            searchViewheightConstant.constant = 0
        }
    }
    
    
    
    @IBAction func searchTextField(_ sender: UITextField) {
        //  self.SearchApi(Name: )
        if sender.text?.count == 0 {
            let objName = self.myFitness.first?.name
            //self.AcceptedApi(id: objId)
            
            //self.SearchApi(Name: "")
            // self.MyFitness = self.myFitness
        }else{
            MyFitness = myFitness.filter({ (text) -> Bool in
                let tmp:NSString = text.category as? NSString ?? ""
                let range = tmp.range(of: sender.text!, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
        }
        tableViewChallenge.reloadData()
        
    }
    
    @IBAction func buttonBackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - API Integration For Delete Challenge
    func deleteChallengeApi(challengeId:Int) {
        CommonUtils.showHudWithNoInteraction(show: true)
        let param :[String:Any] = [
            ApiParameters.challenges_id:challengeId]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.deletechalenges,
                                                   requestMethod: .POST,
                                                   requestParameters: param, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    self.getMyChallenges(type: 1)
                    
                    
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
    func getMyChallenges(type:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        let url = ServiceName.MyChallenges
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    let array = kSharedInstance.getArray(withDictionary: data["data"])
                    self.myFitness = array.map({AllChallenges(data: $0)})
                    self.tableViewChallenge.reloadData()
                    //   let data = //kSharedInstance.getArray(dictResult["data"]).map{AllChallenges(data:kSharedInstance.getDictionary($0)) }
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
    
    func SearchApi(NameSearch:String?){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [
            ApiParameters.kSearchName:NameSearch ]
        
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.Search,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?)  in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    
                    // let data = kSharedInstance.getDictionary(dictResult["data"])
                    // let array = kSharedInstance.getArray(withDictionary: data["data"])
                    let arraydata = kSharedInstance.getDictionaryArray(withDictionary: dictResult["data"])
                    // lat hfgfhg = kSharedInstance.getDictionaryArray(withDictionary: <#T##Any?#>)
                    print("------->",arraydata)
                    self.myFitness = arraydata.map({AllChallenges(data: $0)})
                    self.tableViewChallenge.reloadData()
                    
                    
                    
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
    func AcceptedApi(id:Int) {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [
            ApiParameters.kChallengesId:idAccepted,
            // ApiParameters.kChallengesId:allFitness.first?.id
        ]
        
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.AcceptedChallenges,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?)  in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    break
                    //                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    //                    kSharedUserDefaults.setLoggedInAccessToken(loggedInAccessToken: String.getString(data[kAccessToken]))
                    //                    kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: data)
                    //UserData.shared.saveData(data: data)
                    
                    
                    
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

extension MyChallengesVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFitness.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:MyChallengeTVC .identifier, for: indexPath) as! MyChallengeTVC
        let obj = myFitness[indexPath.row]
        cell.labelGoal.text = obj.goals
        cell.labelDate.text = obj.start_date
        cell.labelStartTime.text = obj.start_time
        cell.labelEndTime.text = obj.end_time
        cell.labelChallengeName.text = obj.name
        cell.NameSearch = obj.name
        self.SearchName = cell.NameSearch
        cell.labelDescription.text = obj.description
        cell.id = obj.id
        self.idAccepted = cell.id ?? 0
        cell.imageMyChallenge.downlodeImage(serviceurl: String.getString(kBucketUrl+obj.images), placeHolder: nil )
        cell.callBack = {
            
            // self.AcceptedApi()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: Storyboards.kFitness, bundle: nil).instantiateViewController(withIdentifier: AboutChallengeDetails.getStoryboardID()) as? AboutChallengeDetails else { return }
        let objId = self.myFitness[indexPath.row].id
        self.AcceptedApi(id: objId)
        vc.AcceptedId = objId
        //            vc.allFitness = self.myFitness
        //           vc.AcceptedId = self.idAccepted
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let delete =  UIContextualAction(style: .normal, title: "") { (action, View, complition) in
            self.deleteChallengeApi(challengeId: self.myFitness[indexPath.row].id )
        }
        delete.image = UIImage.init(named: "bin")
        delete.backgroundColor = .red
        //         let configuration = UISwipeActionsConfiguration(actions: [delete])
        //                   configuration.performsFirstActionWithFullSwipe = true
        //                   return configuration
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}



