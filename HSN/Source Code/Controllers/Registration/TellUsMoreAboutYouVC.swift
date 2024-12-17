//
//  TellUsMoreAboutYouVC.swift
//  HSN
//
//  Created by Mina Fawzy on 21/08/2023.
//  Copyright © 2023 Kartikeya. All rights reserved.
//

import UIKit

class TellUsMoreAboutYouVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var employmentTypeButton: UIButton!
    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var LocationTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var presentLable: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    let datePickerView = UIDatePicker()
    var isCurrentlyWorking = true
    var employeeTypes: [String] = []
    var startDate: Date = Date()
    var endDate: Date = Date()
 
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        getEmploymentTypeApi()
    }
}

//MARK: - IBActions
extension TellUsMoreAboutYouVC {
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
        kSharedAppDelegate?.moveToHomeScreen()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func employmentTypeButtonTaaped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
            return
        }
        vc.items = employeeTypes
        vc.callback = {
            value,index in
            self.dismiss(animated: true){ [self] in
                employmentTypeButton.setTitle(value, for: .normal)
                employmentTypeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                employmentTypeButton.tag = 1
            }
            
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        if endDateView.isHidden {
            isCurrentlyWorking = false
            endDateView.isHidden = false
            presentLable.isHidden = true
            checkButton.setImage(UIImage(named: "checkbox"), for: .normal)
        } else {
            isCurrentlyWorking = true
            endDateView.isHidden = true
            presentLable.isHidden = false
            checkButton.setImage(UIImage(named: "checked"), for: .normal)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if String.getString(titleTF.text).isEmpty {
            CommonUtils.showToast(message: "Please enter Title")
            return
        }
        if employmentTypeButton.tag == 0 {
            CommonUtils.showToast(message: "Please select employment Type")
            return
        }
        if String.getString(companyNameTF.text).isEmpty {
            CommonUtils.showToast(message: "Please enter company name")
            return
        }
        if String.getString(LocationTF.text).isEmpty {
            CommonUtils.showToast(message: "Please enter Location")
            return
        }
        if String.getString(startDateTF.text).isEmpty {
            CommonUtils.showToast(message: "Please enter valid start date")
            return
        }
        if String.getString(endDateTF.text).isEmpty && !isCurrentlyWorking{
            CommonUtils.showToast(message: "Please enter valid end date")
            return
        }
        saveExpereinceApi()
        
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "TopicsVC") as? TopicsVC else { return }
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
}

//MARK: - Date picker methods to start and end date
extension TellUsMoreAboutYouVC {
   
    func setupDatePicker() {
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        self.datePickerView.datePickerMode = .date
        self.setToolBar(textField: startDateTF)
        self.setToolBar(textField: endDateTF)
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
        self.startDateTF.text = dateFormatter.string(from: datePickerView.date)
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
            self.endDateTF.text = dateFormatter.string(from: datePickerView.date)
        }
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
}

//MARK: - Api
extension TellUsMoreAboutYouVC {
    
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
                    self.employeeTypes = data.map{String.getString(kSharedInstance.getDictionary($0)["name"])}
                    
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
    
    func saveExpereinceApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        params = [ "title":String.getString(self.titleTF.text),
                   "employement_type":String.getString(self.employmentTypeButton.titleLabel?.text),
                   "company_name":String.getString(self.companyNameTF.text),
                   "location":String.getString(self.LocationTF.text),
                   "is_currently_working_in_role":isCurrentlyWorking ? "1" :  "2",
                   "start_date":String.getString(startDateTF.text),
                   "end_date":isCurrentlyWorking ? String.getString("Present") : String.getString(endDateTF.text),
                   "share_with_network":"1",
                   "is_medical_professional":"",
                   "comp_exp_id":""
        ]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.save_experience,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: TopicsVC.getStoryboardID()) as? TopicsVC else { return }
                    self.navigationController?.pushViewController(nextvc, animated: true)
//                    switch hasCameFrom{
//                    case .createProfile:
//                        guard let nextvc = UIStoryboard(name: Storyboards.kMain, bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as? LocationVC else { return }
//                        nextvc.workDetails = [
//                            "edit_id":UserData.shared.id
//                        ]
//                        nextvc.location = String.getString(self.textFieldLocation.text)
//                        self.navigationController?.pushViewController(nextvc, animated: true)
//                    case .editProfile,.updateProfile:
//                        self.moveToPopUp(text: "Experience Saved Successfully!", completion: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                    default:break
//                    }
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
