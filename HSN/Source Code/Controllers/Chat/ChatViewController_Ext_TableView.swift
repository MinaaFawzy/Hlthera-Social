//
//  ChatViewController_Ext_TableView.swift
//  RippleApp
//
//  Created by Mohd Aslam on 29/04/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage

extension ChatViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.MessageObjList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = self.MessageObjList[section].messages
        print("Count \(arr.count)")
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        //Media Type Check for type for Cell  , 1 = text , 2- image , 3 - Video , 4 - Pdf , 5 = Location Share Celll
        let obj = self.MessageObjList[indexPath.section].messages[indexPath.row]
        if obj.isInvalidated {
            return UITableViewCell()
        }
        if obj.Senderid == String.getString(UserData.shared.id) {
            
            if obj.mediatype == "call" {
                return UITableViewCell()
            }else if obj.mediatype == "text" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifiers.SendertextCell, for: indexPath) as? SendertextCell else{return UITableViewCell()}
                cell.selectionStyle = .none
                cell.lblMsgTrailingConstraint.constant = 15
                cell.btnDelete.isHidden = true
               // cell.profile_image.image = self.senderProfileImage.image
                cell.lblMessage.text = String.getString(obj.Message)
                cell.lblMessage.backgroundColor = .clear
                if isSearchOn {
                    let msgId = String.getString(obj.uid)
                    if searchList.contains(msgId) {
                        cell.lblMessage.backgroundColor =  UIColor(red: 254/255, green: 177/255, blue: 61/255, alpha: 1)
                    }
                }
                cell.lbltime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                
//                cell.tickImgView.isHidden = false
//                if String.getString(obj.status) == "seen" {
//                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
//                }else if String.getString(obj.status) == "sent" {
//                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
//                }else {
//                    cell.tickImgView.isHidden = true
//                }
                
            //CALL BACK FOR Delete Message
                
                cell.DeleteCallBack = {
                    
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                      //  controller.dismiss(animated: true, completion: nil)
                    })
//                    let story = UIStoryboard(name: Storyboards.kHome, bundle: nil)
//                    let controller = story.instantiateViewController(withIdentifier: AlertConfirmationVC.getStoryboardID()) as! AlertConfirmationVC
//                    controller.alertDesc = "Are you sure want to delete?"
//                    controller.modalTransitionStyle = .crossDissolve
//                    controller.modalPresentationStyle = .overFullScreen
//                        self.present(controller, animated: true) {
//                            controller.yesCallback = {
//                                self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid: String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
//                                self.isDeleted = true
//                                MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
//                                CommonUtils.showToast(message: "message was deleted")
//                                controller.dismiss(animated: true, completion: nil)
//                            }
//                        }
                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    //cell.viewBg.roundCorners([.bottomLeft,.bottomRight, .topLeft], radius: 20)
                cell.viewBg.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
                cell.viewBg.layer.cornerRadius = 20
//                }
                return cell
            } else if obj.mediatype == "photos" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                cell.selectionStyle = .none
                cell.imgTrailingConstraint.constant = 15
                //cell.profile_image.image = self.senderProfileImage.image
//                cell.sendimageView.sd_setImage(with: URL(string: String.getString(obj.imageurl)), placeholderImage: #imageLiteral(resourceName: "dummy_profile"), options: .highPriority, completed: nil)
     
                cell.sendimageView?.downlodeImage(serviceurl: String.getString(obj.imageurl), placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                
                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                
//                cell.tickImgView.isHidden = false
//                if String.getString(obj.status) == "seen" {
//                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
//                }else if String.getString(obj.status) == "sent" {
//                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
//                }else {
//                    cell.tickImgView.isHidden = true
//                }
                
                //OPEN IMAGE
//                cell.openImageCallBack = {
//                    self.player?.pause()
//                    let imageScreen = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewVC") as! ImageViewVC
//                    imageScreen.imageString = String.getString(obj.imageurl)
//                    imageScreen.Messageclass = self.Messageclass
//                    imageScreen.selectedMessage = String.getString(obj.uid)
//                    if #available(iOS 13.0, *) {
//                        imageScreen.modalPresentationStyle = .currentContext
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                    self.present(imageScreen, animated: true, completion: nil)
//                    self.chatTblView.reloadData()
//                }
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                      //  controller.dismiss(animated: true, completion: nil)
                    })
                }
                
                return cell
            }
            else if obj.mediatype == "videos" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderVideoCell", for: indexPath) as! SenderVideoCell
                cell.selectionStyle = .none
                cell.imgTrailingConstraint.constant = 15
//                VideoPickerHelper.shared.thumbnil(url: URL(string: String.getString(obj.Message))!, completionClosure: {image in
//                    cell.sendimageView.image = image
//                })
                AVAsset(url: URL(string: String.getString(obj.Message))!).generateThumbnail { [weak self] (image) in
                               DispatchQueue.main.async {
                                   guard let image = image else { return }
                                cell.sendimageView.image = image
                               }
                           }
               // cell.sendimageView.sd_setImage(with: URL(string: String.getString(obj.Message)), placeholderImage: nil, options: .highPriority, completed: nil)
                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                
                cell.tickImgView.isHidden = false
                if String.getString(obj.status) == "seen" {
                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
                }else if String.getString(obj.status) == "sent" {
                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
                }else {
                    cell.tickImgView.isHidden = true
                }
                
                
                
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                      //  controller.dismiss(animated: true, completion: nil)
                    })
                  
                
                }
                
                //CALL Back for Play Video
                cell.playVideo = {
                    self.player?.pause()
                    let videoURL = NSURL(string:  "\(String.getString(obj.mediaurl))")
                    let player = AVPlayer(url: videoURL! as URL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.modalTransitionStyle = .crossDissolve
                    playerViewController.modalPresentationStyle = .overFullScreen
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                    self.chatTblView.reloadData()
                }
                
                return cell
            } else if obj.mediatype == "audio" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderAudioCell", for: indexPath) as! SenderAudioCell
                cell.selectionStyle = .none
                cell.indicatorView.color = UIColor(named: "5")!
                cell.viewTrailingConstraint.constant = 15
                cell.viewBg.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
                cell.viewBg.layer.cornerRadius = 20
                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                cell.tickImgView.isHidden = false
                if String.getString(obj.status) == "seen" {
                    cell.tickImgView.image = UIImage(named: "chat_doubleTick")
                }else if String.getString(obj.status) == "sent" {
                    cell.tickImgView.image = UIImage(named: "chat_singleTick")
                }else {
                    cell.tickImgView.isHidden = true
                }
                if cell.indicatorView.isAnimating {
                    cell.indicatorView.stopAnimating()
                    cell.imageWave.isHidden = false
                    self.playerTimer.invalidate()
                    cell.labelTime.isHidden = true
                    
                    
                }
                cell.indicatorView.isHidden = true
                cell.playBtn.isSelected = false
                cell.playBtn.backgroundColor = CustomColor.kSenderPlay
                //cell.lblName.isHidden = false
                self.isPlaying = false
                self.player?.pause()
                let url = URL(string: obj.mediaurl ?? "")
                let fileName =  url?.lastPathComponent ?? ""
                let path = CommonUtils.getDocumentDirectoryPath() + "/\(fileName).m4a";
                if fileManager.fileExists(atPath: path) {
                    cell.playBtn.isHidden = false
                    cell.saveBtn.isHidden = true
                }else {
                    cell.playBtn.isHidden = true
                    cell.saveBtn.isHidden = false
                }
                cell.lblName.text = fileName
                
                cell.saveCallback = {
                    CommonUtils.showHudWithNoInteraction(show: true)
                    CommonUtils.saveFileToDocumentDirectory(url: url, fileName: "/\(fileName).m4a") { (success) in
                        if success ?? false {
                            cell.playBtn.isHidden = false
                            cell.saveBtn.isHidden = true
                            CommonUtils.showToast(message: "Saved Success")
                        }
                        CommonUtils.showHudWithNoInteraction(show: false)
                    }
                }
                
                cell.playCallback = {
                    
                    let playerItem:AVPlayerItem = AVPlayerItem(url: CommonUtils.getFileUrl(fileName: "/\(fileName).m4a"))
                  
                    self.player = AVPlayer(playerItem: playerItem)
                    
                   
                   
                    
                    //obj.isSongPlayed = !obj.isSongPlayed
                    
                    
                    
                    if !self.isPlaying{
                        
                        //obj.isSongPlayed  = false
                        cell.playBtn.isSelected = true
                        cell.indicatorView.isHidden = false
                        cell.indicatorView.startAnimating()
                        self.isPlaying = true
                        cell.playBtn.backgroundColor = .clear
                       // cell.lblName.isHidden = true
                        cell.imageWave.isHidden = true
                        self.player!.play()
                        cell.labelTime.isHidden = false
                        
                    
                        self.playerTimer =  Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { timer in

                            if self.player!.currentItem?.status == .readyToPlay {

                                let timeElapsed = CMTimeGetSeconds(self.player!.currentTime())

                                let totalTime = self.player!.currentItem?.asset.duration
                                let totalTimeDuration = CMTimeGetSeconds(totalTime!)
                                let secs = Int(timeElapsed)
                                var currenTime = timeElapsed
                                var currenTimeString = NSString(format: "%02d:%02d", secs/60, secs%60) as String
                                var totalTimeString = NSString(format: "%02d:%02d", Int(totalTimeDuration)/60, Int(totalTimeDuration)%60) as String


                                cell.labelTime.text = (currenTimeString) + "/" + totalTimeString

                            }
                        }
                        
                        
                        
                        
                        
                       
                        
                        
                        
                        
                        
                        
                    }else{
                        //obj.isSongPlayed  = true
                        cell.playBtn.isSelected = false
                        cell.indicatorView.isHidden = true
                        cell.indicatorView.color = UIColor(named: "5")!
                        cell.indicatorView.stopAnimating()
                        cell.imageWave.isHidden = false
                        self.playerTimer.invalidate()
                        self.isPlaying = false
                        cell.playBtn.backgroundColor = CustomColor.kSenderPlay
                        //cell.lblName.isHidden = false
                        cell.imageWave.isHidden = false
                        self.player!.pause()
                        self.playerTimer.invalidate()
                        cell.labelTime.isHidden = true
                    }
                    
                    
                }
                
                //DELETE
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        print(self.CreatedBy)
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                      //  controller.dismiss(animated: true, completion: nil)
                    })
                }
                
                
                return cell
            }else if obj.mediatype == "doc" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderDocumentCell", for: indexPath) as! SenderDocumentCell
                cell.selectionStyle = .none
                cell.imgTrailingConstraint.constant = 15
                //cell.profile_image.image = self.senderProfileImage.image
                cell.labelDocName.text = String.getString(URL(string: obj.Message!)?.lastPathComponent)
                cell.labelTime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                let url = String.getString(obj.thumnilimageurl)
              //  cell.imageDoc?.downlodeImage(serviceurl: url, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.viewDocumentCallBack = { [weak self] in
                    self?.openDocumentFile(mediaurl:  kBucketUrl + String.getString(obj.Message), mediaName: String.getString(URL(string: obj.Message!)?.lastPathComponent))
                }
                
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                 
                }
                
                return cell
            }
            else if obj.mediatype == "gif" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderGifCell", for: indexPath) as! SenderGifCell
                cell.selectionStyle = .none
                cell.imgTrailingConstraint.constant = 15
                //cell.profile_image.image = self.senderProfileImage.image
                
                let url = URL(string: String.getString(obj.Message))
                let loader = UIActivityIndicatorView(style: .white)
                cell.imageGif.setGifFromURL(url!, customLoader: loader)
                
//                do {
//                    let gif = try UIImage(gifName: "success.gif")
//                    DispatchQueue.main.async {
//                        let imageview = UIImageView(gifImage: gif, loopCount: 1) //Use -1 for infinite loop
//                        imageview.contentMode = .scaleAspectFill
//                        imageview.frame = cell.viewGIF.bounds
//                        cell.viewGIF.addSubview(imageview)
//                    }
//                } catch {
//                    print(error)
//                }
                cell.labelTime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                //let url = String.getString(obj.thumnilimageurl)
              //  cell.imageDoc?.downlodeImage(serviceurl: url, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
               
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                  
                }
                
                return cell
            }
            else {
                return UITableViewCell()
            }
        } else {
            let notSubscribedCell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionNotPurchasedTableViewCell", for: indexPath) as! SubscriptionNotPurchasedTableViewCell
           // if kSharedUserDefaults.getUserRole() == "BORROWER"{
//                if !UserData.shared.isPlanPurchased{
//                    return notSubscribedCell
//                }
          //  }
            if obj.mediatype == "text" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Receivertextcell", for: indexPath) as! Receivertextcell
                cell.selectionStyle = .none
                cell.lblMsgTrailingConstraint.constant = 15
                cell.btnDelete.isHidden = true
               // cell.profile_image.image = self.userImgView.image
                cell.lblMessage.text = String.getString(obj.Message)
                cell.lblMessage.backgroundColor = .clear
                if isSearchOn {
                    let msgId = String.getString(obj.uid)
                    if searchList.contains(msgId) {
                        cell.lblMessage.backgroundColor = UIColor(red: 254/255, green: 177/255, blue: 61/255, alpha: 1)
                    }
                }
              
                cell.chatBoxView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
                cell.chatBoxView.layer.cornerRadius = 15
                cell.lbltime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        
                        self.CreatedBy == Parameters.emptyString ? Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                   
                
                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    cell.chatBoxView.roundCorners([.bottomLeft,.bottomRight, .topRight], radius: 20)
//                }
               
                    return cell
                
                
                
            } else if obj.mediatype == "photos" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell", for: indexPath) as! ReceiverImageCell
                cell.selectionStyle = .none
                cell.imageLeadingConstraint.constant = 15
                cell.viewSaveImage.isHidden = true
               // cell.profileImgView.image = self.userImgView.image
               // cell.receiveimageView.loadImageAsync(with: String.getString(obj.imageurl), placeholderImage: nil)
                cell.receiveimageView?.downlodeImage(serviceurl: String.getString(obj.imageurl), placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                // cell.receiveimageView.addFilter(filter: FilterType.Noir)
                
                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                
                
                //OPEN IMAGE
//                cell.openImageCallBack = {
//                    self.player?.pause()
//                    let imageScreen = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewVC") as! ImageViewVC
//                    imageScreen.imageString = String.getString(obj.imageurl)
//                    imageScreen.Messageclass = self.Messageclass
//                    imageScreen.selectedMessage = String.getString(obj.uid)
//                    if #available(iOS 13.0, *) {
//                        imageScreen.modalPresentationStyle = .currentContext
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                    self.present(imageScreen, animated: true, completion: nil)
//                    self.chatTblView.reloadData()
//                }
                
                //Save Image
                cell.saveImageCallBack = {
                    cell.viewSaveImage.isHidden = true
                    guard let image = cell.receiveimageView.image else { return }
                    CommonUtils.showHudWithNoInteraction(show: true)
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                 
                }
                return cell
                
            }
            else if obj.mediatype == "videos" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverVideoCell", for: indexPath) as! ReceiverVideoCell
                cell.selectionStyle = .none
                cell.imageLeadingConstraint.constant = 15
                cell.viewSaveVideo.isHidden = true
                
                cell.receiveimageView.sd_setImage(with: URL(string: String.getString(obj.Message)), placeholderImage: nil, options: .highPriority, completed: nil)
                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                                
                //Save Video
                cell.saveVideoCallBack = {
                    cell.viewSaveVideo.isHidden = true
                    CommonUtils.downloadVideo(url: String.getString(obj.mediaurl))
                }
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                }
                
                //CALL Back for Play Video
                cell.playVideo = {
                    self.player?.pause()
                    
                    let videoURL = NSURL(string: "\(String.getString(obj.mediaurl))")
                    let player = AVPlayer(url: videoURL! as URL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.modalTransitionStyle = .crossDissolve
                    playerViewController.modalPresentationStyle = .overFullScreen
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                    self.chatTblView.reloadData()
                }
                return cell
            }else if obj.mediatype == "audio" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverAudioCell", for: indexPath) as! ReceiverAudioCell
                cell.selectionStyle = .none
                cell.viewBg.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
                cell.viewBg.layer.cornerRadius = 15
                cell.viewLeadingConstraint.constant = 15
                cell.time.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                
                if cell.indicatorView.isAnimating {
                    cell.indicatorView.stopAnimating()
                    cell.imageWave.isHidden = false
                    self.playerTimer.invalidate()
                    cell.labelTime.isHidden = true
                }
                cell.indicatorView.isHidden = true
                cell.indicatorView.color = .white
                cell.playBtn.isSelected = false
                self.isPlaying = false
                cell.playBtn.backgroundColor = CustomColor.kReceiverPlay
                //cell.lblName.isHidden = false
                self.player?.pause()
                let url = URL(string: obj.mediaurl ?? "")
                let fileName =  url?.lastPathComponent ?? ""
                let path = CommonUtils.getDocumentDirectoryPath() + "/\(fileName).m4a";
                if fileManager.fileExists(atPath: path) {
                    cell.playBtn.isHidden = false
                    cell.saveBtn.isHidden = true
                }else {
                    cell.playBtn.isHidden = true
                    cell.saveBtn.isHidden = false
                }
                cell.lblName.text = fileName
                
                cell.saveCallback = {
                    CommonUtils.showHudWithNoInteraction(show: true)
                    CommonUtils.saveFileToDocumentDirectory(url: url, fileName: "/\(fileName).m4a") { (success) in
                        if success ?? false {
                            cell.playBtn.isHidden = false
                            cell.saveBtn.isHidden = true
                        }
                        CommonUtils.showHudWithNoInteraction(show: false)
                    }
                }
                
                cell.playCallback = {
                    
                    let playerItem:AVPlayerItem = AVPlayerItem(url: CommonUtils.getFileUrl(fileName: "/\(fileName).m4a"))
                    self.player = AVPlayer(playerItem: playerItem)
                    //obj.isSongPlayed = !obj.isSongPlayed
                    
                    
                    if !self.isPlaying{
                        //obj.isSongPlayed  = false
                        cell.playBtn.isSelected = true
                        cell.indicatorView.isHidden = false
                        cell.indicatorView.startAnimating()
                        self.isPlaying = true
                        cell.playBtn.backgroundColor = .clear
                        //cell.lblName.isHidden = true
                        cell.imageWave.isHidden = true
                        self.playerTimer =  Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { timer in
                            cell.labelTime.isHidden = false
                            if self.player!.currentItem?.status == .readyToPlay {

                                let timeElapsed = CMTimeGetSeconds(self.player!.currentTime())

                                let totalTime = self.player!.currentItem?.asset.duration
                                let totalTimeDuration = CMTimeGetSeconds(totalTime!)
                                let secs = Int(timeElapsed)
                                var currenTime = timeElapsed
                                var currenTimeString = NSString(format: "%02d:%02d", secs/60, secs%60) as String
                                var totalTimeString = NSString(format: "%02d:%02d", Int(totalTimeDuration)/60, Int(totalTimeDuration)%60) as String


                                cell.labelTime.text = (currenTimeString) + "/" + totalTimeString

                            }
                        }

                        self.player!.play()
                        
                    }else{
                        //obj.isSongPlayed  = true
                        cell.playBtn.isSelected = false
                        cell.indicatorView.isHidden = true
                        cell.indicatorView.stopAnimating()
                        cell.imageWave.isHidden = false
                        self.playerTimer.invalidate()
                        cell.labelTime.isHidden = true
                        self.isPlaying = false
                        cell.playBtn.backgroundColor = CustomColor.kReceiverPlay
                        //cell.lblName.isHidden = false
                        self.player!.pause()
                        self.playerTimer.invalidate()
                    }
                    
                    
                }
                
                //DELETE
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(self.userDetails[Parameters.user_id]), Receiverid: String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        print(self.CreatedBy)
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                 
                }
                
                return cell
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
               
            }else if obj.mediatype == "doc" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverDocumentCell", for: indexPath) as! ReceiverDocumentCell
                cell.selectionStyle = .none
                cell.imageLeadingConstraint.constant = 15
                
                cell.labelDocName.text = String.getString(URL(string: obj.Message!)?.lastPathComponent)
                cell.labelTime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                let url = String.getString(obj.thumnilimageurl)
                cell.imageDoc.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .highPriority, completed: nil)
                cell.viewDocumentCallBack = { [weak self] in
                    self?.openDocumentFile(mediaurl: kBucketUrl + String.getString(obj.Message), mediaName: String.getString(URL(string: obj.Message!)?.lastPathComponent))
                }
                
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                }
                
                return cell
            }
            else if obj.mediatype == "gif" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverGifCell", for: indexPath) as! ReceiverGifCell
                cell.selectionStyle = .none
                cell.imgTrailingConstraint.constant = 15
                //cell.profile_image.image = self.senderProfileImage.image
                
                let url = URL(string: String.getString(obj.Message))
                let loader = UIActivityIndicatorView(style: .white)
                cell.imageGif.setGifFromURL(url!, customLoader: loader)
                
//                do {
//                    let gif = try UIImage(gifName: "success.gif")
//                    DispatchQueue.main.async {
//                        let imageview = UIImageView(gifImage: gif, loopCount: 1) //Use -1 for infinite loop
//                        imageview.contentMode = .scaleAspectFill
//                        imageview.frame = cell.viewGIF.bounds
//                        cell.viewGIF.addSubview(imageview)
//                    }
//                } catch {
//                    print(error)
//                }
                cell.labelTime.text = String.getString(Chat_hepler.Shared_instance.getTime(timeStamp: Double.getDouble(obj.SendingTime)))
                //let url = String.getString(obj.thumnilimageurl)
              //  cell.imageDoc?.downlodeImage(serviceurl: url, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
               
                //CALL BACK FOR Delete Message
                cell.DeleteCallBack = {
                    CommonUtils.showDeleteAlert(title: "Delete Message", message: "Are you sure want to delete?", completion: {
                        
                        
                        self.CreatedBy == Parameters.emptyString ?  Chat_hepler.Shared_instance.deleteMessage(Senderid: String.getString(UserData.shared.id), Receiverid:String.getString(self.receiverid), uid: String.getString(obj.uid)) :Chat_hepler.Shared_instance.deletemessagefromgroup(groupid: String.getString(self.receiverid), uid: String.getString(obj.uid), Senderid: String.getString(self.userDetails[Parameters.user_id]))
                        
                        self.isDeleted = true
                        MessageList.deletePerticularMessage(msgId: String.getString(obj.uid))
                        CommonUtils.showToast(message: "message was deleted")
                    })
                  
                }
                
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = .clear
        
        
        let headerLabel = UILabel.init(frame: CGRect(x: (UIScreen.main.bounds.width-110)/2, y: 5, width: 110, height: 25))
        headerLabel.backgroundColor = .white
        headerLabel.textAlignment = .center
        headerLabel.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        headerLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)!
        view.addSubview(headerLabel)
        headerLabel.drawShadow()
        headerLabel.cornerRadius = 10
        headerLabel.clipsToBounds = true
        let timeStamp = self.MessageObjList[section].SendingTime
        let date1 = timeStamp.dateFromTimeStamp()
        if date1.isToday() {
            headerLabel.text = "Today"
        }else if date1.isYesterday() {
            headerLabel.text = "Yesterday"
        }else {
            let dateStr1  = date1.toString(withFormat: "dd MMM YYYY")
            headerLabel.text = dateStr1
        }
        
        return view
    }

}
