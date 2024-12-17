//
//  EditPageVC.swift
//  HSN
//
//  Created by user206889 on 11/17/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import AlignedCollectionViewFlowLayout
class EditPageVC: UIViewController {
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var textFieldPageName: UITextField!
    @IBOutlet weak var textViewDescription: IQTextView!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var btnIndustry: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var collectionViewLocation: UICollectionView!
    @IBOutlet weak var constraintCollectionViewLocation: NSLayoutConstraint!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var btnCompanySize: UIButton!
    @IBOutlet weak var btnTermsCheck: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var buttonBottomSkip: UIButton!
    @IBOutlet weak var buttonCreatePage: UIButton!
    
    
    var interests:[InterestModel] = []
    var selectedLocations:[String] = []
    var minSize:CGFloat = -1
    var maxSize:CGFloat = -1
    var industries:[ListingDataModel] = []
    var selectedIndustry:ListingDataModel?
    var pageId = ""
    var data:CompanyPageModel?
    var selectedCompany:ListingDataModel?
    var hasCameFrom:HasCameFrom?
    var businessType = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        collectionViewLocation.register(UINib(nibName: MultipleSelectionCVC.identifier, bundle: nil), forCellWithReuseIdentifier: MultipleSelectionCVC.identifier)
        let alignedFlowLayout = collectionViewLocation?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        switch hasCameFrom{
        case .createPage:
            self.labelPageTitle.text = "Add Page Details"
            self.buttonCreatePage.setTitle("Create Page", for: .normal)
            self.buttonSkip.isHidden = true
            self.buttonBottomSkip.isHidden = true
        case .editPage:
            self.labelPageTitle.text = "Edit Page Details"
            self.buttonSkip.isHidden = false
            self.buttonBottomSkip.isHidden = false
            self.buttonCreatePage.setTitle("Update Page", for: .normal)
            
            updateData()
        default:break
        }
        
        // Do any additional setup after loading the view.
    }
    
    
  
    func updateData(){
        if let obj = data{
            self.textFieldPageName.text = obj.page_name
            self.textViewDescription.text = obj.description
            self.textFieldURL.text = obj.website_url
            self.btnCompany.setTitle(obj.company_type, for: .normal)
            self.btnCompany.tag = 1
            self.btnCompany.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnIndustry.setTitle(obj.industry, for: .normal)
            self.btnIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnIndustry.tag = 1
            self.selectedLocations = obj.location
            self.minSize = obj.company_size.components(separatedBy: "-").indices.contains(0) ? CGFloat(Double.getDouble(obj.company_size.components(separatedBy: "-")[0])) : CGFloat(25)
            self.maxSize = obj.company_size.components(separatedBy: "-").indices.contains(1) ? CGFloat(Double.getDouble(obj.company_size.components(separatedBy: "-")[1])) : CGFloat(1000)
            self.btnCompanySize.setTitle ( obj.company_size,for:.normal)
            self.btnCompanySize.tag = 1
            self.btnCompanySize.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
            if !obj.cover_pic.isEmpty{
               
                self.imageCover.tag = 1
                self.imageCover.kf.setImage(with: URL(string: kBucketUrl + obj.cover_pic),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: { data in
                    self.imageCover.setupImageViewer()
                })
            }
            if !obj.profile_pic.isEmpty{
               
                self.imageProfile.kf.setImage(with: URL(string: kBucketUrl + obj.profile_pic),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: { data in
                    self.imageProfile.setupImageViewer()
                })
               
                self.imageProfile.tag = 1
            }
            //self.selectedIndustry = data[index]
        }
    }
    func validateFields(){

        if String.getString(textFieldPageName.text).isEmpty{
            CommonUtils.showToast(message: "Please select page name")
            return
        }
        if String.getString(textViewDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please enter description")
            return
        }
       
         if String.getString(textFieldURL.text).isEmpty{
            CommonUtils.showToast(message: "Please enter URL")
            return
        }
        if  !String.getString(textFieldURL.text).isEmpty && !String.getString(textFieldURL.text).isURL(){
            CommonUtils.showToast(message: "Please enter valid URL")
            return
        }
        if btnIndustry.tag == 0{
            CommonUtils.showToast(message: "Please select industry")
            return
        }
        if btnCompanySize.tag == 0{
            CommonUtils.showToast(message: "Please select company size")
            return
        }
        if btnCompany.tag == 0{
            CommonUtils.showToast(message: "Please select company")
            return
        }
       
        if btnCompanySize.tag == 0{
            CommonUtils.showToast(message: "Please select company size")
            return
        }
        if selectedLocations.isEmpty {
            CommonUtils.showToast(message: "Please select atleast one location")
            return
        }
        if !btnTermsCheck.isSelected{
            CommonUtils.showToast(message: "Please accept terms and conditions")
            return
        }
        updatePage(completion: { company in
            self.moveToPopUp(text: "Page saved successfully!", completion: {
                guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddProductsLifeVC.getStoryboardID()) as? AddProductsLifeVC else { return }
                vc.hasCameFrom = .addProduct
                vc.pageId = company.id
                self.navigationController?.pushViewController(vc, animated: true)

                
//                if self.hasCameFrom == .editPage{
//                    kSharedAppDelegate?.moveToHomeScreen()}
//                else{
//                                    }
            })
        })
    }
    func updatePage(completion: @escaping (CompanyPageModel)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let bType = self.data?.business_type ?? ""
        var params:[String:Any] = [ApiParameters.business_type:String.getString(bType).isEmpty ? String.getString(businessType) : String.getString(bType),
                                   ApiParameters.website_url:String.getString(textFieldURL.text),
                                   ApiParameters.page_name:String.getString(textFieldPageName.text),
                                   ApiParameters.description:String.getString(textViewDescription.text),
                                   ApiParameters.industry:String.getString(btnIndustry.titleLabel?.text),
                                   ApiParameters.company_type:String.getString(btnCompany.titleLabel?.text),
                                   ApiParameters.company_size:String.getString(btnCompanySize.titleLabel?.text),
                                   ApiParameters.location:self.selectedLocations.joined(separator: ","),
                                   
        ]
        if hasCameFrom == .editPage{
            params[ApiParameters.id] = self.pageId
            params[ApiParameters.is_delete] = "0"
            
        }
        
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
                    let company = CompanyPageModel(data: data)
                    
                 
                    completion(company)
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
    
    
    @IBAction func buttonSelectCoverImageTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController(isEditing:false) {image in
         
            self.imageCover.image = image as! UIImage
           self.imageCover.setupImageViewer()
        }
    }
    @IBAction func buttonSelectProfileImageTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController(isEditing: false,isCircular: true)  {image in
          
            self.imageProfile.image = image as! UIImage
            self.imageProfile.setupImageViewer()
//            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: {
//                let cropper = CropperViewController(originalImage: image as! UIImage,isCircular: true)
//                cropper.delegate = self
//                self.present(cropper, animated: true, completion:nil)
//            })
           
            
        }
    }
    @IBAction func buttonSkipTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddProductsLifeVC.getStoryboardID()) as? AddProductsLifeVC else { return }
        vc.hasCameFrom = .addProduct
        vc.pageId = self.pageId
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func btnTermsCheckTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func btnTermsTapped(_ sender: Any) {
        guard let nextVc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
        nextVc.pageTitleString = "Company Terms & Conditions"
        nextVc.url = kBASEURL + "company_term_condition"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
       // validateFields()
    }
   
    @IBAction func btnIndustryTapped(_ sender: Any) {
        globalApis.getListingData(type: .industry, completion: {data in
            
                                                                 self.showDropDown(on: self.navigationController, for:  data.map{$0.name}, completion: {
                value,index in
                
                self.btnIndustry.setTitle(value, for: .normal)
                self.btnIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnIndustry.tag = 1
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
    @IBAction func btnCompanyTypeTapped(_ sender: Any) {
        globalApis.getListingData(type: .company, completion: {data in
            
                                                                 self.showDropDown(on: self.navigationController, for:  data.map{$0.name}, completion: {
                value,index in
                
                self.btnCompany.setTitle(value, for: .normal)
                self.btnCompany.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnCompany.tag = 1
                                                                     self.selectedCompany = data[index]

            })

        })

    }
    
    @IBAction func btnCompanySizeTapped(_ sender: Any) {
    
        
                                                             self.showDropDown(on: self.navigationController, for:["Small Size","Medium Size","Large Size"], completion: {
            value,index in
            
            self.btnCompanySize.setTitle(value, for: .normal)
            self.btnCompanySize.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnCompanySize.tag = 1
                                                                 

        })

    }
    @IBAction func btnLocationTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
           autocompleteController.delegate = self

           // Specify the place data types to return.
           let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
             UInt(GMSPlaceField.placeID.rawValue))!
           autocompleteController.placeFields = fields

           // Specify a filter.
           let filter = GMSAutocompleteFilter()
        filter.type = .region
           autocompleteController.autocompleteFilter = filter

           // Display the autocomplete view controller.
           present(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func btnSaveTapped(_ sender: Any) {
        validateFields()
        
    }
    
}
extension EditPageVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            
            return selectedLocations.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleSelectionCVC.identifier, for: indexPath) as! MultipleSelectionCVC
       
            cell.labelText.text = selectedLocations[indexPath.row]
            cell.removeCallback = {
                self.selectedLocations.remove(at: indexPath.row)
                self.collectionViewLocation.reloadData()
                if self.selectedLocations.isEmpty{
                    self.constraintCollectionViewLocation.constant = 0
                }
            }
            self.constraintCollectionViewLocation.constant = collectionViewLocation.contentSize.height
       
        return cell
      
    }
    
    
    
}
extension EditPageVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    
      if self.selectedLocations.filter{$0.lowercased() == place.name}.isEmpty{
          self.selectedLocations.append(place.name ?? "")
          self.constraintCollectionViewLocation.constant =  CGFloat(50 * selectedLocations.count)
          self.collectionViewLocation.reloadData()
      }
            
            
            
             
    
    
    
    
    dismiss(animated: true, completion: nil)
    
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
//extension EditPageVC:RangeSeekSliderDelegate{
//
//    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
//        self.minSize = minValue
//        self.maxSize = maxValue
//    }
//}


