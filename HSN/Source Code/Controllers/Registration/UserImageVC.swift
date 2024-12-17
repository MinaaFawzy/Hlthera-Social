//
//  UserImageViewController.swift
//  HSN
//
//  Created by Kartikeya on 13/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class UserImageVC: UIViewController {
    var workdetails:[String:Any] = [:]
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    var location = ""
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = self.location
        if location.isEmpty{
            self.viewLocation.isHidden = true
        } else {
            if let nsLocation = location as? NSString{
                if nsLocation.length >= 40{
                    self.labelLocation.text = location + " ..."
                } else {
                    self.labelLocation.text = location
                }
            }
        }
        
        self.labelName.text = UserData.shared.full_name
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        // Do any additional setup after loading the view.
    }
    
    
    
}

//MARK: - Actions
extension UserImageVC {
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   @IBAction func buttonCrossTapped(_ sender:UIButton){
       kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
       kSharedAppDelegate?.moveToHomeScreen()
     }
    
    @IBAction func buttonDoneTapped(_ sender:UIButton){
        if imageProfile.tag == 0{
            CommonUtils.showToast(message: "Please Select Profile Pic")
            return
        }
        else{
            uploadProfileData()
        }
            }
    @IBAction func buttonUploadImageTapped(_ sender: Any) {
       
        
        ImagePickerHelper.shared.showPickerController(isEditing: false,isCircular: true)  {image in
          
            self.imageProfile.image = image as! UIImage
            self.imageProfile.restorationIdentifier = " "
               
            self.imageProfile.tag = 1

            self.imageProfile.setupImageViewer()
//            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: {
//                let cropper = CropperViewController(originalImage: image as! UIImage,isCircular: true)
//                cropper.delegate = self
//                self.present(cropper, animated: true, completion:nil)
//            })
           
            
        }
    }
}

//MARK: - Api
extension UserImageVC{
    func uploadProfileData(){
        CommonUtils.showHudWithNoInteraction(show: true)
//        let params:[String:Any] = workdetails
        let images:[String:Any] = ["imageName":ApiParameters.kprofile_picture,
                                   "image": self.imageProfile.image!]
        print("\(images)")
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: ServiceName.userUpdateProfile,
                                                         requestMethod: .post,
                                                         requestImages: [images],
                                                         requestVideos: [:],
                                                         requestData: [:])
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    UserData.shared.saveData(data: data)
//                  guard let vc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: WelcomePageVC.getStoryboardID()) as? WelcomePageVC else {return}
//                  self?.navigationController?.pushViewController(vc, animated: true)
                    kSharedAppDelegate?.moveToHomeScreen()
                    kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
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
//MARK: - Image Picker
extension UserImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let selectedImage:UIImage = info[.originalImage] as! UIImage
        
        imageProfile.image = self.fixOrientation(img: selectedImage)
        imageProfile.restorationIdentifier = " "
        imageProfile.tag = 1
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImage.Orientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
}
