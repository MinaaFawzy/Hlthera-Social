//
//  RoomParticipantsView.swift
//  HSN
//
//  Created by Apple on 21/07/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class RoomParticipantsView: UIView {
    
    // @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTotalPeople: UILabel!
    @IBOutlet weak var btnFilterType: ResizableButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var anonymousState: Bool = false
    var selectedFilterType = -1
    var isSearching = false
    var reactView:ReactView?
    var roomType = "" {
        didSet{
            self.btnFilterType.setTitle(roomType.capitalized, for: .normal)
            self.btnFilterType.setImage(getRoomTypeImage(type: roomType ), for: .normal)
            self.btnFilterType.tintColor = UIColor(hexString: "#001428")
        }
    }
    var searchedResults:[RoomUserModel] = []
    var data:[RoomUserModel] = []{
        didSet{
            print("dataasdasdas")
            self.labelTotalPeople.text = String.getString( data.count
            ) + " people"
            
            self.collectionView.reloadData()
        }
    }
    var updateCallback:((Bool,Int,Int,RoomUserModel?)->())?
    var filterCallback:((Int)->())?
    var obj:RoomModel = RoomModel(data: [:])
    var roomTypeImages = [UIImage(named: "anyone_selected")!,UIImage(named: "connections_only_selected")!,UIImage(named: "no_one_selected")!]
    
    override func awakeFromNib() {
        let searchField = self.searchBar.searchTextField
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: LoungeParticipantsCVC.identifier, bundle: nil), forCellWithReuseIdentifier: LoungeParticipantsCVC.identifier)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        collectionView.addGestureRecognizer(longPress)
        self.reactView = getHeaderObj() as! ReactView
    }
    
    func getRoomTypeImage(type:String,index:Int = -1)->(UIImage){
        switch type{
        case "public" :
            return roomTypeImages[0]
        case "connections","connection" :
            return roomTypeImages[1]
        case "private" :
            return roomTypeImages[2]
        default:return UIImage()
        }
    }
    func getRoomTypeIndex(type:String)->(Int){
        switch type{
        case "public" :
            return 0
        case "connections","connection" :
            return 1
        case "private" :
            return 2
        default:return 0
        }
    }
    func getRoomTypeNames(index:Int = -1)->(String){
        switch index{
        case  0:
            return "public"
        case 1:
            return "connections"
        case 2:
            return "private"
        default:return ""
        }
    }
    
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            dismissReactView()
            let touchPoint = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                let view = reactView
                if let cell = collectionView.cellForItem(at: indexPath),let frame = collectionView.cellForItem(at: indexPath)?.frame{
                    view?.tag = 097
                    view?.callbackReactions = { status,index,type in
                        self.dismissReactView()
                        if type == 0{
                            self.updateCallback?(false,index,type,nil)
                        }else if type == 1{
                            self.updateCallback?(status,indexPath.row,type,self.data[indexPath.row])
                        }
                        else{
                            self.updateCallback?(false,indexPath.row,type,self.data[indexPath.row])
                        }
                    }
                    
                    
                    view?.updateData(viewPermission: obj.id == UserData.shared.id ? false : true, viewRemove: obj.id == UserData.shared.id ? false : true, data: self.data[indexPath.row], nav: UIApplication.topViewController()?.navigationController ?? UINavigationController())
                    
                    
                    
                    
                    self.addSubview(view ?? UIView())
                    view?.translatesAutoresizingMaskIntoConstraints = false
                    
                    let leading = view?.leadingAnchor.constraint(equalTo: cell.leadingAnchor) ?? NSLayoutConstraint()
                    let trailing = view?.trailingAnchor.constraint(equalTo: cell.trailingAnchor) ?? NSLayoutConstraint()
                    
                    let top =                             view?.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0) ?? NSLayoutConstraint()
                    NSLayoutConstraint.activate([leading,trailing,top])
                }
                
                
                
                print(touchPoint)
            }
        }
    }
    func dismissReactView(){
        self.subviews.map{
            if $0.tag == 097{
                $0.removeFromSuperview()
            }
        }
        //   self.reactView?.isHidden = true
    }
    func getHeaderObj()->ReactView{
        return UINib(nibName: "ReactView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ReactView
    }
    @objc func doneAction(_ sender : UITextField!) {
        self.endEditing(true)
    }
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectPostVisiblityPopUpVC.getStoryboardID()) as? SelectPostVisiblityPopUpVC else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.hasCameFrom = .lounge
        vc.selected = getRoomTypeIndex(type: self.roomType)
        vc.callback = { index,name,image in
            self.btnFilterType.setTitle(self.getRoomTypeNames(index: index).capitalized, for: .normal)
            self.btnFilterType.setImage(image, for: .normal)
            self.selectedFilterType = index
            self.filterCallback?(index)
            
        }
        
        UIApplication.topViewController()?.navigationController?.present(vc, animated: true)
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
extension RoomParticipantsView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? searchedResults.count : data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoungeParticipantsCVC.identifier, for: indexPath) as! LoungeParticipantsCVC
        var obj = RoomUserModel(data: [:])
        if isSearching{
            obj = searchedResults[indexPath.row]
        }
        else{
            obj = data[indexPath.row]
        }
        if obj.typeHost == "host"{
            cell.viewContent.backgroundColor = UIColor(hexString: "#385B8A")
            cell.labelName.textColor = .white
        }
        else{
            cell.labelName.textColor = UIColor(hexString: "#1E3F6C")
            cell.viewContent.backgroundColor = .white
        }
        if anonymousState {
            cell.labelName.text = String.getString(Int.random(in: 1...100))
            cell.imageProfile.image = UIImage(named: "your_lounges")
        } else {
            cell.labelName.text = obj.name
            cell.imageProfile.setImage(urlString: obj.profile, placeHolderImage: UIImage(named: "profile_placeholder")!, completionBlock: nil)
        }
        
        cell.labelHost.text = obj.typeHost.capitalized
        cell.btnMic.isSelected = obj.mic
        //self.constraintCollectionViewHeight.constant = self.collectionView.contentSize.height
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3.25, height: 55)
    }
    
}

extension RoomParticipantsView:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            isSearching = false
            self.collectionView.reloadData()
        }
        else{
            isSearching = true
            searchedResults = self.data.filter{$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()}
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        self.collectionView.reloadData()
    }
    @objc func buttonCrossTapped(_ sender:Any){
        searchBar.text = ""
        isSearching = false
        self.collectionView.reloadData()
    }
}
