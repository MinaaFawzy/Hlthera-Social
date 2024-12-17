//
//  SelectGroupVC.swift
//  HSN
//
//  Created by Prashant Panchal on 16/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SelectGroupVC: UIViewController {
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var hasCameFrom:HasCameFrom = .none
    var activeGroups:[GroupListingModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    var callback:((GroupListingModel,Bool)->())?
    var callbackEventMember:((EventMemberModel)->())?
    var callbackGroupMember:((GroupUserModel)->())?
    var eventMembers:[EventMemberModel] = []
    var groupMembers:[GroupUserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
       
        tableView.tableFooterView = UIView()
        switch hasCameFrom{
        case .viewGroup:
            self.labelPageTitle.text = "All Members"
        case .viewEvent:
            self.labelPageTitle.text = "All Members"
        default:
            self.labelPageTitle.text = "Select Group"
            setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
            getData()
        }

        // Do any additional setup after loading the view.
    }
    func getData(){
        switch hasCameFrom{
        case .viewGroup:
            print("nothing")
        case .viewEvent:
            print("nothing")
        default:
            globalApis.getGroupsList(){ all,_ in
                self.activeGroups = all
                self.tableView.refreshControl?.endRefreshing()
                
            }
        }
    }
    func setupTableView(){
        tableView.register(UINib(nibName: GroupListTVC.identifier, bundle: nil), forCellReuseIdentifier: GroupListTVC.identifier)
        tableView.register(UINib(nibName: ConnectionsTVC.identifier, bundle: nil), forCellReuseIdentifier: ConnectionsTVC.identifier)
    }
    @IBAction func buttonCloseTapped(_ sender: Any) {
        switch hasCameFrom{
        case .viewEvent:
            
            self.dismiss(animated: true, completion: nil)
        case .viewGroup:
            
            self.dismiss(animated: true, completion: nil)
        default:
            
            let res = self.activeGroups.filter{$0.isSelected == true}
            if res.isEmpty{
                callback?(GroupListingModel(data: [:]),false)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                callback?(res[0],true)
                self.navigationController?.popViewController(animated: true)
            }
            
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
extension SelectGroupVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch hasCameFrom{
        case .viewEvent:
            return eventMembers.count
        case .viewGroup:
            return groupMembers.count
        default:
            return activeGroups.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch hasCameFrom{
        case .viewGroup:
            let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionsTVC.identifier, for: indexPath) as! ConnectionsTVC
           
            if groupMembers.indices.contains(indexPath.row){
                let obj = groupMembers[indexPath.row]
                cell.labelName.text = String.getString(obj.full_name).capitalized
            cell.labelProfession.isHidden = true
            cell.constraintRemoveConnectionHeight.constant = 0
            cell.buttonMessage.isHidden = true
                cell.imageProfile.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.profile_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.buttonRemove.isHidden = true
                cell.labelConnectionTime.isHidden = true
            }
            
           
            return cell
        case .viewEvent:
            let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionsTVC.identifier, for: indexPath) as! ConnectionsTVC
           
            if eventMembers.indices.contains(indexPath.row){
                let obj = eventMembers[indexPath.row]
                cell.labelName.text = String.getString(obj.full_name).capitalized
            cell.labelProfession.isHidden = true
            cell.constraintRemoveConnectionHeight.constant = 0
            cell.buttonMessage.isHidden = true
                cell.imageProfile.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.profile_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.buttonRemove.isHidden = true
                cell.labelConnectionTime.isHidden = true
            }
            
           
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupListTVC.identifier, for: indexPath) as! GroupListTVC
           
                let obj = activeGroups[indexPath.row]
                cell.labelName.text = String.getString(obj.group?.name).capitalized
                cell.labelTotalMembers.text = "Total Members: " +  String.getString(obj.join_users.count)
                cell.labelTotalCount.text =  String.getString(obj.join_users.count > 5 ? "+" + String.getString(obj.join_users.count - 4) : obj.join_users.count)
                
                cell.imageGroup.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.group?.group_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.stackView.isHidden = true
                cell.viewMembers.isHidden = true
            cell.buttonRadio.isHidden = false
            if obj.isSelected{
                cell.buttonRadio.isSelected = true
            }
            else{
                cell.buttonRadio.isSelected = false
            }
            
           
            return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch hasCameFrom{
        case .viewGroup:
            self.dismiss(animated: true, completion: { [self] in
                callbackGroupMember?(groupMembers[indexPath.row])
            })
        case .viewEvent:
            self.dismiss(animated: true, completion: { [self] in
                callbackEventMember?(eventMembers[indexPath.row])
            })
            
        default:
            activeGroups.map{$0.isSelected = false}
            activeGroups[indexPath.row].isSelected = true
            self.tableView.reloadData()
        }
       
//            globalApis.getGroup(id: activeGroups[indexPath.row].group_id, completion: { data in
//                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ViewGroupVC.getStoryboardID()) as? ViewGroupVC else { return }
//                vc.groupId = self.activeGroups[indexPath.row].group_id
//                vc.data = data
//                if self.activeGroups[indexPath.row].is_admin == "1"{
//                    vc.hasCameFrom = .viewGroup
//                }
//                else{
//                    vc.hasCameFrom = .viewGroupAdmin
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            })
//
        
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
