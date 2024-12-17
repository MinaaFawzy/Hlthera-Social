//
//  LocationViewController.swift
//  HSN
//
//  Created by Kartikeya on 13/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import DropDown
import GooglePlaces

class LocationVC: UIViewController {
    
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    
    var location = ""
    var dropDown = DropDown()
    var workDetails: [String:Any] = [:]
    var countries: [CountriesStatesCitiesModel] = []
    var cities: [CountriesStatesCitiesModel] = []
    var states: [CountriesStatesCitiesModel] = []
    var countryId = ""
    var stateId = ""
    var cityId = ""
    var countrySortName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar() //(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        getCountries()
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    

}

//MARK: - Actions
extension LocationVC {
    
    @IBAction func buttonCrossTapped(_ sender:UIButton){
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
        kSharedAppDelegate?.moveToHomeScreen()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonNextTapped(_ sender:UIButton) {
        if btnCountry.tag == 0{
            CommonUtils.showToast(message: "Please Select Country")
            return
        }
        if btnCity.tag == 0 && cityId != ""{
            CommonUtils.showToast(message: "Please Select City")
            return
        }
        updateLocation()
//        if btnState.tag == 0{
//            CommonUtils.showToast(message: "Please Select Location")
//            return
//        }
         
//        guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "UserImageVC") as? UserImageVC else { return }
//        self.workDetails["country"] = countryId
//        self.workDetails["state"] = stateId
//        self.workDetails["city"] = cityId
//        self.workDetails["address"] = btnState.titleLabel?.text ?? ""
//        print("\(self.workDetails)ssss")
//        nextvc.workdetails = self.workDetails
//        nextvc.location = self.location
//        self.navigationController?.pushViewController(nextvc, animated: true)
        
    }
    
    @IBAction func buttonCountryTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
            return
        }
        vc.items = countries.map{$0.name}
        vc.callback = {
            value,index in
            self.dismiss(animated: true){ [self] in
                btnCountry.setTitle(value, for: .normal)
                btnCountry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                btnCountry.tag = 1
//                btnState.setTitle("Select Location", for: .normal)
//                btnState.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
//                btnState.tag = 0
                btnCity.setTitle("Select City", for: .normal)
                btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                btnCity.tag = 0
                self.countryId = countries[index].id
                self.countrySortName = countries[index].sortname
//                getStates(id: Int.getInt(countryId))
                getCities(id: Int.getInt(countryId))
            }
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func buttonStateTapped(_ sender: UIButton) {
//        if String.getString(countryId) == "" && self.btnCountry.tag == 0{
//            CommonUtils.showToast(message: "Please select Country first")
//            return
//        }
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//                                                  UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields
//
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .region
//        filter.country = countrySortName
//        autocompleteController.autocompleteFilter = filter
//
//        // Display the autocomplete view controller.
//        present(autocompleteController, animated: true, completion: nil)
//
//        if String.getString(countryId) == "" && self.btnCountry.tag == 0{
//            CommonUtils.showToast(message: "Please select Country first")
//            return
//        }
//        else if String.getString(countryId) != "" && states.isEmpty{
//            CommonUtils.showToast(message: "No states found, Please select another State")
//            return
//        }
//
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
//        }
//        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func buttonCItyTapped(_ sender: UIButton) {
//        if String.getString(stateId) == "" && self.btnState.tag == 0{
//            CommonUtils.showToast(message: "Please select State first")
//            return
//        }
//        else
        if String.getString(countryId) == "" && cities.isEmpty{
            CommonUtils.showToast(message: "No cities found, Please select another city")
            return
        }
        
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
            return
        }
        vc.items =  cities.map{$0.name}
        vc.callback = {
            value,index in
            self.dismiss(animated: true){ [self] in
                self.cityId = cities[index].id
                btnCity.setTitle(value, for: .normal)
                btnCity.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                btnCity.tag = 1
            }
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

//MARK: - Api
extension LocationVC {
    
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
                    
                    if !LocationManager.sharedInstance.currentISOCode.isEmpty{
                        let res = self.countries.filter{$0.sortname == LocationManager.sharedInstance.currentISOCode}
                        if !res.isEmpty{
                            let obj = res[0]
                            self.btnCountry.setTitle(obj.name, for: .normal)
                            self.btnCountry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                            self.btnCountry.tag = 1
                            if !LocationManager.sharedInstance.currentLocality.isEmpty{
                                self.btnState.setTitle(LocationManager.sharedInstance.currentLocality, for: .normal)
                                self.btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                                self.btnState.tag = 1
                                
                            }
                            else{
                                self.btnState.setTitle("Select Location", for: .normal)
                                self.btnState.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                                self.btnState.tag = 0
                            }
                            self.btnCity.setTitle("Select City", for: .normal)
                            self.btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                            self.btnCity.tag = 0
                            self.countryId = obj.id
                            self.countrySortName = obj.sortname
                            self.getStates(id: Int.getInt(self.countryId))
                            self.getCities(id: Int.getInt(self.countryId))
                            
                        }
                        
                    }
                    
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
        let params:[String:Any] = [ApiParameters.countryId:id]
        
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
        let params:[String:Any] = [ApiParameters.countryId:id]
        
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
                    self.cities = data.map{CountriesStatesCitiesModel(data: kSharedInstance.getDictionary($0))}
                    
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
    
    func updateLocation(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = ["country_id": countryId,
                                   "city_id": cityId,
                                   "edit_id":UserData.shared.id
        ]
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: ServiceName.userUpdateProfile,
                                                         requestMethod: .post,
                                                         requestImages: [],
                                                         requestVideos: [:],
                                                         requestData: params)
        {(result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    UserData.shared.saveData(data: data)
                    guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: TellUsMoreAboutYouVC.getStoryboardID()) as? TellUsMoreAboutYouVC else { return }
                    self.navigationController?.pushViewController(nextvc, animated: true)
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

extension LocationVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        btnState.setTitle(place.name, for: .normal)
        btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        btnState.tag = 1
        self.stateId = ""
        getCities(id: Int.getInt(stateId))
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
