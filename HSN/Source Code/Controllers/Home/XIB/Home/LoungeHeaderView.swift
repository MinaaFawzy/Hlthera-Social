//
//  ExploreHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 22/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets
class LoungeHeaderView: UIView {
    
    @IBOutlet weak var collectionViewLounge: UICollectionView!
     //@IBOutlet weak var viewNavigation: UIView!
    
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var observerRef:DatabaseReference?
    var roomId = ""
    var selectedPostType = ""
    var ViewAllBtnCallBack:(()->())?
    var joinBtnCallBack:((RoomModel)->())?
    var allLounges:[RoomModel] = []
    var activeLounges:[RoomModel] = [] {
        didSet{
            collectionViewLounge.reloadData()
        }
    }
    var nav:UINavigationController?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func updateData(data:[ExploreOptionsModel],nav:UINavigationController){
        
        self.collectionViewLounge.delegate = self
        self.collectionViewLounge.dataSource = self
      
        self.collectionViewLounge.register(UINib(nibName: LoungeHomeCVC.identifier, bundle: nil), forCellWithReuseIdentifier: LoungeHomeCVC.identifier)
        self.collectionViewLounge.reloadData()
        self.nav = nav
        setupFirebase()
    }
    func setupFirebase(){
        self.mainRef = rootRef.child("usertouser")
        self.roomsRef = mainRef?.child("rooms")
        //self.currentRoomRef = roomsRef?.child(roomId)
        roomsRef?.observe(.value) { (snap) in
                  //  print(snap.value,"SNAP VALUE")
           
//            kSharedInstance.getDictionary(snap.value).values.map{RoomModel(data: kSharedInstance.getDictionary($0))}.filter{$0.ongoing}.sorted{ $0.createdAt > $1.createdAt }
            globalApis.getHomeLoungeRooms(completion:{data in
                let rooms = data.filter{$0.ongoing}.sorted{ $0.createdAt > $1.createdAt }
                if rooms.count > 10{
                    var temp:[RoomModel] = []
                    for (i,room) in rooms.enumerated(){
                        if i < 10{
                            
                            temp.append(room)
                        }
                    }
                    self.activeLounges = temp
                }
                else{
                    
                    self.activeLounges = rooms
                }
                
            })
                }
    }
    func removeObservers(){
        self.roomsRef?.removeAllObservers()
    }
    @IBAction func buttonViewAllTapped(_ sender: Any) {
        ViewAllBtnCallBack?()
    }
    
}
extension LoungeHeaderView:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activeLounges.count
       
     
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoungeHomeCVC.identifier, for: indexPath) as! LoungeHomeCVC
        let obj = activeLounges[indexPath.row]
      
            cell.buttonNotification.isSelected = obj.notificationsEnabled
      
        cell.callbackNotification = { sender in
         
            sender.isSelected = !sender.isSelected
            obj.notificationsEnabled = sender.isSelected
         
        }
        cell.imageBackground.removeBlur()
        cell.labelName.text = obj.category
        cell.labelTotalPeople.text = String.getString(obj.users.count)
        cell.imageProfile.downlodeImage(serviceurl: obj.profile, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        cell.imageBackground.addBlur()

        cell.imageBackground.kf.setImage(with: URL(string: String.getString(obj.profile)),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: {_ in
           
                cell.imageBackground.addBlur()
                //image = cell.imageBackground.image?.blur(10)
           
            
        })
        cell.buttonInvite.setTitle(obj.id == UserData.shared.id ? "Invite" : "Join", for: .normal)
        
        cell.callback = {
            self.joinBtnCallBack?(obj)
        }
        return cell
   
    
    }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let obj = activeLounges[indexPath.row]
            let storyBoard = UIStoryboard(name: Storyboards.kLounge, bundle: nil)
            let optionsSheetVC = storyBoard.instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
            if let vc = optionsSheetVC as? AudioRoomVC{
                vc.roomId = obj.roomId
                vc.anonymousState = obj.anonymousState
            }
            let options = SheetOptions(
                pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
            )

           let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.marginFromTop(100)], options: options)
            sheetController.allowGestureThroughOverlay = false
            sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
            sheetController.minimumSpaceAbovePullBar = 0
            sheetController.treatPullBarAsClear = false
            sheetController.autoAdjustToKeyboard = false
            sheetController.dismissOnOverlayTap = true
            

            // Disable the ability to pull down to dismiss the modal
            sheetController.dismissOnPull = true
           // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())
            self.nav?.present(sheetController, animated: false, completion: nil)
        }
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 120, height: collectionView.frame.height)
        }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
    
    
}
extension UIView{
    func addBlur(_ alpha: CGFloat = 0.45) {
         // create effect
         let effect = UIBlurEffect(style: .dark)
         let effectView = UIVisualEffectView(effect: effect)

         // set boundry and alpha
         effectView.frame = self.bounds
         effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         effectView.alpha = alpha
        effectView.tag = 097
         self.addSubview(effectView)
     }
    func removeBlur(_ alpha: CGFloat = 0.25) {
         // create effect
        self.subviews.forEach{
            if $0.tag == 097{
                $0.removeFromSuperview()
            }
        }
     }
}
