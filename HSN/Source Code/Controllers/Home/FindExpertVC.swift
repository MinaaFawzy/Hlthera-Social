//
//  FindExpertVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
class FindExpertVC: UIViewController {

    @IBOutlet var buttonsType: [UIButton]!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var textViewDescription: IQTextView!
    @IBOutlet weak var textFieldTitle: UITextField!
    
    var location = ""
    var dropDown = DropDown()
    var countries:[CountriesStatesCitiesModel] = []
    var cities:[CountriesStatesCitiesModel] = []
    var states:[CountriesStatesCitiesModel] = []
    var countryId = ""
    var stateId = ""
    var cityId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsType[0].isSelected = true
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        getCountries()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                btnState.setTitle("Select State", for: .normal)
                btnState.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                btnState.tag = 0
                btnCity.setTitle("Select City", for: .normal)
                btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                btnCity.tag = 0
                self.countryId = countries[index].id
                getStates(id: Int.getInt(countryId))
                
            }
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func buttonStateTapped(_ sender: UIButton) {
        if String.getString(countryId) == "" && self.btnCountry.tag == 0{
            CommonUtils.showToast(message: "Please select Country first")
            return
        }
        else if String.getString(countryId) != "" && states.isEmpty{
            CommonUtils.showToast(message: "No states found, Please select another State")
            return
        }
        
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
            return
        }
        vc.items =  states.map{$0.name}
        vc.callback = {
            value,index in
            self.dismiss(animated: true){ [self] in
                btnState.setTitle(value, for: .normal)
                btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                btnState.tag = 1
                self.stateId = states[index].id
                getCities(id: Int.getInt(stateId))
                btnCity.setTitle("Select City", for: .normal)
                btnCity.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
                btnCity.tag = 0
                
            }
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func buttonCityTapped(_ sender: UIButton) {
        if String.getString(stateId) == "" && self.btnState.tag == 0{
            CommonUtils.showToast(message: "Please select State first")
            return
        }
        else if String.getString(stateId) != "" && cities.isEmpty{
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
    @IBAction func buttonNextTapped(_ sender: Any) {
        if btnCountry.tag == 0{
            CommonUtils.showToast(message: "Please Select Country")
            return
        }
        if btnState.tag == 0{
            CommonUtils.showToast(message: "Please Select State")
            return
        }
        if btnCity.tag == 0 && cityId != ""{
            CommonUtils.showToast(message: "Please Select City")
            return
        }
        if String.getString(textFieldTitle.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Title")
        }
        if String.getString(textViewDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Description")
        }
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreatePostVC.getStoryboardID()) as? CreatePostVC else { return }
        vc.isFindExpert = true
        vc.country = String.getString(self.btnCountry.titleLabel?.text)
        vc.state = String.getString(self.btnState.titleLabel?.text)
        vc.city = String.getString(self.btnCity.titleLabel?.text)
        vc.findExpertTitle = String.getString(textFieldTitle.text)
        vc.findExpertDescription = String.getString(textViewDescription.text)
        vc.findExpertPostType = buttonsType[0].isSelected ? String.getString(buttonsType[0].titleLabel?.text) : String.getString(buttonsType[1].titleLabel?.text)
        vc.shareData?.is_post_type = "7"
        vc.findExpertHashTags = "#" + (buttonsType[0].isSelected ? String.getString(buttonsType[0].titleLabel?.text) : String.getString(buttonsType[1].titleLabel?.text))
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func buttonsPostTypeTapped(_ sender: UIButton) {
        if sender.tag == 0{
            self.buttonsType[0].isSelected = true
            self.buttonsType[1].isSelected = false
        }
        else{
            self.buttonsType[0].isSelected = false
            self.buttonsType[1].isSelected = true
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
extension FindExpertVC{
    func getCountries(){
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
    func getStates(id:Int){
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

    func getCities(id:Int){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.stateId:id]
        
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

}
