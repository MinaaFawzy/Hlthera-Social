//
//  AddEditEducationVC.swift
//  HSN
//
//  Created by Prashant Panchal on 14/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardManagerSwift
import DropDown

class AddEditEducationVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var labelSchoolName: UITextField!
    @IBOutlet weak var buttonDegree: UIButton!
    @IBOutlet weak var textFieldFieldOFStudy: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var textFieldGrades: UITextField!
    @IBOutlet weak var textViewDescription: IQTextView!
    @IBOutlet weak var switchShareWithNetwork: UISwitch!
    @IBOutlet weak var viewEndDate: UIView!
    @IBOutlet weak var labelPageTitle: UILabel!
    
    // MARK: - Stored Properties
    var degrees: [ListingDataModel] = []
    var dropDown = DropDown()
    var hasCameFrom: HasCameFrom = .editProfile
    var updateId = ""
    var data: EducationModel?
    let datePickerView = UIDatePicker()
    var dateCameFrom = 0
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        //(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        globalApis.getListingData(type: .degree, completion: { data in
            self.degrees = data
        })
        switch hasCameFrom {
        case .editProfile:
            self.labelPageTitle.text = "Add Education"
        case .updateProfile:
            fillData()
            self.labelPageTitle.text = "Update Education"
        default:
            break
        }
        setupDatePicker()
    }
    
    func fillData() {
        if let obj = data {
            self.labelSchoolName.text = obj.school_name
            self.textFieldFieldOFStudy.text = obj.field_of_study
            self.textFieldGrades.text = obj.grade
            self.textViewDescription.text = obj.description
            self.textFieldStartDate.text = obj.start_date
            self.textFieldEndDate.text = obj.end_date
            self.buttonDegree.setTitle(obj.degree, for: .normal)
            
            buttonDegree.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonDegree.tag = 1
        }
    }
    
    func validateFields() {
        if String.getString(labelSchoolName.text).isEmpty{
            CommonUtils.showToast(message: "Enter School/College Name")
            return
        }
        if buttonDegree.tag == 0 {
            CommonUtils.showToast(message: "Select Degree")
            return
        }
        if String.getString(textFieldFieldOFStudy.text).isEmpty{
            CommonUtils.showToast(message: "Enter Field of Study Name")
            return
        }
        if String.getString(textFieldStartDate.text).isEmpty{
            CommonUtils.showToast(message: "Select Start Date")
            return
        }
        if String.getString(textFieldEndDate.text).isEmpty {
            CommonUtils.showToast(message: "Select End Date")
            return
        }
        if buttonDegree.tag == 0{
            CommonUtils.showToast(message: "Select Degree")
            return
        }
        if String.getString(textViewDescription.text).isEmpty {
            CommonUtils.showToast(message: "Please Enter Description")
            return
        }
        updateProfile(hasCameFrom)
    }
    
    func setupDatePicker() {
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        self.datePickerView.datePickerMode = .date
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        let maxDate = currentDate
        //datePickerView.maximumDate = maxDate
        //datePickerView.minimumDate = minDate
        self.setToolBar(textField: textFieldStartDate)
        self.setToolBar(textField: textFieldEndDate)
    }
    
    func setToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldStartDate.text = dateFormatter.string(from: self.datePickerView.date)
        startDate = self.datePickerView.date
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
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.textFieldEndDate.text = dateFormatter.string(from: self.datePickerView.date)
        }
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
}

// MARK: - Actions
extension AddEditEducationVC {
    
    @IBAction func buttonStartDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.textFieldStartDate.becomeFirstResponder()
    }
    
    @IBAction func buttonEndDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.textFieldEndDate.becomeFirstResponder()
    }
    
    @IBAction func buttonDegreeTapped(_ sender: UIButton) {
        showDropDown(on: self.navigationController, for: degrees.map{ $0.name }, completion: { [weak self]
            value,index in
            guard let self = self else { return }
            self.buttonDegree.setTitle(value, for: .normal)
            self.buttonDegree.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonDegree.tag = 1
        })
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddEditEducationVC {
    func updateProfile(_ hasCameFrom: HasCameFrom) {
        CommonUtils.showHudWithNoInteraction(show: true)
        var params: [String: Any] = [:]
        switch hasCameFrom{
        case .editProfile:
            params = [ApiParameters.school_name:String.getString(labelSchoolName.text),
                      ApiParameters.degree:String.getString(buttonDegree.titleLabel?.text),
                      ApiParameters.field_of_study:String.getString(textFieldFieldOFStudy.text),
                      ApiParameters.is_completed:"",
                      ApiParameters.start_date:String.getString(textFieldStartDate.text),
                      ApiParameters.end_date:String.getString(textFieldEndDate.text),
                      ApiParameters.share_with_network:switchShareWithNetwork.isOn ? "1" : "0",
                      ApiParameters.grade: String.getString(textFieldGrades.text),
                      ApiParameters.description: String.getString(textViewDescription.text)]
        case .updateProfile:
            params = [ApiParameters.school_name:String.getString(labelSchoolName.text),
                      ApiParameters.degree:String.getString(buttonDegree.titleLabel?.text),
                      ApiParameters.field_of_study:String.getString(textFieldFieldOFStudy.text),
                      ApiParameters.is_completed:"",
                      ApiParameters.start_date:String.getString(textFieldStartDate.text),
                      ApiParameters.end_date:String.getString(textFieldEndDate.text),
                      ApiParameters.share_with_network:switchShareWithNetwork.isOn ? "1" : "0",
                      ApiParameters.edu_id: updateId,
                      ApiParameters.grade: String.getString(textFieldGrades.text),
                      ApiParameters.description: String.getString(textViewDescription.text)]
        default: break
        }
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.save_school,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            CommonUtils.showHudWithNoInteraction(show: false)
            if errorType == .requestSuccess {
                let dictResult = kSharedInstance.getDictionary(result)
                switch Int.getInt(statusCode) {
                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["data"])
                    self.navigationController?.moveToPopUp(text: "Education Saved Successfully!", completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
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

