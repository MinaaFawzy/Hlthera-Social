//
//  ChatViewController.swift
//  Kindling
//
//  Created by Mohd Aslam on 29/12/20.
//

import UIKit
import IQKeyboardManagerSwift
import AVKit
import AVFoundation
import iRecordView
import MobileCoreServices
import RealmSwift
import GiphyUISDK
import ISEmojiView

class ChatViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var viewChatInput: UIView!
    @IBOutlet weak var buttonPhotos: UIButton!
    @IBOutlet weak var buttonVideo: UIButton!
    @IBOutlet weak var buttonCamera: UIButton!
    @IBOutlet weak var buttonSendVoice: RecordButton!
    @IBOutlet weak var viewSlideToCancel: RecordView!
    @IBOutlet weak var buttonCameraMain: UIButton!
    @IBOutlet weak var chatTblView: UITableView! {
        didSet{
            chatTblView.delegate = self
            chatTblView.dataSource = self
        }
    }
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var chatTextView: IQTextView!
    @IBOutlet var txtMessageHTConstant: NSLayoutConstraint!
    @IBOutlet var bottomViewBottmConstraint: NSLayoutConstraint!
    @IBOutlet var constraintBottomShowAttachment: NSLayoutConstraint!
    @IBOutlet weak var viewMediaOptions: UIView!
    @IBOutlet weak var btnAttachment: UIButton!
    //@IBOutlet weak var navView:UIView!
    //@IBOutlet weak var btnEmoji: UIButton!
    //@IBOutlet weak var constraintViewMediaHeight: NSLayoutConstraint!
    //@IBOutlet weak var imgBtnSend: UIImageView!
    //@IBOutlet weak var viewProfile: UIView!
    //@IBOutlet weak var buttonBack: UIButton!
    //@IBOutlet weak var viewTyping: UIView!
    //@IBOutlet weak var typingUserImg: UIImageView!
    //@IBOutlet weak var lblTypingName: UILabel!
    //@IBOutlet weak var viewBg: UIView!
    
    // MARK: - Variables
    var isCameFromNotififications = false
    let textViewMaxHeight: CGFloat = 100
    let textViewMinHeight: CGFloat = 34.0
    var userDetails = kSharedUserDefaults.getLoggedInUserDetails()
    var receiverid = String()
    var receivername = String()
    var CreatedBy = String()
    var receiverprofile_image = String()
    var Messageclass = [MessageClass]()
    var readmessagesCountCheck = false
    var ChatBackup :[ChatbackupOnetoOne]?
    var MessageObjList = [MessageObject]()
    var player:AVPlayer?
    //var playerItem: AVPlayerItem?
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var meterTimer:Timer!
    var playerTimer:Timer!
    var isAudioRecordingGranted = false
    var isRecording = false
    var isPlaying = false
    let recordedAudioFileName = "RecordingClip.m4a"
    let fileManager = FileManager.default
    var longGesture: UILongPressGestureRecognizer?
    var moveGesture: UIPanGestureRecognizer?
    //var usermodel: UserProfileModel?
    var isDeleted = false
    var slideConnstant = 0
    var isRecordingCancel = false
    var isComingFromUserProfile = false
    var unread_count = 0
    var isSearchOn = false
    var searchList = [String]()
    var selectedSearchIndex = 0
    var isUserBlocked = false
    var isCallback = false
    var isAnimated = false
    var isFriend = true
    var senderIdStr = ""
    var isBlock = false
    var chatCallback: (() ->Void)? = nil
    var startedAt = String()
    var loanId = String()
    var senderProfileImage = UIImageView()
    var contactDetail:Contacts?
    var msgCount = 0
    var previousRect: CGRect = .zero
    
    // MARK: - View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBar()
        btnSend.isHidden = true
        self.constraintBottomShowAttachment.isActive = false
        self.bottomViewBottmConstraint.isActive = true
        bottomViewBottmConstraint.constant = 15
        viewSlideToCancel.isSoundEnabled = true
        buttonSendVoice.recordView = viewSlideToCancel
        viewSlideToCancel.delegate = self
        chatTextView.delegate = self
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        senderIdStr = String.getString(UserData.shared.id)
        viewChatInput.cornerRadius  =
        viewChatInput.frame.height/2
        
        self.viewMediaOptions.isHidden = true
        let ResentUser = ResentUsers.fetchResentListFromDatabase()
        for object in ResentUser ?? [] {
            var recId = object.to
            
            if recId == String.getString(UserData.shared.id) {
                recId = object.from
            }
            if recId == self.receiverid {
                // self.isFriend = object.isFriend
                break
            }
        }
        self.senderProfileImage.downlodeImage(serviceurl: String.getString(kBucketUrl+UserData.shared.profile_pic), placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        //hideKeyboardWhenTappedAround(views: self.chatTblView)
        chatTblView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        initialSetup()
        registerNib()
        self.Messageclass = MessageList.fetchMessagesForUser(userid: self.receiverid) ?? []
        setup_recorder()
        self.filterMessageArray()
        
        self.scrollToBottom(animated : false)
        perform(#selector(changeScrollStatus), with: nil, afterDelay: 3)
        if self.Messageclass.count == 0 {
            //            CommonUtils.showHudWithNoInteraction(show: true)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Notifications.kChatNotificationReceived), object: nil, queue: nil) { (notification) in
            self.Messageclass = MessageList.fetchMessagesForUser(userid: self.receiverid) ?? []
            self.filterMessageArray()
            self.chatTblView.reloadData()
            self.scrollToBottom(animated : true)
        }
        self.ReceiveMessage()
        //        Chat_hepler.Shared_instance.Resent_Users(userid: UserData.shared.id, message: {
        //            data in
        //            print(data)
        //        })
        //
        //        Chat_hepler.Shared_instance.getUeadCountForAConversation(Senderid: String.getString(UserData.shared.id), Receiverid: self.receiverid) { (count, success) in
        //            if success {
        //                self.unread_count = count
        //                if !self.isCallback {
        //                    self.isCallback = true
        //                    self.refreshReceiverDetailOnFirebase()
        //                }
        //            }
        //        }
        self.chatTblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = true
        chatTblView.reloadData()
        registerKeyboardNotifications()
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //DispatchQueue.main.async {
        //        Chat_hepler.Shared_instance.readMessageCountForAConversation(Senderid: String.getString(UserData.shared.id), Receiverid: self.receiverid)
        //        }
        //        self.getTypingStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.tabBarController?.tabBar.isHidden = false
        
        
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.player?.pause()
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeScrollStatus() {
        self.isAnimated = true
    }
    
    //MARK:- Private Functions
    private func initialSetup() {
        chatTblView.rowHeight = UITableView.automaticDimension
        //footerView.addShadowWithBlurOnView(footerView, spread: 0, blur: 12, color: .black, opacity: 0.16, OffsetX: 0, OffsetY: 0)
        userNameLbl.text = receivername.isEmpty ? "Unknown User" : receivername
        let url = receiverprofile_image
        self.senderProfileImage.downlodeImage(serviceurl: url, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnRecordingBtn(_:)))
        btnSend.addGestureRecognizer(longGesture!)
        chatTextView.delegate = self
        //moveGesture = UIPanGestureRecognizer(target: self, action: #selector(touchMoved(_:)))
        //moveGesture?.delegate = self
        //btnSend.addGestureRecognizer(moveGesture!)
    }
    
    private func getTypingStatus() {
        //        Chat_hepler.Shared_instance.getTypingStat(receiverid: self.receiverid) { (status) in
        //            if status ?? 0 == 1 {
        //                self.lblTypingName.text = "\(self.receivername) is typing..."
        //                self.viewTyping.isHidden = false
        //                self.typingUserImg.image = self.userImgView.image
        //            }else {
        //                self.viewTyping.isHidden = true
        //            }
        //        }
    }
    
    //Function for Register  Nib in for Table View
    private func registerNib() {
        self.chatTblView.register(UINib(nibName: cellidentifiers.SendertextCell, bundle: nil),   forCellReuseIdentifier: cellidentifiers.SendertextCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.Receivertextcell, bundle: nil),  forCellReuseIdentifier: cellidentifiers.Receivertextcell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderImageCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderImageCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverImageCell, bundle: nil),forCellReuseIdentifier: cellidentifiers.ReceiverImageCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderVideoCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderVideoCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverVideoCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.ReceiverVideoCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderAudioCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderAudioCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverAudioCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.ReceiverAudioCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.MissedCallCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.MissedCallCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderDocumentCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderDocumentCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.SenderGifCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SenderGifCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverGifCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.ReceiverGifCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.ReceiverDocumentCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.ReceiverDocumentCell)
        self.chatTblView.register(UINib(nibName: cellidentifiers.SubscriptionNotPurchasedTableViewCell, bundle: nil), forCellReuseIdentifier: cellidentifiers.SubscriptionNotPurchasedTableViewCell)
        
        
    }
    
    private func registerKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func scrollToBottom(animated : Bool){
        if !isDeleted {
            //DispatchQueue.main.async {
            if self.MessageObjList.count > 0 {
                let arr = self.MessageObjList[self.MessageObjList.count-1].messages
                let indexPath = IndexPath(row: arr.count-1, section: self.MessageObjList.count-1)
                self.chatTblView.scrollToRow(at: indexPath, at: .bottom, animated: self.isAnimated )
            }
            //}
        }else {
            isDeleted = false
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if player != nil {
            isPlaying = false
            player?.pause()
        }
    }
    
    //Callback to save image in Gallery
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            CommonUtils.showToast(message: error.localizedDescription)
        } else {
            CommonUtils.showToast(message: "Image saved successfully")
        }
        CommonUtils.showHudWithNoInteraction(show: false)
    }
    
    //Keyboard methods
    func emojiKeyboard(){
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        //self.btnEmoji.isSelected = true
        self.chatTextView.inputView = emojiView
        self.chatTextView.reloadInputViews()
        self.chatTextView.becomeFirstResponder()
    }
    func defaultKeyboard(){
        //self.chatTextView.resignFirstResponder()
        self.chatTextView.inputView = nil
        self.chatTextView.keyboardType = .default
        self.chatTextView.reloadInputViews()
        self.chatTextView.becomeFirstResponder()
        //self.btnEmoji.isSelected = false
        
    }
    
    @objc func dismissKeyboard() {
        self.chatTextView.resignFirstResponder()
        self.chatTextView.inputView = nil
        self.chatTextView.keyboardType = .default
        self.chatTextView.reloadInputViews()
        
        //self.btnEmoji.isSelected = false
        view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround(views : UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        views.addGestureRecognizer(tap)
    }
    
    //More options method
    private func deleteConversationAction() {
        let story = UIStoryboard(name: Storyboards.kHome, bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: AlertConfirmationVC.getStoryboardID()) as! AlertConfirmationVC
        controller.alertTitle = "Are you sure you want to delete this conversation?"
        self.present(controller, animated: true) {
            controller.yesCallback = {
                Chat_hepler.Shared_instance.ClearChat(msgclass: self.Messageclass, Senderid: self.senderIdStr, Receiverid: String.getString(self.receiverid))
                CommonUtils.showHudWithNoInteraction(show: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    CommonUtils.showHudWithNoInteraction(show: false)
                    CommonUtils.showToast(message: "All chat cleared")
                    //Chat_hepler.Shared_instance.removeFromresent(senderid: String.getString(self.userDetails[Parameters.user_id]), receiverid: String.getString(self.receiverid))
                    let node = self.senderIdStr < String.getString(self.receiverid) ? "\(String.getString(self.senderIdStr))_\(String.getString(self.receiverid))" :  "\(String.getString(self.receiverid))_\(String.getString(self.senderIdStr))"
                    MessageList.deleteMessagesForUser(userid: node)
                    self.Messageclass.removeAll()
                    self.MessageObjList.removeAll()
                    self.chatTblView.reloadData()
                    Chat_hepler.Shared_instance.removeFromresent(Senderid: self.senderIdStr, Receiverid: String.getString(self.receiverid))
                }
            }
        }
    }
    
    private func blockUser() {
        let story = UIStoryboard(name: Storyboards.kHome, bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: AlertConfirmationVC.getStoryboardID()) as! AlertConfirmationVC
        controller.alertTitle = self.isBlock ? "Are you sure you want to unblock this user?" : "Are you sure you want to block this user?"
        self.present(controller, animated: true) {
            controller.yesCallback = {
                
                self.blockUnblockApi()
            }
        }
    }
    
    private func searchMessages(searchText: String) {
        
        searchList.removeAll()
        self.Messageclass.forEach { (message) in
            let txtStr = String.getString(message.Message).lowercased()
            if txtStr.contains(searchText.lowercased()) {
                let msgId = String.getString(message.uid)
                searchList.append(msgId)
            }
        }
        chatTblView.reloadData()
        selectedSearchIndex = searchList.count - 1
        moveToSearchMessage()
    }
    
    private func moveToSearchMessage() {
        if selectedSearchIndex < 0 || selectedSearchIndex >= searchList.count{
            CommonUtils.showToast(message:"No searched message found")
            return
        }
        if searchList.count > selectedSearchIndex {
            let msgId = String.getString(searchList[selectedSearchIndex])
            
            for section in 0..<self.MessageObjList.count {
                let arr = self.MessageObjList[section].messages
                for index in 0..<arr.count {
                    let msgIdStr = String.getString(arr[index].uid)
                    if msgId == msgIdStr {
                        let indexPath = IndexPath(row: index, section: section)
                        self.chatTblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                        break
                    }
                }
            }
        }
        
    }
    
    private func makeVideoCall() {
        //        if let vc = UIStoryboard(name: "Chat", bundle: .main).instantiateViewController(withIdentifier: "VideoCallViewController") as? VideoCallViewController {
        //            vc.titleStr = String.getString(self.receivername)
        //            kSharedUserDefaults.setCallerId(name: String.getString(self.receiverid))
        //            kSharedUserDefaults.setChennalName(chennalName: String.getString(self.receiverid))
        //            kSharedUserDefaults.setCallerName(name: String.getString(self.receivername))
        //            kSharedUserDefaults.setProfileImg(name: String.getString(self.receiverprofile_image))
        //            kSharedAppDelegate?.isGroupCall = false
        //            vc.profileUrl = String.getString(self.receiverprofile_image)
        //            vc.receiverName = String.getString(self.receivername)
        //            vc.isComingFromChat = true
        //            self.present(vc, animated: true, completion: nil)
        //        }
    }
    
    private func makeAudioCall() {
        //        if let vc = UIStoryboard(name: "Chat", bundle: .main).instantiateViewController(withIdentifier: "VoiceChatViewController") as? VoiceChatViewController {
        //            kSharedUserDefaults.setCallerId(name: String.getString(self.receiverid))
        //            kSharedUserDefaults.setChennalName(chennalName: String.getString(self.receiverid))
        //            kSharedAppDelegate?.isGroupCall = false
        //            kSharedUserDefaults.setCallerName(name: String.getString(self.receivername))
        //            kSharedUserDefaults.setProfileImg(name: String.getString(self.receiverprofile_image))
        //            vc.receiverId = String.getString(self.receiverid)
        //            vc.profileUrl = String.getString(self.receiverprofile_image)
        //            vc.receiverName = String.getString(self.receivername)
        //            vc.isComingFromChat = true
        //            self.present(vc, animated: true, completion: nil)
        //        }
    }
    
    func openDocumentFile(mediaurl: String?, mediaName: String?) {
        let story = UIStoryboard(name: Storyboards.kHome, bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        
        controller.url = String.getString(mediaurl)
        controller.pageTitleString = String.getString(mediaName)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    // MARK: -  Notification
    @objc func keyboardWillShow(notification: NSNotification) {
        var keyboardSize: CGSize = CGSize.zero
        self.constraintBottomShowAttachment.isActive = false
        self.bottomViewBottmConstraint.isActive = true
        self.viewMediaOptions.isHidden = true
        btnAttachment.isSelected = false
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            keyboardSize = value.cgRectValue.size
            if DeviceType.IS_IPHONE_X || DeviceType.IS_IPHONE_X_MAX {
                bottomViewBottmConstraint.constant = keyboardSize.height - 15
            }else {
                bottomViewBottmConstraint.constant = keyboardSize.height
            }
            self.view.layoutIfNeeded()
            scrollToBottom(animated: true)
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        self.constraintBottomShowAttachment.isActive = false
        self.bottomViewBottmConstraint.isActive = true
        bottomViewBottmConstraint.constant = 15
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Record Sound Methods
    private func hideOrShowFooterView(isShow: Bool) {
        // btnSend.isHidden = isShow
        // imgBtnSend.isHidden = isShow
        chatTextView.isHidden = isShow
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        isPlaying = false
        chatTblView.reloadData()
    }
    
    @objc func longPressOnRecordingBtn(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == .began {
            print_debug(items: "Long Press started")
            if !isRecording {
                startRecording()
            }
        }else if guesture.state == .ended {
            print_debug(items: "Long Press Ended")
            stopRecording()
        }
    }
    
    private func deletePreviousFile() {
        //        if fileManager.fileExists(atPath: CommonUtils.getFileUrl(fileName: recordedAudioFileName).path) {
        //            do {
        //                try fileManager.removeItem(atPath: CommonUtils.getFileUrl(fileName: recordedAudioFileName).path)
        //            } catch {
        //
        //            }
        //        }
    }
    
    //Check Recording Permission
    private func check_record_permission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    //Recording start
    private func startRecording() {
        btnSend.isHidden = true
        check_record_permission()
        deletePreviousFile()
        setup_recorder()
        
        if audioRecorder != nil {
            audioRecorder.record()
            hideOrShowFooterView(isShow: true)
            
            
            meterTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            isRecording = true
            self.buttonCameraMain.isHidden = true
            self.btnAttachment.isHidden = true
        }
        
    }
    //Recording stop
    private func stopRecording() {
        btnSend.isHidden = true
        if meterTimer != nil {
            meterTimer.invalidate()
        }
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
            
            //btnRecording.isSelected = false
            isRecording = false
            hideOrShowFooterView(isShow: false)
            
            // viewSlideToCancel.isHidden = true
            print_debug(items: "recorded successfully.")
            self.buttonCameraMain.isHidden = false
            self.btnAttachment.isHidden = false
            String.getString(chatTextView.text).isEmpty ? (btnSend.isHidden = true) : (btnSend.isHidden = false)
            
            
            viewSlideToCancel.isUserInteractionEnabled = false
            
        }
        
    }
    
    private func setup_recorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: CommonUtils.getFileUrl(fileName: recordedAudioFileName), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.record(forDuration: 60)
                audioRecorder.prepareToRecord()
            }
            catch let error {
                CommonUtils.showToast(message: String.getString(error.localizedDescription))
            }
        }
        else {
            print("Don't have access to use your microphone.")
        }
    }
    
    private func setupStatusBar() {
        // Get the main window of your app
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        // Set the background color of the status bar
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor(red: 245, green: 247, blue: 249, transparency: 1)
        window.addSubview(statusBarBackgroundView)
        
        // Add constraints to the status bar background view
        statusBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        statusBarBackgroundView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        statusBarBackgroundView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        statusBarBackgroundView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        statusBarBackgroundView.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor).isActive = true
        
    }
    
    //Update recording time
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
            //let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            audioRecorder.updateMeters()
            if sec > 60 {
                CommonUtils.showToast(message: String.getString("Maxium Recording time is 60 seconds"))
                longGesture?.state = .cancelled
                stopRecording()
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            CommonUtils.showToast(message: String.getString("Recording failed."))
        }
        hideOrShowFooterView(isShow: false)
        if isRecordingCancel {
            isRecordingCancel = false
        }else {
            let url = CommonUtils.getFileUrl(fileName: recordedAudioFileName)
            self.uploadImagesVideos(imageOrVideo: url, isImage: false,isAudio: true)
            
        }
    }
    
    // MARK: - IBActions
    @IBAction func backBtnTapped(_ sender: Any) {
        if isSearchOn {
            
        }else {
            if isUserBlocked {
                Chat_hepler.Shared_instance.deleteChatNode(Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self.receiverid))
                //sharedAppDelegate.moveToHome()
            }
            //            else {
            //                if isComingFromUserProfile {
            //                    sharedAppDelegate.moveToHome()
            //                }else {
            //                    self.navigationController?.popViewC()
            //                }
            //            }
            if isCameFromNotififications{
                kSharedAppDelegate?.moveToHomeScreen(index: 3)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func tap_AttachmentBtn(_ sender: UIButton) {
        btnAttachment.isSelected = !btnAttachment.isSelected
        
        if btnAttachment.isSelected{
            // sender.setImage(#imageLiteral(resourceName: "close"), for: .normal)
            self.view.endEditing(true)
            self.viewMediaOptions.isHidden = false
            bottomViewBottmConstraint.isActive = false
            constraintBottomShowAttachment.isActive = true
            constraintBottomShowAttachment.constant = 15
            self.dismissKeyboard()
        }
        else{
            self.constraintBottomShowAttachment.isActive = false
            self.bottomViewBottmConstraint.isActive = true
            self.bottomViewBottmConstraint.constant = 15
            // sender.setImage(#imageLiteral(resourceName: "media"), for: .normal)
            self.view.endEditing(true)
            self.viewMediaOptions.isHidden = true
            
            
            
        }
    }
    
    @IBAction func tap_DeleteBtn(_ sender: Any) {
        self.deleteConversationAction()
    }
    //
    //    @IBAction func tap_AudioCallBtn(_ sender: Any) {
    //
    //        self.makeAudioCall()
    //
    //    }
    //
    //    @IBAction func tap_VideoCallBtn(_ sender: Any) {
    //
    //        self.makeVideoCall()
    //
    //    }
    
    @IBAction func tap_EmojiBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.player?.pause()
        chatTblView.reloadData()
        sender.isSelected ? self.emojiKeyboard() : self.defaultKeyboard()
        
        
        
        
    }
    
    @IBAction func dismissMediaView(_ sender: UIButton) {
        self.viewMediaOptions.isHidden = true
    }
    
    @IBAction func tap_DocumentBtn(_ sender: UIButton) {
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func tap_VideoBtn(_ sender: UIButton) {
        
        VideoPickerHelper.shared.showVideoController(maxlength:600) { (videoUrl, videoData,duration) -> (Void) in
            if duration <= 600{
                
                print(videoUrl,videoData)
                var image:UIImage = UIImage()
                
                VideoPickerHelper.shared.thumbnil(url:videoUrl! , completionClosure: {imageThumbnail in
                    image = imageThumbnail ?? UIImage()
                })
                
                //self.myProtocal?.selectedMedia(fileUrl: videoUrl!,postType: 2,image:image,id: -1,other: "")
                self.uploadImagesVideos(imageOrVideo: videoUrl, isImage: false)
            }
            else{
                CommonUtils.showToast(message: "Video Length is too long, Select another video")
                return
            }
        }
    }
    
    @IBAction func tap_MusicBtn(_ sender: UIButton) {
        //        self.viewMediaOptions.isHidden = true
        //
        //        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        //        importMenu.delegate = self
        //        importMenu.modalPresentationStyle = .formSheet
        //        self.present(importMenu, animated: true, completion: nil)
    }
    
    @IBAction func tap_GifBtn(_ sender: Any) {
        let giphy = GiphyViewController()
        giphy.mediaTypeConfig = [.gifs]
        giphy.theme = GPHTheme(type: .lightBlur)
        giphy.stickerColumnCount = GPHStickerColumnCount.four
        giphy.showConfirmationScreen = false
        giphy.rating = .ratedPG13
        GiphyViewController.trayHeightMultiplier = 0.7
        giphy.delegate = self
        present(giphy, animated: true, completion: nil)
    }
    
    @IBAction func tap_GalleryBtn(_ sender: UIButton) {
        //  self.viewMediaOptions.isHidden = true
        
        ImagePickerHelper.shared.showPhotosGalleryPickerController(){data in
            if data is UIImage{
                // self.myProtocal?.selectedMedia(fileUrl: data,postType: 5,image:data as! UIImage,id: -1,other: "")
                let img = data as? UIImage ?? UIImage()
                var width = img.size.width
                var height = img.size.height
                if img.size.width  > ScreenSize.SCREEN_WIDTH {
                    width = ScreenSize.SCREEN_WIDTH
                }
                if img.size.height > ScreenSize.SCREEN_HEIGHT - 100 {
                    height = ScreenSize.SCREEN_HEIGHT - 100
                }
                let size: CGSize = CGSize(width: width , height: height )
                let finalImage: UIImage? = img.ResizeImageOriginalSize(targetSize: size)
                //  self.sendImage(image : finalImage, check: true)
                if finalImage != nil {
                    self.uploadImagesVideos(imageOrVideo:img, isImage: true)
                }
            }
            else{
                
            }
            
        }
        
        
        
        
        
    }
    
    @IBAction func tap_CameraBtn(_ sender: UIButton) {
        // self.viewMediaOptions.isHidden = true
        
        ImagePickerHelper.shared.showCameraGalleryPickerController(){data in
            if data is UIImage{
                // self.myProtocal?.selectedMedia(fileUrl: data,postType: 5,image:data as! UIImage,id: -1,other: "")
                let img = data as? UIImage ?? UIImage()
                var width = img.size.width
                var height = img.size.height
                if img.size.width  > ScreenSize.SCREEN_WIDTH {
                    width = ScreenSize.SCREEN_WIDTH
                }
                if img.size.height > ScreenSize.SCREEN_HEIGHT - 100 {
                    height = ScreenSize.SCREEN_HEIGHT - 100
                }
                let size: CGSize = CGSize(width: width , height: height )
                let finalImage: UIImage? = img.ResizeImageOriginalSize(targetSize: size)
                //  self.sendImage(image : finalImage, check: true)
                if finalImage != nil {
                    self.uploadImagesVideos(imageOrVideo:img, isImage: true)
                }
            }
            else{
                
            }
            
        }
        
    }
    
    @IBAction func tap_RecordingBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func tap_SendBtn(_ sender: UIButton) {
        self.player?.pause()
        chatTblView.reloadData()
        if !(chatTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            self.SendtextMessage()
            self.btnSend.isHidden = true
            self.buttonSendVoice.isHidden = false
            self.chatTblView.reloadData()
            txtMessageHTConstant.constant = textViewMinHeight
        }else {
            CommonUtils.showToast(message: "Please enter some text")
        }
    }
    
    @IBAction func tap_SearchBtn(_ sender: UIButton) {
        if searchList.count == 0 {
            //CommonUtils.showToast(message:"No searched message found")
            return
        }
        if sender.tag == 1 {//Top btn
            selectedSearchIndex -= 1
            if selectedSearchIndex < 0 {
                selectedSearchIndex = 0
                CommonUtils.showToast(message:"No searched message found")
                return
            }
        }else {//Bottom btn
            selectedSearchIndex += 1
            if selectedSearchIndex >= searchList.count {
                selectedSearchIndex = searchList.count - 1
                CommonUtils.showToast(message:"No searched message found")
                return
            }
        }
        moveToSearchMessage()
    }
    
}

extension ChatViewController: RecordViewDelegate {
    
    func onStart() {
        self.player?.pause()
        chatTblView.reloadData()
        startRecording()
        print("onStart")
        viewSlideToCancel.isHidden = false
        self.view.bringSubviewToFront(viewSlideToCancel)
        viewSlideToCancel.isUserInteractionEnabled = true
    }
    
    func onCancel() {
        isRecordingCancel = true
        stopRecording()
        print("onCancel")
    }
    
    func onFinished(duration: CGFloat) {
        if duration < 60 {
            if duration < 1 {
                isRecordingCancel = true
            }
            stopRecording()
        }
        print("onFinished \(duration)")
        //viewSlideToCancel.isHidden = true
    }
    
    func onAnimationEnd() {
        print("onAnimationEnd")
        self.view.bringSubviewToFront(viewChatInput)
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2 , execute: { [self] in
        
        //            })
    }
}

extension ChatViewController {
    
    func blockUnblockApi(){
        /*
         CommonUtils.showHudWithNoInteraction(show: true)
         let params:[String:Any] = [ApiParameters.kUserId: self.receiverid,
         ApiParameters.kIsBlocked:self.isBlock ? "0" : "1"]
         TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.blockUser,
         requestMethod: .PUT,
         requestParameters: params, withProgressHUD: false)
         { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
         CommonUtils.showHudWithNoInteraction(show: false)
         if errorType == .requestSuccess {
         let dictResult = kSharedInstance.getDictionary(result)
         switch Int.getInt(statusCode) {
         case 200:
         if self.isBlock {
         self.viewBloak.isHidden = true
         self.footerView.isHidden = false
         }else {
         self.viewBloak.isHidden = false
         self.footerView.isHidden = true
         }
         Chat_hepler.Shared_instance.blockUnblocFromRecent(Senderid: self.senderIdStr, Receiverid: String.getString(self.receiverid), status: self.isBlock)
         let story = UIStoryboard.init(name:Storyboards.kPlan, bundle: nil)
         let vc = story.instantiateViewController(withIdentifier: Identifiers.kSuccessPopupVC) as! SuccessPopupVC
         vc.titleStr = self.isBlock ? "User unblocked successfully!" : "User blocked successfully!"
         self.present(vc, animated: true)
         
         default:
         self.showSimpleAlert(message: String.getString(dictResult[kMessage]))
         }
         } else if errorType == .noNetwork {
         self.showSimpleAlert(message: AlertMessage.kNoInternet)
         
         } else {
         self.showSimpleAlert(message: AlertMessage.kDefaultError)
         }
         }*/
    }
    
    fileprivate func postBlockAPI() {
        /*
         let params : [String:String] = [ APIKeys.reciever_id :  self.receiverid,
         APIKeys.sender_id   :  String.getString(self.userDetails[Parameters.user_id])
         ]
         
         CommonUtils.showHudWithNoInteraction(show: true)
         NetworkManager.shared.requestData(serviceName: ServiceName.blockuser, method: .post, parameters: params){dicResponse,statusCode  in
         self.isUserBlocked = true
         ResentUsers.deleteRecordForUser(userid: String.getString(self.receiverid))
         let loggedInUserid = String.getString(self.userDetails[Parameters.user_id])
         let chatId = loggedInUserid < self.receiverid ? "\(String.getString(loggedInUserid))_\(String.getString(self.receiverid))" : "\(String.getString(self.receiverid))_\(String.getString(loggedInUserid))"
         MessageList.deleteMessagesForUser(userid: chatId)
         self.MessageObjList.removeAll()
         self.Messageclass.removeAll()
         self.chatTblView.reloadData()
         Chat_hepler.Shared_instance.deleteChatNode(Senderid: String.getString(self.userDetails[APIKeys.user_id]), Receiverid: String.getString(self.receiverid))
         
         CommonUtils.showToast(message: "Block Successfully")
         
         self.viewBloak.isHidden = false
         self.footerView.isHidden = true
         
         }*/
    }
    
}

// MARK: - UITextViewDelegate Methods
extension ChatViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        //        if !String.getString(textView.text).isEmpty {
        //            self.dismissKeyboard()
        //            //searchMessages(searchText: String.getString(textView.text))
        //        }else {
        //            self.view.endEditing(true)
        //            self.dismissKeyboard()
        //        }
        self.view.endEditing(true)
        self.dismissKeyboard()
    }
    func textViewDidChange(_ textView: UITextView) {
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        print(currentRect.origin.y,"$",previousRect.origin.y)
        if currentRect.origin.y+100 > previousRect.origin.y{
            
            if textView.contentSize.height >= self.textViewMaxHeight {
                txtMessageHTConstant.constant = self.textViewMaxHeight
            }
            else {
                txtMessageHTConstant.constant = max(textViewMinHeight, textView.contentSize.height)
            }
        }
        previousRect = currentRect
        
        if String.getString(textView.text).isEmpty{
            
            btnSend.isSelected = false
            btnSend.isHidden = true
            buttonSendVoice.isHidden = false
        }
        else{
            btnSend.isSelected = true
            btnSend.isHidden = false
            buttonSendVoice.isHidden = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = NSString(string:textView.text).replacingCharacters(in: range, with: text)
        
        //print("changedd")
        
        
        
        if text == "\n" {
            //chatTextView.resignFirstResponder()
            print("newTextt")
            if !(chatTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                //self.player?.pause()
                // chatTblView.reloadData()
                //self.SendtextMessage()
                chatTextView.text = chatTextView.text + "\n"
                
                //txtMessageHTConstant.constant = textViewMinHeight
                return false
            }else {
                //CommonUtils.showToast(message: "Please enter some text")
                chatTextView.resignFirstResponder()
            }
        }
        return true
    }
}

extension ChatViewController {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        if !String.getString(textField.text).isEmpty {
        //            self.dismissKeyboard()
        //            searchMessages(searchText: String.getString(textField.text))
        //        }else {
        //            self.view.endEditing(true)
        //            self.dismissKeyboard()
        //        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if String.getString(textField.text).isEmpty {
            CommonUtils.showToast(message: "Please enter text")
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
}

// MARK: - Extension for Emoji Send
extension ChatViewController : EmojiViewDelegate {
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        self.chatTextView.insertText(emoji)
    }
    
    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        self.chatTextView.inputView = nil
        self.chatTextView.keyboardType = .default
        self.chatTextView.reloadInputViews()
    }
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        self.chatTextView.deleteBackward()
    }
    
    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        self.chatTextView.resignFirstResponder()
        self.chatTextView.inputView = nil
        self.chatTextView.keyboardType = .default
        self.chatTextView.reloadInputViews()
    }
    
}

// MARK: - extension for Pick Pdf from Cloud
extension ChatViewController : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        print(url as URL)
        print(url.lastPathComponent)
        //print(fileSize(forURL: url))
        
        self.sendDocFile(fileURL: url)
        
    }
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func fileSize(forURL url: Any) -> Double {
        var fileURL: URL?
        var fileSize: Double = 0.0
        if (url is URL) || (url is String)
        {
            if (url is URL) {
                fileURL = url as? URL
            }
            else {
                fileURL = URL(fileURLWithPath: url as! String)
            }
            var fileSizeValue = 0.0
            try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
            if fileSizeValue > 0.0 {
                fileSize = (Double(fileSizeValue) / (1024 * 1024))
            }
        }
        return fileSize
    }
    
}

extension ChatViewController:GiphyDelegate{
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        //        let gifURL : String = String.getString(media.url)
        //      https://giphy.com/embed/L1VXD3bEo3Uelzk6EF
        let gifURL : String = "https://media2.giphy.com/media/" + (media.id) + "/giphy.gif"
        
        //        let imageURL = UIImage.gifImageWithURL(gifUrl: gifURL)
        //        let imageView3 = UIImageView(image: imageURL)
        //        self.selectedGif = gifURL
        //        self.selectedMedia = 3
        //
        //        self.videoUrl = nil
        //        self.selectedvideo = Data()
        //        self.selectedImage = UIImage()
        //        imageView3.frame = CGRect(x: 0.0, y: 0.0, width: self.mediaView.frame.size.width, height: self.mediaView.frame.size.height)
        //        self.mediaView.addSubview(imageView3)
        giphyViewController.dismiss(animated: true, completion: {
            self.sendGif(url: gifURL)
        })
    }
    
    func didDismiss(controller: GiphyViewController?) {
        // your user dismissed the controller without selecting a GIF.
    }
}

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        return lastIndexPath == indexPath
    }
}
