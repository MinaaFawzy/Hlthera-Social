//
//  CreatePostBottomSheetVC.swift
//  HSN
//
//  Created by Prashant Panchal on 05/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import PhotosUI
import AVKit
import BSImagePicker
import AssetsLibrary
import AssetsPickerViewController

class CreatePostBottomSheetVC: UIViewController, BottomSheet {
    
    // MARK: - Outlets
    @IBOutlet weak var stackVIew: UIStackView!
    
    // MARK: - Stored Properties
    var hasCameFrom:HasCameFrom = .createPost
    var groupId = ""
    var companyId = ""
    
    func refreshBottomSheet(type: Int) {
        if type != 0 {
            hideAndShow(index: type-1)
        } else {
            for view in stackVIew.arrangedSubviews{
                view.isHidden = false
            }
        }
    }
    
    var media:[Any] = []
    var myProtocal:MediaSelection?
    var parentVC:CreatePostVC?
    var file:Any?
    var currentTotalImages = 0

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //let obj = self.view.layer
        //obj.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        //obj.cornerRadius = 20
        //obj.shadowColor = UIColor.lightGray.cgColor
        //obj.shadowOffset = CGSize(width: 0, height: 1)
        //obj.shadowOpacity = 0.35
        //obj.shadowRadius = 5
    }
    
    func hideAndShow(index: Int){
        for view in stackVIew.arrangedSubviews{
            view.isHidden = true
        }
        stackVIew.arrangedSubviews[index].isHidden = false
    }
    
    @IBAction func buttonAddPostTapped(_ sender: Any) {
        
        
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration()
            config.selectionLimit = 5
            config.filter = .any(of: [.images, .videos, .livePhotos])
            let pickerViewController = PHPickerViewController(configuration: config)
            pickerViewController.delegate = self
            self.present(pickerViewController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            ImagePickerHelper.shared.showBSPickerController({data in
                if let assets = data as? [PHAsset]{
                    for asset in assets{
                        self.myProtocal?.selectedMedia(fileUrl: asset.getAssetThumbnail(),postType: 1,image: asset.getAssetThumbnail(),id: -1,other: "")
                    }
                }
                
                if let image = data as? UIImage{
                    print(image)
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                    self.myProtocal?.selectedMedia(fileUrl: image,postType: 1,image: image,id: -1,other: "")
                }
            })
        }
        
    }
    
    @IBAction func buttonTakeVideoTapped(_ sender: Any) {
        //        isVideo = true
        //        if isVideo && mediaCount > 1{
        //            CommonUtils.showToast(message: "Video Limit is 1")
        //            return
        //        }else{
        VideoPickerHelper.shared.showVideoController(maxlength:600) { (videoUrl, videoData,duration) -> (Void) in
            if duration <= 600 {
                print(videoUrl,videoData)
                var image: UIImage = UIImage()
                VideoPickerHelper.shared.thumbnil(url:videoUrl! , completionClosure: {imageThumbnail in
                    image = imageThumbnail ?? UIImage()
                })
                self.myProtocal?.selectedMedia(fileUrl: videoUrl!,postType: 2,image:image,id: -1,other: "")
            } else {
                CommonUtils.showToast(message: "Video Length is too long, Select another video")
                return
            }
        }
    }
    
    @IBAction func buttonAddDocumentTapped(_ sender: Any) {
        showDocumentPicker()
    }
    
    @IBAction func buttonCreatePollTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreatePollVC.getStoryboardID()) as? CreatePollVC else { return }
        vc.hasCameFrom = self.hasCameFrom
        vc.groupId = self.groupId
        vc.pageId = self.companyId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func buttonAddStoryTapped(_ sender: Any) {
        //        if #available(iOS 14, *) {
        //            var config = PHPickerConfiguration()
        //            config.filter = .any(of: [.videos,.images])
        //                        let picker = PHPickerViewController(configuration: config)
        //                        picker.delegate = self
        //                        present(picker, animated: true, completion: nil)
        //
        //        } else {
        ImagePickerHelper.shared.showGalleryPickerController(maxLength: 60){ [weak self] data in
            guard let self = self else { return }
            if data is UIImage {
                // self.myProtocal?.selectedMedia(fileUrl: data,postType: 5,image:data as! UIImage,id: -1,other: "")
                self.media = [data as! UIImage]
                self.createStory(companyId: self.companyId)
            } else {
                let asset = AVAsset(url: data as! URL)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                if durationTime <= 60{
                    VideoPickerHelper.shared.thumbnil(url:data as! URL , completionClosure: { [weak self] imageThumbnail in
                        guard let self = self else { return }
                        //self.myProtocal?.selectedMedia(fileUrl: data as! URL,postType: 5, image: imageThumbnail as! UIImage,id: -1,other: "")
                        self.media = [data as! URL]
                        self.createStory(companyId: self.companyId)
                    })
                } else {
                    CommonUtils.showToast(message: "Please Select another Video which is shorter than 60 seconds")
                    return
                }
            }
            
        }
    }
    
    @IBAction func buttonCelebrateTapped(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:  "CelebrateOccassionVC") as?  CelebrateOccassionVC else { return }
        vc.parentVC = self.parentVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension CreatePostBottomSheetVC {
    func selectDocument(type:Int){
        switch type{
        case 0:
            showDocumentPicker()
        case 1:
            CommonUtils.imagePickerCamera(viewController: self)
        case 2:
            CommonUtils.imagePickerGallery(viewController: self)
        default:break
        }
    }
}

extension CreatePostBottomSheetVC: UIDocumentPickerDelegate {
    func showDocumentPicker() {
        let types: [String] = self.returnAlldoctType()
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .pageSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func returnAlldoctType() ->[String] {
        return ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key", "public.item", "public.content", "public.audiovisual-content",  "public.audiovisual-content",  "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content"]
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pdfUrl = urls.first else { return  }
        let _ = pdfUrl.startAccessingSecurityScopedResource()
        let data = try! Data.init(contentsOf: pdfUrl)
        print(pdfUrl,data)
        
        myProtocal?.selectedMedia(fileUrl: pdfUrl,postType: 3,image: UIImage(),id: -1,other: "")
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension CreatePostBottomSheetVC: AssetsPickerViewControllerDelegate {
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {}
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
        print(assets)
        for asset in assets{
            // PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { (image, info) in
            // Do something with image
            
            self.myProtocal?.selectedMedia(fileUrl: asset.getAssetThumbnail(),postType: 1,image: asset.getAssetThumbnail(),id: -1,other: "")
            //     }
            
        }
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {}
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
}

extension CreatePostBottomSheetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image:UIImage = info[.originalImage] as! UIImage
        
        myProtocal?.selectedMedia(fileUrl: image,postType: 1,image: image,id: -1,other: "")
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
}

extension CreatePostBottomSheetVC: PHPickerViewControllerDelegate {
    
    private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool,completion: @escaping ((UIImage)->())) {
        let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
        if itemProvider.canLoadObject(ofClass: objectType) {
            itemProvider.loadObject(ofClass: objectType) { object, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if !isLivePhoto {
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            // use image
                            completion(image)
                        }
                    }
                } else {
                    if let livePhoto = object as? PHLivePhoto {
                        DispatchQueue.main.async {
                            let livePhotoResources = PHAssetResource.assetResources(for: livePhoto)
                            for resource in livePhotoResources {
                                if resource.type == .photo {
                                    let buffer = NSMutableData()
                                    var dataRequestID:PHAssetResourceDataRequestID = PHInvalidAssetResourceDataRequestID
                                    let options = PHAssetResourceRequestOptions()
                                    options.isNetworkAccessAllowed = true
                                    
                                    dataRequestID = PHAssetResourceManager.default().requestData(for: resource, options: options, dataReceivedHandler: { (data:Data) in
                                        buffer.append(data)
                                        
                                    }, completionHandler: { (error:Error?) in
                                        // buffer now contains the resource data
                                        if let image = UIImage(data: buffer as Data) {
                                            // use image
                                            completion(image)
                                        }
                                    })
                                    
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        for result in results {
            let itemProvider = result.itemProvider
            
            guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier)
            else { continue }
            
            if utType.conforms(to: .gif){
                self.getPhoto(from: itemProvider, isLivePhoto: false){ image in
                    self.myProtocal?.selectedMedia(fileUrl: image,postType: 1,image: image,id: -1,other: "")
                    
                }
            }
            else if utType.conforms(to: .image) {
                self.getPhoto(from: itemProvider, isLivePhoto: false){ image in
                    self.myProtocal?.selectedMedia(fileUrl: image,postType: 1,image: image,id: -1,other: "")
                    
                }
            } else if utType.conforms(to: .movie) {
                // self.getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, err in
                    if let videoUrl = url {
                        
                        
                        
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                        guard let targetURL = documentsDirectory?.appendingPathComponent(videoUrl.lastPathComponent) else { return }
                        
                        do {
                            if FileManager.default.fileExists(atPath: targetURL.path) {
                                try FileManager.default.removeItem(at: targetURL)
                            }
                            
                            try FileManager.default.copyItem(at: videoUrl, to: targetURL)
                            
                            DispatchQueue.main.async {
                                //self.photoPicker.mediaItems.append(item: PhotoPickerModel(with: targetURL))
                                VideoPickerHelper.shared.thumbnil(url:targetURL , completionClosure: {imageThumbnail in
                                    guard let image = imageThumbnail else {return}
                                    self.myProtocal?.selectedMedia(fileUrl: targetURL,postType: 2,image:image,id: -1,other: "")
                                    
                                })
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }}
            } else {
                //self.getPhoto(from: itemProvider, isLivePhoto: true)
            }
        }

        //           for result in results {
        //               if result.hasca
        //
        //
        //              result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
        //                 if let image = object as? UIImage {
        //                    DispatchQueue.main.async {
        //                       // Use UIImage
        //                       print("Selected image: \(image)")
        //                    }
        //                 }
        //              })
        //           }
        
        //        picker.dismiss(animated: true, completion: nil)
        //            guard let provider = results.first?.itemProvider else { return }
        //        if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) || provider.hasItemConformingToTypeIdentifier(UTType.video.identifier) || provider.hasItemConformingToTypeIdentifier(UTType.mpeg4Movie.identifier) || provider.hasItemConformingToTypeIdentifier(UTType.mpeg2Video.identifier) {
        //            provider.loadItem(forTypeIdentifier: provider.registeredTypeIdentifiers[0], options: [:]) { [self] (videoURL, error) in
        //                            print("resullt:", videoURL, error)
        //                            DispatchQueue.main.async {
        //                                    if let url = videoURL as? URL {
        //                                        let player = AVPlayer(url: url)
        //                                        let playerViewController = AVPlayerViewController()
        //                                        playerViewController.player = player
        //                                        parent?.present(playerViewController, animated: true) {
        //                                            playerViewController.player!.play()
        //                                        }
        //                                    }
        //                            }
        //                    }
        //            }
        //        else{
        //            provider.loadItem(forTypeIdentifier: provider.registeredTypeIdentifiers[0], options: [:]) { [self] (image, error) in
        //                    print("resullt:", image, error)
        //                    DispatchQueue.main.async {
        //                            if let url = image as? UIImage {
        //                                    print(image)
        //                            }
        //                    }
        //            }
        //        }
    }
}

extension CreatePostBottomSheetVC {
    func thumbnailFromPdf(withUrl url:URL, pageNumber:Int, width: CGFloat = 240) -> UIImage? {
        guard let pdf = CGPDFDocument(url as CFURL),
              let page = pdf.page(at: pageNumber)
        else {
            return nil
        }
        
        var pageRect = page.getBoxRect(.mediaBox)
        let pdfScale = width / pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
        pageRect.origin = .zero
        
        UIGraphicsBeginImageContext(pageRect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        // White BG
        context.setFillColor(UIColor.white.cgColor)
        context.fill(pageRect)
        context.saveGState()
        // Next 3 lines makes the rotations so that the page look in the right direction
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        
        context.drawPDFPage(page)
        context.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

protocol MediaSelection {
    func selectedMedia(fileUrl: Any,postType:Int,image:UIImage,id:Int,other:String)
}

extension PHAsset {
    var image: UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
}

extension PHAsset {
    func getAssetThumbnail() -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: self,
                             targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                             contentMode: .aspectFit,
                             options: option,
                             resultHandler: {(result, info) -> Void in
            thumbnail = result ?? UIImage()
        })
        return thumbnail
    }
}

extension CreatePostBottomSheetVC {
    func createStory(companyId: String = "") {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params: [String: Any] = [:]
        if !companyId.isEmpty {
            params[ApiParameters.company_id] = companyId
            params[ApiParameters.is_company_post] = "1"
        }
        var images: [[String: Any]] = []
        var documents: [[String: Any]] = []
        var videos: [String: Any] = [:]
        
        for data in media {
            if data is UIImage {
                images.append(["imageName":ApiParameters.mediaUpload,"image":data])
            } else if data is URL {
                let imageExtensions = ["png", "jpg", "gif","jpeg"]
                let documentExtensions = ["pdf"]
                //...
                // Iterate & match the URL objects from your checking results
                let url: URL = data as! URL
                let pathExtention = url.pathExtension
                if imageExtensions.contains(pathExtention) {
                } else if documentExtensions.contains(pathExtention) {
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

protocol BottomSheet {
    func refreshBottomSheet(type: Int)
}
