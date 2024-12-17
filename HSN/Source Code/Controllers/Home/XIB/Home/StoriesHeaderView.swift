//
//  StoriesHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 22/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import AVFoundation

class StoriesHeaderView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var viewStories: UIView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var labelStoryTagline: UILabel!
//    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var labelStoriesSubHeading: UILabel!
    
    var storyMedia: [Any] = []
    var seconds: Int = 1
    var timer = Timer()
    var data: IGStories?
    var nav: UINavigationController?
    
    func updateData(stories: IGStories?, nav: UINavigationController?) {
        self.nav = nav
        self.data = stories
        self.storiesCollectionView.delegate = self
        self.storiesCollectionView.dataSource = self
        storiesCollectionView.register(UINib(nibName: StoryCVC.identifier, bundle: nil), forCellWithReuseIdentifier: StoryCVC.identifier)
        storiesCollectionView.register(UINib(nibName: DocumentVC.identifier, bundle: nil), forCellWithReuseIdentifier: DocumentVC.identifier)
        storiesCollectionView.register(IGStoryListCell.self, forCellWithReuseIdentifier: IGStoryListCell.reuseIdentifier)
        viewStories.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        viewStories.cornerRadius1 = 15
        viewStories.drawShadow()
        //self.exploreCollectionView.reloadData()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(seconds)
        self.seconds -= 1
        if seconds <= 0 {
            
            //self.labelStoryTagline.text = "Hi, \(String.getString(UserData.shared.first_name.capitalized))"
            //UIView.animate(withDuration: 0.35, delay: 0, options: [.transitionCrossDissolve]) {
            //self.labelStoryTagline.layoutIfNeeded()
            //}
            timer.invalidate()
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.labelStoryTagline.alpha = 0.5
                self.labelStoryTagline.alpha = 0.0
                let sentence = "Hi, " + "\(String.getString(UserData.shared.full_name.capitalized))"
                let attributedString = NSMutableAttributedString(string: sentence)
                // Set font and color for the word "sentence"
                let sentenceRange = (sentence as NSString).range(of: "Hi,")
                let sentenceFont = UIFont.SFDisplayRegular(fontSize: 19)
                let sentenceAttributes: [NSAttributedString.Key: Any] = [
                    .font: sentenceFont,
                    .foregroundColor: UIColor(red: 30, green: 63, blue: 108, transparency: 1)
                ]
                attributedString.addAttributes(sentenceAttributes, range: sentenceRange)

                // Use the attributed string in a label or text view
                self.labelStoryTagline.attributedText = attributedString
                self.labelStoriesSubHeading.isHidden = true
            }, completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.labelStoryTagline.alpha = 1.0
            }, completion: nil)
        }
    }
}

extension StoriesHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = data?.otherStoriesCount {
            return count + 1
        }
        return 1
        //return exploreOptions.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let obj = data
        if indexPath.row == 0 && data?.myStory.first?.snapsCount < 1  {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCVC.identifier, for: indexPath) as! StoryCVC
            
            // cell.userDetails = ("Create Story",UserData.shared.profile_pic)
            cell.imageCreatePost.isHidden = false
            cell.labelName.text = "Create Story"
            // cell.imageStory.downlodeImage(serviceurl: , placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
            cell.imageStory.kf.setImage(with: URL(string: kBucketUrl + UserData.shared.profile_pic),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            if let profilePic = obj?.myStory.first?.profile_pic{
                // cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + profilePic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.imageProfile.kf.setImage(with: URL(string: kBucketUrl + profilePic))
            }
            return cell
        }else if indexPath.row == 0 && data?.myStory.first?.snapsCount > 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCVC.reuseIdentifier,for: indexPath) as? StoryCVC else { fatalError() }
            let obj = data
            
            cell.labelName.text = String.getString(obj?.myStory.first?.full_name).capitalized
            if let picture = obj?.myStory.first?.snaps[0].url {
                if let firstPicURL = URL(string: picture){
                    let imageExtensions = ["png", "jpg", "gif","jpeg"]
                    let documentExtensions = ["pdf","rtf","txt"]
                    let pathExtention = firstPicURL.pathExtension
                    if imageExtensions.contains(pathExtention) {
                        //cell.imageStory.downlodeImage(serviceurl: kBucketUrl + picture, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                        cell.imageStory.kf.setImage(with: URL(string:  picture),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
                    } else {
                        DispatchQueue.main.async {
                            
                            AVAsset(url:firstPicURL).generateThumbnail { [weak self] (image) in
                                DispatchQueue.main.async {
                                    guard let image = image else { return }
                                    cell.imageStory.image = image
                                }
                            }
                            //cell.imageStory.image = obj?.myStory?.snaps[0].downloadedVideoImage
                        }
                    }
                }
            }
            if let profilePic = obj?.myStory.first?.profile_pic {
                //cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + profilePic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.applyGradient()
                cell.imageProfile.kf.setImage(with: URL(string: kBucketUrl + profilePic),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            }
            cell.imageCreatePost.isHidden = true
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCVC.reuseIdentifier,for: indexPath) as? StoryCVC else { fatalError() }
            let obj = data?.otherStories[indexPath.row-1]
            cell.labelName.text = String.getString(obj?.full_name)
            if let picture = obj?.snaps[0].url {
                // cell.imageStory.downlodeImage(serviceurl: kBucketUrl + picture, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.imageStory.kf.setImage(with: URL(string:  picture),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            }
            if let profilePic = obj?.user.picture{
                //cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + profilePic, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
                cell.imageProfile.kf.setImage(with: URL(string: profilePic),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            }
            cell.imageCreatePost.isHidden = true
            return cell
        }
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCVC.identifier, for: indexPath) as! ExploreCVC
        //        let obj = exploreOptions[indexPath.row]
        //        cell.labelName.text = obj.name
        //        cell.viewBackground.backgroundColor = .white
        //        cell.viewBackground.layer.cornerRadius = 10
        //
        //
        //        if obj.isSelected{
        //            cell.labelName.textColor = UIColor(named: "10")!
        //            cell.viewBackground.backgroundColor = UIColor(named: "5")!
        //            cell.imageIcon.kf.setImage(with: URL(string: kBucketUrl + obj.activeImage),placeholder:  #imageLiteral(resourceName: "profile_placeholder"))
        //            //cell.imageIcon.image = obj.localImageActive
        //        }
        //        else{
        //            cell.labelName.textColor = UIColor(named: "5")!
        //            //cell.viewBackground.backgroundColor = UIColor(named: "10")!
        //            cell.viewBackground.backgroundColor = .white
        //            cell.imageIcon.kf.setImage(with: URL(string: kBucketUrl + obj.inActiveImage),placeholder:  #imageLiteral(resourceName: "profile_placeholder"))
        //            //cell.imageIcon.image = obj.localImageInActive
        //        }
        //        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = data
        if indexPath.row == 0 && obj?.myStory.first?.snapsCount < 1 {
            ImagePickerHelper.shared.showGalleryPickerController(maxLength: 60){ [weak self] data in
                guard let self = self else { return }
                if data is UIImage {
                    // self.myProtocal?.selectedMedia(fileUrl: data,postType: 5,image:data as! UIImage,id: -1,other: "")
                    self.storyMedia = [data as! UIImage]
                    self.createStory()
                } else {
                    let asset = AVAsset(url: data as! URL)
                    let duration = asset.duration
                    let durationTime = CMTimeGetSeconds(duration)
                    if durationTime <= 60 {
                        VideoPickerHelper.shared.thumbnil(url:data as! URL , completionClosure: { [weak self] imageThumbnail in
                            guard let self = self else { return }
                            //self.myProtocal?.selectedMedia(fileUrl: data as! URL,postType: 5, image: imageThumbnail as! UIImage,id: -1,other: "")
                            self.storyMedia = [data as! URL]
                            self.createStory()
                        })
                    } else {
                        CommonUtils.showToast(message: "Please Select another Video which is shorter than 60 seconds")
                        return
                    }
                }
            }
        } else if indexPath.row == 0 && obj?.myStory.first?.snapsCount > 0 {
            isDeleteSnapEnabled = true
            DispatchQueue.main.async {
                if let stories = obj, let stories_copy = try? stories.copy().myStory, stories_copy.count > 0 && stories_copy[0].snaps.count > 0 {
                    let storyPreviewScene = IGStoryPreviewController.init(stories: stories_copy, handPickedStoryIndex: indexPath.row, handPickedSnapIndex: 0)
                    
                    storyPreviewScene.modalTransitionStyle = .crossDissolve
                    storyPreviewScene.modalPresentationStyle = .overFullScreen
                    self.nav?.present(storyPreviewScene, animated: true, completion: nil)
                } else {
                    print("none")
                }
            }
        } else {
            DispatchQueue.main.async {
                if let stories = self.data, let stories_copy = try? stories.copy().otherStories {
                    let storyPreviewScene = IGStoryPreviewController.init(stories: stories_copy, handPickedStoryIndex:  indexPath.row-1, handPickedSnapIndex: 0)
                    storyPreviewScene.modalTransitionStyle = .crossDissolve
                    storyPreviewScene.modalPresentationStyle = .overFullScreen
                    isDeleteSnapEnabled = false
                    self.nav?.present(storyPreviewScene, animated: true,completion: nil)
                }
            }
        }
        //            let res = self.exploreOptions.filter{$0.isSelected}
        //            if exploreOptions[indexPath.row].isSelected{
        //                self.exploreOptions[indexPath.row].isSelected = false
        //                self.selectedPostType = ""
        //                self.updateData()
        //            }
        //            else if res.count > 0{
        //                self.exploreOptions.map{$0.isSelected = false}
        //                self.exploreOptions[indexPath.row].isSelected = true
        //                self.selectedPostType = exploreOptions[indexPath.row].id
        //                self.updateData()
        //
        //            }
        //            else{
        //                self.exploreOptions[indexPath.row].isSelected = !self.exploreOptions[indexPath.row].isSelected
        //                self.selectedPostType = exploreOptions[indexPath.row].id
        //                self.updateData()
        //            }
        //            self.exploreCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row == 0 ? CGSize(width: 100, height: 100) : CGSize(width: 80, height: 100)
        //            if collectionView == storiesCollectionView{
        //
        //            }
        //            else{
        //                return CGSize(width: 100, height: 50)
        //            }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 100, height: 100)
    //    }
    
}

extension StoriesHeaderView {
    
    func createStory() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String: Any] = [:]
        var images:[[String: Any]] = []
        var documents:[[String: Any]] = []
        var videos:[String: Any] = [:]
        for data in storyMedia {
            if data is UIImage {
                images.append(["imageName":ApiParameters.mediaUpload,"image":data])
            } else if data is URL {
                let imageExtensions = ["png", "jpg", "gif","jpeg"]
                let documentExtensions = ["pdf"]
                //...
                // Iterate & match the URL objects from your checking results
                let url: URL = data as! URL
                let pathExtention = url.pathExtension
                if imageExtensions.contains(pathExtention) {}
                else if documentExtensions.contains(pathExtention) {
                    documents.append(["documentName":ApiParameters.mediaUpload,"document":data])
                } else {
                    videos = [ApiParameters.kvideo : data, ApiParameters.kvideoName : ApiParameters.mediaUpload]
                }
            }
        }
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.add_story, method: .post, arrImages: images, video: videos,document: documents,  parameters: params)
        { [weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["type_of_post"])
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    kSharedAppDelegate?.moveToHomeScreen()
                    
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
    
}
