//
//  EditProfileViewController.swift
//  HSN
//
//  Created by Prashant Panchal on 11/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout
import IQKeyboardManagerSwift
import DropDown
import GooglePlaces
import QCropper

class EditProfileVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var constraintCollectionViewIndustryHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewIndustry: UICollectionView!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonSelectCoverImage: UIButton!
    @IBOutlet weak var buttonSelectProfileImage: UIButton!
    @IBOutlet weak var textFieldFullName: UITextField!
    //@IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textViewHeadline: IQTextView!
    @IBOutlet weak var btnCountry: UIButton!
    //@IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var buttonIndustry: UIButton!
    
    // MARK: - Stored Properties
    var countrySortName = ""
    var data: UserProfileModel?
    var countries: [CountriesStatesCitiesModel] = []
    var cities: [CountriesStatesCitiesModel] = []
    var states: [CountriesStatesCitiesModel] = []
    var selectedIndustries:[String] = []
    var countryId = ""
    var stateId = ""
    var cityId = ""
    var location = ""
    var dropDown = DropDown()
    var nav: UIViewController?
    var isCoverDelete = false
    var isProfileDelete = false
    var empTypes: [String] = []
    var industries: [ListingDataModel] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintCollectionViewIndustryHeight.constant = 0
        let alignedFlowLayout = collectionViewIndustry?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        getCountries()
        if !(data?.country.isEmpty)! {
            self.getCities(id: Int.getInt(data?.country))
        }
        setStatusBar()
        fillDetails()
        buttonIndustry.setTitle("Select Industry", for: .normal)
        buttonIndustry.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        
        imageCover.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageCover.contentMode = UIView.ContentMode.scaleAspectFill
        globalApis.getListingData(type: .industry, completion: {data in
            self.industries = data
        })
    }
    
    func fillDetails() {
        //        self.textFieldFirstName.text = data?.first_name
        //        self.textFieldLastName.text = data?.last_name
        
        self.textFieldFullName.text = data?.full_name
        
        self.textViewHeadline.text = data?.headline
        if let obj = data{
            if !obj.country_name.isEmpty{
                self.btnCountry.setTitle(obj.country_name, for: .normal)
                self.btnCountry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnCountry.tag = 1
                self.countryId = obj.country
            }
            //!obj.state_name.isEmpty
            if !obj.address.isEmpty{
                //self.btnState.setTitle(obj.address, for: .normal)
                //self.btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                //self.btnState.tag = 1
                self.stateId = obj.state
            }
            if !obj.city_name.isEmpty{
                self.btnCity.setTitle(obj.city_name, for: .normal)
                self.btnCity.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnCity.tag = 1
                self.cityId = obj.city
            }
            if !obj.cover_pic.isEmpty{
                
                self.imageCover.tag = 1
                self.imageCover.kf.setImage(with: URL(string: kBucketUrl + obj.cover_pic),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"),completionHandler: { data in
                    self.imageCover.setupImageViewer()
                })
            }
            if !obj.profile_pic.isEmpty{
                
                self.imageProfile.kf.setImage(with: URL(string: kBucketUrl + obj.profile_pic),placeholder: #imageLiteral(resourceName: "no_profile_image"),completionHandler: { data in
                    self.imageProfile.setupImageViewer()
                })
                
                self.imageProfile.tag = 1
            }
            if !obj.industries.isEmpty{
                print(industries)
                self.selectedIndustries = obj.industries
                self.collectionViewIndustry.reloadData()
                self.constraintCollectionViewIndustryHeight.constant = 50
            }
        }
    }
    
    func validateField() {
        if String.getString(textFieldFullName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Full Name")
            return
        }
        //        if String.getString(textFieldLastName.text).isEmpty{
        //            CommonUtils.showToast(message: "Please Enter Last Name")
        //            return
        //        }
        if String.getString(textViewHeadline.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Headling")
            return
        }
        if btnCountry.tag == 0{
            CommonUtils.showToast(message: "Please Select Country")
            return
        }
        //        if btnState.tag == 0{
        //            CommonUtils.showToast(message: "Please Select Location")
        //            return
        //        }
        if btnCity.tag == 0 && cityId != ""{
            CommonUtils.showToast(message: "Please Select City")
            return
        }
        updateProfile()
    }
    
}

// MARK: - Actions
extension EditProfileVC {
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func buttonCountryTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
            return
        }
        vc.items = countries.map{$0.name}
        vc.callback = {
            value,index in
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.btnCountry.setTitle(value, for: .normal)
                self.btnCountry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnCountry.tag = 1
                //btnState.setTitle("Select Region", for: .normal)
                //btnState.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                //btnState.tag = 0
                self.btnCity.setTitle("Select City", for: .normal)
                self.btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                self.btnCity.tag = 0
                self.countryId = self.countries[index].id
                //self.getStates(id: Int.getInt(self.countryId))
                self.getCities(id: Int.getInt(self.countryId))
            }
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
        
        //dropDown.anchorView = sender
        //dropDown.dataSource = countries.map{$0.name}
        //dropDown.selectionAction = {[unowned self](index:Int, item:String) in
        //            btnCountry.setTitle(item, for: .normal)
        //            btnCountry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //            btnCountry.tag = 1
        //            btnState.setTitle("Select State", for: .normal)
        //            btnState.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
        //            btnState.tag = 0
        //            btnCity.setTitle("Select City", for: .normal)
        //            btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
        //            btnCity.tag = 0
        //            self.countryId = countries[index].id
        //            getStates(id: Int.getInt(countryId))
        //        }
        //        dropDown.width = self.btnCountry.frame.width
        //        dropDown.show()
    }
    
    @IBAction func buttonStateTapped(_ sender: UIButton) {
        
        if String.getString(countryId) == "" && self.btnCountry.tag == 0{
            CommonUtils.showToast(message: "Please select Country first")
            return
        }
        //        else if String.getString(countryId) != "" && states.isEmpty{
        //            CommonUtils.showToast(message: "No states found, Please select another State")
        //            return
        //        }
        
        //        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
        //            return
        //        }
        //        vc.items =  states.map{$0.name}
        //        vc.callback = {
        //            value,index in
        //            self.dismiss(animated: true){ [self] in
        //                btnState.setTitle(value, for: .normal)
        //                btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //                btnState.tag = 1
        //                self.stateId = states[index].id
        //                getCities(id: Int.getInt(stateId))
        //                btnCity.setTitle("Select City", for: .normal)
        //                btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
        //                btnCity.tag = 0
        //
        //            }
        //
        //        }
        //        self.navigationController?.present(vc, animated: true, completion: nil)
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = countrySortName
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
        
        
        
        //        dropDown.anchorView = sender
        //        dropDown.dataSource = states.map{$0.name}
        //        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
        //            btnState.setTitle(item, for: .normal)
        //            btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //            btnState.tag = 1
        //            self.stateId = states[index].id
        //            getCities(id: Int.getInt(stateId))
        //            btnCity.setTitle("Select City", for: .normal)
        //            btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
        //            btnCity.tag = 0
        //        }
        //        dropDown.width = self.btnCountry.frame.width
        //        dropDown.show()
    }
    
    @IBAction func buttonCityTapped(_ sender: UIButton) {
        
        
        //        if String.getString(stateId) == "" && self.btnState.tag == 0{
        //            CommonUtils.showToast(message: "Please select State first")
        //            return
        //        }
        //        else if String.getString(stateId) != "" && cities.isEmpty{
        //            CommonUtils.showToast(message: "No cities found, Please select another city")
        //            return
        //        }
        
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else { return }
        vc.items = cities.map{ $0.name }
        vc.callback = { [weak self] value, index in
            guard let self = self else { return }
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.cityId = self.cities[index].id
                self.btnCity.setTitle(value, for: .normal)
                self.btnCity.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnCity.tag = 1
            }
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
        
//        dropDown.anchorView = sender
//        dropDown.dataSource = cities.map{$0.name}
//        dropDown.selectionAction = {[unowned self](index:Int, item:String) in
//            
//            self.cityId = cities[index].id
//            btnCity.setTitle(item, for: .normal)
//            btnCity.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//            btnCity.tag = 1
//        }
//        dropDown.width = self.btnCountry.frame.width
//        dropDown.show()
    }
    
    @IBAction func buttonIndustryTapped(_ sender: UIButton) {
        showDropDown(on: self.navigationController, for:  industries.map{$0.name}, completion: {
            value,index in
            
            self.buttonIndustry.setTitle(value, for: .normal)
            self.buttonIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonIndustry.tag = 1
            let res = self.selectedIndustries.filter{String.getString($0) == value}
            if res.isEmpty{
                self.selectedIndustries.append(value)
                self.collectionViewIndustry.reloadData()
                self.constraintCollectionViewIndustryHeight.constant = 50
                
                self.buttonIndustry.setTitle("Select Industry", for: .normal)
                self.buttonIndustry.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
            }
            
        })
        
        
        
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        validateField()
    }
}

extension EditProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedIndustries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndustriesCVC.identifier, for: indexPath) as! IndustriesCVC
        cell.labelName.text = selectedIndustries[indexPath.row]
        cell.removeCallback = {
            self.selectedIndustries.remove(at: indexPath.row)
            self.collectionViewIndustry.reloadData()
            if self.selectedIndustries.isEmpty{
                self.constraintCollectionViewIndustryHeight.constant = 0
            }
        }
        self.constraintCollectionViewIndustryHeight.constant = collectionViewIndustry.contentSize.height
        
        return cell
    }
    
}

extension EditProfileVC {
    
    func getCountries() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.userCountryList,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    self.countries = data.map{CountriesStatesCitiesModel(data: kSharedInstance.getDictionary($0))}
                    
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
    
    func getStates(id: Int) {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.countryId: id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.userStateList,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    self.states = data.map{CountriesStatesCitiesModel(data: kSharedInstance.getDictionary($0))}
                    
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
    
    func getCities(id: Int) {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params: [String: Any] = [ApiParameters.countryId: id]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.userCityList,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    self.cities = data.map{ CountriesStatesCitiesModel(data: kSharedInstance.getDictionary($0)) }
                    
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
    
    func getEmploymentTypeApi() {
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.employement_type,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["employement_type"])
                    self.empTypes = data.map{String.getString(kSharedInstance.getDictionary($0)["name"])}
                    
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
    
    func updateProfile() {
        CommonUtils.showHudWithNoInteraction(show: true)
        //     ApiParameters.state:stateId,
        
        let params:[String: Any] = [
            ApiParameters.full_name: String.getString(textFieldFullName.text),
            ApiParameters.headline: String.getString(textViewHeadline.text),
            ApiParameters.country: countryId,
            ApiParameters.city: cityId,
            //ApiParameters.kAddress: String.getString(btnState.titleLabel?.text),
            ApiParameters.is_cover_pic_delete: isCoverDelete ? "1" : "0",
            ApiParameters.is_profile_pic_delete: isProfileDelete ? "1" : "0",
            ApiParameters.industries: selectedIndustries.joined(separator: ","),
        ]
        
        let image: [[String: Any]] = [["imageName":ApiParameters.cover_pic,"image":self.imageCover.image],["imageName":ApiParameters.profile_pic,"image":self.imageProfile.image]]
        
        NetworkManager.shared.requestMultiParts(serviceName: ServiceName.editProfile, method: .post, arrImages: image, video: [:],document: [],  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    UserData.shared.full_name = String.getString(self?.textFieldFullName.text)
                    //UserData.shared.last_name = String.getString(self?.textFieldLastName.text)
                    
                    globalApis.getProfile(id: UserData.shared.id, completion: {
                        res in
                        UserData.shared.profile_pic = String.getString(res.profile_pic)
                        kSharedAppDelegate?.moveToHomeScreen()
                        
                    })
//                    self?.moveToPopUp(text: "Profile Updated Successfully!", completion: {
//
//
//
//                        //
//                    })
                    
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

class IndustriesCVC: UICollectionViewCell {
    
    var removeCallback: (()->())?
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBAction func buttonRemoveLanguageTapped(_ sender: Any) {
        removeCallback?()
    }
    
}

extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        //        btnState.setTitle(place.name, for: .normal)
        //        btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //        btnState.tag = 1
        self.stateId = ""
        getCities(id: Int.getInt(countryId))
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



