//
//  CreatePageOverviewVC.swift
//  HSN
//
//  Created by user206889 on 11/16/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class CreatePageOverviewVC: UIViewController {
    @IBOutlet weak var lblPageName: UILabel!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonSelectCoverImage: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var buttonSelectProfileImage: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBusinessType: UILabel!
    @IBOutlet weak var lblIndustry: UILabel!
    @IBOutlet weak var lblCompanySize: UILabel!
    @IBOutlet weak var lblUrl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblLocation.text = String.getString(pageData[ApiParameters.location])
        self.lblIndustry.text = String.getString(pageData[ApiParameters.industry])
        self.lblBusinessType.text = String.getString(pageData[ApiParameters.business_type])
        self.lblCompanySize.text = String.getString(pageData[ApiParameters.company_size])
        self.lblUrl.text = String.getString(pageData[ApiParameters.website_url])
    }
    
    func validateFields(){
        if imageProfile.tag == 0{
            CommonUtils.showToast(message: "Please select profile image")
            return
        }
        if imageCover.tag == 0{
            CommonUtils.showToast(message: "Please select cover image")
            return
        }
        
        createPage(){
            self.moveToPopUp(text: "Page created successfully!", completion: {
                kSharedAppDelegate?.moveToHomeScreen()
            })
        }
        
    }
    func createPage(completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = pageData
        
        var images:[[String:Any]] = []
        var document:[String:Any] = [:]
        var video:[String:Any] = [:]
       
        images = [["imageName":ApiParameters.profile_pic,"image":self.imageProfile.image],["imageName":ApiParameters.cover_pic,"image":self.imageCover.image]]
        
            
        

        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.add_company, method: .post, arrImages: images, video: video,document: [document],  parameters: params)
                {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            

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
    
        
    
    
    @IBAction func btnTermsTapped(_ sender: Any) {
        
    }
    @IBAction func btnCreatePageTapped(_ sender: Any) {
        validateFields()
    }
    @IBAction func buttonSelectCoverImageTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController(isEditing:false) {image in
         
            self.imageCover.image = image as! UIImage
           self.imageCover.setupImageViewer()
            self.imageCover.tag = 1
            if let vc = self.parent{
                if let pvc = vc as? CreatePageConnectionsVC{
                    pvc.changeViewController(index: 2, direction: .forward)
                    if let parentOfPVC = pvc.parent{
                        if let ppvc = parentOfPVC as? CreatePromotionPostVC{
                            ppvc.selectScreen(index: 2)
                        }
                    }
                }
            }

        }
    }
    @IBAction func buttonSelectProfileImageTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController(isEditing: false,isCircular: true)  {image in
          
            self.imageProfile.image = image as! UIImage
            self.imageProfile.setupImageViewer()
            self.imageProfile.tag = 1
            if let vc = self.parent{
                if let pvc = vc as? CreatePageConnectionsVC{
                    pvc.changeViewController(index: 2, direction: .forward)
                    if let parentOfPVC = pvc.parent{
                        if let ppvc = parentOfPVC as? CreatePageVC{
                            ppvc.selectScreen(index: 2)
                        }
                    }
                }
            }

//            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: {
//                let cropper = CropperViewController(originalImage: image as! UIImage,isCircular: true)
//                cropper.delegate = self
//                self.present(cropper, animated: true, completion:nil)
//            })
           
            
        }
    }
    
}
