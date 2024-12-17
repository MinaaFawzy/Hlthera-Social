//
//  AudioRoomVC.swift
//  HSN
//
//  Created by Mina Fawzy on 15/7/23.
//

import UIKit
import FittedSheets
import AgoraRtcKit
import Firebase
import FirebaseDatabase
import SRFacebookAnimation
import AVFoundation

class AudioRoomVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var moreInfoView: UIView!
    @IBOutlet weak var labelRoomName: UILabel!
    @IBOutlet weak var labelRoomDescription: UILabel!
    @IBOutlet weak var viewMic: UIView!
    @IBOutlet weak var labelRoomType: UILabel!
    @IBOutlet weak var switchAnyoneCanSpeak: UISwitch!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var labelMicStatus: UILabel!
    @IBOutlet weak var viewJoin: UIView!
    @IBOutlet weak var viewMainOptions: UIView!
    @IBOutlet var btnsJoinType: [UIButton]!
    @IBOutlet weak var btnSpeaker: UIButton!
    @IBOutlet weak var btnManageMember: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var roomParticipantView: RoomParticipantsView!
    
    
    var currentUserObj: RoomUserModel? {
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
    var commingFromSmalView: Bool = false
    var micFromSmalView: Bool = false
    var speakerFromSmalView: Bool = false
    var leaveLounge: Bool = false
    var userRole: AgoraClientRole = .broadcaster
    var userId: UInt = 0
    var echoTestResult: Int32?
    var roomName: String!
    var isCreatedBySelf = false
    var firstTime = true
    let rootRef = Database.database().reference()
    var mainRef:DatabaseReference?
    var roomsRef:DatabaseReference?
    var currentRoomRef:DatabaseReference?
    var currentUserRef:DatabaseReference?
    var roomId = ""
    var participantsVC:AudioRoomParticipantsVC?
    var sheetController:SheetViewController?
    var anonymousState : Bool = false
    var enteredLounge: Bool = false
    var obj:RoomModel? {
        didSet{
            self.updateData()
        }
    }
    
    fileprivate var agoraKit: AgoraRtcEngineKit!
    fileprivate var logs = [String]()
    fileprivate var audioMuted = true {
        didSet {
            if !commingFromSmalView {
                btnMic.isSelected = !audioMuted
                labelMicStatus.text = audioMuted ? "Mic is off" : "Mic is on"
                self.currentUserRef = currentRoomRef?.child("users").child(UserData.shared.id)
                self.currentUserRef?.updateChildValues(["mic":!audioMuted])
            }
        }
    }
    fileprivate var speakerEnabled = false {
        didSet {
            btnSpeaker.isSelected = speakerEnabled
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UINib(nibName: LoungeUserRequestTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeUserRequestTVC.identifier)
        self.viewJoin.isHidden = true
        self.viewMic.isHidden = true
        self.moreInfoView.isHidden = true
  //      setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
    //    setupBottomSheet()
        self.view.bringSubviewToFront(tableView)
        setupAgora()
        if commingFromSmalView {
            btnMic.isSelected = !micFromSmalView
            labelMicStatus.text = micFromSmalView ? "Mic is off" : "Mic is on"
            audioMuted = micFromSmalView
            speakerEnabled = speakerFromSmalView
        }
        
        DispatchQueue.main.async {
            self.viewMainOptions.setGradientLoungeOptionsBackground()
        }
        switchAnyoneCanSpeak.transform = CGAffineTransform(scaleX: 0.70, y: 0.65)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if enteredLounge {
            if leaveLounge {
                kSharedAppDelegate?.isShowLounge = true
                CommonUtils.showToast(message: "You ended the call")
                enteredLounge = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                })
            } else {
                kSharedAppDelegate?.viewToShow.roomId = self.roomId
                kSharedAppDelegate?.viewToShow.micState = self.audioMuted
                kSharedAppDelegate?.viewToShow.speakerState = self.speakerEnabled
                kSharedAppDelegate?.viewToShow.anonymousState = self.anonymousState
                kSharedAppDelegate?.viewToShow.isHidden = false
            }
        }
    }
    //MARK: - methods
    func updateData(){
        if let res = obj{
            self.labelRoomName.text = res.category.isEmpty ? "Lounge" : res.category
            self.labelRoomDescription.text = res.description.isEmpty ? "Description unavailable" : res.description
            self.labelRoomType.text = res.type.isEmpty ? "Type not found" : res.type.capitalized
//            self.participantsVC?.data = res.users.filter{!$0.isRemoved}
//            self.participantsVC?.obj = obj ?? RoomModel(data: [:])
//            self.participantsVC?.roomType = self.obj?.type ?? ""
            self.roomParticipantView?.data = res.users.filter{!$0.isRemoved}
            self.roomParticipantView?.obj = obj ?? RoomModel(data: [:])
            self.roomParticipantView?.roomType = self.obj?.type ?? ""
            self.roomParticipantView.anonymousState = self.anonymousState
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
                tableView.isHidden = false
                self.tableView.reloadData()
            } else {
                tableView.isHidden = true
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
        mainRef = rootRef.child("usertouser")
        self.roomsRef = mainRef?.child("rooms")
        self.currentRoomRef = roomsRef?.child(roomId)
        self.currentUserRef = currentRoomRef?.child("users").child(UserData.shared.id)
        currentUserRef?.observe(.value) { (snap) in
//            print(snap.value,"SNAP VALUE")
            if !kSharedInstance.getDictionary(snap.value).isEmpty{
                self.currentUserObj = RoomUserModel(data: kSharedInstance.getDictionary(snap.value))
            } else {
                self.currentUserObj = nil
            }
        }
        currentRoomRef?.observe(.value) { (snap) in
//            print(snap.value,"SNAP VALUE")
            self.obj = RoomModel(data: kSharedInstance.getDictionary(snap.value))
            if self.agoraKit == nil && self.firstTime {
                self.firstTime = false
                completion()
            }
        }
    }
    
    func setupAgora(){
        setupFirebase(){ [self] in
            if obj?.id == UserData.shared.id {
                isCreatedBySelf = true
                self.viewJoin.isHidden = true
                self.moreInfoView.isHidden = false
                joinFirebaseRoom {
                    KeyCenter.roomId = self.obj?.roomId ?? ""
                    self.loadAgoraKit()
                }
            } else {
                isCreatedBySelf = false
                self.sheetController?.setSizes([.percent(0.75)])
                self.viewJoin.isHidden = false
                self.moreInfoView.isHidden = true
            }
            if commingFromSmalView && obj?.id != UserData.shared.id{
                self.moreInfoView.isHidden = false
                self.viewJoin.isHidden = true
                self.loadAgoraKit()
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
        
        let bottomSheetVC = self.storyboard?.instantiateViewController(withIdentifier: AudioRoomParticipantsVC.getStoryboardID()) as! AudioRoomParticipantsVC
        if let vc = bottomSheetVC as? AudioRoomParticipantsVC{
            vc.obj = self.obj!
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

    
    //MARK: - @IBACtion
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
                self.viewMic.isHidden = false
                self.moreInfoView.isHidden = true
    }
    
    @IBAction func backButtonToHideInfoBar(_ sender: Any) {
        self.viewMic.isHidden = true
        self.moreInfoView.isHidden = false
    }
    
    @IBAction func doMuteAudioPressed(_ sender: UIButton) {
        checkMicPermissionAndOpenIt()
        if audioMuted {
            agoraKit.adjustRecordingSignalVolume(0)
        } else {
            agoraKit.adjustRecordingSignalVolume(100)
        }
    }
    
    @IBAction func buttonSpeakerTapped(_ sender: Any) {
        speakerEnabled = !speakerEnabled
        if speakerEnabled {
            agoraKit.adjustPlaybackSignalVolume(100)
            agoraKit.adjustUserPlaybackSignalVolume(userId, volume: 0)
        } else {
            agoraKit.adjustPlaybackSignalVolume(0)
        }
    }
    
    @IBAction func doClosePressed(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: LoungeAlertVC.getStoryboardID()) as! LoungeAlertVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        if !isCreatedBySelf{
            vc.msgString = "The audio call will end for you"
        }
        vc.yesCallback = {
            self.leaveLounge = true
            self.leaveChannel()
            if self.isCreatedBySelf {
                CommonUtils.showToast(message: "The Call has been ended by admin")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    //self.leaveChannel()
                })
            }
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
            if btnsJoinType.filter({$0.isSelected}).isEmpty{
                CommonUtils.showToast(message: "Please select join type")
                return
            }
            joinFirebaseRoom {
                KeyCenter.roomId = self.obj?.roomId ?? ""
                self.loadAgoraKit()
                self.viewJoin.isHidden = true
                self.moreInfoView.isHidden = false
                
            }
        }
    
    @IBAction func buttonsJoinTypeTapped(_ sender: UIButton) {
        btnsJoinType.forEach{$0.isSelected = false}
        btnsJoinType[sender.tag].isSelected = true
        
    }
    
}

//MARK: - Extension funcs
extension AudioRoomVC{
    
    func showMessage(title: String, text: String, delay: Int = 2) -> Void {
    let deadlineTime = DispatchTime.now() + .seconds(delay)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true)
        alert.dismiss(animated: true, completion: nil)
    })
}
    
    func checkForPermissions() async -> Bool {
        let hasPermissions = await self.avAuthorization(mediaType: .audio)
        return hasPermissions
    }

    func avAuthorization(mediaType: AVMediaType) async -> Bool {5
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }

    func checkMicPermissionAndOpenIt() {
        if let res = currentUserObj{
            if res.typeHost == "host" {
                  audioMuted = !audioMuted
             } else {
                 if res.permission {
                         let temp = !audioMuted
                         self.currentRoomRef?.child("users").child(res.userId).updateChildValues(["mic":temp])
                         audioMuted = !audioMuted
//                     }
                 } else {
                     CommonUtils.showAlert(title: "Insufficient Permissions", message: "You need to request for mic permission to speak", firstTitle: "Send Request to admin", secondTitle: "Cancel",isSecondCancel: true, completion: {buttonTitle in
                         self.currentRoomRef?.child("request_users").child(res.userId).updateChildValues([
                            "id":res.userId,
                            "name":res.name,
                            "permission":0,
                            "profile":res.profile])

                     })
                }
           }
        } else {
            print("res != currentUserObj ")
        }
    }
        
    func append(log string: String) {
        print(string)
        guard !string.isEmpty else {
            return
        }
        logs.append(string)
//        var deleted: String?
//        if logs.count > 200 {
//            deleted = logs.removeFirst()
//        }
        
        //updateLogTable(withDeleted: deleted)
    }

//MARK: - Agora join& Leave
    
    func loadAgoraKit() {
        CommonUtils.showHudWithNoInteraction(show: true)
        Task { @MainActor in
            if await !self.checkForPermissions() {
                showMessage(title: "Error", text: "Permissions were not granted")
                return
            }
        }
        var result : Int32 = -1
        let config = AgoraRtcEngineConfig()
        config.appId = KeyCenter.AppId
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        let option = AgoraRtcChannelMediaOptions()
        if self.userRole == .broadcaster {
            option.clientRoleType = .broadcaster
        } else {
            option.clientRoleType = .audience
        }

        option.channelProfile = .communication

        if !commingFromSmalView {
            agoraKit.adjustRecordingSignalVolume(0)
            agoraKit.adjustPlaybackSignalVolume(0)
        }
        if commingFromSmalView {
            result = 0
        } else {
             result = agoraKit.joinChannel(
                byToken: nil, channelId: String.getString(KeyCenter.roomId), uid: 0, mediaOptions: option,
                joinSuccess: { (channel, uid, elapsed) in
                    CommonUtils.showToast(message: "Joined Successfully!")
                    self.currentRoomRef?.updateChildValues(["ongoing":"1"])
                    kSharedAppDelegate?.callManager.startCall(handle: "test", videoEnabled: false)
                    self.sheetController?.setSizes([.fixed(190),.percent(0.85)])
                }
                
            )
        }
        CommonUtils.showHudWithNoInteraction(show: false)
        self.enteredLounge = true

        if (result != 0) && !commingFromSmalView {
            showMessage(title: "Error", text: "Cannot join the channel as \(self.userRole)")
        } else if commingFromSmalView {
            commingFromSmalView = false
        }
    }
    
    func leaveChannel() {
        self.currentUserRef?.removeAllObservers()
        self.currentRoomRef?.removeAllObservers()
        if viewJoin.isHidden && enteredLounge {
            
            agoraKit.leaveChannel()
            kSharedAppDelegate?.callManager.removeAllCalls()
            if isCreatedBySelf {
                self.currentRoomRef?.updateChildValues(["ongoing":"0"])
                self.currentRoomRef?.child("users").removeValue()
            } else {
                if obj?.users.contains(where:{$0.userId == UserData.shared.id}) ?? false{
                    self.currentUserRef?.updateChildValues(["removed":1])
                } else if ((obj?.users.isEmpty) != nil) {
                    self.currentRoomRef?.child("users").removeValue()
                }
            }
            
            //            kSharedAppDelegate?.moveToHomeScreen()
            self.dismiss(animated: true)
        } else {
            self.currentUserRef?.removeAllObservers()
            //kSharedAppDelegate?.moveToHomeScreen()
            self.dismiss(animated: true)
        }
        //self.currentRoomRef?.updateChildValues(["ongoing":"0"])
        //delegate?.roomVCNeedClose(self)
    }
    
}

//MARK: - Agora Delegate
extension AudioRoomVC: AgoraRtcEngineDelegate {
    
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Interrupted")
    }
    
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        append(log: "Connection Lost")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        append(log: "Occur error: \(errorCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        append(log: "Did joined channel: \(channel), with uid: \(uid), elapsed: \(elapsed)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        append(log: "Did joined of uid: \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        append(log: "Did offline of uid: \(uid), reason: \(reason.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioQualityOfUid uid: UInt, quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
        append(log: "Audio Quality of uid: \(uid), quality: \(quality.rawValue), delay: \(delay), lost: \(lost)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
        append(log: "Did api call execute: \(api), error: \(error)")
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
         // Handle audio mute/unmute events
     }
    
}


//MARK: - Firebase Funcs
extension AudioRoomVC{
    func joinFirebaseRoom(completion:(@escaping ()->())){
        print("wwwwwwwwwwwww\(commingFromSmalView)")
        if isCreatedBySelf {
            if commingFromSmalView {
                print("asaad\(micFromSmalView)")
                currentRoomRef?.child("users").child(UserData.shared.id).updateChildValues([
                    "mic":!micFromSmalView,
                    "name":UserData.shared.full_name,
                    "profile":kBucketUrl + UserData.shared.profile_pic,
                    "removed":0,
                    "typeHost":"host",
                    "userId":UserData.shared.id,
                    "permission":1,
                    "notifications":1
                ], withCompletionBlock: { res,err in
                        completion()
                    })
            } else {
                currentRoomRef?.child("users").child(UserData.shared.id).updateChildValues([
                    "mic":false,
                    "name":UserData.shared.full_name,
                    "profile":kBucketUrl + UserData.shared.profile_pic,
                    "removed":0,
                    "typeHost":"host",
                    "userId":UserData.shared.id,
                    "permission":1,
                    "notifications":1
                ], withCompletionBlock: { res,err in
                        completion()
                    })
            }
        }
        else{
            if obj != nil {
                if commingFromSmalView {
                    print("asaad\(micFromSmalView)")
                    currentRoomRef?.child("users").child(UserData.shared.id).updateChildValues([
                        "mic":!micFromSmalView,
                        "name":UserData.shared.full_name,
                        "profile":kBucketUrl + UserData.shared.profile_pic,
                        "removed":0,
                        "typeHost":btnsJoinType[0].isSelected ? "speaker" : "listener",
                        "userId":UserData.shared.id,
                        "permission":1,
                        "notifications":1
                    ], withCompletionBlock: { res,err in
                        completion()
                    })
                } else {
                    currentRoomRef?.child("users").child(UserData.shared.id).updateChildValues([
                        "mic":false,
                        "name":UserData.shared.full_name,
                        "profile":kBucketUrl + UserData.shared.profile_pic,
                        "removed":0,
                        "typeHost":btnsJoinType[0].isSelected ? "speaker" : "listener",
                        "userId":UserData.shared.id,
                        "permission":1,
                        "notifications":1
                    ], withCompletionBlock: { res,err in
                        completion()
                    })
                }
            }
            
        }
    }
}

//MARK: - TableView functions
extension AudioRoomVC:UITableViewDelegate,UITableViewDataSource{
   
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

struct KeyCenter {
    static let AppId: String = "7b7c99ac420e4577ba2562eae092fa56"
    //""
    
    // assign token to nil if you have not enabled app certificate
    static var Token: String? = nil
    
    static var roomId:String? = ""
}

struct MediaCharacter {
    
    fileprivate static let legalMediaCharacterSet: NSCharacterSet = {
        return NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&()+,-:;<=.>?@[]^_`{|}~")
    }()
    
    static func updateToLegalMediaString(from string: String) -> String {
        let legalSet = MediaCharacter.legalMediaCharacterSet
        let separatedArray = string.components(separatedBy: legalSet.inverted)
        let legalString = separatedArray.joined(separator: "")
        return legalString
    }
}

