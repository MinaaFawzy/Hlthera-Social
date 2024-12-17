//
//  VideoPickerHelper.swift
//  Agafos
//
//  Created by Shubham Kaliyar on 12/10/17.
//  Copyright © 2017 Tahir. All rights reserved.
//


var PickerVideoCallBack:PickerVideo = nil
typealias PickerVideo = ((URL? , Data?,Float64) -> (Void))?
let videoPickerInstanse = VideoPickerHelper.shared

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class VideoPickerHelper: NSObject {
    
    private override init() {
    }
    static var shared : VideoPickerHelper = VideoPickerHelper()
    var picker = UIImagePickerController()
    
    // MARK:- Action Sheet
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
    func showVideoController(maxlength:Int,_ handler:PickerVideo) {
        self.showActionSheet(withTitle: "Choose Option", withAlertMessage: nil, withOptions: ["Take Video", "Open Gallery"]){ ( _ selectedIndex: Int) in
            switch selectedIndex {
            case 0:
                self.showCamera(maxlength:maxlength)
            case 1:
                self.openGallery(maxlength:maxlength)
            default:
                break
            }
        }
        PickerVideoCallBack = handler
    }
    
    
    // MARK:-  Camera
    func showCamera(maxlength:Int) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            picker.videoMaximumDuration = TimeInterval(maxlength)
            picker.mediaTypes = [kUTTypeMovie] as [String]
            presetImagePicker(pickerVC: picker)
        } else {
            self.showAlertmesssage(message: "Camera not available.")
        }
        picker.delegate = self
    }
    
    // MARK:-  Gallery
    
    func openGallery(maxlength:Int) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie] as [String]
        presetImagePicker(pickerVC: picker)
        picker.delegate = self
    }
    
    // MARK:- Show ViewController
    
    private func presetImagePicker(pickerVC: UIViewController) -> Void {
        //self.dismissViewController()
        DispatchQueue.main.async {
            
            let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            let vc = scene?.window?.rootViewController?.presentedViewController
//            scene?.window?.rootViewController?.present(pickerVC, animated: true, completion: {
//               self.picker.delegate = self
//         })
            
//            vc?.present(pickerVC, animated: true, completion: {
//               self.picker.delegate = self
//         })
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(pickerVC, animated: true, completion: {
                   self.picker.delegate = self
             })

            // topController should now be your topmost view controller
            }
            
            
        }
      
       
    }
    
    fileprivate func dismissViewController() -> Void {
//        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
//        scene?.window?.rootViewController?.dismiss(animated: true, completion: nil)
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.dismiss(animated: true, completion: nil)

        // topController should now be your topmost view controller
        }
    }
    //thumbnail create
    func thumbnailForVideoAtURL(url: URL) -> UIImage? {
            let asset = AVAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            var time = asset.duration
            time.value = min(time.value, 2)
            do {
                let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                return UIImage(cgImage: imageRef)
            } catch {
                print("Place holder not get")
                return #imageLiteral(resourceName: "profile_placeholder")
            }
        }
        
        func thumbnil(url: URL , completionClosure: @escaping (_ result: UIImage?) -> ()) {
            let asset = AVURLAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            var time = asset.duration
            
            time.value = min(time.value, 2)
            do {
                let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                completionClosure(UIImage(cgImage: imageRef))
            } catch {
                completionClosure(#imageLiteral(resourceName: "profile_placeholder"))
                print("Place holder  get")
            }
        }
}


// MARK: - Picker Delegate
extension VideoPickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
        
        
        guard let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        print(videoUrl.lastPathComponent)
        var videoData = try? Data.init(contentsOf: videoUrl)
        let asset = AVAsset(url: videoUrl)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        
        let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPreset1280x720)
           
           exporter?.shouldOptimizeForNetworkUse = true
           
        
        exporter?.fileLengthLimit = 1048576 * 10 //10 MB
        
        videoData = try? Data.init(contentsOf: exporter?.outputURL ?? videoUrl)
        PickerVideoCallBack?(exporter?.outputURL ?? videoUrl ,  videoData,durationTime)
        dismissViewController()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissViewController()
    }
    func showAlertmesssage(message:String = "Video file is too large") {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let alert = UIAlertController(title: "Video Alert", message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        scene?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
