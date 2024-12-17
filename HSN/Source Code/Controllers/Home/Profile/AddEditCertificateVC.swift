//
//  AddEditCertificateVC.swift
//  HSN
//
//  Created by Prashant Panchal on 14/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import DropDown

class AddEditCertificateVC: UIViewController {
    @IBOutlet weak var textFieldCertificateName: UITextField!
    @IBOutlet weak var buttonIssuingOrganization: UIButton!
    @IBOutlet weak var buttonCertficateDoesNotExprire: UIButton!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var switchShareWithNetwork: UISwitch!
    @IBOutlet weak var viewEndDate: UIView!
    @IBOutlet weak var labelPresentDate: UILabel!
    @IBOutlet weak var labelPageTitle: UILabel!
    
    let datePickerView = UIDatePicker()
    var dateCameFrom = 0
    var dropDown = DropDown()
    var organizations:[ListingDataModel] = []
    var updateId = ""
    var data:CertificateModel?
    var hasCameFrom:HasCameFrom = .editProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        globalApis.getListingData(type: .organization, completion: { data in
           
            self.organizations = data
       })
        switch hasCameFrom {
        case .editProfile:
            print("none")
            self.labelPageTitle.text = "Add License & Certficate"
        case .updateProfile:
            self.labelPageTitle.text = "Update License & Certficate"
            fillData()
        default:
            break
        }
        // Do any additional setup after loading the view.
    }
    func fillData(){
        if let obj = data{
            
            self.textFieldCertificateName.text = obj.certificate
            if obj.end_date == "Present"{
                self.viewEndDate.isHidden = true
                self.labelPresentDate.isHidden = false
                self.buttonCertficateDoesNotExprire.isSelected = true
            }
            else{
                self.viewEndDate.isHidden = false
                self.textFieldEndDate.text = obj.end_date
                self.labelPresentDate.isHidden = true
                self.buttonCertficateDoesNotExprire.isSelected = false
            }
            self.switchShareWithNetwork.isOn = obj.share_with_network == "1" ? true : false
            self.textFieldStartDate.text = obj.start_date
            self.textFieldEndDate.text = obj.end_date
            self.buttonIssuingOrganization.setTitle(obj.org_name, for: .normal)
            
            buttonIssuingOrganization.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonIssuingOrganization.tag = 1
        }
    }
    func setupDatePicker(){
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
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
       self.setToolBar(textField: textFieldStartDate)
        self.setToolBar(textField: textFieldEndDate)
    }
    func setToolBar(textField:UITextField) {
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
            self.textFieldStartDate.text = dateFormatter.string(from: self.datePickerView.date)
    }
    @objc func doneClick2() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldEndDate.text = dateFormatter.string(from: self.datePickerView.date)
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    func validateFields(){
        if String.getString(textFieldCertificateName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Certificate Name")
            return
        }
        if buttonIssuingOrganization.tag == 0{
            CommonUtils.showToast(message: "Please Select Organization")
            return
        }
        if String.getString(textFieldStartDate.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Start Date")
            return
        }
        if String.getString(textFieldEndDate.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter End Date")
            return
        }
        updateProfile(self.hasCameFrom)
    }
    @IBAction func buttonStartDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.textFieldStartDate.becomeFirstResponder()
    }
    @IBAction func buttonEndDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.textFieldEndDate.becomeFirstResponder()
    }
    @IBAction func buttonCertificateDoesNotExpireTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.viewEndDate.isHidden = true
            self.labelPresentDate.isHidden = false
        }else{
            self.viewEndDate.isHidden = false
            self.labelPresentDate.isHidden = true
        }
    }
    @IBAction func buttonIssuingOrganizationTapped(_ sender: UIButton) {
        showDropDown(on: self.navigationController, for:organizations.map{$0.name}, completion: {
            value,index in
          
            self.buttonIssuingOrganization.setTitle(value, for: .normal)
            self.buttonIssuingOrganization.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonIssuingOrganization.tag = 1
            
        })
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        validateFields()
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
extension AddEditCertificateVC{
    func updateProfile(_ hasCameFrom:HasCameFrom){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [:]
        switch hasCameFrom{
        case .editProfile:
            params = [ApiParameters.certificate:String.getString(textFieldCertificateName.text),
                      ApiParameters.org_name:String.getString(buttonIssuingOrganization.titleLabel?.text),
                      ApiParameters.is_certificate_expire:buttonCertficateDoesNotExprire.isSelected ? "1" : "0",
                      
                      ApiParameters.start_date:String.getString(textFieldStartDate.text),
                      ApiParameters.end_date:viewEndDate.isHidden ? String.getString("Present") : String.getString(textFieldEndDate.text),
                      ApiParameters.share_with_network:switchShareWithNetwork.isOn ? "1" : "0",
                      ]
        case .updateProfile:
            params = [ApiParameters.certificate:String.getString(textFieldCertificateName.text),
                      ApiParameters.org_name:String.getString(buttonIssuingOrganization.titleLabel?.text),
                      ApiParameters.is_certificate_expire:buttonCertficateDoesNotExprire.isSelected ? "1" : "0",
                      
                      ApiParameters.start_date:String.getString(textFieldStartDate.text),
                      ApiParameters.end_date:viewEndDate.isHidden ? String.getString("Present") : String.getString(textFieldEndDate.text),
                      ApiParameters.share_with_network:switchShareWithNetwork.isOn ? "1" : "0",
                      ApiParameters.cert_id:updateId
                      ]
         
        default:break
        
        }
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.save_certificate,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    self.navigationController?.moveToPopUp(text: "Certificate Saved Successfully!", completion: {
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
