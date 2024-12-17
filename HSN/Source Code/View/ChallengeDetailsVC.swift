//
//  ChallengeDetailsVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 24/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ChallengeDetailsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewChallengeDetails: UIView!
    @IBOutlet weak var textFieldDate: UITextField!
    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var textFieldDescription: UITextField!
    
    @IBOutlet weak var textFielsGoal: UITextField!
   
    @IBOutlet weak var textFieldTiming: UITextField!
    
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var textFieldEndTime: UITextField!
    
   
    
    @IBOutlet var labelName: [UILabel]!
    

    @IBOutlet var buttonConnectionPublic: [UIButton]!
    var callback:(()->())?
    let datePickerView = UIDatePicker()
    var dateCameFrom = 0
    var date = Date()
    var endDate = Date()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        
        //        DispatchQueue.main.async {
        //            self.viewChallengeDetails.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        //        }
        //        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        
        
        func setupDatePicker(){
            if #available(iOS 13.4, *) {
                datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
                datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
                datePickerView.preferredDatePickerStyle = .wheels
                datePickerView.preferredDatePickerStyle = .wheels
            }
            
            self.datePickerView.datePickerMode = .date
            textFieldTiming.delegate = self
            textFieldDate.delegate = self
            textFieldEndTime.delegate = self
            textFieldEndDate.delegate = self
            
            self.setToolBar(textField: textFieldDate)
            self.setToolBar(textField: textFieldTiming)
            self.setToolBar(textField: textFieldEndDate)
            self.setToolBar(textField: textFieldEndTime)
            
        }
    }
    
    
    func validateFields() {
     
        if String.getString(textFieldName.text).isEmpty{
            CommonUtils.showToast(message: "Please enter Event name")
            return
        }
        if String.getString(textFieldDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please enter Challenge description")
            return
        }
        
        if  String.getString(textFieldDate.text).isEmpty{
            CommonUtils.showToast(message: "Please select date")
            return
        }
        if  String.getString(textFieldTiming.text).isEmpty{
            CommonUtils.showToast(message: "Please select time")
            return
        }
        if  String.getString(textFieldEndDate.text).isEmpty{
            CommonUtils.showToast(message: "Please select end date")
            return
        }
        if  String.getString(textFieldEndTime.text).isEmpty{
            CommonUtils.showToast(message: "Please select end time")
            return
        }
        self.addChallengeApi()
        
            
        }
    

    @IBOutlet weak var imageChallenge: UIImageView!
    
//    let datePickerView = UIDatePicker()
//    var dateCameFrom = 0
//    var date = Date()
//
    
    @IBAction func buttonBackTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
        @IBAction func buttonStartDateTapped(_ sender: UIButton) {
    
            self.view.endEditing(true)
            self.textFieldDate.becomeFirstResponder()
            self.datePickerView.datePickerMode = .date
    
        }
    
        @IBAction func buttonTimeTapped(_ sender: UIButton) {
            self.view.endEditing(true)
            self.textFieldTiming.becomeFirstResponder()
            self.datePickerView.datePickerMode = .time


        }
    
    @IBAction func buttonSelectChallengeImageTap(_ sender: UIButton) {
        ImagePickerHelper.shared.showPickerController(isEditing: false,isCircular: true)  {image in
            
            self.imageChallenge.image = image as? UIImage
            self.imageChallenge.setupImageViewer()
        }
        
    }
    
    @IBAction func butttonNextTapped(_ sender: UIButton) {
        
        self.validateFields()
        
            }
    
    
    @IBAction func buttonConnectionsPublicTapped(_ sender: UIButton) {
        
        
        buttonConnectionPublic.forEach{
            $0.isSelected = false
        }
        buttonConnectionPublic.forEach{
            $0.backgroundColor = .white
        }
        labelName.forEach{
            $0.textColor = UIColor(named: "5")!
        }
        
        labelName[sender.tag].textColor = .white
        buttonConnectionPublic[sender.tag].isSelected = true
        buttonConnectionPublic[sender.tag].backgroundColor = UIColor(named: "5")!

        }
        
        
//        buttonConnectionPublic[sender.tag].isSelected = true
//        buttonConnectionPublic[sender.tag].backgroundColor = UIColor(named: "#CBE4FAA5")
        
    }
    
    

    
   
    
    
    
    
    
extension ChallengeDetailsVC {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textFieldDate:
            setMinMaxDate(datePickerView: datePickerView, isTime: false)
            datePickerView.datePickerMode = .date
       
        case textFieldTiming:
            setMinMaxDate(datePickerView: datePickerView, isTime: true)
            datePickerView.datePickerMode = .time
            
        case textFieldEndTime:
            setMinMaxDate(datePickerView: datePickerView, isTime: true)
            datePickerView.datePickerMode = .time
            
        case textFieldEndDate:
            setMinMaxDate(datePickerView: datePickerView, isTime: false)
            datePickerView.datePickerMode = .date
        default: break
            
        }
    }
    
    
    
    func setMinMaxDate(datePickerView:UIDatePicker,isTime:Bool){
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        var maxDate = Date()
        if isTime{
            dateComponents.year = 100
            maxDate = calendar.date(byAdding: dateComponents, to: currentDate) ?? Date()
        
        }
        else{
            dateComponents.year = 100
             maxDate = calendar.date(byAdding: dateComponents, to: currentDate) ?? Date()
        }
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
        datePickerView.minimumDate = Date()
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
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClickDate))
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClickEndDate))
        let doneButton3 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClickTime))
        let doneButton4 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClickEndTime))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        if textField.tag == 0{
            toolBar.setItems([cancelButton, spaceButton, doneButton1], animated: false)
        }
        else if textField.tag == 1{
            toolBar.setItems([cancelButton, spaceButton, doneButton2], animated: false)
        }
        
        else if textField.tag == 2{
            toolBar.setItems([cancelButton, spaceButton, doneButton3], animated: false)
        }
        else if textField.tag == 3{
            toolBar.setItems([cancelButton, spaceButton, doneButton4], animated: false)
        }
        toolBar.isUserInteractionEnabled = true
        textField.inputView = self.datePickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClickDate() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/YYYY"
            self.textFieldDate.text = dateFormatter.string(from: self.datePickerView.date)
        self.date = self.datePickerView.date
    }
    @objc func doneClickEndDate() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/YYYY"
            self.textFieldEndDate.text = dateFormatter.string(from: self.datePickerView.date)
        self.date = self.datePickerView.date
    }

   
    @objc func doneClickTime() {
        self.view.endEditing(true)
      
        let time = self.datePickerView.date
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: time)
            let hour = comp.hour
            let minute = comp.minute
        
        self.textFieldTiming.text = dateFormatter.string(from: time)
//        self.date = setTimeOnDate(date: self.date, timeDate: time )
    }
    @objc func doneClickEndTime() {
        self.view.endEditing(true)
      
        let time = self.datePickerView.date
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: time)
            let hour = comp.hour
            let minute = comp.minute
        
        self.textFieldEndTime.text = dateFormatter.string(from: time)
//        self.date = setTimeOnDate(date: self.date, timeDate: time )
    }

    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
}



extension ChallengeDetailsVC{
    func addChallengeApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var url = ServiceName.addChallenges
        var params:[String:Any] = [ApiParameters.name:String.getString(textFieldName.text),
                                   ApiParameters.description:String.getString(textFieldDescription.text),
                                   ApiParameters.goal:String.getString(textFielsGoal.text),
                                   ApiParameters.start_date:String.getString(textFieldDate.text),
                                   ApiParameters.start_time:String.getString(textFieldTiming.text),
                                   ApiParameters.end_date:String.getString(textFieldEndDate.text),
                                   ApiParameters.end_time:String.getString(textFieldEndTime.text),
                                   ApiParameters.kConnectionType:buttonConnectionPublic[0].isSelected ? "0" : "1",
                                   ]
        var image:[[String:Any]] = [["imageName":ApiParameters.image,"image":self.imageChallenge.image]]

        NetworkManager.shared.requestMultiParts(serviceName: url, method: .post, arrImages: image, video: [:],document: [],  parameters: params)
                {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    
                       
                        self?.dismiss(animated: true,completion: {
                            guard let nextVc = self?.storyboard?.instantiateViewController(identifier: ChallengePopUpVC.getStoryboardID()) as? ChallengePopUpVC else {return}
                            self?.navigationController?.present(nextVc, animated: true)
                        })
                        
                        
                            self?.dismiss(animated: true,completion:{
                                guard let nextVc = self?.storyboard?.instantiateViewController(identifier: FitnessHomeVC.getStoryboardID()) as? FitnessHomeVC else {return}
                                self?.navigationController?.pushViewController(nextVc, animated: true)
                            })

                case 405:
                    CommonUtils.showAlert(title: kAppName, message: String.getString(dictResult["message"]), firstTitle: "Change Subscription Plan", secondTitle: "Cancel",isSecondCancel: true, completion: {title in
                        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SubscriptionVC.getStoryboardID()) as? SubscriptionVC else { return }
                        self?.navigationController?.pushViewController(vc, animated: true)
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
