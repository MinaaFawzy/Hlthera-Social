//
//  SelectLougePromotionVC.swift
//  HSN
//
//  Created by Apple on 10/08/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import Firebase
import FittedSheets

class SelectLougePromotionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var observerRef:DatabaseReference?
    var callbackDone:((String)->())?
    
    var MyLoungeList:[RoomModel] = [] {
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self,
                                  action: #selector(refresh(_:)),
                                  for: .valueChanged)
         tableView.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
        setStatusBar()//(color: UIColor(hexString: "F5F7F9"))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: UpcomingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        setupFirebase {}
    }
    
    
    @objc func refresh(_ sender:UIRefreshControl){
         setupFirebase {}
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObservers()
    }

    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSelectTapped(_ sender: Any) {
        if self.MyLoungeList.filter{$0.isSelected}.isEmpty{
            CommonUtils.showToast(message: "Please Select Lounge")
            return
        }
        else{
            
            self.dismiss(animated: true, completion: { [self] in
                let data = self.MyLoungeList.filter{$0.isSelected}
                callbackDone?(data[0].roomId)
            })
        }
    }
    
}

extension SelectLougePromotionVC : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyLoungeList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as! UpcomingTableViewCell
      
        if indexPath.row % 2 == 0 {
            cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "346FC8"), col2: UIColor(hexString: "7289F7"))
        }else if indexPath.row % 3 == 0 {
            cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "3085E3"), col2: UIColor(hexString: "95C6FA"))
        }else{
            cell.viewBackground.setGradientBackgroundNew(col1: UIColor(hexString: "1D416D"), col2: UIColor(hexString: "4275C1"))
        }
        
        let obj = MyLoungeList[indexPath.row]
        
        cell.labelHeading.text = obj.category
       
//        cell.labelType.text = obj.type.capitalized
        cell.labelDiscription.text = obj.description
        cell.labelName.text = obj.name
        cell.labelViewers.text = String.getString(obj.users.count)
        cell.buttonNotification.isSelected = obj.notificationsEnabled
        cell.labelRemainImages.text = ""
        cell.buttonSponsored.isHidden = false
        let count = Int(String.getString(obj.users.count - 1)) ?? 0
        if count > 0 {
            if count <= 3 {
                for i in 0...count {
                    print("ImagePath -- \(String.getString(obj.users[i].profile))")
                    cell.imagesUser[i].downlodeImage(serviceurl: String.getString(obj.users[i].profile) , placeHolder: UIImage(named: "profile_placeholder"))
                }
                if count <= 3{
                    cell.labelRemainImages.text = ""
                }else{
                    cell.labelRemainImages.text = "+\((count - 3))"
                }
            }
            
        }
    
        cell.selectionView.isHidden = obj.isSelected ? false : true
        cell.callbackNotifications = { sender in
            sender.isSelected = !sender.isSelected
            obj.notificationsEnabled = sender.isSelected
        }
        cell.callbackJoin = {
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
            self.navigationController?.present(sheetController, animated: false, completion: nil)
        }
        cell.callbackShare = {
            let textToShare = "Join Hlthera Audio Room!"
            if let myWebsite = NSURL(string: obj.link) {
                let objectsToShare = [textToShare, myWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            }
        }

        cell.callbackSponsored = {
            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: CreatePromotionPostVC.getStoryboardID()) as? CreatePromotionPostVC else { return }
            kSharedAppDelegate?.promotionType = "louge"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if kSharedAppDelegate?.promotionType == "louge" {
            self.MyLoungeList.forEach{
                $0.isSelected = false
            }
            MyLoungeList[indexPath.row].isSelected = true
            self.tableView.reloadData()
        }
    }

}


extension SelectLougePromotionVC {
    
    func setupFirebase(completion:@escaping ()->()){
        self.mainRef = rootRef.child("usertouser")
        self.roomsRef = mainRef?.child("rooms")
        //self.currentRoomRef = roomsRef?.child(roomId)
        roomsRef?.observe(.value) { (snap) in
                    print(snap.value,"SNAP VALUE")
            //&& $0.roomId == self.roomId
            let userID = String.getString(UserData.shared.id)
            let data = kSharedInstance.getDictionary(snap.value).values.map{RoomModel(data: kSharedInstance.getDictionary($0))}.sorted{ $0.createdAt > $1.createdAt }
//            self.UpcomingLounge = data.filter({$0.ongoing == false})
            self.MyLoungeList = data.filter({$0.id == userID})
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func removeObservers(){
        roomsRef?.removeAllObservers()
    }
}
