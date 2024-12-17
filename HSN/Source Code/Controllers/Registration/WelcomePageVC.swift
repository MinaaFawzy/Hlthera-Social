//
//  TellUsAboutUrSelfVC.swift
//  HSN
//
//  Created by Mac02 on 07/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout
class WelcomePageVC: UIViewController {
    
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var textFieldDOB: UITextField!
    @IBOutlet var buttonsGender: [UIButton]!
    @IBOutlet var labelsName: [UILabel]!
    
    var email: String = ""
    var password: String = ""
    var countryCode: String = ""
    var phone: String = ""
    var genderIsMan:Bool?
    var selectedInterests:[InterestModel] = []
    var interests:[InterestModel] = []
    let datePickerView = UIDatePicker()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setupDatePicker()
        
    }
    //MARK: - methods
    func validateFields() {
          if String.getString(fullNameTF.text).isEmpty {
            CommonUtils.showToast(message: "Please enter Full Name")
            return
        }
        
        if !String.getString(fullNameTF.text).validateName() {
            CommonUtils.showToast(message: "Please enter valid Full Name")
            return
        }
        if !validDate(textField: textFieldDOB) {
            CommonUtils.showToast(message: "Please enter valid Date")
            return
        }
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: NameVC.getStoryboardID()) as? NameVC else {return}
        nextVc.email = self.email
        nextVc.password = self.password
        nextVc.countryCode = self.countryCode
        nextVc.phone = self.phone
        nextVc.fullName = String.getString(self.fullNameTF.text)
        nextVc.DOB = String.getString(self.textFieldDOB.text)
        if genderIsMan == true {
            nextVc.gender = "0"
        } else if genderIsMan == false {
            nextVc.gender = "1"
        } else {
            nextVc.gender = ""
        }
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    
    //MARK: - IBActions
    @IBAction func buttonCloseTapped(_ sender: Any) {
        kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
        kSharedAppDelegate?.moveToHomeScreen()
    }
    
    @IBAction func buttonsGenderTapped(_ sender: UIButton) {
        
        for i in 0 ... self.buttonsGender.count - 1 {
            if self.buttonsGender[i].isTouchInside {
                self.buttonsGender[i].tintColor = UIColor(named: "5")!
                self.buttonsGender[i].backgroundColor = UIColor(named: "cbe4fa")!
                self.labelsName[i].textColor = UIColor(named: "5")!
                if i == 0 {
                    genderIsMan = true
                } else {
                    genderIsMan = false
                }
                
            } else {
                self.buttonsGender[i].tintColor = UIColor(named: "8794AA")!
                self.buttonsGender[i].backgroundColor = UIColor(named: "F5F7F9")!
                self.labelsName[i].textColor = UIColor(named: "8794AA")!
                
            }
        }
    }
    
    @IBAction func buttonAddInterestTapped(_ sender: Any) {
        showDropDown(on: self.navigationController, for:  interests.map{$0.name}, completion: { [self]
            value,index in
            let res = self.selectedInterests.filter{String.getString($0) == value}
            if res.isEmpty{
                let index1 = interests.firstIndex(where: {$0.name == value})
                
                self.selectedInterests.append(interests[index1 ?? 0] ?? InterestModel(data: [:]))
            }
            
        })
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        validateFields()
    }
}

//MARK: - collection view
//extension WelcomePageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return interests.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectInterestCVC.identifier, for: indexPath) as! SelectInterestCVC
//        cell.labelName.text = interests[indexPath.row].name
//
////        cell.removeCallback = {
////            self.selectedInterests.remove(at: indexPath.row)
////            self.collectionView.reloadData()
////            if self.selectedInterests.isEmpty{
////                self.constraintCollectionViewInterests.constant = 0
////            }
////        }
//        cell.imageCover.downlodeImage(serviceurl:interests[indexPath.row].picture, placeHolder: #imageLiteral(resourceName: "profile_placeholder"))
//        if interests[indexPath.row].isSelected{
//            cell.imageCover.borderWidth = 1.5
//            cell.imageCover.borderColor = UIColor(named: "5")
//        }
//        else{
//            cell.imageCover.borderWidth = 0
//            cell.imageCover.borderColor = .clear
//        }
////        self.constraintCollectionViewInterests.constant = self.collectionView.contentSize.height
//
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width/3.25
//        return CGSize(width: width, height: width)
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        interests[indexPath.row].isSelected = !interests[indexPath.row].isSelected
////        self.collectionView.reloadData()
//    }
//
//
//}
//
//MARK: APIs
//extension WelcomePageVC {
//    func getInterests(){
//        CommonUtils.showHudWithNoInteraction(show: true)
//        let params:[String:Any] = [:]
//
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.getInterests,
//                                                   requestMethod: .GET,
//                                                   requestParameters: params, withProgressHUD: false)
//        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//
//            CommonUtils.showHudWithNoInteraction(show: false)
//
//            if errorType == .requestSuccess {
//
//                let dictResult = kSharedInstance.getDictionary(result)
//
//                switch Int.getInt(statusCode) {
//
//                case 200:
//                    let data =  kSharedInstance.getArray(dictResult["data"])
//                    self.interests = data.map{InterestModel(data: kSharedInstance.getDictionary($0))}
////                    self.collectionView.reloadData()
//
//                default:
//                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
//                }
//            } else if errorType == .noNetwork {
//                showAlertMessage.alert(message: AlertMessage.kNoInternet)
//            } else {
//                showAlertMessage.alert(message: AlertMessage.kDefaultError)
//            }
//        }
//    }
//    func addInterestApi(){
//        CommonUtils.showHudWithNoInteraction(show: true)
//
//        var params:[String:Any] = [ApiParameters.kdob:"",
//                                   ApiParameters.kGender:"",
//                                   ApiParameters.interests:interests.filter{$0.isSelected}.map{$0.id}.joined(separator: ","),
//
//        ]
//
//
//
//        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.add_interest,
//                                                   requestMethod: .POST,
//                                                   requestParameters: params, withProgressHUD: false)
//        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//
//            CommonUtils.showHudWithNoInteraction(show: false)
//
//            if errorType == .requestSuccess {
//
//                let dictResult = kSharedInstance.getDictionary(result)
//
//                switch Int.getInt(statusCode) {
//
//                case 200:
//
//                    let data = kSharedInstance.getDictionary(dictResult["user_data"])
//                    UserData.shared.saveData(data: data)
//                    kSharedAppDelegate?.moveToHomeScreen()
//                    kSharedUserDefaults.setUserLoggedIn(userLoggedIn: true)
//
//
//
//                default:
//                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
//                }
//            } else if errorType == .noNetwork {
//                showAlertMessage.alert(message: AlertMessage.kNoInternet)
//            } else {
//                showAlertMessage.alert(message: AlertMessage.kDefaultError)
//            }
//        }
//    }
//}

//MARK: - Date setup picker and data
extension WelcomePageVC {
    
    func validDate(textField: UITextField) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if dateFormatter.date(from: textField.text ?? "") != nil {
            let birthdate = textField.text?.split(separator: "/")
            if birthdate![2].count == 4 {
                return true
            } else {
                return false
            }
        } else {
            return false
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
        self.setToolBar(textField: textFieldDOB)
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
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        textField.inputView = self.datePickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today = Date()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let age = gregorian.components([.year], from: self.datePickerView.date, to: today, options: [])
        
        if age.year < 18 {
            CommonUtils.showToast(message: "Your age must be greater than 18")
        } else {
            self.textFieldDOB.text = dateFormatter.string(from: self.datePickerView.date)
        }
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
}
