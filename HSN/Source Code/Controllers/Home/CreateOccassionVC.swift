//
//  CreateOccassionVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class CreateOccassionVC: UIViewController {
    @IBOutlet weak var imageOccassion: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var parentVC:UIViewController?
    var occassions:[CelebrationImageModel] = []
    var occassionType = -1
    @IBOutlet weak var viewUploadBtn: UIView!
    @IBOutlet weak var buttonRemovePhoto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        getCelebrations(type: occassionType+1)
        self.buttonRemovePhoto.isHidden = true

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonSelectPhotoTapped(_ sender: Any) {
        CommonUtils.imagePicker(viewController: self)
    }
    @IBAction func buttonNextTapped(_ sender: Any) {
        if imageOccassion.tag == 0{
            CommonUtils.showToast(message: "Please Select Image")
            return
        }
        else{
            uploadBanner()
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonRemovePhotoTapped(_ sender: Any) {
        self.imageOccassion.image = #imageLiteral(resourceName: "cover_page_placeholder")
        self.imageOccassion.isHidden  = true
        self.viewUploadBtn.isHidden = false
        self.buttonRemovePhoto.isHidden = true
        self.imageOccassion.tag = 0
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
extension CreateOccassionVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
         let image:UIImage = info[.originalImage] as! UIImage
//        if media.count < 8{
//
//        }else{
//            CommonUtils.showToast(message: "Max Documents upload limit is reached")
//            return
//        }
        self.imageOccassion.image = image
        self.imageOccassion.isHidden  = false
        self.viewUploadBtn.isHidden = true
        self.buttonRemovePhoto.isHidden = false
        self.imageOccassion.tag = 1
       // collectionViewDocuments.reloadData()
         picker.dismiss(animated: true, completion: nil)
     }
     //button cancel
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
         
     }
    
}
extension CreateOccassionVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return occassions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateOccassionCVC.identifier, for: indexPath) as! CreateOccassionCVC
        if occassions[indexPath.row].isSelected{
            cell.imageOccassion.borderColor = UIColor.black
            cell.imageOccassion.borderWidth = 1
        }
        else{
            cell.imageOccassion.borderWidth = 0
        }
        cell.imageOccassion.downlodeImage(serviceurl: kBucketUrl+occassions[indexPath.row].celebration_image, placeHolder: #imageLiteral(resourceName: "cover_page_placeholder"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2.2, height: self.collectionView.frame.width/2.2)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        occassions.map{$0.isSelected = false}
        occassions[indexPath.row].isSelected = true
        viewUploadBtn.isHidden = true
        self.imageOccassion.isHidden = false
        self.buttonRemovePhoto.isHidden = false
        self.imageOccassion.tag = 1
        self.imageOccassion.downlodeImage(serviceurl: kBucketUrl+occassions[indexPath.row].celebration_image, placeHolder: #imageLiteral(resourceName: "event_cover_page"))
        
        self.collectionView.reloadData()
    }
    
}
class CreateOccassionCVC:UICollectionViewCell{
    @IBOutlet weak var imageOccassion: UIImageView!
    
}
extension CreateOccassionVC{
    func getCelebrations(type:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.celebration_images + "?celebration_type=\(Int.getInt(type))",
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["images"])
                    self.occassions = data.map{CelebrationImageModel(data: (kSharedInstance.getDictionary($0)))}
                    self.collectionView.reloadData()
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
    func uploadBanner(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = ["type":"1"]
        
        let image:[String:Any] = ["imageName":"picture","image":self.imageOccassion.image ?? UIImage()]
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.upload_banner, method: .post, arrImages: [image], video: [:],document: [[:]],  parameters: params)
                {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  String.getString(dictResult["img_url"])
                    
                    self?.handleResponse(url: data)
                    
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
    
    func handleResponse(url:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: SelectRecipientVC.getStoryboardID()) as! SelectRecipientVC
        
        vc.image = self.imageOccassion.image ?? #imageLiteral(resourceName: "profile_placeholder")
        vc.url = url
        vc.celebrationId = occassionType
        vc.hasCameFrom = .recipient
        vc.parentVC = self.parentVC ?? UIViewController()
         self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImageView{
    
     func setImageFromUrl(stringUrl:String){
         if !stringUrl.isEmpty{
             let url = URL(string: stringUrl)
             DispatchQueue.global().async {
                 let data = try? Data(contentsOf: url!)
                 DispatchQueue.main.async {
                    if data != nil{
                        self.image = UIImage(data: data!)
                    }
                    
                 }
             }
         }
         
         
         // SVProgressHUD.dismiss()
     }
 
}
