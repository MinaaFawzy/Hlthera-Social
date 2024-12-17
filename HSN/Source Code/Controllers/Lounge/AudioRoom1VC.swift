//
//  AudioRoom1VC.swift
//  HSN
//
//  Created by Ankur on 08/07/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import FittedSheets
import AgoraRtcKit
import Firebase
import FirebaseDatabase
import SRFacebookAnimation

class AudioRoom1VC: UIViewController {
    
    @IBOutlet weak var labelRoomName: UILabel!
    @IBOutlet weak var labelRoomDescription: UILabel!
    @IBOutlet weak var viewMic: UIView!
    @IBOutlet weak var labelRoomType: UILabel!
    @IBOutlet weak var switchAnyoneCanSpeak: UISwitch!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var btnEndCall: UIButton!
    @IBOutlet weak var labelMicStatus: UILabel!
    @IBOutlet weak var viewJoin: UIView!
    @IBOutlet weak var viewMainOptions: UIView!
    @IBOutlet var btnsJoinType: [UIButton]!
    @IBOutlet weak var btnSpeaker: UIButton!
    @IBOutlet weak var btnManageMember: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    // @IBOutlet weak var muteAudioButton: UIButton!
    // @IBOutlet weak var speakerButton: UIButton!
    var currentUserObj:RoomUserModel? {
        didSet{
            if let obj = currentUserObj{
                if obj.isRemoved && agoraKit != nil{
                    CommonUtils.showToast(message: "You have been removed from this call")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.leaveChannel()
                    })
                }
                if agoraKit != nil{
                    
                    if obj.permission{
                        
                    }else{
                        audioMuted = true
                    }
                    
                }
                
                
            }
        }
    }
    var roomName: String!
    var isCreatedBySelf = false
    var firstTime = true
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var currentUserRef:DatabaseReference?
    var roomId = ""
    var participantsVC:AudioRoomParticipants1VC?
    var sheetController:SheetViewController?
    var obj:RoomModel? {
        didSet{
            self.updateData()
        }
    }
    
    
    // create a reference for the Agora RTC engine
    fileprivate var agoraKit: AgoraRtcEngineKit!
    fileprivate var logs = [String]()
    
    // create a property for the Audio Muted state
    fileprivate var audioMuted = false {
        didSet {
            self.currentUserRef = currentRoomRef?.child("users").child(UserData.shared.id)
            // update the audio button graphic whenever the audioMuted (bool) changes
            btnMic.isSelected = !audioMuted
            labelMicStatus.text = audioMuted ? "Mic is off" : "Mic is on"
            // use the audioMuted (bool) to mute/unmute the local audio stream
            agoraKit.muteLocalAudioStream(audioMuted)
            self.currentUserRef?.updateChildValues(["mic":!audioMuted])
        }
    }
   //  create a property for the Speaker Mode state
        fileprivate var speakerEnabled = true {
            didSet {
                btnSpeaker.isSelected = !speakerEnabled
                agoraKit.setEnableSpeakerphone(speakerEnabled)
                print("###",agoraKit.isSpeakerphoneEnabled())
                
                // update the speaker button graphics whenever the speakerEnabled (bool) changes
                
                // use the speakerEnabled (bool) to enable/disable speakerPhone

            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: LoungeUserRequestTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeUserRequestTVC.identifier)
        self.viewJoin.isHidden = true
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupBottomSheet()
        self.view.bringSubviewToFront(tableView)
        setupAgora()
        DispatchQueue.main.async {
            self.viewMainOptions.setGradientLoungeOptionsBackground()
        }
        switchAnyoneCanSpeak.transform = CGAffineTransform(scaleX: 0.70, y: 0.65)
        // Do any additional setup after loading the view.
    }
    
    func updateData(){
        if let res = obj{
            self.labelRoomName.text = res.category.isEmpty ? "Lounge" : res.category
            self.labelRoomDescription.text = res.description.isEmpty ? "Description unavailable" : res.description
            self.labelRoomType.text = res.type.isEmpty ? "Type not found" : res.type.capitalized
            self.participantsVC?.data = res.users.filter{!$0.isRemoved}
            self.participantsVC?.obj = obj ?? RoomModel(data: [:])
            self.participantsVC?.roomType = self.obj?.type ?? ""
            if res.id == UserData.shared.id{
                btnManageMember.isHidden = false
            }
            else{
                btnManageMember.isHidden = true
            }
            if !res.reacts.isEmpty{
                res.reacts.forEach{animteEmojis(index: Int.getInt($0.type))}
            }
            if !res.requestUsers.isEmpty && res.id == UserData.shared.id{
              //  self.view.bringSubviewToFront(tableView)
                tableView.isHidden = false
                self.tableView.reloadData()
            }
            else{
                //self.view.sendSubviewToBack(tableView)
                tableView.isHidden = true
            }
//            if res.users.isEmpty && res.ongoing == true && res.id != UserData.shared.id && viewJoin.isHidden || res.users.isEmpty && res.ongoing == false && res.schedule && res.id != UserData.shared.id && viewJoin.isHidden{
//                CommonUtils.showAlert(title: "No members found", message: "Do you want to leave the call? ", firstTitle: "Yes", secondTitle: "No, I am waiting for someone.",isSecondCancel: true, completion:{str in
//                    self.leaveChannel()
//                } )
//            }
            if res.users.isEmpty && res.ongoing == false && !res.schedule && viewJoin.isHidden{
                CommonUtils.showToast(message: "The Call has been ended by admin")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.leaveChannel()
                })
                
            }
            
            tableView.reloadData()
            
        }
    }
    func animteEmojis(index:Int){
        SRFacebookAnimation.startPoint(CGPoint(x: 0, y: self.view.frame.height/2))
        SRFacebookAnimation.animate(image: self.getEmojiImage(index: index))
        SRFacebookAnimation.animationDirection(.leftToRight)
        
    }
    func getEmojiImage(index:Int)->UIImage{
        switch index{
        case 1:
            return UIImage(named: "clapping")!
        case 2:
            return UIImage(named: "cool")!
        case 3:
            return UIImage(named: "victory")!
        case 4:
            return UIImage(named: "smiling_with_hearts")!
               
        case 5:
            return UIImage(named: "party")!
        default:
            return UIImage(named: "victory")!
            
        }

    }
    func setupFirebase(completion:@escaping ()->()){
        let lastId = obj?.roomId
        mainRef = rootRef.child("usertouser")
        self.roomsRef = mainRef?.child("rooms")
        self.currentRoomRef = roomsRef?.child(roomId)
        self.currentUserRef = currentRoomRef?.child("users").child(UserData.shared.id)
        currentUserRef?.observe(.value) { (snap) in
            print(snap.value,"SNAP VALUE")
            if kSharedInstance.getDictionary(snap.value).isEmpty{
                self.currentUserObj = RoomUserModel(data: kSharedInstance.getDictionary(snap.value))
            }
            else{
                self.currentUserObj = nil
            }
            
        }
        currentRoomRef?.observe(.value) { (snap) in
            print(snap.value,"SNAP VALUE")
            
            self.obj = RoomModel(data: kSharedInstance.getDictionary(snap.value))
            
            if self.agoraKit == nil && self.firstTime {
                self.firstTime = false
                completion()
            }
            
            
            
            
            //                    if let dict = snap.value as? [String : Any]{
            //                        for (_,value) in dict{
            //                            print(value)
            //                          //  self.drivers.append(RoomModel(data: kSharedInstance.getDictionary(value)))
            //                        }
            //
            //                        //                self.initialSetup()
            //                    }else{
            //                        print("No Drivers Nearby")
            //                    }
        }
    }
    func setupAgora(){
        setupFirebase(){ [self] in
            if obj?.id == UserData.shared.id{
                isCreatedBySelf = true
                self.viewJoin.isHidden = true
                self.viewMic.isHidden = false
                
                joinFirebaseRoom {
                    KeyCenter.roomId = obj?.roomId ?? ""
                    self.loadAgoraKit()
                }
                
            }
            else{
             
                
                isCreatedBySelf = false
                self.sheetController?.setSizes([.percent(0.75)])
                self.viewJoin.isHidden = false
                self.viewMic.isHidden = true
                
            }
            
            
            
        }
    }
    
    func showOptionsBottomSheet(height:Int = 475,percent:Float = 0.45){
        
        let optionsSheetVC = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OptionsSheetVC.getStoryboardID()) as! OptionsSheetVC
        if let vc = optionsSheetVC as? OptionsSheetVC{
            vc.hasCameFrom = .lounge
            vc.parentVC = self
            vc.loungeData = obj
            //vc.userHomeFeedData = self.data
            // vc.data = self.groupData
        }
        let options = SheetOptions(
            pullBarHeight: 40, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
        )
        let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.intrinsic], options: options)
        sheetController.allowGestureThroughOverlay = false
        sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = false
        sheetController.autoAdjustToKeyboard = false
        sheetController.dismissOnOverlayTap = true
        
        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = true
        // sheetController?.animateIn(to: self.parent?.view ?? UIView(), in: parent ?? UIViewController())
        self.present(sheetController, animated: false, completion: nil)
    }
    
    func setupBottomSheet(height:Int = 475,percent:Float = 0.15){
        
        let bottomSheetVC = self.storyboard?.instantiateViewController(withIdentifier: AudioRoomParticipants1VC.getStoryboardID()) as! AudioRoomParticipants1VC
        if let vc = bottomSheetVC as? AudioRoomParticipants1VC{
            self.participantsVC = vc
            
            
            self.participantsVC?.filterCallback = { index in
                
                switch index{
                case 0:
                    self.currentRoomRef?.updateChildValues(["type":"public"])
                case 1:
                    self.currentRoomRef?.updateChildValues(["type":"connections"])
                case 2:
                    self.currentRoomRef?.updateChildValues(["type":"private"])
                default:break
                }
            }
            self.participantsVC?.updateCallback = { status,index,type,data in
                if type == 0{
                    let subNode = self.currentRoomRef?.child("react").childByAutoId() ?? DatabaseReference()
                    let id = subNode.key ?? ""
                    subNode.updateChildValues(["emoji":index+1,
                                               "name":UserData.shared.full_name,
                                               "userId":UserData.shared.id],withCompletionBlock: { a,b in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                            self.currentRoomRef?.child("react").child(id).removeValue()
                        }
                        
                    })
                }
                else if type == 1{
                    if let obj = data{
                        if obj.userId != UserData.shared.id{
                            if !status{
                                self.currentRoomRef?.child("users").child(obj.userId).updateChildValues([
                                    "permission":1,
                                ])
                            }
                            else{
                                self.currentRoomRef?.child("users").child(obj.userId).updateChildValues([
                                    "permission":0,
                                ])
                            }
                            
                        }
                    }
                }else{
                    if let obj = data{
                        if obj.userId != UserData.shared.id{
                            self.currentRoomRef?.child("users").child(obj.userId).updateChildValues(["removed":1])
                            
                        }
                    }
                }
                // self.animteEmojis(index: index)
            }
            
        }
        let options = SheetOptions(
            pullBarHeight: 30, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: false, useInlineMode: true
        )
        let sheetController = SheetViewController(controller: bottomSheetVC, sizes: [.fixed(190),.percent(0.85)], options: options)
        self.sheetController = sheetController
        sheetController.allowGestureThroughOverlay = true
        sheetController.overlayColor = .clear
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.treatPullBarAsClear = false
        sheetController.autoAdjustToKeyboard = true
        sheetController.dismissOnOverlayTap = false
        
        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = false
        sheetController.animateIn(to: self.view, in: self)
        self.view.bringSubviewToFront(viewMainOptions)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func doMuteAudioPressed(_ sender: UIButton) {
        if let res = currentUserObj{
            
            if res.typeHost == "host"{
                audioMuted = !audioMuted
            }
            else {
                if res.permission{
                    //                 let temp = !audioMuted
                    //                 self.currentRoomRef?.child("users").child(res.userId).updateChildValues([
                    //                                                                                                  "mic":temp,
                    //                                                                                                  ])
                    audioMuted = !audioMuted
                }
                else{
                    CommonUtils.showAlert(title: "Insufficient Permissions", message: "You need to request for mic permission to speak", firstTitle: "Send Request to admin", secondTitle: "Cancel",isSecondCancel: true, completion: {buttonTitle in
                        self.currentRoomRef?.child("request_users").child(res.userId).updateChildValues(["id":res.userId,
                                                                                                         "name":res.name,
                                                                                                         "permission":0,
                                                                                                         "profile":res.profile])
                        
                    })
                }
            }
        }
        
    }
    
    @IBAction func doSpeakerPressed(_ sender: UIButton) {
        //
    }
    
    @IBAction func doClosePressed(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: LoungeAlertVC.getStoryboardID()) as! LoungeAlertVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        if !isCreatedBySelf{
            vc.msgString = "The audio call will end for you"
        }
        vc.yesCallback = {
            self.leaveChannel()
        }
        self.present(vc, animated: false, completion: nil)
        
    }
    @IBAction func buttonOptionsTapped(_ sender: Any) {
        showOptionsBottomSheet()
    }
    @IBAction func buttonAllMembersTapped(_ sender: Any) {
        let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: AudioRoomAllParticipants.getStoryboardID()) as! AudioRoomAllParticipants
        vc.data = self.obj
        vc.callbackRemove = { id in
            self.currentRoomRef?.child("users").child(id).updateChildValues(["removed":1])
        }
        self.present(vc, animated: false, completion: nil)

        
    }
    @IBAction func buttonJoinLoungeTapped(_ sender: Any) {
        if btnsJoinType.filter{$0.isSelected}.isEmpty{
            CommonUtils.showToast(message: "Please select join type")
            return
        }
        joinFirebaseRoom {
            KeyCenter.roomId = self.obj?.roomId ?? ""
            self.viewJoin.isHidden = true
            self.viewMic.isHidden = false
            self.loadAgoraKit()
        }
    }
    @IBAction func buttonsJoinTypeTapped(_ sender: UIButton) {
        btnsJoinType.forEach{$0.isSelected = false}
        btnsJoinType[sender.tag].isSelected = true
    }
    @IBAction func buttonSpeakerTapped(_ sender: Any) {
        speakerEnabled = !speakerEnabled
    }
    
}
extension AudioRoom1VC{
    
    func append(log string: String) {
        print(string)
        guard !string.isEmpty else {
            return
        }
        
        logs.append(string)
        
        var deleted: String?
        if logs.count > 200 {
            deleted = logs.removeFirst()
        }
        
        //  updateLogTable(withDeleted: deleted)
    }
    
    //    func updateLogTable(withDeleted deleted: String?) {
    //        guard let tableView = logTableView else {
    //            return
    //        }
    //
    //        let insertIndexPath = IndexPath(row: logs.count - 1, section: 0)
    //
    //        tableView.beginUpdates()
    //        if deleted != nil {
    //            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    //        }
    //        tableView.insertRows(at: [insertIndexPath], with: .none)
    //        tableView.endUpdates()
    //
    //        tableView.scrollToRow(at: insertIndexPath, at: .bottom, animated: false)
    //    }
    func loadAgoraKit() {
        ///  Initialize the RTC Engine in two basic steps:
        
        // Step 1: get the instance of the engine using the `AppId`
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        self.agoraKit.muteLocalAudioStream(true)
        // Step 2: join the channel using the `Token` and `roomName`
        let code = agoraKit.joinChannel(byToken: nil, channelId: String.getString(KeyCenter.roomId), info: nil, uid: (UserData.shared.id.isEmpty ? 0 : UInt(UserData.shared.id)) ?? 0, joinSuccess: {a,b,c in
            print(a,b,c)
            CommonUtils.showToast(message: "Joined Successfully!")
            self.currentRoomRef?.updateChildValues(["ongoing":"1"])
            kSharedAppDelegate?.callManager.startCall(handle: "test", videoEnabled: false)
            self.sheetController?.setSizes([.fixed(190),.percent(0.85)])
        })
        
        // check if channel join failed
        if code != 0 {
            DispatchQueue.main.async(execute: {
                self.append(log: "Join channel failed: \(code)")
            })
        }
        
    }
    
    func leaveChannel() {
        // leaving the Agora channel
        self.currentUserRef?.removeAllObservers()
        self.currentRoomRef?.removeAllObservers()
        if viewJoin.isHidden{
           
            agoraKit.leaveChannel()
            kSharedAppDelegate?.callManager.removeAllCalls()
            if isCreatedBySelf{
                self.currentRoomRef?.updateChildValues(["ongoing":"0"])
                self.currentRoomRef?.child("users").removeValue()
                
            }
            else{
                if obj?.users.contains(where:{$0.userId == UserData.shared.id}) ?? false{
                    self.currentUserRef?.updateChildValues(["removed":1])
                }
                else if ((obj?.users.isEmpty) != nil){
                    self.currentRoomRef?.child("users").removeValue()
                }
                
            }
            
            kSharedAppDelegate?.moveToHomeScreen()
        }
        else{
            
            
            self.currentUserRef?.removeAllObservers()
            kSharedAppDelegate?.moveToHomeScreen()
        }
        //self.currentRoomRef?.updateChildValues(["ongoing":"0"])
        //delegate?.roomVCNeedClose(self)
    }
}

//MARK: Agora Delegate
extension AudioRoom1VC: AgoraRtcEngineDelegate {
    
    /** Occurs when the connection between the SDK and the server is interrupted.
     *
     * **DEPRECATED** from v2.3.2. Use the [connectionChangedToState]([AgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]) callback instead.
     *
     * The SDK triggers this callback when it loses connection with the server for more than four seconds after a connection is established.
     *
     * This callback is different from [rtcEngineConnectionDidLost]([AgoraRtcEngineDelegate rtcEngineConnectionDidLost:]):
     *
     * - The SDK triggers this callback when it loses connection with the server for more than four seconds after it joins the channel.
     * - The SDK triggers the [rtcEngineConnectionDidLost when it loses connection with the server for more than 10 seconds, regardless of whether it joins the channel or not.
     *
     * If the SDK fails to rejoin the channel 20 minutes after being disconnected from Agora's edge server, the SDK stops rejoining the channel.
     *
     *  @param engine - AgoraRtcEngineKit object.
     */
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Interrupted")
        
    }
    
    /** Occurs when the SDK cannot reconnect to Agora's edge server 10 seconds after its connection to the server is interrupted.
     *  See the description above to compare this method to rtcEngineConnectionDidInterrupted.
     *
     * @param engine AgoraRtcEngineKit object.
     */
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Lost")
    }
    
    /** Reports an error during SDK runtime.
     *
     * In most cases, the SDK cannot fix the issue and resume running. The SDK requires the app to take action or informs the user about the issue.
     *
     * For example, the SDK reports an AgoraErrorCodeStartCall = 1002 error when failing to initialize a call. The app informs the user that the call initialization failed and invokes the [leaveChannel]([AgoraRtcEngineKit leaveChannel:]) method to leave the channel.
     *
     *  @param engine   - AgoraRtcEngineKit object
     *  @param errorCode - Error code: AgoraErrorCode
     */
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        append(log: "Occur error: \(errorCode.rawValue)")
    }
    
    /** This method handles event for the local user joins a specified channel.
     *
     *  @param engine  - AgoraRtcEngineKit object.
     *  @param channel - Channel name.
     *  @param uid     - User ID. If the `uid` is specified in the [joinChannelByToken]([AgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method, the specified user ID is returned. If the user ID is not specified when the joinChannel method is called, the server automatically assigns a `uid`.
     *  @param elapsed - Time elapsed (ms) from the user calling the [joinChannelByToken]([AgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method until the SDK triggers this callback.
     * - */
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        append(log: "Did joined channel: \(channel), with uid: \(uid), elapsed: \(elapsed)")
    }
    
    /** This method handles event for a remote user or host joins a channel.
     * - Communication profile: This callback notifies the app that another user joins the channel. If other users are already in the channel, the SDK also reports to the app on the existing users.
     * - Live-broadcast profile: This callback notifies the app that a host joins the channel. If other hosts are already in the channel, the SDK also reports to the app on the existing hosts. Agora recommends limiting the number of hosts to 17.
     
     * The SDK triggers this callback under one of the following circumstances:
     * - A remote user/host joins the channel by calling the [joinChannelByToken]([AgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method.
     * - A remote user switches the user role to the host by calling the [setClientRole]([AgoraRtcEngineKit setClientRole:]) method after joining the channel.
     * - A remote user/host rejoins the channel after a network interruption.
     * - A host injects an online media stream into the channel by calling the [addInjectStreamUrl]([AgoraRtcEngineKit addInjectStreamUrl:config:]) method.
     
     * *Note:**
     
     * Live-broadcast profile:
     *
     * * The host receives this callback when another host joins the channel.
     * * The audience in the channel receives this callback when a new host joins the channel.
     * * When a web application joins the channel, the SDK triggers this callback as long as the web application publishes streams.
     *
     * @param engine  - AgoraRtcEngineKit object.
     * @param uid     - ID of the user or host who joins the channel. If the `uid` is specified in the [joinChannelByToken]([AgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method, the specified user ID is returned. If the `uid` is not specified in the joinChannelByToken method, the Agora server automatically assigns a `uid`.
     * @param elapsed - Time elapsed (ms) from the local user calling the [joinChannelByToken]([AgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) or [setClientRole]([AgoraRtcEngineKit setClientRole:]) method until the SDK triggers this callback.
     */
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        append(log: "Did joined of uid: \(uid)")
    }
    
    /** Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel. Same as [userOfflineBlock]([AgoraRtcEngineKit userOfflineBlock:]).
     *
     * There are two reasons for users to be offline:
     *
     * - Leave a channel: When the user/host leaves a channel, the user/host sends a goodbye message. When the message is received, the SDK assumes that the user/host leaves a channel.
     * - Drop offline: When no data packet of the user or host is received for a certain period of time (20 seconds for the Communication profile, and more for the Live-broadcast profile), the SDK assumes that the user/host drops offline. Unreliable network connections may lead to false detections, so Agora recommends using a signaling system for more reliable offline detection.
     *
     *  @param engine - AgoraRtcEngineKit object.
     *  @param uid   - ID o -f the user or host who leaves a channel or goes offline.
     *  @param reason - Reason why the user goes offline, see AgoraUserOfflineReason.
     */
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        append(log: "Did offline of uid: \(uid), reason: \(reason.rawValue)")
    }
    
    /** Reports the audio quality of the remote user.
     *
     *  @param engine  - AgoraRtcEngineKit object.
     *  @param uid     - User ID of the speaker.
     *  @param quality - Audio quality of the user, see [AgoraNetworkQuality](https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraNetworkQuality.html).
     *  @param delay - Time delay (ms) of the audio packet sent from the sender to the receiver, including the time delay from audio sampling pre-processing, transmission, and the jitter buffer.
     *  @param lost - Packet loss rate (%) of the audio packet sent from the sender to the receiver.
     * - */
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioQualityOfUid uid: UInt, quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
        append(log: "Audio Quality of uid: \(uid), quality: \(quality.rawValue), delay: \(delay), lost: \(lost)")
    }
    
    /** Occurs when a method is executed by the SDK.
     *
     *  @param engine  - AgoraRtcEngineKit object.
     *  @param api - The method executed by the SDK.
     *  @param error - The error code ([AgoraErrorCode](https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html)) returned by the SDK when the method call fails. If the SDK returns 0, then the method call succeeds.
     *  @param result - The result of the method call.
     * - */
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
        append(log: "Did api call execute: \(api), error: \(error)")
    }
//    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
//
//        if !speakers.isEmpty{
//            if String.getString(speakers.first?.uid) == UserData.shared.id{
//                return
//            }
//            speakers.forEach{
//                if String.getString($0.uid) == "0"{
//                    continue
//                }}
//        }
//
//    }
    
}
extension AudioRoom1VC{
    func joinFirebaseRoom(completion:(@escaping ()->())){
        if isCreatedBySelf{
            currentRoomRef?.child("users").child(UserData.shared.id).updateChildValues(
                
                    
                        ["mic":false,
                         "name":UserData.shared.full_name,
                         "profile":kBucketUrl + UserData.shared.profile_pic,
                         "removed":0,
                         "typeHost":"host",
                         "userId":UserData.shared.id,
                         "permission":1,
                         "notifications":1
                        ]
                    
                
                ,withCompletionBlock: {res,err in
                    completion()
                } )
        }
        else{
            if let res = obj{
                currentRoomRef?.child("users").child(UserData.shared.id).updateChildValues(
                   
                            ["mic":false,
                             "name":UserData.shared.full_name,
                             "profile":kBucketUrl + UserData.shared.profile_pic,
                             "removed":0,
                             "typeHost":btnsJoinType[0].isSelected ? "speaker" : "listener",
                             "userId":UserData.shared.id,
                             "permission":0,
                             "notifications":1
                            ]
                                                ,withCompletionBlock: {res,err in
                        completion()
                    })            }
            
            
        }
        
        
        
        
    }
    
}
extension AudioRoom1VC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (obj?.requestUsers.count ?? 0 ) > 6{
            constraintTableViewHeight.constant = 65*6
        }
        else{
            constraintTableViewHeight.constant = CGFloat((obj?.requestUsers.count ?? 0) * 65)
        }
        return obj?.requestUsers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoungeUserRequestTVC.identifier, for: indexPath) as! LoungeUserRequestTVC
        if let res = obj?.requestUsers[indexPath.row]{
            cell.labelName.text = res.name
            cell.imageProfile.downlodeImage(serviceurl: res.profile, placeHolder: UIImage(named: "profile_placeholder")!)
            cell.callbackAcceptReject = { status in
                self.currentRoomRef?.child("request_users").child(res.id).removeValue()
                self.currentRoomRef?.child("users").child(res.id).updateChildValues(["permission":status ? 1 : 0])
                
            }
        }
        //cell.labelRequestedToSpeak.isHidden = false
        //cell.viewContent.backgroundColor = .clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}













//struct KeyCenter {
//    static let AppId: String = "7b7c99ac420e4577ba2562eae092fa56"
//    //""
//    
//    // assign token to nil if you have not enabled app certificate
//    static var Token: String? = nil
//
//    static var roomId:String? = ""
//}
//struct MediaCharacter {
//
//    fileprivate static let legalMediaCharacterSet: NSCharacterSet = {
//        return NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&()+,-:;<=.>?@[]^_`{|}~")
//    }()
//
//    static func updateToLegalMediaString(from string: String) -> String {
//        let legalSet = MediaCharacter.legalMediaCharacterSet
//        let separatedArray = string.components(separatedBy: legalSet.inverted)
//        let legalString = separatedArray.joined(separator: "")
//        return legalString
//    }
//}
//class LogCell: UITableViewCell {
//
//    @IBOutlet weak var logLabel: UILabel!
//
//    func set(log: String) {
//        logLabel.text = log
//    }
//}
