//
//  AudioRoomAllParticipants.swift
//  HSN
//
//  Created by Prashant Panchal on 19/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class AudioRoomAllParticipants: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var labelPageHeading: UILabel!
    
    var navigationTabsNames = ["All People","Host","Speaker","Listener","Requests","Removed"]
    var selectedTab = 0{
        didSet{
            self.tableView.reloadData()
        }
    }
    var data:RoomModel?
    var host:[RoomUserModel] = []
    var speakers:[RoomUserModel] = []
    var listeners:[RoomUserModel] = []
    var requests:[RoomUserModel] = []
    var removed:[RoomUserModel] = []
    var callbackRemove:((String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeSearchTVC.identifier, bundle: nil), forCellReuseIdentifier: HomeSearchTVC.identifier)
        tableView.tableFooterView = UIView()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateData()
        // Do any additional setup after loading the view.
    }
    
    func updateData(){
        self.host = data?.users.filter{$0.typeHost.lowercased() == "host" && $0.isRemoved == false} ?? []
        self.speakers = data?.users.filter{$0.typeHost.lowercased() == "speaker" && $0.isRemoved == false} ?? []
        self.listeners = data?.users.filter{$0.typeHost.lowercased() == "listener" && $0.isRemoved == false} ?? []
        self.requests = data?.users.filter{$0.typeHost.lowercased() == "request" && $0.isRemoved == false} ?? []
        self.removed = data?.users.filter{$0.isRemoved} ?? []
        self.tableView.reloadData()
    }
    
    
    @IBAction func dissmissViewAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension AudioRoomAllParticipants:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationTabsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewNavigationCVC", for: indexPath) as! ViewNavigationCVC
        cell.labelTabName.text = navigationTabsNames[indexPath.row]
        if indexPath.row == selectedTab{
            cell.viewActive.isHidden = false
            cell.labelTabName.textColor = #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1)
            cell.labelTabName.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        }
        else{
            cell.viewActive.isHidden = true
            cell.labelTabName.textColor = #colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)
            cell.labelTabName.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastIndex = selectedTab
        selectedTab = indexPath.row
//        if lastIndex > selectedTab{
//
//        }
//        else{
//        }
        
        collectionView.reloadData()
    }
}

extension AudioRoomAllParticipants:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedTab == 0 ?  5 :  1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedTab == 0{
            switch section{
            case 0:
                return tableView.createHeaderView(text: "Host", subText: "\(host.isEmpty ? 0 : host.count) Host")
            case 1:
                return tableView.createHeaderView(text: "Speaker", subText: "\(speakers.isEmpty ? 0 : speakers.count) Speaker")
            case 2:
                return tableView.createHeaderView(text: "Listener", subText: "\(listeners.isEmpty ? 0 : listeners.count) Listener")
            case 3:
                return tableView.createHeaderView(text: "Requests", subText: "\(requests.isEmpty ? 0 : requests.count) Requests")
            case 4:
                return tableView.createHeaderView(text: "Removed", subText: "\(removed.isEmpty ? 0 : removed.count) Removed")
            default:return UIView()
            }
        }
        else{
            return UIView()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return selectedTab == 0 ? 30 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0{
            switch section{
            case 0:
                return host.count
            case 1:
                return speakers.count
            case 2:
                return listeners.count
            case 3:
                return requests.count
            case 4:
                return removed.count
            default:return 0
            }
        }
        else{
            switch selectedTab{
            case 1:
                return host.count
            case 2:
                return speakers.count
            case 3:
                return listeners.count
            case 4:
                return requests.count
            case 5:
                return removed.count
            default:return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchTVC.identifier, for: indexPath) as! HomeSearchTVC
        var obj:RoomUserModel = RoomUserModel(data: [:])
        if selectedTab == 0{
            switch indexPath.section{
            case 0:
                obj = host[indexPath.row]
            case 1:
                obj = speakers[indexPath.row]
            case 2:
                obj = listeners[indexPath.row]
            case 3:
                obj = requests[indexPath.row]
            case 4:
                obj = removed[indexPath.row]
            default:break
            }
        }
        else{
            switch selectedTab{
            case 1:
                obj = host[indexPath.row]
            case 2:
                obj = speakers[indexPath.row]
            case 3:
                obj = listeners[indexPath.row]
            case 4:
                obj = requests[indexPath.row]
            case 5:
                obj = removed[indexPath.row]
            default:break
            }
        }
        cell.labelUserName.text = obj.name
        cell.labelProfession.text = "Unknown"
        cell.imageProfile.downlodeImage(serviceurl:kBucketUrl + obj.profile, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                var obj:RoomUserModel = RoomUserModel(data: [:])
                if selectedTab == 0{
                    switch indexPath.section{
                    case 0:
                        obj = host[indexPath.row]
                    case 1:
                        obj = speakers[indexPath.row]
                    case 2:
                        obj = listeners[indexPath.row]
                    case 3:
                        obj = requests[indexPath.row]
                    case 4:
                        obj = removed[indexPath.row]
                    default:break
                    }
                }
                else{
                    switch selectedTab{
                    case 1:
                        obj = host[indexPath.row]
                    case 2:
                        obj = speakers[indexPath.row]
                    case 3:
                        obj = listeners[indexPath.row]
                    case 4:
                        obj = requests[indexPath.row]
                    case 5:
                        obj = removed[indexPath.row]
                    default:break
                    }
                }
                if indexPath.section != 0{
                    let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                        // delete the item here
                       // self.deleteAddressApi(id: self.addresses[indexPath.row].id)
                        print("hello")
                        if UserData.shared.id != obj.userId{
                            if self.selectedTab == 0{
                                switch indexPath.section{
                                case 0:
                                    print("none")
                                case 1:
                                    self.speakers.remove(at:indexPath.row)
                                case 2:
                                    self.listeners.remove(at:indexPath.row)
                                case 3:
                                    self.requests.remove(at:indexPath.row)
                                case 4:
                                    self.removed.remove(at:indexPath.row)
                                default:break
                                }
                            }
                            else{
                                switch self.selectedTab{
                                case 1:
                                    print("none")
                                case 2:
                                    self.speakers.remove(at:indexPath.row)
                                case 3:
                                    self.listeners.remove(at:indexPath.row)
                                case 4:
                                    self.requests.remove(at:indexPath.row)
                                case 5:
                                    self.removed.remove(at:indexPath.row)
                                default:break
                                }
                            }
                            self.tableView.reloadData()
                            self.callbackRemove?(obj.userId)
                            completionHandler(true)
                        }
                        else{
                            CommonUtils.showToast(message: "Cannot delete yourself, kindly please leave this call.")
                            completionHandler(false)
                        }
                       
                        
                    }
                    deleteAction.image = #imageLiteral(resourceName: "delete_white")
                    deleteAction.backgroundColor = .red
                
                    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

                    return configuration
                }
                else{
                    return UISwipeActionsConfiguration()
                }
    }

    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeSearchTVC
       // cell.viewBG.isHidden = false
        let mainView = tableView.subviews.filter{String(describing:Swift.type(of: $0)) == "_UITableViewCellSwipeContainerView"}
        if !mainView.isEmpty{
            let backgroundView = mainView[0].subviews
            if !backgroundView.isEmpty{
                backgroundView[0].frame = CGRect(x: 0, y: 5, width: mainView[0].frame.width, height: mainView[0].frame.height-10)
                backgroundView[0].layoutIfNeeded()
            }
        }
        
        }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let index = indexPath{
            let cell = tableView.cellForRow(at: index) as! HomeSearchTVC
            
            UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
               // cell.viewBG.isHidden = true
                cell.viewBG.layoutIfNeeded()
            })
        }
    }
   
    
    
}
class ViewNavigationCVC: UICollectionViewCell {
    @IBOutlet weak var viewActive: UIView!
    @IBOutlet weak var labelTabName: UILabel!
    
}
