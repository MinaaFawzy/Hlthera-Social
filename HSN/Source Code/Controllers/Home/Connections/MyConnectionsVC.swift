//
//  MyConnectionsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class MyConnectionsVC: UIViewController {
    
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableVIew: UITableView!
    @IBOutlet weak private var labelConnections: UILabel!
    
    var connections: [InvitationsModel] = [] {
        didSet {
            tableVIew.reloadData()
        }
    }
    var searchedResults: [InvitationsModel] = [] {
        didSet {
            tableVIew.reloadData()
        }
    }
    var selectedSortType = 1
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        //(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        //let searchView = self.searchBar
        //searchView?.layer.cornerRadius = 20
        //searchView?.clipsToBounds = true
        //searchView?.borderWidth = 0
        //searchView?.setSearchIcon(image: #imageLiteral(resourceName: "search_white"))
        //searchView?.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        //searchView?.backgroundImage = UIImage()
        let searchField = self.searchBar.searchTextField
        //searchField.backgroundColor = .white
        //searchField.font = UIFont(name: "Helvetica", size: 13)
        //searchField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        if let clearButton = searchField.value(forKey: "_clearButton") as? UIButton{
            clearButton.addTarget(self, action: #selector(buttonCrossTapped(_:)), for: .touchUpInside)
        }
        searchBar.delegate = self
        tableVIew.register(UINib(nibName: ConnectionsTVC.identifier, bundle: nil), forCellReuseIdentifier: ConnectionsTVC.identifier)
        globalApis.getConnections(sortType: String.getString(self.selectedSortType), searchText: String.getString(searchBar.text)) { [weak self] data in
            guard let self = self else { return }
            self.updateData(data: data)
        }
    }
    
    func updateData(data: [InvitationsModel]) {
        // if !String.getString(self.searchBar.text).isEmpty {
        self.connections = data
        //}
        //else {
        //self.connections = []
        //}
        self.labelConnections.text = data.count <= 1 ? "\(data.count) Connection" : "\(data.count) Connections"
    }
    
    @objc private func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    @IBAction private func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonFilterTapped(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: FilterVC.getStoryboardID()) as? FilterVC else { return }
        //        vc.modalTransitionStyle = .crossDissolve
        //        vc.modalPresentationStyle = .overFullScreen
        //        vc.selectedSort = selectedSort
        //        vc.callback = { type,selectedSort in
        //            self.selectedSort = selectedSort
        //            vc.dismiss(animated: true, completion: {self.sortType = String.getString(type)
        //                        self.getProducts(id: self.id,hasCameFrom: self.hasCameFrom)})
        //
        //        }
        vc.callback = { sort in
            self.selectedSortType = Int.getInt(sort)
            globalApis.getConnections(sortType: sort, searchText: self.searchBar.text ?? ""){ data in
                self.updateData(data: data)
            }
        }
        vc.selectedType = self.selectedSortType
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension MyConnectionsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? (tableView.numberOfRow(numberofRow: searchedResults.count)) : (tableView.numberOfRow(numberofRow: connections.count))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionsTVC.identifier, for: indexPath) as! ConnectionsTVC
        
        var obj = InvitationsModel(data: [:])
        if isSearching{
            obj = searchedResults[indexPath.row]
        }
        else{
            obj = connections[indexPath.row]
        }
        
        cell.updateCell(data: obj)
        cell.sendMessageCallback = {
            guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: ChatViewController.getStoryboardID()) as? ChatViewController else { return }
            vc.receiverid = String.getString(obj.user?.id)
            vc.receivername = String.getString(obj.user?.full_name)
            vc.receiverprofile_image = kBucketUrl+String.getString(obj.user?.profile_pic)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.deleteCallback = {
            globalApis.removeConnection(id: obj.recipient_id){
                self.moveToPopUp(text: "Connection Removed Successfully!", completion: {
                    globalApis.getConnections(completion:{
                        data in
                        self.updateData(data: data)
                    })
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalApis.getProfile(id: String.getString(self.connections[indexPath.row].user?.id), completion: { [weak self] user in
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
            vc.data = user
            vc.id = user.id
            vc.hasCameFrom = .viewProfile
            self?.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MyConnectionsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            globalApis.getConnections(sortType: String.getString(self.selectedSortType), searchText: String.getString(searchText)){ data in
                self.updateData(data: data)
            }
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        globalApis.getConnections(sortType: String.getString(self.selectedSortType), searchText: String.getString(searchBar.text)) { data in
            self.updateData(data: data) }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        self.view.endEditing(true)
        tableVIew.reloadData()
    }
    
    @objc func buttonCrossTapped(_ sender: Any) {
        searchBar.text = ""
    }
    
}
