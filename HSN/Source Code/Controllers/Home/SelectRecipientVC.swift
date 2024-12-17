//
//  SelectRecipientVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//
var ddd = #imageLiteral(resourceName: "calories")
import UIKit

class SelectRecipientVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    var recipients:[RecipientModel] = []
    var users:[AllUserModel] = []
    var originalusers:[AllUserModel] = []
    var hasCameFrom:HasCameFrom = .recipient
    var image:UIImage = UIImage()
    var url:String = ""
    var celebrationId = -1
    var parentVC = UIViewController()
    var recipientsId = ""
    var groupId = ""
    var usersId = ""
    var eventId = ""
    
    var callback:(([AllUserModel])->())?
    var callbackInvitePeople:(([RecipientModel])->())?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchBar.delegate = self
        let searchField = self.searchBar.searchTextField
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        if let clearButton = searchField.value(forKey: "_clearButton") as? UIButton{
            clearButton.addTarget(self, action: #selector(buttonCrossTapped(_:)), for: .touchUpInside)
        }
        searchBar.becomeFirstResponder()
        // Do any additional setup after
        
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.tableView.tableFooterView = UIView()
        switch hasCameFrom{
        case .recipient:
            self.labelPageTitle.text = "Select Recipient"
            getRecipients()
        case .tagPeople:
            self.labelPageTitle.text = "Tag People"
            getRecipients()
        case .invitePeopleEvent,.invitePeopleGroup:
            self.labelPageTitle.text = "Invite People"
            getRecipients()
        case .searchLeader:
            self.labelPageTitle.text = "Add Leader"
        default: break
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        switch hasCameFrom{
        case .recipient:
            
            let data = recipients.filter({$0.isSelected})
            if data.isEmpty && !recipients.isEmpty{
                CommonUtils.showToast(message: "Please Select Recipient")
                return
            }else{
                recipientsId = data.map{$0.recipient_id}.joined(separator: ",")
//                for controller in self.navigationController?.viewControllers ?? []{
//                    if controller.isKind(of: CreatePostVC.self){
//                        if let vc = controller as? CreatePostVC{
//                            vc.selectedMedia(fileUrl:kBucketUrl+url, postType:4,image: UIImage(),id: celebrationId, other: recipientsId )
//                        }
//                        self.navigationController?.popToViewController(controller, animated: false)
//                        //self.navigationController?.popToRootViewController(animated: true)
//                        //self.navigationController?.popToViewController(controller, animated: true)
//
//                    }
//                }
                
                
               let vc = self.storyboard?.instantiateViewController(withIdentifier: CreatePostVC.getStoryboardID()) as! CreatePostVC
              //  vc.selectedMedia(fileUrl:kBucketUrl+url, postType:4,image: image,id: celebrationId, other: recipientsId )
                
                vc.media = [image]
               // ddd = image
               // vc.media = [#imageLiteral(resourceName: "facebook")]
                vc.celebrationId = celebrationId + 1
                vc.celebrationImgUrl = url
                vc.isCelebration = true
                vc.selectedPostType = 4
                
                //vc.bottomSheetDelegate?.refreshBottomSheet(type: 5)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .invitePeopleEvent,.invitePeopleGroup:
            let data = recipients.filter({$0.isSelected})
            if data.isEmpty && !recipients.isEmpty{
                self.navigationController?.popViewController(animated: true)
            }else{
                recipientsId = data.map{$0.recipient_id}.joined(separator: ",")
                callbackInvitePeople?(data)
                self.navigationController?.popViewController(animated: true)
            }
                
               
        case .tagPeople:
            let data = users.filter({$0.isSelected})
          
                
               callback?(data)
                self.navigationController?.popViewController(animated: true)
        case .searchLeader:
            let data = users.filter({$0.isSelected})
          
                
               callback?(data)
                self.navigationController?.popViewController(animated: true)
            
        default: break
        }
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

}
extension SelectRecipientVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch hasCameFrom{
        case .recipient,.invitePeopleEvent,.invitePeopleGroup:
            return tableView.numberOfRow(numberofRow: recipients.count)
        case .tagPeople,.searchLeader:
            return tableView.numberOfRow(numberofRow: users.count)
        default: return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch hasCameFrom{
        case .recipient,.invitePeopleEvent,.invitePeopleGroup:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectRecipientTVC.identifier, for: indexPath) as! SelectRecipientTVC
            
            
            let obj = recipients[indexPath.row]
            if obj.isSelected{
                cell.buttonSelectUnselect.isSelected = true
            }
            else{
                cell.buttonSelectUnselect.isSelected = false
            }
         
            cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String(obj.user?.profile_pic ?? "") , placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            cell.labelName.text = String.getString(obj.user?.full_name)
            cell.labelDesignary.text = String.getString(obj.user?.employee_type).isEmpty ? "Unknown" : String.getString(obj.user?.employee_type)
            return cell
        case .tagPeople:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectRecipientTVC.identifier, for: indexPath) as! SelectRecipientTVC
            
            
            let obj = users[indexPath.row]
            if obj.isSelected{
                cell.buttonSelectUnselect.isSelected = true
            }
            else{
                cell.buttonSelectUnselect.isSelected = false
            }
         
            cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String(obj.profile_pic ?? "") , placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            cell.labelName.text = String.getString(obj.full_name).capitalized
            cell.labelDesignary.text = obj.employee_type.isEmpty ? "Unknown" : String.getString(obj.employee_type)
            return cell
        case .searchLeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectRecipientTVC.identifier, for: indexPath) as! SelectRecipientTVC
            
            
            let obj = users[indexPath.row]
            cell.buttonSelectUnselect.isHidden = true
            cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String(obj.profile_pic ?? "") , placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            cell.labelName.text = String.getString(obj.full_name).capitalized
            cell.labelDesignary.text = obj.employee_type.isEmpty ? "Unknown" : String.getString(obj.employee_type)
            return cell
        default: return UITableViewCell()
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch hasCameFrom{
        case .recipient,.invitePeopleEvent,.invitePeopleGroup:
            self.recipients[indexPath.row].isSelected = !self.recipients[indexPath.row].isSelected
            
            self.tableView.reloadData()
        case .tagPeople:
            self.users[indexPath.row].isSelected = !self.users[indexPath.row].isSelected
            self.tableView.reloadData()
        case .searchLeader:
            callback?([self.users[indexPath.row]])
            self.navigationController?.popViewController(animated: true)
        default: break
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
class SelectRecipientTVC:UITableViewCell{
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDesignary: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonSelectUnselect: UIButton!
    @IBOutlet weak var labelTime: UILabel!
    @IBAction func buttonSelectUnselectTapped(_ sender: Any) {
    }
    
}
extension SelectRecipientVC{
    func getRecipients(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        var url = ""
        switch hasCameFrom{
        case .recipient:
            url = ServiceName.my_connecation
        case .tagPeople:
            url = ServiceName.all_users
            
        case .invitePeopleGroup:
            url = ServiceName.my_connecation + "?event_id=\(groupId)&type=2"
        
            
        case .invitePeopleEvent:
        url = ServiceName.my_connecation + "?event_id=\(eventId)&type=1"
        default:break
        }
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                   
                    switch self.hasCameFrom{
                    case .recipient:
                        let data =  kSharedInstance.getArray(dictResult["my_connecation"])
                        
                        self.recipients = data.map{RecipientModel(data: (kSharedInstance.getDictionary($0)))}
                        
                    case .invitePeopleEvent,.invitePeopleGroup:
                    let data =  kSharedInstance.getDictionary(dictResult["my_connecation"])
                    let arr = kSharedInstance.getArray(data["data"])
                    self.recipients = arr.map{RecipientModel(data: (kSharedInstance.getDictionary($0)))}
                    case .tagPeople:
                        let data =  kSharedInstance.getArray(dictResult["all_users"])
                        
                        self.users = data.map{AllUserModel(data: (kSharedInstance.getDictionary($0)))}
                        self.originalusers = self.users
                    default:break
                    }
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


extension SelectRecipientVC : UISearchBarDelegate{
    func hideSearch(){
        self.users = originalusers
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            let filterByName = originalusers.filter { (String.getString($0.full_name).lowercased().contains(searchText.lowercased())) }
            users = filterByName
        }
        else{
            self.users = originalusers
        }
        self.tableView.reloadData()
       
    }
   
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if String.getString(searchBar.text) != ""{
            let filterByName = originalusers.filter { (String.getString($0.full_name).lowercased().contains(String.getString(searchBar.text).lowercased())) }
            users = filterByName
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
