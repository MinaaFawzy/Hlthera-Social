//
//  ManageAdminAccessVC.swift
//  HSN
//
//  Created by Apple on 14/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ManageAdminAccessVC : UIViewController {

    @IBOutlet weak var btnAdmin: UIButton!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewAdmin: UIView!
    @IBOutlet weak var viewInvite : UIView!
    @IBOutlet weak var lblAdmin: UILabel!
    @IBOutlet weak var lblInvite : UILabel!
    @IBOutlet weak var btnConfirm : UIButton!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var adminList = [CandidateDetailsModel]()
    var connections:[InvitationsModel] = []
    var filterConnections:[InvitationsModel] = []
    var isAdmin = true
    var pageId = ""
    var selectedIds : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        let searchField = self.searchBar.searchTextField
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        if let clearButton = searchField.value(forKey: "_clearButton") as? UIButton{
            clearButton.addTarget(self, action: #selector(buttonCrossTapped(_:)), for: .touchUpInside)
        }
        searchBar.becomeFirstResponder()
   
        getAdminList()
        globalApis.getConnections(completion:{
            data in
            self.connections = data
            self.filterConnections = data
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view.
    }
    
    func getAdminList(){
        globalApis.getAdmins(pageId: pageId, completion: { data in
            self.adminList = data
            self.tableView.reloadData()
        })
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    @IBAction func selectOptionAction(_ sender: UIButton) {
        self.setupSelectionView(sender)
    }
    
    @IBAction func dissmissViewAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if selectedIds.count == 0 {
            CommonUtils.showToast(message: "Please select user")
            return
        }
        
        let param = ["company_id" : pageId, "user_id" : selectedIds.joined(separator: ",")] as [String : Any]
        globalApis.addUserAsAdmin(params: param, completion: {
            self.setupSelectionView(self.btnAdmin)
            self.getAdminList()
        })
    }

    
    func setupSelectionView(_ sender : UIButton){
        btnAdmin.isSelected = sender == btnAdmin ? true : false
        btnInvite.isSelected = sender == btnInvite ? true : false
        isAdmin = sender == btnAdmin ? true : false
        
        lblAdmin.textColor = sender == btnInvite ? UIColor(hexString: "8794AA") : UIColor(hexString: "263E68")
        lblInvite.textColor = sender == btnInvite ? UIColor(hexString: "263E68") : UIColor(hexString: "8794AA")
        viewAdmin.isHidden = sender == btnAdmin ? false : true
        viewInvite.isHidden = sender == btnInvite ? false : true
        btnConfirm.isHidden = sender == btnInvite ? false : true
        
        self.tableView.reloadData()
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


extension ManageAdminAccessVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isAdmin ? adminList.count : filterConnections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ManageAdminCell.identifier, for: indexPath) as! ManageAdminCell
        if isAdmin{
            cell.admin = adminList[indexPath.row]
        }else{
            let connection =  filterConnections[indexPath.row]
            cell.obj = connection
            cell.buttonRadio.isSelected = selectedIds.contains(connection.recipient_id) ? true : false
            cell.selectUserCallback = { sender in
                if sender.isSelected {
                    self.selectedIds.append(connection.recipient_id)
                }else {
                    if let index = self.selectedIds.firstIndex(of: connection.recipient_id) {
                        self.selectedIds.remove(at: index)
                    }
                }
                self.tableView.reloadData()
             }
        }
  
        cell.buttonAdmin.isHidden = self.isAdmin ? false : true
        cell.buttonRadio.isHidden = self.isAdmin ? true : false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: CandidateProfileVC.getStoryboardID()) as? CandidateProfileVC else { return }
//        vc.userID = String.getString(self.candidates[indexPath.row].user_id)
//        vc.candidate = self.candidates[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ManageAdminAccessVC : UISearchBarDelegate{
    func hideSearch(){
        self.filterConnections = self.connections
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            let filterByName = connections.filter { (String.getString($0.user?.full_name).lowercased().contains(searchText.lowercased())) }
            filterConnections = filterByName
        }
        else{
            self.filterConnections = connections
        }
        self.tableView.reloadData()
       
    }
   
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if String.getString(searchBar.text) != ""{
            let filterByName = connections.filter { (String.getString($0.user?.full_name).lowercased().contains(String.getString(searchBar.text).lowercased())) }
            filterConnections = filterByName
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
