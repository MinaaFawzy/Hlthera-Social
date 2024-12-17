//
//  WorkViewController.swift
//  HSN
//
//  Created by Kartikeya on 13/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import DropDown
import GooglePlaces

var location = ""

class WorkViewController: UIViewController {
    
    //@IBOutlet weak var tableView:UITableView!
    //@IBOutlet weak var textFieldEmploymentType: UITextField!
    @IBOutlet weak var textFieldCompanyName: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var buttonEmploymentType: UIButton!
    @IBOutlet weak var viewEndDate: UIView!
    @IBOutlet weak var labelPresentDate: UILabel!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var buttonSaveNext: UIButton!
    @IBOutlet weak var viewShareWith: UIView!
    @IBOutlet weak var viewHealer: UIView!
    @IBOutlet weak var switchShareWith: UISwitch!
    @IBOutlet weak var switchMedicalProfessional: UISwitch!
    @IBOutlet weak var switchCurrentlyWorking: UISwitch!
    // @IBOutlet weak var constraintViewShareWithNetwork: NSLayoutConstraint!
    // @IBOutlet weak var constraintHideShareWithNetwork: NSLayoutConstraint!
    
    var empTypes: [String] = []
    var dropDown = DropDown()
    var isMedicalProfessor = false
    var isCurrentlyWorking = false
    let datePickerView = UIDatePicker()
    var dateCameFrom = 0
    var hasCameFrom:HasCameFrom = .createProfile
    var updateId = ""
    var updateData: ExperienceModel?
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchCurrentlyWorking.transform = CGAffineTransform(scaleX:0.70, y: 0.65)
        switchShareWith.transform = CGAffineTransform(scaleX:0.70, y: 0.65)
//        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupDatePicker()
        textFieldDate.isUserInteractionEnabled = true
        textFieldEndDate.isUserInteractionEnabled = true
        switch hasCameFrom{
        case .createProfile:
            self.buttonSaveNext.setTitle("Next", for: .normal)
            self.labelPageTitle.text = "What type of work do you do?"
            self.viewShareWith.isHidden = true
            //viewHealer.isHidden = false
            viewShareWith.isHidden = true
        case .editProfile:
            //  viewHealer.isHidden = true
            viewShareWith.isHidden = false
            
            self.viewShareWith.isHidden = false
            self.buttonSaveNext.setTitle("Save", for: .normal)
            self.labelPageTitle.text = "Add New Experience"
        case .updateProfile:
            //  viewHealer.isHidden = true
            viewShareWith.isHidden = true
            
            self.viewShareWith.isHidden = false
            self.buttonSaveNext.setTitle("Save", for: .normal)
            self.labelPageTitle.text = "Update Experience"
            updateDetails()
        default:break
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getEmploymentTypeApi()
    }
    
    func updateDetails() {
        if let obj = updateData {
            self.textFieldTitle.text = obj.title
            self.textFieldDate.text = obj.start_date
            self.buttonEmploymentType.setTitle(obj.employement_type, for: .normal)
            self.buttonEmploymentType.tag = 1
            self.buttonEmploymentType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            if obj.end_date == "Present"{
                self.viewEndDate.isHidden = true
                self.labelPresentDate.isHidden = false
                self.switchCurrentlyWorking.isOn = true
            }
            else{
                self.viewEndDate.isHidden = false
                self.textFieldEndDate.text = obj.end_date
                self.labelPresentDate.isHidden = true
                self.switchCurrentlyWorking.isOn = false
            }
            self.textFieldLocation.text = obj.location
            self.textFieldCompanyName.text = obj.company_name
            self.switchShareWith.isOn = obj.share_with_network == "1" ? true : false
            self.switchMedicalProfessional.isOn = obj.is_medical_professional == "1" ? true : false
            
        }
    }
    
    func setupDatePicker() {
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        self.datePickerView.datePickerMode = .date
        //let currentDate = Date()
        //var dateComponents = DateComponents()
        //let calendar = Calendar.init(identifier: .gregorian)
        //dateComponents.year = -100
        //let minDate = calendar.date(byAdding: .year, value: -50, to: currentDate)
        //let maxDate = currentDate
        //datePickerView.maximumDate = currentDate
        //datePickerView.minimumDate = minDate
        // Set minimum and maximum dates
        self.setToolBar(textField: textFieldEndDate)
        self.setToolBar(textField: textFieldDate)
    }
    
    func setToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
        
        toolBar.tag = 0
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick1))
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick2))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        if textField.tag == 0{
            toolBar.setItems([cancelButton, spaceButton, doneButton1], animated: false)
        }
        else if textField.tag == 1{
            toolBar.setItems([cancelButton, spaceButton, doneButton2], animated: false)
        }
        
        toolBar.isUserInteractionEnabled = true
        textField.inputView = self.datePickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick1() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        self.textFieldDate.text = dateFormatter.string(from: datePickerView.date)
        startDate = datePickerView.date
    }
    
    @objc func doneClick2() {
        if startDate > self.datePickerView.date {
            // Start date is after end date, show an error message
            let alert = UIAlertController(title: "Invalid dates", message: "Start date must be before end date", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            self.view.endEditing(true)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            self.textFieldEndDate.text = dateFormatter.string(from: datePickerView.date)
        }
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonCrossTapped(_ sender:UIButton){
        switch hasCameFrom{
        case .editProfile,.updateProfile:
            self.navigationController?.popViewController(animated: true)
        case .createProfile:
            kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
            kSharedAppDelegate?.moveToHomeScreen()
        default:break
        }
    }
    
    @IBAction func buttonStartDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.textFieldDate.becomeFirstResponder()
    }
    
    @IBAction func buttonEndDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.textFieldEndDate.becomeFirstResponder()
    }
    
    @IBAction func buttonNextTapped(_ sender:UIButton){
        if String.getString(textFieldTitle.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Title")
            return
        }
        if buttonEmploymentType.tag == 0{
            CommonUtils.showToast(message: "Please Select Employement Type")
            return
        }
        if String.getString(textFieldCompanyName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Company Name")
            return
            
        }
        if String.getString(textFieldLocation.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Location")
            return
            
        }
        if String.getString(textFieldLocation.text).count > 40{
            CommonUtils.showToast(message: "Location Text is too long, max allowed is 40")
            return
            
        }
        if String.getString(textFieldDate.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Start Date")
            return
            
        }
        if String.getString(textFieldEndDate.text).isEmpty && isCurrentlyWorking == false{
            CommonUtils.showToast(message: "Please Enter End Date")
            return
        }
        saveExpereinceApi(hasCameFrom)
        
    }
    
    @IBAction func switchMedicalProfessorTapped(_ sender: UISwitch) {
        isMedicalProfessor = sender.isOn
    }
    
    @IBAction func buttonCurrentlyWorking(_ sender: UISwitch) {
        
        if sender.isOn{
            self.viewEndDate.isHidden = true
            self.labelPresentDate.isHidden = false
            isCurrentlyWorking = true
        }
        else{
            self.viewEndDate.isHidden = false
            self.labelPresentDate.isHidden = true
            isCurrentlyWorking = false
        }
    }
    
    @IBAction func buttonEmploymentTypeTapped(_ sender: UIButton) {
        showDropDown(on: self.navigationController, for: empTypes, completion: {
            value,index in
            
            self.buttonEmploymentType.setTitle(value, for: .normal)
            self.buttonEmploymentType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonEmploymentType.tag = 1
            
        })
    }
    
    @IBAction func buttonLocationTapped(_ sender: UIButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        //  filter.country = countrySortName
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension WorkViewController {
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
    func saveExpereinceApi(_ hasCameFrom:HasCameFrom){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        switch hasCameFrom{
        case .createProfile,.editProfile:
            params = [ "title":String.getString(self.textFieldTitle.text),
                       "employement_type":String.getString(self.buttonEmploymentType.titleLabel?.text),
                       "company_name":String.getString(self.textFieldCompanyName.text),
                       "location":String.getString(self.textFieldLocation.text),
                       "is_currently_working_in_role":isCurrentlyWorking ? "1" :  "2",
                       "start_date":String.getString(textFieldDate.text),
                       "end_date":isCurrentlyWorking ? String.getString("Present") : String.getString(textFieldEndDate.text),
                       "share_with_network":switchShareWith.isOn ? "1" : "0",
                       "is_medical_professional":isMedicalProfessor ? "1" : "0",
                       "comp_exp_id":""
            ]
        case .updateProfile:
            params = [ "title":String.getString(self.textFieldTitle.text),
                       "employement_type":String.getString(self.buttonEmploymentType.titleLabel?.text),
                       "company_name":String.getString(self.textFieldCompanyName.text),
                       "location":String.getString(self.textFieldLocation.text),
                       "is_currently_working_in_role":isCurrentlyWorking ? "1" :  "2",
                       "start_date":String.getString(textFieldDate.text),
                       "end_date":isCurrentlyWorking ? String.getString("Present") : String.getString(textFieldEndDate.text),
                       "share_with_network":switchShareWith.isOn ? "1" : "0",
                       "is_medical_professional":isMedicalProfessor ? "1" : "0",
                       "comp_exp_id":updateId
            ]
        default:break
        }
        
        
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.save_experience,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    switch hasCameFrom{
                    case .createProfile:
                        guard let nextvc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as? LocationVC else { return }
                        nextvc.workDetails = [
                            "edit_id":UserData.shared.id
                        ]
                        nextvc.location = String.getString(self.textFieldLocation.text)
                        self.navigationController?.pushViewController(nextvc, animated: true)
                    case .editProfile,.updateProfile:
                        self.navigationController?.popViewController(animated: true)
//                        self.moveToPopUp(text: "Experience Saved Successfully!", completion: {
//                            
//                        })
                    default:break
                    }
                    let data = kSharedInstance.getDictionary(dictResult[kResponse])
                    
                    
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

extension WorkViewController : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        self.textFieldLocation.text = place.name
        //    btnState.setTitle(place.name, for: .normal)
        //     btnState.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //     btnState.tag = 1
        //     self.stateId = ""
        //     getCities(id: Int.getInt(stateId))
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



