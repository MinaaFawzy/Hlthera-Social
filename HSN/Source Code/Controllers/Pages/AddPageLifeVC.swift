//
//  AddPageLifeVC.swift
//  HSN
//
//  Created by Prashant Panchal on 30/11/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVKit
import Photos
import PhotosUI

class AddPageLifeVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var buttonDeleteMainMedia: UIButton!
    @IBOutlet weak var imageMainMedia: UIImageView!
    @IBOutlet weak var switchCompanyDetails: UISwitch!
    @IBOutlet weak var textFieldCompanyHeadline: UITextField!
    @IBOutlet weak var textViewContent: IQTextView!
    @IBOutlet weak var collectionViewLeaders: UICollectionView!
    @IBOutlet weak var tableViewSpotlight: UITableView!
    @IBOutlet weak var constraintTableViewSpotlightHeight: NSLayoutConstraint!
    @IBOutlet weak var switchCompanyPhotos: UISwitch!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var switchTestimonials: UISwitch!
    @IBOutlet weak var tableViewTestimonials: UITableView!
    @IBOutlet weak var constraintTableViewTestimonialsHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonCreateLife: UIButton!
    @IBOutlet weak var buttonPlayVideo: UIButton!
    @IBOutlet weak var labelPageTitle: UILabel!
    
    var pageId = ""
    
    var footerView:PageModuleFooterView?
    var footerView1:PageModuleFooterView?
    var productImages:[Any] = []{
        didSet{
            self.collectionViewPhotos.reloadData()
        }
    }
    var modules:[PageSpotlightModuleModel] = [PageSpotlightModuleModel(data: [:])]
    var testimonials:[PageTestimonialModel] = [PageTestimonialModel(data: [:])]
    var mainVideoLocalURL:URL?
    var mainMediaURL:String = ""
    var hasCameFrom:HasCameFrom = .none
    var leaders:[AllUserModel] = [AllUserModel(data: [:]),AllUserModel(data: [:]),AllUserModel(data: [:]),AllUserModel(data: [:])]
    var data:PageLifeModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    func initialSetup(){
        self.collectionViewLeaders.delegate = self
        self.collectionViewLeaders.dataSource = self
        self.collectionViewLeaders.register(PageLifeLeaderCVC.nib, forCellWithReuseIdentifier: PageLifeLeaderCVC.identifier)
        self.collectionViewLeaders.register(ViewPageLifeLeaderCVC.nib, forCellWithReuseIdentifier: ViewPageLifeLeaderCVC.identifier)
        self.collectionViewPhotos.delegate = self
        self.collectionViewPhotos.dataSource = self
        self.collectionViewPhotos.register(UploadPhotoVideoBtnCVC.nib, forCellWithReuseIdentifier: UploadPhotoVideoBtnCVC.identifier)
        self.collectionViewPhotos.register(PhotoCVC.nib, forCellWithReuseIdentifier: PhotoCVC.identifier)
        self.tableViewTestimonials.delegate = self
        self.tableViewTestimonials.dataSource = self
        self.tableViewTestimonials.register(CreatePageTestimonialTVC.nib, forCellReuseIdentifier: CreatePageTestimonialTVC.identifier)
        self.tableViewSpotlight.delegate = self
        self.tableViewSpotlight.dataSource = self
        self.tableViewSpotlight.register(PageLifeModuleTVC.nib, forCellReuseIdentifier: PageLifeModuleTVC.identifier)
        self.buttonDeleteMainMedia.isHidden = true
        self.buttonPlayVideo.isHidden = true
        self.footerView = UINib(nibName: "PageModuleFooterView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? PageModuleFooterView
        self.footerView1 = UINib(nibName: "PageModuleFooterView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? PageModuleFooterView
        
        
        switch hasCameFrom {
        case .addLife:
            self.labelPageTitle.text = "Add Life Event"
            self.buttonCreateLife.setTitle("Create Life", for: .normal)
        case .editLife:
            self.labelPageTitle.text = "Edit Life Event"
            self.buttonCreateLife.setTitle("Update Life", for: .normal)
            self.updateData()
            
        default:break
        }
    }
    func updateData(){
        if let obj = data{
            self.textFieldName.text = obj.view_name
            self.switchCompanyDetails.isOn = obj.company_leader_visibility
            self.textFieldCompanyHeadline.text = obj.company_leader_headline
            self.textViewContent.text = obj.company_leader_content
            self.modules = obj.company_spot_light
            self.switchCompanyPhotos.isOn = obj.company_photos_visibility
            self.productImages = obj.company_photos.map{$0.media}
            self.switchTestimonials.isOn = obj.company_testimonials_visibility
            self.testimonials = obj.company_testimonial
            self.leaders = obj.company_leader_name
            self.tableViewSpotlight.reloadData()
            self.tableViewTestimonials.reloadData()
            self.collectionViewPhotos.reloadData()
            self.collectionViewLeaders.reloadData()
            self.imageMainMedia.tag = 1
            switch self.getMediaType(urlString:obj.media , url: nil){
            case 1:
                self.imageMainMedia.downlodeImage(serviceurl: kBucketUrl + obj.media, placeHolder: UIImage(named: "Group 104770")!)
                self.imageMainMedia.tag = 1
                self.buttonDeleteMainMedia.isHidden = false
                self.buttonPlayVideo.isHidden = true
                mainMediaURL = obj.media
            case 3:
                
                self.imageMainMedia.tag = 1
                VideoPickerHelper.shared.thumbnil(url:URL(string: kBucketUrl + obj.media)! , completionClosure: {imageThumbnail in
                    self.mainVideoLocalURL = URL(string: kBucketUrl + obj.media)!
                    //self.myProtocal?.selectedMedia(fileUrl: data as! URL,postType: 5, image: imageThumbnail as! UIImage,id: -1,other: "")
                    self.imageMainMedia.image = imageThumbnail as! UIImage
                    self.imageMainMedia.tag = 1
                    self.buttonDeleteMainMedia.isHidden = false
                    self.buttonPlayVideo.isHidden = false
                    self.mainMediaURL = obj.media
                    
                })
            default:break
            }
            
        }
    }
    
    func getMediaType(urlString:String = "",url fileURL:URL?)->Int{
        let imageExtensions = ["png", "jpg", "gif","jpeg"]
        let documentExtensions = ["pdf","rtf","txt"]
        var url: URL?
        if urlString.isEmpty && fileURL != nil{
             url = fileURL
        }
        else{
             url = NSURL(fileURLWithPath: urlString) as URL
        }
        let pathExtention = url?.pathExtension
        if imageExtensions.contains(pathExtention!)
        {
            return 1
        }
        else if documentExtensions.contains(pathExtention!)
        {
            return 2
        }
        else
        {
            return 3
        }
    }
    
    func validateFields(){
        if String.getString(textFieldName.text).isEmpty{
            CommonUtils.showToast(message: "Please enter name")
            return
        }
        
        if imageMainMedia.tag == 0{
            CommonUtils.showToast(message: "Please select main image/video")
            return
        }
        if String.getString(textFieldCompanyHeadline.text).isEmpty{
            CommonUtils.showToast(message: "Please enter company headline")
            return
        }
        if String.getString(textViewContent.text).isEmpty{
            CommonUtils.showToast(message: "Please enter company content")
            return
        }
        if self.leaders.filter{$0.id.isEmpty}.count == 4{
            CommonUtils.showToast(message: "Please select atleast one leader")
            return
        }
        if self.productImages.isEmpty{
            CommonUtils.showToast(message: "Please select atleast one company image")
            return
        }
        if self.testimonials.filter{$0.employee_quote != ""}.isEmpty{
            CommonUtils.showToast(message: "Please enter atleast one quote")
            return
        }
        if hasCameFrom == .addLife{
            addLife {
                self.moveToPopUp(text: "Life saved successfully!", completion: {
                    kSharedAppDelegate?.moveToHomeScreen()
                })
            }
        }
        else{
            updateLife(id: String.getString(self.data?.id), type: 0, spotlightObj: nil, lifesId: nil, testimonialObj: nil) {
                self.moveToPopUp(text: "Life updated successfully!", completion: {
                    
                    kSharedAppDelegate?.moveToHomeScreen()
                })
            }
        }
    }
    

    @IBAction func buttonDeleteMainMediaTapped(_ sender: Any) {
        self.buttonDeleteMainMedia.isHidden = true
        self.buttonPlayVideo.isHidden = true
        self.imageMainMedia.tag = 0
        self.imageMainMedia.image = UIImage(named: "Group 104770")!
        self.mainVideoLocalURL = nil
        self.mainMediaURL = ""
    }
    @IBAction func buttonUploadMainImageVideoTapped(_ sender: Any) {
        ImagePickerHelper.shared.showGalleryPickerController(maxLength: 60){data in
            if data is UIImage{
               // self.myProtocal?.selectedMedia(fileUrl: data,postType: 5,image:data as! UIImage,id: -1,other: "")
                globalApis.uploadMedia(type: .lifeMedia, image: [data as! UIImage], completion: { urlString in
                    
                    self.imageMainMedia.image = data as! UIImage
                    self.imageMainMedia.tag = 1
                    self.buttonDeleteMainMedia.isHidden = false
                    self.mainMediaURL = String.getString(urlString.first)
                    
                    
                    self.updateLife(id: "", type: 2, spotlightObj: nil, lifesId: String.getString(self.data?.id), testimonialObj: nil,mediaURL: String.getString(urlString.first)) {
                        print("added photos")
                    }
                    
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                })
                
                
            }
            else{
                self.mainVideoLocalURL = data as! URL
                let asset = AVAsset(url: data as! URL)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                if durationTime <= 60{
                    globalApis.uploadMedia(type: .lifeMedia, image: [], video: data as! URL,isVideo: true, completion: { urlString in
                        
                        VideoPickerHelper.shared.thumbnil(url:data as! URL , completionClosure: {imageThumbnail in
                            
                            //self.myProtocal?.selectedMedia(fileUrl: data as! URL,postType: 5, image: imageThumbnail as! UIImage,id: -1,other: "")
                            self.imageMainMedia.image = imageThumbnail as! UIImage
                            self.imageMainMedia.tag = 1
                            self.buttonDeleteMainMedia.isHidden = false
                            self.buttonPlayVideo.isHidden = false
                            self.mainMediaURL = String.getString(urlString.first)
                            self.updateLife(id: "", type: 2, spotlightObj: nil, lifesId: String.getString(self.data?.id), testimonialObj: nil,mediaURL: String.getString(urlString.first)) {
                                print("added video")
                            }
                            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        })
                    })
                   
                }
                else{
                    CommonUtils.showToast(message: "Please Select another Video which is shorter than 60 seconds")
                    return
                }
            }

        }
    }
    @IBAction func buttonPlayVideoTapped(_ sender: Any) {
        if let url = mainVideoLocalURL{
            let videoURL = url
            
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            parent?.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else{
            CommonUtils.showToast(message: "Video not uploaded")
            return
        }
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCreateLifeTapped(_ sender: Any) {
        validateFields()
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
extension AddPageLifeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewLeaders{
            return leaders.count
        }
        else{
            return productImages.count + 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewLeaders{
            let obj = leaders[indexPath.row]
            if obj.full_name.isEmpty{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageLifeLeaderCVC.identifier, for: indexPath) as! PageLifeLeaderCVC
                cell.callback = {
                    globalApis.getAllLeaders(completion: {data in
                        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectRecipientVC.getStoryboardID()) as? SelectRecipientVC else { return }
                        vc.parentVC = self
                        vc.hasCameFrom = .searchLeader
                        vc.users = data
                        
                        vc.callback = { data in
                            if !data.isEmpty{
                                self.leaders[indexPath.row] = data[0]
                                self.collectionViewLeaders.reloadData()
                            }
                            
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    
                }
                return cell

            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewPageLifeLeaderCVC.identifier, for: indexPath) as! ViewPageLifeLeaderCVC
                cell.labelName.text = obj.full_name
                cell.labelProfile.text = obj.employee_type
                cell.deleteCallback = {
                    self.leaders[indexPath.row] = AllUserModel(data: [:])
                    self.collectionViewLeaders.reloadData()
                }
                cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: UIImage(named: "profile_placeholder")!)
                return cell

            }
        }
        else{
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadPhotoVideoBtnCVC.identifier , for: indexPath)  as! UploadPhotoVideoBtnCVC
                cell.uploadCallback = {
                    
                    ImagePickerHelper.shared.showBSPickerController({data in
                        if let assets = data as? [PHAsset]{
                            
                            globalApis.uploadMedia(type: .lifeMedia, image:  assets.map{$0.getAssetThumbnail()}, completion: { urlPath in
                                self.productImages = self.productImages + urlPath
                                
                                self.collectionViewPhotos.reloadData()
                            })
                            
                        }
                        if let image = data as? UIImage{
                            globalApis.uploadMedia(type: .lifeMedia, image: [image], completion: { urlPath in
                                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                                self.productImages.append(urlPath)
                                
                                self.collectionViewPhotos.reloadData()
                            })
                            
                            
                        }
                    })
                    
//                    ImagePickerHelper.shared.showPickerController(isEditing: false,isCircular: true,isCropper: false)  {image in
//                        globalApis.uploadMedia(type: .productMedia, image: [image as! UIImage], completion: { urlPath in
//                            self.productImages.append(urlPath)
//                        })
//
//
//                        self.collectionViewPhotos.reloadData()
//
//                    }
                }
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier , for: indexPath)  as! PhotoCVC
                if productImages.indices.contains(indexPath.row-1){
                    if let image = productImages[indexPath.row-1] as? UIImage{
                        cell.imageMedi.image = image
                        

                    }
                    else{
                        cell.imageMedi.downlodeImage(serviceurl: String.getString(kBucketUrl + String.getString(productImages[indexPath.row-1])), placeHolder: UIImage(named: "profile_placeholder")!)
                    }
                }
                
                cell.buttonEdit.isHidden = true
                cell.deleteCallback = {
                    self.productImages.remove(at: indexPath.row-1)
                    self.collectionViewPhotos.reloadData()
                }
                return cell
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewLeaders{
            return CGSize(width: collectionViewLeaders.frame.width/3.75, height: collectionViewLeaders.frame.height)
        }
        else{
            return CGSize(width: collectionViewPhotos.frame.width/3.15, height: collectionViewPhotos.frame.height)
        }

    }
    
    
}
extension AddPageLifeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tableViewSpotlight{
            self.footerView?.callback = {
                if self.modules.count > 4{
                    CommonUtils.showToast(message: "Maximum 4 modules are allowed")
                    return
                }
                else{
                    
                    self.modules.append(PageSpotlightModuleModel(data: [:]))
//                    self.updateLife(id: String.getString(self.data?.id), type: 4, spotlightObj: self.modules.last, lifesId: String.getString(self.data?.id), testimonialObj: nil) {
//                        print("added spotlight")
//                    }
                    
                    self.tableViewSpotlight.reloadData()
                }
                
            }
            
            return footerView
        }
        else{
            self.footerView1?.buttonAddModule.setTitle("Add Another Testimonial", for: .normal)
            self.footerView1?.callback = {
                if self.testimonials.count > 4{
                    CommonUtils.showToast(message: "Maximum 4 testimonials are allowed")
                    return
                }
                else{
                    
                    self.testimonials.append(PageTestimonialModel(data: [:]))
                    self.tableViewTestimonials.reloadData()
                }
                
            }
            
            return footerView1
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewSpotlight{
            constraintTableViewSpotlightHeight.constant = CGFloat(modules.count*500) + 60
            return modules.count
        }
        else{
            constraintTableViewTestimonialsHeight.constant = 2*100 + 60
            return testimonials.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewSpotlight{
            let cell = tableView.dequeueReusableCell(withIdentifier: PageLifeModuleTVC.identifier, for: indexPath) as! PageLifeModuleTVC
            let obj = modules[indexPath.row]
            cell.buttonDeleteModuleMedia.isHidden = true
            cell.buttonPlay.isHidden = true
            cell.parent = self.navigationController
            cell.textFieldSubtitle.delegate = self
            cell.textViewContent.delegate = self
            cell.textFieldURL.delegate = self
            cell.textFieldURL.tag = indexPath.row
            cell.textViewContent.tag = indexPath.row
            cell.textFieldSubtitle.tag = indexPath.row
            cell.labelModuleHeading.text = "Custom Module \(indexPath.row + 1)"
            cell.textFieldSubtitle.text = obj.title
            cell.textViewContent.text = obj.content
            cell.textFieldURL.text = obj.url_link
            cell.switchVisibility.isOn = obj.spotlight_visibility
            cell.visibilityCallback = { status in
                obj.moduleVisibility = status
                obj.spotlight_visibility = status ? true : false
//                self.updateLife(id: String.getString(self.data?.id), type: 1, spotlightObj: obj, lifesId: String.getString(self.data?.company_lifes_id), testimonialObj: nil) {
//                    print("updated spotlight")
//                }
            }
            cell.deleteModuleCallback = {
                self.modules.remove(at: indexPath.row)
                if self.hasCameFrom == .editLife{
                    globalApis.deleteModule(id: obj.id, type: 1, completion: {
                        CommonUtils.showToast(message: "Module deleted successfully!")
                    })
                }
                else{
                    CommonUtils.showToast(message: "Module deleted successfully!")
                }
                self.tableViewSpotlight.reloadData()
                
            }
            cell.deleteCallback = {
                cell.buttonDeleteModuleMedia.isHidden = true
                cell.buttonPlay.isHidden = true
                cell.imageModuleMedia.tag = 0
                cell.imageModuleMedia.image = UIImage(named: "Group 104770")!
                cell.moduleVideoURL = nil
                obj.moduleVideoURL = nil
            }
            cell.uploadCallback = {
                ImagePickerHelper.shared.showGalleryPickerController(maxLength: 60){data in
                    if data is UIImage{
                       // self.myProtocal?.selectedMedia(fileUrl: data,postType: 5,image:data as! UIImage,id: -1,other: "")
                        globalApis.uploadMedia(type: .lifeMedia, image: [data as! UIImage], video: nil, isVideo: false, completion: { urlString in
                            cell.imageModuleMedia.image = data as! UIImage
                            cell.imageModuleMedia.tag = 1
                            cell.buttonDeleteModuleMedia.isHidden = false
                            obj.moduleImage = data as! UIImage
                            obj.moduleVideoURL = nil
                            obj.media = String.getString(urlString.first)
//                            self.updateLife(id: String.getString(self.data?.id), type: 1, spotlightObj: obj, lifesId: String.getString(self.data?.company_lifes_id), testimonialObj: nil) {
//                                print("updated spotlight")
//                            }
                            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                        })
                    }
                    else{
                        cell.moduleVideoURL = data as! URL
                        obj.moduleVideoURL = data as! URL
                        obj.moduleImage = nil
                        let asset = AVAsset(url: data as! URL)
                        let duration = asset.duration
                        let durationTime = CMTimeGetSeconds(duration)
                        if durationTime <= 60{
                            globalApis.uploadMedia(type: .lifeMedia, image: [], video: data as! URL, isVideo: true, completion: { urlString in
                                VideoPickerHelper.shared.thumbnil(url:data as! URL , completionClosure: {imageThumbnail in
                                    
                                    //self.myProtocal?.selectedMedia(fileUrl: data as! URL,postType: 5, image: imageThumbnail as! UIImage,id: -1,other: "")
                                    cell.imageModuleMedia.image = imageThumbnail as! UIImage
                                    cell.imageModuleMedia.tag = 1
                                    cell.buttonDeleteModuleMedia.isHidden = false
                                    cell.buttonPlay.isHidden = false
                                    obj.media = String.getString(urlString.first)
//                                    self.updateLife(id: String.getString(self.data?.id), type: 1, spotlightObj: obj, lifesId: String.getString(self.data?.company_lifes_id), testimonialObj: nil) {
//                                        print("updated spotlight")
//                                    }
                                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                                })
                            })
                            
                        }
                        else{
                            CommonUtils.showToast(message: "Please Select another Video which is shorter than 60 seconds")
                            return
                        }
                    }

                }
            }
            if obj.media.isEmpty && obj.moduleImage == nil{
                cell.imageModuleMedia.image = UIImage(named: "Group 104770")!
            }
            else if obj.moduleImage != nil && obj.media.isEmpty{
                cell.imageModuleMedia.image = obj.moduleImage
            }
            else{
                switch self.getMediaType(urlString:kBucketUrl + obj.media , url: nil){
                case 1:
                    cell.imageModuleMedia.downlodeImage(serviceurl: kBucketUrl + obj.media, placeHolder: UIImage(named: "Group 104770")!)
                    cell.imageModuleMedia.tag = 1
                    cell.buttonDeleteModuleMedia.isHidden = false
                    cell.buttonPlay.isHidden = true
                case 3:
                    
                    VideoPickerHelper.shared.thumbnil(url:URL(string: kBucketUrl + obj.media)! , completionClosure: {imageThumbnail in
                        cell.moduleVideoURL = URL(string: kBucketUrl + obj.media)!
                        //self.myProtocal?.selectedMedia(fileUrl: data as! URL,postType: 5, image: imageThumbnail as! UIImage,id: -1,other: "")
                        cell.imageModuleMedia.image = imageThumbnail as! UIImage
                        cell.imageModuleMedia.tag = 1
                        cell.buttonDeleteModuleMedia.isHidden = false
                        cell.buttonPlay.isHidden = false
                        
                    })
                default:break
                }
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier:CreatePageTestimonialTVC.identifier, for: indexPath) as! CreatePageTestimonialTVC
            let obj = testimonials[indexPath.row]
            cell.textViewQuote.delegate = self
            cell.textViewQuote.text = obj.employee_quote
            if !String.getString(obj.employee_name?.full_name).isEmpty{
              
                cell.labelLeaderName.text = obj.employee_name?.full_name
                cell.viewLeader.isHidden = false
                cell.viewAddLeader.isHidden = true
                cell.imageProfile.downlodeImage(serviceurl: kBucketUrl + String.getString(obj.employee_name?.profile_pic), placeHolder: UIImage(named: "profile_placeholder")!)
                
            }
            else{
                cell.viewLeader.isHidden = true
                cell.viewAddLeader.isHidden = false
            }
            cell.callbackDelete = {
                self.testimonials.remove(at: indexPath.row)
                if self.hasCameFrom == .editLife{
                    globalApis.deleteModule(id: obj.id, type: 3, completion: {
                        CommonUtils.showToast(message: "Testimonial deleted successfully!")
                    })
                }
                else{
                    CommonUtils.showToast(message: "Testimonial deleted successfully!")
                }
                self.tableViewTestimonials.reloadData()
            }
            cell.callback = {
                globalApis.getAllLeaders(completion: {data in
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectRecipientVC.getStoryboardID()) as? SelectRecipientVC else { return }
                    vc.parentVC = self
                    vc.hasCameFrom = .searchLeader
                    vc.users = data
                    
                    vc.callback = { data in
                        if !data.isEmpty{
//                            self.testimonials[indexPath.row] = data[0]
//                            self.collectionViewLeaders.reloadData()
                            obj.employee_id = data[0].id
                            obj.employee_name = data[0]
                            cell.labelLeaderName.text = data[0].full_name
                            cell.viewLeader.isHidden = false
                            cell.viewAddLeader.isHidden = true
                        }
                        
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
            
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension AddPageLifeVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let cell = tableViewSpotlight.cellForRow(at: IndexPath(row: textView.tag, section: 0)) as! PageLifeModuleTVC
        if textView == cell.textViewContent{
            self.modules[textView.tag].content = String.getString(textView.text)
//            updateLife(id: String.getString(self.data?.id), type: 1, spotlightObj: modules[textView.tag], lifesId: String.getString(self.data?.id), testimonialObj: nil) {
//                print("updated spotlight")
//            }
            
        }
        else{
            self.testimonials[textView.tag].employee_quote = String.getString(textView.text)
//            updateLife(id: String.getString(self.data?.id), type: 3, spotlightObj: nil, lifesId: String.getString(self.data?.company_lifes_id), testimonialObj: self.testimonials[textView.tag]) {
//                print("updated testimonial")
//            }
        }
        //
        //let cell2 = tableViewTestimonials.cellForRow(at: IndexPath(row: textView.tag, section: 0)) as! CreatePageTestimonialTVC
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let cell = tableViewSpotlight.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as! PageLifeModuleTVC
        if textField == cell.textFieldSubtitle{
            self.modules[textField.tag].title = String.getString(textField.text)
//            updateLife(id: String.getString(self.data?.id), type: 1, spotlightObj: modules[textField.tag], lifesId: String.getString(self.data?.id), testimonialObj: nil) {
//                print("updated spotlight")
//            }
        }
        
        if textField == cell.textFieldURL{
            self.modules[textField.tag].url_link = String.getString(textField.text)
//            updateLife(id: String.getString(self.data?.id), type: 1, spotlightObj: modules[textField.tag], lifesId: String.getString(self.data?.id), testimonialObj: nil) {
//                print("updated spotlight")
//            }
            
        }
        
    }
}
extension AddPageLifeVC{
    
    func addLife(completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let res = self.productImages.filter{$0 is String}.map{String.getString($0)}
        
        //Spotlight Modules
        let moduleMedia = self.modules.map{$0.media}
        let moduleTitles = self.modules.map{$0.title}
        let moduleContent = self.modules.map{$0.content}
        let moduleUrlLink = self.modules.map{$0.url_link}
        let moduleVisibility = self.modules.map{$0.spotlight_visibility ? "1" : "0"}
        
        //Company
        let companyMedia = self.productImages.filter{$0 is String}.map{$0 as? String ?? ""}
        
        //Testimonials
        let testimonialsIds = self.testimonials.map{String.getString($0.employee_name?.id)}
        let testimonialsQuotes = self.testimonials.map{$0.employee_quote}
        
        
        
        
        
        var params:[String:Any] = [ApiParameters.company_id:String.getString(pageId),
                                   ApiParameters.view_name:String.getString(textFieldName.text),
                                   
                                   ApiParameters.media:String.getString(mainMediaURL),
                                   ApiParameters.image_url_link:"",
                                   ApiParameters.company_leader_headline:String.getString(textFieldCompanyHeadline.text),
                                   ApiParameters.company_leader_content:String.getString(textViewContent.text),
                                   ApiParameters.members_of_company_leader:self.leaders.map{$0.id}.joined(separator: ","),
                                   ApiParameters.company_leader_visibility:self.switchCompanyDetails.isOn ? "1" : "0",
                                   ApiParameters.company_photos_visibility:self.switchCompanyPhotos.isOn ? "1" : "0",
                                   ApiParameters.company_testimonials_visibility:self.switchTestimonials.isOn ? "1" : "0",
                                   ApiParameters.spotlight_media:moduleMedia,
                                   ApiParameters.caption:"",
                                   ApiParameters.title:moduleTitles,
                                   ApiParameters.content:moduleContent,
                                   ApiParameters.url_link:moduleUrlLink,
                                   ApiParameters.spotlight_visibility:moduleVisibility,
                                   ApiParameters.company_photos_media:companyMedia,
                                   ApiParameters.employee_ids:testimonialsIds,
                                   ApiParameters.employee_quote:testimonialsQuotes,
                                   
                                   
        ]
//        if hasCameFrom == .editProduct{
//            params[ApiParameters.id] = String.getString(data?.id)
//            params[ApiParameters.is_delete] = "0"
//
//        }
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.add_company_life,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    let comment = CommentModel(data: kSharedInstance.getDictionary(data))
                    
                 
                    completion()
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
    func updateLife(id:String,type:Int,spotlightObj:PageSpotlightModuleModel?,lifesId:String?,testimonialObj:PageTestimonialModel?,mediaURL:String = "",completion: @escaping ()->()){
        if hasCameFrom == .addLife{
            return
        }
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        guard let obj = data else {return}
        var url = ""
        var params:[String:Any] = [:]
        
        switch type{
        case 0: //update company
            url = ServiceName.update_company_life
            let moduleMedia = self.modules.map{$0.media}
            let moduleTitles = self.modules.map{$0.title}
            let moduleContent = self.modules.map{$0.content}
            let moduleUrlLink = self.modules.map{$0.url_link}
            let moduleVisibility = self.modules.map{$0.spotlight_visibility ? "1" : "0"}
            let testimonialsIds = self.testimonials.map{String.getString($0.employee_name?.id)}
            let testimonialsQuotes = self.testimonials.map{$0.employee_quote}
            
            params = [ApiParameters.id:id,
                      ApiParameters.view_name:String.getString(textFieldName.text),
                      
                      ApiParameters.media:String.getString(mainMediaURL),
                      ApiParameters.image_url_link:"",
                      ApiParameters.company_leader_headline:String.getString(textFieldCompanyHeadline.text),
                      ApiParameters.company_leader_content:String.getString(textViewContent.text),
                      ApiParameters.members_of_company_leader:self.leaders.map{$0.id}.joined(separator: ","),
                      ApiParameters.company_leader_visibility:self.switchCompanyDetails.isOn ? "1" : "0",
                      ApiParameters.company_photos_visibility:self.switchCompanyPhotos.isOn ? "1" : "0",
                      ApiParameters.company_testimonials_visibility:self.switchTestimonials.isOn ? "1" : "0",
                      ApiParameters.spotlight_media:moduleMedia,
                      ApiParameters.caption:"",
                      ApiParameters.title:moduleTitles,
                      ApiParameters.content:moduleContent,
                      ApiParameters.url_link:moduleUrlLink,
                      ApiParameters.spotlight_visibility:moduleVisibility,
                      ApiParameters.company_lifes_id:String.getString(data?.id),
                      ApiParameters.employee_ids:testimonialsIds,
                      ApiParameters.employee_quote:testimonialsQuotes
            ]
        case 1: //update spotlight
            
            //Spotlight Modules
//            let moduleMedia = spotlightObj?.media
//            let moduleTitles = spotlightObj?.title
//            let moduleContent = spotlightObj?.content
//            let moduleUrlLink = spotlightObj?.url_link
//            let moduleVisibility = spotlightObj?.spotlight_visibility ?? true ? "1" : "0"
            //Spotlight Modules
            
            url = ServiceName.update_company_spotlight
          //  params = [//ApiParameters.id:String.getString(spotlightObj?.id),
              //        ]
            
        case 2:
            //Update Company Photos
           // let companyMedia = self.productImages.filter{$0 is String}.map{$0 as? String ?? ""}
            url = ServiceName.update_company_photos
            params = [
                      ApiParameters.company_lifes_id:String.getString(data?.id),
                      ApiParameters.company_photos_media:mediaURL]
        case 3:
            //Update Testimonials
            let testimonialsIds = self.testimonials.map{String.getString($0.employee_name?.id)}
            let testimonialsQuotes = self.testimonials.map{$0.employee_quote}
            url = ServiceName.update_company_testimonial
        //params = [//ApiParameters.id:String.getString(testimonialObj?.id),
                   //   ]
        case 4:
            //Add spotlight
            let moduleMedia = spotlightObj?.media
//            let moduleTitles = spotlightObj?.title
//            let moduleContent = spotlightObj?.content
//            let moduleUrlLink = spotlightObj?.url_link
//            let moduleVisibility = spotlightObj?.spotlight_visibility ?? true ? "1" : "0"
//            url = ServiceName.update_company_spotlight
//            params = [
//                      ApiParameters.spotlight_media:String.getString(moduleMedia),
//                      ApiParameters.caption:"",
//                      ApiParameters.title:String.getString(moduleTitles),
//                      ApiParameters.content:String.getString(moduleContent),
//                      ApiParameters.url_link:String.getString(moduleUrlLink),
//                      ApiParameters.spotlight_visibility:String.getString(moduleVisibility),
//                      ApiParameters.company_lifes_id:String.getString(data?.id)]
            
        case 5://Add testimonial
//            let testimonialsIds = String.getString(testimonialObj?.employee_name?.id)
//        let testimonialsQuotes = String.getString(testimonialObj?.employee_quote)
            let testimonialsIds = self.testimonials.map{String.getString($0.employee_name?.id)}
            let testimonialsQuotes = self.testimonials.map{$0.employee_quote}
            
            url = ServiceName.update_company_testimonial
        params = [
                      ApiParameters.company_lifes_id:String.getString(data?.id),
                      ApiParameters.employee_ids:testimonialsIds,
                      ApiParameters.employee_quote:testimonialsQuotes]
            
        default:break
        }
    
//        if hasCameFrom == .editProduct{
//            params[ApiParameters.id] = String.getString(data?.id)
//            params[ApiParameters.is_delete] = "0"
//
//        }
        TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    let comment = CommentModel(data: kSharedInstance.getDictionary(data))
                    
                 
                    completion()
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
