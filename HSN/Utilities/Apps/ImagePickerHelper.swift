//
//  ImagePickerHelper.swift
//  Agafos
//
//  Created by Mohammad Tahir on 12/10/17.
//  Copyright © 2017 Tahir. All rights reserved.
//

// MARK:- Permission in Info Plist
/*
 1- For Camera
 
 Key       :  Privacy - Camera Usage Description
 Value     :  $(PRODUCT_NAME) camera use
 
 2- For Gallery
 Key       :  Privacy - Photo Library Usage Description
 Value     :  $(PRODUCT_NAME) photo use
 
 */

var pickerCallBack:PickerImage = nil
var pickerImagesCallback:PickerImages = nil
typealias PickerImage = ((Any?) -> (Void))?
typealias PickerImages = (([Any])->(Void))?


import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import BSImagePicker
import PhotosUI
import QCropper

class ImagePickerHelper: NSObject {
    
    private override init() {}
    
    static var shared : ImagePickerHelper = ImagePickerHelper()
    var picker = UIImagePickerController()
    var isCircular = false
    var isCropper = false
    
    // MARK: - Action Sheet
    
    func showActionSheet(withTitle title: String?, withAlertMessage message: String?, withOptions options: [String], handler:@escaping (_ selectedIndex: Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for strAction in options {
            let anyAction =  UIAlertAction(title: strAction, style: .default){ (action) -> Void in
                return handler(options.firstIndex(of: strAction)!)
            }
            alert.addAction(anyAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
            return handler(-1)
        }
        alert.addAction(cancelAction)
        presetImagePicker(pickerVC: alert)
        
    }
    
    // MARK: Public Method
    
    /**
     
     * Public Method for showing ImagePicker Controlller simply get Image
     * Get Image Object
     */
    
    func showPickerControllerWithVideo(_ handler:PickerImage) {
        
        self.showActionSheet(withTitle: "Choose Option", withAlertMessage: nil, withOptions: ["Take Picture", "Open Gallery"]){ ( _ selectedIndex: Int) in
            switch selectedIndex {
            case OpenMediaType.camera.rawValue:
                self.showCamera()
            case OpenMediaType.photoLibrary.rawValue:
                self.openPhotoVideos(maxLength: 600)
            
            default:
                break
            }
        }
        
        pickerCallBack = handler
    }
    func showPickerController(isEditing:Bool = false,isCircular:Bool = false,isCropper:Bool = true,_ handler:PickerImage) {
        self.isCircular = isCircular
        self.isCropper = isCropper
        self.showActionSheet(withTitle: "Choose Option", withAlertMessage: nil, withOptions: ["Take Picture", "Open Gallery"]){ ( _ selectedIndex: Int) in
            switch selectedIndex {
            case OpenMediaType.camera.rawValue:
                self.showCamera()
            case OpenMediaType.photoLibrary.rawValue:
                self.openGallery(editing: isEditing)
            
            default:
                break
            }
        }
        
        pickerCallBack = handler
    }
    
    
//    func createPostImagePicker(limit:Int = 5,_ handler:PickerImage){
//        if #available(iOS 14, *) {
//            var config = PHPickerConfiguration()
//            config.selectionLimit = 5
//            config.filter = .any(of: [.images, .videos, .livePhotos])
//            let pickerViewController = PHPickerViewController(configuration: config)
//            pickerViewController.delegate = self
//            self.present(pickerViewController, animated: true, completion: nil)
//        }
//        else{
//            self.showBSPickerController(handler)
//        }
//    }
    
    
    
    
    
    func showBSPickerController(limit:Int = 5,withVideoEnabled:Bool = false,_ handler:PickerImage) {
        
        self.showActionSheet(withTitle: "Choose Option", withAlertMessage: nil, withOptions: ["Take Picture", "Open Gallery"]){ ( _ selectedIndex: Int) in
            switch selectedIndex {
            case OpenMediaType.camera.rawValue:
                self.showCamera()
            case OpenMediaType.photoLibrary.rawValue:
                self.openBSGallery(limit: limit,withVideoEnabled:withVideoEnabled)
            
            default:
                break
            }
        }
        
        pickerCallBack = handler
    }
    func openBSGallery(limit:Int = 5,withVideoEnabled:Bool = false){
        let bsImagePicker = ImagePickerController(selectedAssets: [])
        bsImagePicker.settings.fetch.assets.supportedMediaTypes = withVideoEnabled ? [.video,.image] : [.image]
        bsImagePicker.settings.selection.max = limit
        bsImagePicker.settings.selection.unselectOnReachingMax = true
        UIApplication.shared.windows.first?.rootViewController?.presentImagePicker(bsImagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            //pickerCallBack()
            pickerCallBack?(assets)
            // User finished selection assets.


        })
    }
    func showGalleryPickerController(maxLength:Int, _ handler:PickerImage) {
        
        self.openPhotoVideos(maxLength: maxLength)
        
        pickerCallBack = handler
    }
    func showPhotosGalleryPickerController( _ handler:PickerImage) {
        
        self.openGallery()
        
        pickerCallBack = handler
    }
    func showCameraGalleryPickerController( _ handler:PickerImage) {
        
        self.showCamera()
        
        pickerCallBack = handler
    }
     func imagePickerGallery(){
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        presetImagePicker(pickerVC: picker)
        picker.delegate = self
    }
    
    
    // MARK:-  Camera
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            presetImagePicker(pickerVC: picker)
        } else {
            showAlertMessage.alert(message: "Camera not available.")
        }
        picker.delegate = self
        
    }
    
    
    // MARK:-  Gallery
    
    func openGallery(editing:Bool = true) {
        picker.allowsEditing = editing
        picker.sourceType = .photoLibrary
        presetImagePicker(pickerVC: picker)
        picker.delegate = self
    }
    func openPhotoVideos(maxLength:Int) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie","public.image"]
        picker.videoMaximumDuration = TimeInterval(maxLength)
        presetImagePicker(pickerVC: picker)
        picker.delegate = self
    }
    
    // MARK:- Show ViewController
    
    private func presetImagePicker(pickerVC: UIViewController) -> Void {
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
         UIApplication.shared.windows.first?.rootViewController?.present(pickerVC, animated: true, completion: {
            self.picker.delegate = self
        })
    }
    
    fileprivate func dismissViewController() -> Void {
      //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
         UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK;- func for imageView in swift
    func SaveImage (imageView :UIImage) {
        UIImageWriteToSavedPhotosAlbum(imageView, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            showAlertMessage.alert(message: "Photos not Saved ")
        } else {
             showAlertMessage.alert(message: "Your altered image has been saved to your photos. ")
        }
    }
}


// MARK: - Picker Delegate
extension ImagePickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString

        switch mediaType {
        case kUTTypeImage:
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: {
                
                if self.isCropper{
                    let cropper = CropperViewController(originalImage: image as! UIImage,isCircular: self.isCircular)
                    cropper.delegate = self
                    UIApplication.shared.windows.first?.rootViewController?.present(cropper, animated: true, completion: nil)
                }
                else{
                    pickerCallBack?(image)
                }
               
            })
             
              //dismissViewController()
            break
        case kUTTypeMovie:
            guard let image = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
            
              pickerCallBack?(image)
             // dismissViewController()
            break
        case kUTTypeLivePhoto:
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
              pickerCallBack?(image)
             // dismissViewController()
            break
            
        case kUTTypeGIF :
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
              pickerCallBack?(image)
        default:
            break
        }
      
    }
    
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissViewController()
    }
}

extension ImagePickerHelper: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)

        if let state = state,
            let image = cropper.originalImage.cropped(withCropperState: state) {
//            cropperState = state
//            imageView.image = image
            print(cropper.isCurrentlyInInitialState)
            print(image)
            pickerCallBack?(image)
        }
    }
}


class TextFieldMargin: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
