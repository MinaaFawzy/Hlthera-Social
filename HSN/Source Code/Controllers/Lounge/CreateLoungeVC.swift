//
//  CreateLoungeVC.swift
//  HSN
//
//  Created by Prashant Panchal on 14/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseDynamicLinks
import CoreMIDI
import FittedSheets

class CreateLoungeVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var anonymousSwitch: UISwitch!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewDescription: IQTextView!
    @IBOutlet var viewsNavigation: [UIView]!
    @IBOutlet var viewsLoungeType: [UIView]!
    @IBOutlet var btnsLoungeType: [UIButton]!
    @IBOutlet var imgsLoungeType: [UIImageView]!
    @IBOutlet weak var constraintScheduleHeight: NSLayoutConstraint!
    @IBOutlet weak var switchSchedule: UISwitch!
    @IBOutlet weak var btnStartSchedule: UIButton!
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet var labelsLoungeType: [UILabel]!
    
    //MARK: - variables
    let datePickerView = UIDatePicker()
    var dateCameFrom = 0
    var date = Date()
    var selectedTab = 0
    var anonymousState = false
    var health:[LoungeSuggestedModel] = [
        LoungeSuggestedModel(image: UIImage(named: "health_covid")!, name: "COVID-19"),
        LoungeSuggestedModel(image: UIImage(named: "health_wellness_and_lifestyle")!, name: "Wellness and Lifestyle"),
        LoungeSuggestedModel(image: UIImage(named: "health_nutrition")!, name: "Nutrition"),
        LoungeSuggestedModel(image: UIImage(named: "health_drug_therapy")!, name: "Drug Therapy"),
        LoungeSuggestedModel(image: UIImage(named: "health_holistic_healing")!, name: "Holistic Healing"),
        LoungeSuggestedModel(image: UIImage(named: "health_diabetes")!, name: "Diabetes"),
        LoungeSuggestedModel(image: UIImage(named: "health_cancer")!, name: "Cancer")]
    
    var social:[LoungeSuggestedModel] = [
        LoungeSuggestedModel(image: UIImage(named: "social_hanging_out")!, name: "Hanging out"),
        LoungeSuggestedModel(image: UIImage(named: "social_story_time")!, name: "Story time"),
        LoungeSuggestedModel(image: UIImage(named: "social_town_halls")!, name: "Town Halls"),
        LoungeSuggestedModel(image: UIImage(named: "social_media_discussion")!, name: "Media Discussion"),
        LoungeSuggestedModel(image: UIImage(named: "social_networking")!, name: "Networking"),
        LoungeSuggestedModel(image: UIImage(named: "social_tech_talks")!, name: "Tech Talks"),
        LoungeSuggestedModel(image: UIImage(named: "social_open_mic")!, name: "Open Mic"),
        LoungeSuggestedModel(image: UIImage(named: "social_travel")!, name: "Travel"),
        LoungeSuggestedModel(image: UIImage(named: "social_hobbies")!, name: "Hobbies")]

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatePicker()
        tableView.tableFooterView = UIView()
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        setStatusBar()//color: UIColor(hexString: "F5F7F9"))
        self.tableView.register(UINib(nibName: LoungeSuggestionsTVC.identifier, bundle: nil), forCellReuseIdentifier: LoungeSuggestionsTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigation()
        constraintScheduleHeight.constant = 0
        viewSchedule.isHidden = true
        switchSchedule.transform = CGAffineTransform(scaleX: 0.70, y: 0.65)
        anonymousSwitch.transform = CGAffineTransform(scaleX: 0.70, y: 0.65)
        tableView.separatorStyle = .none
        self.textFieldName.delegate = self
    }
    
    //MARK: - methods
    func setupDatePicker(){
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        self.datePickerView.datePickerMode = .date
        textFieldTime.delegate = self
        textFieldDate.delegate = self
        
        self.setToolBar(textField: textFieldDate)
        self.setToolBar(textField: textFieldTime)
    }
    
    func selectLoungeType(index:Int){
        btnsLoungeType.forEach{
            $0.isSelected = false
        }
//        imgsLoungeType.forEach{
//            $0.image = UIImage(named: "select")
//        }
        viewsLoungeType.forEach{
            $0.backgroundColor = UIColor(named: "LoungeTypeBgColor")!
        }
        labelsLoungeType.forEach{
            $0.textColor = UIColor(named: "LoungeTextColor")!
        }
      //  labelsLoungeType[index].textColor = .white
        viewsLoungeType[index].backgroundColor = UIColor(named: "SelectionColor")!
        
        
       btnsLoungeType[index].isSelected = true
//        imgsLoungeType[index].image = UIImage(named: "selected")
    }
    
    func setupNavigation(selectedIndex:Int = 0){
   
        for (index,view) in self.viewsNavigation.enumerated(){
            for btn in view.subviews{
                if let button  = btn as? UIButton{
                    button.setTitleColor(selectedIndex == index ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1)), for: .normal)
                  //  button.titleLabel?.font = selectedIndex == index ? (UIFont(name: "SFProDisplay-Medium", size: 16)) : (UIFont(name: "SFProDisplay-Regular", size: 16))
                    button.adjustsImageWhenDisabled = false
                    button.adjustsImageWhenHighlighted = false
                }
                
                else{
                    btn.isHidden = index == selectedIndex ? (false) : (true)
                    btn.backgroundColor = index == selectedIndex ? (#colorLiteral(red: 0.1512879729, green: 0.3206651807, blue: 0.4994546771, alpha: 1)) : (#colorLiteral(red: 0.5176470588, green: 0.5803921569, blue: 0.6784313725, alpha: 1))
                    
                }
            }
        }
    }
    func validateFields(){
     
        if String.getString(textFieldName.text).isEmpty{
            CommonUtils.showToast(message: "Please enter lounge name")
            return
        }
        if String.getString(textViewDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please enter lounge description")
            return
        }
        if btnsLoungeType.filter({$0.isSelected}).isEmpty{
            CommonUtils.showToast(message: "Please select lounge type")
            return
        }
        if switchSchedule.isOn && String.getString(textFieldDate.text).isEmpty{
            CommonUtils.showToast(message: "Please select date")
            return
        }
        if switchSchedule.isOn && String.getString(textFieldTime.text).isEmpty{
            CommonUtils.showToast(message: "Please select time")
            return
        }

        createFirebaseRoom(){ id in
            if self.viewSchedule.isHidden{
                self.navigationController?.popToRootViewController(animated: true)
                kSharedAppDelegate?.isShowLounge = false
                let optionsSheetVC = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: AudioRoomVC.getStoryboardID()) as! AudioRoomVC
                
                if let vc = optionsSheetVC as? AudioRoomVC{
                    vc.isCreatedBySelf = true
                    vc.roomId = id
                    vc.anonymousState = self.anonymousState
                    print("vc\(vc.anonymousState)-----\(self.anonymousState)")
                }
                let options = SheetOptions(
                    pullBarHeight: 50, presentingViewCornerRadius: 20, shouldExtendBackground: true, shrinkPresentingViewController: true, useInlineMode: false
                )

               let sheetController = SheetViewController(controller: optionsSheetVC, sizes: [.marginFromTop(100)], options: options)
                sheetController.allowGestureThroughOverlay = false
                sheetController.overlayColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7475818452)
                sheetController.minimumSpaceAbovePullBar = 0
                sheetController.treatPullBarAsClear = false
                sheetController.autoAdjustToKeyboard = false
                sheetController.dismissOnOverlayTap = true
                
                sheetController.dismissOnPull = true
                self.navigationController?.present(sheetController, animated: false, completion: nil)
            }
            else{
                guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: ScheduledLoungesVC.getStoryboardID()) as? ScheduledLoungesVC else { return }
               
                vc.roomId = id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - IBAction
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartScheduleTapped(_ sender: Any) {
    }
    @IBAction func buttonStartLoungeTapped(_ sender: Any) {
        validateFields()
//        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: TempCallVC.getStoryboardID()) as? TempCallVC else { return }
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonSuggestedTapped(_ sender: UIButton) {
        setupNavigation(selectedIndex: sender.tag)
        self.selectedTab = sender.tag
        self.tableView.reloadData()
    }
  
    @IBAction func switchTapped(_ sender: UISwitch) {
        if sender.isOn {
            constraintScheduleHeight.constant = 64
            viewSchedule.isHidden = false
        }
        else{
            constraintScheduleHeight.constant = 0
            viewSchedule.isHidden = true
        }
        btnStartSchedule.setTitle(sender.isOn ? "Schedule" : "Start Lounge", for: .normal)
    }
   
    
    @IBAction func anonymousSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
           anonymousState = true
       } else {
           anonymousState = false
       }
    }
    
    @IBAction func btnLoungeTapped(_ sender: UIButton) {
        selectLoungeType(index: sender.tag)
    }

}
//MARK: - table funcs
extension CreateLoungeVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 0{
            constraintTableViewHeight.constant = CGFloat(health.count*50)
            return health.count
        }
        else{
            constraintTableViewHeight.constant = CGFloat(social.count*50)
            return social.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoungeSuggestionsTVC.identifier, for: indexPath) as! LoungeSuggestionsTVC
        var obj:LoungeSuggestedModel = LoungeSuggestedModel(image: UIImage(named: "health_covid")!, name: "COVID-19")
        cell.selectionStyle = .none
        if selectedTab == 0{
            obj = health[indexPath.row]
        }
        else{
            obj = social[indexPath.row]
        }
        cell.labelName.text = obj.name
        cell.imageIcon.image = obj.image
        if obj.isSelected{
          //  cell.imageCheck.isHidden = false
            cell.viewContent.backgroundColor = UIColor(named: "SelectionColor")!
      //      cell.labelName.textColor = .white
        }
        else{
            cell.imageCheck.isHidden = true
            cell.viewContent.backgroundColor = .white
            cell.labelName.textColor = UIColor(hexString: "#4A4A4A")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.health.forEach{$0.isSelected = false}
        self.social.forEach{$0.isSelected = false}
        if selectedTab == 0{
            self.health[indexPath.row].isSelected = true
            self.textFieldName.text = self.health[indexPath.row].name
        }
        else{
            self.social[indexPath.row].isSelected = true
            self.textFieldName.text = self.social[indexPath.row].name
        }
        self.tableView.reloadData()
    }
    
}
//MARK: - textField funcs
extension CreateLoungeVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case textFieldDate:
            setMinMaxDate(datePickerView: datePickerView, isTime: false)
            datePickerView.datePickerMode = .date
       
        case textFieldTime:
            setMinMaxDate(datePickerView: datePickerView, isTime: true)
            datePickerView.datePickerMode = .time
     
        default:break
            
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == textFieldName{
            self.health.forEach{$0.isSelected = false}
            self.tableView.reloadData()
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
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClickTime))
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
    
    @objc func doneClickDate() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/YYYY"
            self.textFieldDate.text = dateFormatter.string(from: self.datePickerView.date)
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
        
        self.textFieldTime.text = dateFormatter.string(from: time)
        self.date = setTimeOnDate(date: self.date, timeDate: time )
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
}

//MARK: - firebase funcs
extension CreateLoungeVC{
    func createFirebaseRoom(completion:(@escaping (String)->())){
        let rootRef = Database.database().reference()
        let mainRef = rootRef.child("usertouser")
        let roomsRef = mainRef.child("rooms").childByAutoId()
        let res = btnsLoungeType.filter{$0.isSelected}[0]
        var type = ""
        switch res.tag{
        case 0:
        type = "public"
        case 1:
        type = "connections"
        case 2:
        type = "private"
        default:break
            
        }
        createDynamicLink(ref: roomsRef){ url in
            var dict:[String:Any] = [
                "category" : String.getString(self.textFieldName.text),
                "createdAt" : String.getString(Int64(Date().timeIntervalSince1970 * 1000)),
                "description" : String.getString(self.textViewDescription.text),
                "host" : "host",
                "id" : String.getString(UserData.shared.id),
                "link" : url,
                "message" : "",
                "ongoing" : self.viewSchedule.isHidden ? "1" : "0",
                "name" : "\(UserData.shared.full_name)",
                "profile" : kBucketUrl+String.getString(UserData.shared.profile_pic),
                "roomId" : String.getString(roomsRef.key),
                "schedule" : self.viewSchedule.isHidden ? false : true,
                "scheduleAt" : Int64(self.date.timeIntervalSince1970 * 1000),
                "type" : type,
                "updateAt" : String.getString(Int(Date().timeIntervalSince1970 * 1000)),
                "country" : UserData.shared.country,
                "anonymousState" : self.anonymousState ? "1" : "0"
            ]
            roomsRef.updateChildValues(dict)
            KeyCenter.roomId = roomsRef.key ?? ""
            
            if self.viewSchedule.isHidden{
                dict["roomId"] = roomsRef.key ?? ""
                kSharedUserDefaults.setLounge(lounge: dict)
            }
            let notifRequest = ["louge_id":KeyCenter.roomId,
                                "title": "Lounge Creation",
                                "description": "Your lounge has been created successfully"]
            globalApis.sendNotification(notifRequest as [String : Any], completion: { })
            completion(roomsRef.key ?? "")
        }
    }
    
    func createDynamicLink(ref:DatabaseReference,completion:@escaping (String)->()){
        guard let link = URL(string: "https://hltherasocialnetwork.page.link/?id=\(String.getString(ref.key))") else { return }
        let dynamicLinksDomainURIPrefix = "https://hltherasocialnetwork.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.app.hltherasocial")
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.android.hltherasocialnetwork")

        guard let longDynamicLink = linkBuilder?.url else { return }
        
        
        linkBuilder?.options = DynamicLinkComponentsOptions()
        linkBuilder?.options?.pathLength = .short
        linkBuilder?.shorten() { url, warnings, error in
            
            guard let url = url, error == nil else { return }
            //return longDynamicLink.absoluteString
          print("The short URL is: \(url)")
            completion(url.absoluteString)
        }
        
        print("The long URL is: \(longDynamicLink)")
    }
}

extension UIViewController{
    func setTimeOnDate(date:Date,timeDate:Date)->Date{
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour,.minute,.second], from: timeDate)
       
           return calendar.date(bySettingHour: comp.hour ?? 00 , minute: comp.minute ?? 00, second: comp.second ?? 00, of: date) ?? Date()
    }
}
