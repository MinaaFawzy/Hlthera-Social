//
//  AudioRoomParticipantsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 14/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import SRFacebookAnimation

class AudioRoomParticipantsVC: UIViewController {
   // @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTotalPeople: UILabel!
    @IBOutlet weak var btnFilterType: ResizableButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedFilterType = -1
    var isSearching = false
    var reactView:ReactView?
    var roomType = "" {
        didSet{
            self.btnFilterType.setTitle(roomType.capitalized, for: .normal)
            self.btnFilterType.setImage(getRoomTypeImage(type: roomType ?? ""), for: .normal)
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
    var roomTypeImages = [UIImage(named: "anyone_white")!,UIImage(named: "connections_only_white")!,UIImage(named: "no_one_white")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchField = self.searchBar.searchTextField
        searchField.addDoneOnKeyboardWithTarget(self, action: #selector(self.doneAction(_:)), shouldShowPlaceholder: false)
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: LoungeParticipantsCVC.identifier, bundle: nil), forCellWithReuseIdentifier: LoungeParticipantsCVC.identifier)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        collectionView.addGestureRecognizer(longPress)
        self.reactView = getHeaderObj() as! ReactView
       
        
        // Do any additional setup after loading the view.
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
                    
                   
                    view?.updateData(viewPermission: obj.id == UserData.shared.id ? false : true, viewRemove: obj.id == UserData.shared.id ? false : true, data: self.data[indexPath.row], nav: self.navigationController ?? UINavigationController())
                        

                    self.view.addSubview(view ?? UIView())
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
        self.view.subviews.map{
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
        self.view.endEditing(true)
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
    
        self.navigationController?.present(vc, animated: true)
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
extension AudioRoomParticipantsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
        if obj.userId == UserData.shared.id{
            cell.viewContent.backgroundColor = UIColor(hexString: "#1E3F6C")
            cell.labelName.textColor = .white
        }
        else{
            cell.labelName.textColor = UIColor(hexString: "#1E3F6C")
            cell.viewContent.backgroundColor = .white
        }
        cell.labelName.text = obj.name
        cell.labelHost.text = obj.typeHost.capitalized
        cell.imageProfile.setImage(urlString: obj.profile, placeHolderImage: UIImage(named: "profile_placeholder")!, completionBlock: nil)
        cell.btnMic.isSelected = obj.mic

        //self.constraintCollectionViewHeight.constant = self.collectionView.contentSize.height
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3.25, height: 55)
    }

}

extension AudioRoomParticipantsVC:UISearchBarDelegate{
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
