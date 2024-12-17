//
//  AddPageProductVC.swift
//  HSN
//
//  Created by Prashant Panchal on 30/11/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Photos
import PhotosUI
class AddPageProductVC: UIViewController {

    @IBOutlet weak var labelPageName: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var textFieldProductName: UITextField!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var textViewDescription: IQTextView!
    @IBOutlet weak var buttonIndustry: UIButton!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var textFieldUrl: UITextField!
    @IBOutlet weak var textFieldProductURL: UITextField!
    @IBOutlet weak var buttonAddProduct: UIButton!
    @IBOutlet weak var constraintCompanyAlreadySelected: NSLayoutConstraint!
    @IBOutlet weak var constraintCompanyNotSelected: NSLayoutConstraint!
    @IBOutlet weak var viewCompanyName: UIView!
    @IBOutlet weak var buttonCompany: UIButton!
    var hasCameFrom:HasCameFrom = .none
    var selectedIndustry = ListingDataModel(data: [:])
    var pageId = ""
    var pageName = "Your page"
    var data:PageProductModel?
    var productImages:[Any] = []{
        didSet{
            self.collectionViewImages.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        // Do any additional setup after loading the view.
    }
    
    func initialSetup(){
        self.labelPageName.text = "\(pageName)/"
        switch hasCameFrom{
        case .addProduct:
            self.labelPageTitle.text = "Add Product"
            self.buttonAddProduct.setTitle("Add Product", for: .normal)
        case .editProduct:
            self.labelPageTitle.text = "Edit Product"
            self.buttonAddProduct.setTitle("Update Product", for: .normal)
            updateData()
        default:break
        }
        setStatusBar()//color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
        self.collectionViewImages.register(UploadPhotoVideoBtnCVC.nib, forCellWithReuseIdentifier: UploadPhotoVideoBtnCVC.identifier)
        self.collectionViewImages.register(PhotoCVC.nib, forCellWithReuseIdentifier: PhotoCVC.identifier)
        if pageId.isEmpty{
            constraintCompanyAlreadySelected.isActive = false
            constraintCompanyNotSelected.isActive = true
            constraintCompanyNotSelected.constant = 15
            self.viewCompanyName.isHidden = false
        }
        else{
            constraintCompanyNotSelected.isActive = false
            constraintCompanyAlreadySelected.isActive = true
            constraintCompanyAlreadySelected.constant = 15
            self.viewCompanyName.isHidden = true
        }
    }
    
    func updateData(){
        if let obj = data{
            self.textFieldProductName.text = obj.product_name
            self.imageLogo.downlodeImage(serviceurl: kBucketUrl + obj.profile_pic, placeHolder: UIImage(named: "profile_placeholder"))
            self.textViewDescription.text = obj.tagline
            self.textFieldProductURL.text = obj.product_url
            self.imageLogo.tag = 1
            self.buttonIndustry.setTitle(obj.industry, for: .normal)
            self.buttonIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonIndustry.tag = 1
            self.productImages = obj.product_media.components(separatedBy: ",")
            self.textFieldUrl.text = obj.website_url
            self.selectedIndustry.name = obj.industry
            
        }
    }
    func validateFields(){
        if imageLogo.tag == 0{
            CommonUtils.showToast(message: "Please select product logo")
            return
        }
        if String.getString(textFieldProductName.text).isEmpty{
            CommonUtils.showToast(message: "Please enter product name")
            return
        }
        if pageId.isEmpty && buttonCompany.tag == 0{
            CommonUtils.showToast(message: "Please select company")
            return
        }
        
        if String.getString(textViewDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please enter product tagline or description")
            return
        }
        if String.getString(textFieldProductURL.text).isEmpty{
            CommonUtils.showToast(message: "Please enter product URL")
            return
        }
       
        if buttonIndustry.tag == 0{
            CommonUtils.showToast(message: "Please select Industry")
            return
        }
        if productImages.isEmpty{
            CommonUtils.showToast(message: "Please select atleast one product image")
            return
        }
        if String.getString(textFieldUrl.text).isEmpty{
            CommonUtils.showToast(message: "Please enter website URL")
            return
        }
        if !String.getString(textFieldUrl.text).isURL(){
            CommonUtils.showToast(message: "Please enter valid website URL")
            return
        }
        addProduct {
            self.moveToPopUp(text: "Product saved successfully", completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
    @IBAction func buttonSelectCompanyTapped(_ sender: Any) {
        globalApis.getAllPages(completion: { data,_  in
            self.showDropDown(on: self.navigationController, for: data.map{$0.page_name}, completion: { value,index in
                self.pageId = data[index].id
                self.buttonCompany.setTitle(value, for: .normal)
                self.buttonCompany.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonCompany.tag = 1
                
            })
        })
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonIndustryTapped(_ sender: Any) {
        globalApis.getListingData(type: .industry, completion: {data in
            
                                                                 self.showDropDown(on: self.navigationController, for:  data.map{$0.name}, completion: {
                value,index in
                
                self.buttonIndustry.setTitle(value, for: .normal)
                self.buttonIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonIndustry.tag = 1
                                                                     self.selectedIndustry = data[index]
                
    //            let res = self.selectedIndustries.filter{String.getString($0) == value}
    //                if res.isEmpty{
    //                    self.selectedIndustries.append(value)
    //                    self.collectionViewIndustry.reloadData()
    //                    self.constraintCollectionViewIndustryHeight.constant = 50
    //
    //                    self.buttonIndustry.setTitle("Select Industry", for: .normal)
    //                    self.buttonIndustry.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
    //                }
                
            })

        })

        
    }
    @IBAction func btnAddProductTapped(_ sender: Any) {
        validateFields()
        
    }
    @IBAction func buttonUploadProductLogoTapped(_ sender: Any) {
        
        
        
        
        
        
        
        ImagePickerHelper.shared.showPickerController(isEditing: false,isCircular: true,isCropper: true)  {image in
          
            self.imageLogo.image = image as! UIImage
            self.imageLogo.tag = 1
        }
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
extension AddPageProductVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadPhotoVideoBtnCVC.identifier , for: indexPath)  as! UploadPhotoVideoBtnCVC
            cell.uploadCallback = {
                
                ImagePickerHelper.shared.showBSPickerController({data in
                    if let assets = data as? [PHAsset]{
                        
                        globalApis.uploadMedia(type: .productMedia, image:  assets.map{$0.getAssetThumbnail()}, completion: { urlPath in
                            self.productImages = self.productImages + urlPath
                            
                            self.collectionViewImages.reloadData()
                        })
                        
                    }
                    if let image = data as? UIImage{
                        globalApis.uploadMedia(type: .productMedia, image: [image], completion: { urlPath in
                            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                            self.productImages.append(urlPath)
                            
                            self.collectionViewImages.reloadData()
                        })
                        
                        
                    }
                })
                
                
                
                
                
               
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
                    cell.imageMedi.downlodeImage(serviceurl: String.getString(kBucketUrl + String.getString(productImages[indexPath.row-1])), placeHolder: UIImage(named: "dummy_cover")!)
                }
            }
            
            cell.buttonEdit.isHidden = true
            cell.deleteCallback = {
                self.productImages.remove(at: indexPath.row-1)
                self.collectionViewImages.reloadData()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewImages.frame.width/3.15, height: collectionViewImages.frame.height)
    }
}
extension AddPageProductVC{
    
    func addProduct(completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let res = self.productImages.filter{$0 is String}.map{String.getString($0)}
        
        var params:[String:Any] = [ApiParameters.company_id:String.getString(pageId),
                                   ApiParameters.product_name:String.getString(textFieldProductName.text),
                                   ApiParameters.product_url:String.getString(textFieldProductURL.text),
                                   ApiParameters.website_url:String.getString(textFieldUrl.text),
                                   ApiParameters.tagline:String.getString(textViewDescription.text),
                                   ApiParameters.industry:String.getString(selectedIndustry.name),
                                   ApiParameters.product_media:res.joined(separator: ","),
                                   
                                   
        ]
        if hasCameFrom == .editProduct{
            params[ApiParameters.id] = String.getString(data?.id)
            params[ApiParameters.is_delete] = "0"

        }
        
        var images:[[String:Any]] = []
        var document:[String:Any] = [:]
        var video:[String:Any] = [:]
       
        images = [["imageName":ApiParameters.profile_pic,"image":self.imageLogo.image]]
        
            
        

        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.add_company_product, method: .post, arrImages: images, video: video,document: [document],  parameters: params)
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
}
