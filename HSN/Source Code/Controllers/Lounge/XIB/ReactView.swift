//
//  ExploreHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 22/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Firebase
import SRFacebookAnimation
class ReactView: UIView {
    
  
     //@IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewReact: UIView!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnPermitToSpeak: UIButton!
    @IBOutlet weak var viewPermission: UIView!
    @IBOutlet weak var viewRemove: UIView!
    
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var observerRef:DatabaseReference?
    var roomId = ""
    var selectedPostType = ""
    var callback:((String)->())?
    var data:RoomUserModel = RoomUserModel(data: [:])
    var callbackReactions:((Bool,Int,Int)->())?
    
    var nav:UINavigationController?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func updateData(viewPermission:Bool,viewRemove:Bool,data:RoomUserModel,nav:UINavigationController){
        self.viewPermission.isHidden = viewPermission
        self.viewRemove.isHidden = viewRemove
        self.data = data
        self.nav = nav
        self.btnPermitToSpeak.isSelected = data.permission
        
        //setupFirebase()
    }
    
    
    @IBAction func buttonViewAllTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: ScheduledLoungesVC.getStoryboardID()) as? ScheduledLoungesVC else { return }
       
        vc.isViewAll = true
        self.nav?.pushViewController(vc, animated: true)
    }
    @IBAction func btnPermissionTapped(_ sender: Any) {
        callbackReactions?(data.permission,data.permission ? 0 : 1,1)
    }
    @IBAction func btnRemoveTapped(_ sender: Any) {
        callbackReactions?(false,0,2)
    }
    @IBAction func btnEmojisTapped(_ sender: UIButton) {
        callbackReactions?(false,sender.tag,0)

    }
    
    
}
