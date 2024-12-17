//
//  EditEventVC.swift
//  HSN
//
//  Created by Ankur on 03/06/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import DropDown

class EditEventVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var textFieldEventName: UITextField!
    @IBOutlet weak var textFieldDescription: IQTextView!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var textFieldStartTime: UITextField!
    @IBOutlet weak var textFieldEndTime: UITextField!
    @IBOutlet weak var buttonLocation: UIButton!
    //@IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var switchIsEventOnline: UISwitch!
    @IBOutlet weak var textFieldBroadcastLink: UITextField!
    @IBOutlet weak var textFieldRegistrationLink: UITextField!
    @IBOutlet weak var buttonVisibility: UIButton!
    @IBOutlet weak var textFieldEventType: UITextField!
   // @IBOutlet var buttonsEventType: [UIButton]!
    
    @IBOutlet weak var buttonCreateEvent: UIButton!
    private var isChecked: Bool = false
    var eventArr = ["Public Event","Private Event"]
    
    let marker = GMSMarker()
    let geocoder = GMSGeocoder()
    var latitude = 19.0760
    var longitude = 72.8777
    let datePickerView = UIDatePicker()
    var dateCameFrom = 0
    var editData:EventListModel?
    var companyId = ""
    var eventKeyType = ""
    var hasCameFrom:HasCameFrom = .viewEvent
    var data:EventModel?
    var eventId = ""
    
   
    //MARK: - DropDown's
    
    let dropdown = DropDown()
   
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropdown,
        
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
//        setStatusBar(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        //buttonsEventType[0].isSelected = true
        setStatusBar()
        setupDatePicker()
//        self.constraintHideShowLocation.constant = 15
//        self.viewLocation.isHidden = true
        setupGoogleMaps()
//        setupMapCamera()
//        fillDetails()
        setupMarker(lat: self.latitude, long: self.longitude)
  
        switchIsEventOnline.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.hidesBottomBarWhenPushed = false
        // Do any additional setup after loading the view.
    }

    
    func setupGoogleMaps(){
//        viewMap.settings.myLocationButton = false
//        viewMap.isMyLocationEnabled = false
//        viewMap.isHidden = false
//        viewMap.isUserInteractionEnabled = false
//        viewMap.settings.zoomGestures = true
//        viewMap.delegate = self
//        viewMap.clipsToBounds = true
        setupMarker(lat: latitude, long: longitude)
    }
//    func setupMapCamera(){
//        let camera = GMSCameraPosition.camera(withLatitude: latitude,
//                                              longitude: longitude,
//                                              zoom: 18)
//        viewMap.camera = camera
//        if self.viewMap.isHidden {
//            self.viewMap.isHidden = false
//            self.viewMap.camera = camera
//        } else {
//            self.viewMap.animate(to: camera)
//        }
//
//    }
    func setupMarker(lat:Double,long:Double){
//        self.viewMap.clear()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.marker.title = "Selected Location"
        self.marker.snippet = "Drag map to change location"
        self.marker.icon = #imageLiteral(resourceName: "location")
        self.marker.isDraggable = false
//        self.marker.map = self.viewMap
    }
    func updateMapView(mapView:GMSMapView){
  
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        setupMarker(lat: latitute, long: longitude)
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            }else {
                let result = response?.results()?.first
                
                    
                let locality = result?.locality ?? ""
                let country = result?.country ?? ""
                let subLocality = result?.subLocality ?? ""
                let lines = result?.lines?[0] ?? ""
                //self.labelLocationTitle.text = "\(subLocality), \(locality),\(country)"
                //self.labelLocationAddressa.text = lines
                self.latitude = position.latitude
                self.longitude = position.longitude
            }
        }
        
        
    }
    func setLocationName(lat:Double,long:Double){
        
        let userLocation :CLLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let placemark = placemarks {
                if placemark.count > 0 {
                    let placemarkDetails = placemark[0]
                    print(" \(placemarkDetails)")
//                        self.localityTextField.text = "\(placemarkDetails.subLocality ?? ""), \(placemarkDetails.name ?? "")"
//                        self.cityTextField.text = placemarkDetails.subAdministrativeArea ?? ""
//                        self.postalCodeTextField.text  = placemarkDetails.postalCode ?? ""
//                        self.stateTextField.text = placemarkDetails.administrativeArea ?? ""
                    let address = [placemarkDetails.locality,
                                        placemarkDetails.subLocality,
                                        placemarkDetails.thoroughfare,
                                        placemarkDetails.postalCode,
                                        placemarkDetails.subThoroughfare,
                                        placemarkDetails.country].compactMap{$0}.joined(separator: ", ")
                    self.buttonLocation.setTitle(address, for: .normal)
                    self.buttonLocation.setTitleColor(.black, for: .normal)
                    self.buttonLocation.tag = 1
                    
                
                }
            }
        }
    }
//    func fillDetails(){
//        if let obj = editData{
//            self.textFieldEventName.text = obj.event?.name
//            self.textFieldStartDate.text = obj.event?.start_date
//            self.textFieldEndDate.text = obj.event?.end_date
//            self.textFieldDescription.text = obj.event?.description
//            self.textFieldRegistrationLink.text = obj.event?.registration_link
//            self.textFieldBroadcastLink.text = obj.broadcast_link
//            self.switchIsEventOnline.isOn = obj.event?.is_online_event == "1" ? true : false
//
//            self.imageCover.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.event?.event_pic)),placeholder: #imageLiteral(resourceName: "cover_page_placeholder"))
////            self.imageEventIcon.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.event_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
//            buttonCreateEvent.setTitle("Update Event", for: .normal)
////            eventKeyType = obj.event_type
////            if obj.event_type == "public" {
////                textFieldEventType.text = "Public Event"
////            }
////            else{
////                textFieldEventType.text = "Private Event"
////            }
////            if obj.event_type == "Public" {
//////               selectEventType(index: 0)
////            }
////            else{
//////                selectEventType(index: 1)
////            }
//            if obj.location.isEmpty{
////                self.constraintHideShowLocation.constant = 15
////                self.viewLocation.isHidden = true
//            }
//            else{
//                self.latitude = obj.latitude
//                self.longitude = obj.longitude
////                self.setupMapCamera()
//                self.setLocationName(lat: latitude, long: latitude)
//                self.setupMarker(lat: longitude, long: longitude)
////                self.constraintHideShowLocation.constant = 235
////                self.viewLocation.isHidden = false
//            }
//        }
//    }
    func validateFields(){
        if String.getString(textFieldEventName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Event Name")
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
        if String.getString(textFieldStartTime.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Start Time")
            return
        }
        if String.getString(textFieldEndTime.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter End Time")
            return
        }
        if String.getString(textFieldDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Description")
            return
        }
//         if isChecked == false {
//             CommonUtils.showToast(message: "Please accept T&C")
//        }
        
        createEvent()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func setupDatePicker(){
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        self.datePickerView.datePickerMode = .date
       
        
        textFieldStartTime.delegate = self
        textFieldEndTime.delegate = self
        textFieldStartDate.delegate = self
        textFieldEndDate.delegate = self
       self.setToolBar(textField: textFieldStartDate)
        self.setToolBar(textField: textFieldEndDate)
        self.setToolBar(textField: textFieldStartTime)
         self.setToolBar(textField: textFieldEndTime)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField{
        case textFieldStartDate:
            setMinMaxDate(datePickerView: datePickerView, isTime: false)
            datePickerView.datePickerMode = .date
        case textFieldEndDate:
            setMinMaxDate(datePickerView: datePickerView, isTime: false)
            datePickerView.datePickerMode = .date
        case textFieldStartTime:
            setMinMaxDate(datePickerView: datePickerView, isTime: true)
            datePickerView.datePickerMode = .time
        case textFieldEndTime:
            setMinMaxDate(datePickerView: datePickerView, isTime: true)
            datePickerView.datePickerMode = .time
        default:break
            
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
        let doneButton3 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick3))
        let doneButton4 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick4))
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
    
    @objc func doneClick1() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
            self.textFieldStartDate.text = dateFormatter.string(from: self.datePickerView.date)
    }
    @objc func doneClick2() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        self.textFieldEndDate.text = dateFormatter.string(from: self.datePickerView.date)
    }
    @objc func doneClick3() {
        self.view.endEditing(true)
      
        let date = self.datePickerView.date
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: date)
            let hour = comp.hour
            let minute = comp.minute
        
        self.textFieldStartTime.text = dateFormatter.string(from: date)
    }
    @objc func doneClick4() {
        self.view.endEditing(true)
        let date = self.datePickerView.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
            let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
            let hour = comp.hour
            let minute = comp.minute
        
        
        self.textFieldEndTime.text = dateFormatter.string(from: date)
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    @IBAction func buttonStartTimeTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.datePickerView.datePickerMode = .time
        self.textFieldStartTime.becomeFirstResponder()
    }
    @IBAction func buttonSelectStartDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.datePickerView.datePickerMode = .date
        self.textFieldStartDate.becomeFirstResponder()
    }
    @IBAction func buttonTermsTapped(_ sender: Any) {
        guard let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
        nextVc.pageTitleString = "Terms and Conditions"
        nextVc.url = kBASEURL + "term_condition"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func buttonSelectEndDateTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.datePickerView.datePickerMode = .date
        self.textFieldEndDate.becomeFirstResponder()
    }
    @IBAction func buttonEndTimeTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.datePickerView.datePickerMode = .time
        self.textFieldEndTime.becomeFirstResponder()
    }
    @IBAction func buttonSwitchTapped(_ sender: UISwitch) {
//        if sender.isOn{
//            self.constraintHideShowLocation.constant = 15
//            self.viewLocation.isHidden = true
//
//
//
//        }
//        else{
//            LocationManager.sharedInstance.startUpdatingLocation()
//            LocationManager.sharedInstance.callback = {lat,long in
//                self.latitude = lat
//                self.longitude = long
//                self.setupMapCamera()
//                self.setLocationName(lat: lat, long: long)
//                self.setupMarker(lat: lat, long: long)
//
//                LocationManager.sharedInstance.stopUpdatingLocation()
//            }
//            self.constraintHideShowLocation.constant = 235
//            self.viewLocation.isHidden = false
//        }
        
    }
    
    @IBAction func buttonLocationTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "FetchCurrentLocationVC") as? FetchCurrentLocationVC else { return }
        vc.callback = { lat, long in
            
            self.latitude = lat
            self.longitude = long
            
//            self.setupMapCamera()
            
//            self.setupMarker(lat: lat, long: long)
            self.setLocationName(lat: lat, long: long)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonUploadCoverTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController( {image in
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            self.imageCover.image = image as! UIImage
            
        })
    }
    
    @IBAction func btnCheckMarkTapped(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        isChecked = sender.isSelected
        if sender.tag == 0 {
            sender.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            sender.tag = 1
            isChecked = true
        }else{
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            sender.tag = 0
            isChecked = false
        }
    }

    @IBAction func buttonEventTypeTapped(_ sender: UIButton) {
        self.dropdown.anchorView = sender
        self.dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height + 8)
        self.dropdown.textColor = .black
        self.dropdown.separatorColor = .clear
        self.dropdown.selectionBackgroundColor = .clear
        self.dropdown.backgroundColor = #colorLiteral(red: 0.954236269, green: 0.954236269, blue: 0.954236269, alpha: 1)
        self.dropdown.dataSource.removeAll()
        self.dropdown.cellHeight = 35
        self.dropdown.dataSource.append(contentsOf: eventArr)
        
        self.dropdown.selectionAction = { [unowned self] (index, item) in
            self.textFieldEventType.text = item
            if index == 0 {
                self.eventKeyType = "public"
            }else if index == 1 {
                self.eventKeyType = "private"
            }
            
        }
        self.dropdown.show()
    }
   
    @IBAction func buttonCreateEventTapped(_ sender: Any) {
        validateFields()
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension EditEventVC{
    func createEvent(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var url = ServiceName.create_event
        var params:[String:Any] = [ApiParameters.name:String.getString(textFieldEventName.text),
                                   ApiParameters.description:String.getString(textFieldDescription.text),
                                   ApiParameters.is_event_online:switchIsEventOnline.isOn ? "1" : "0",
                                   ApiParameters.registration_link:String.getString(textFieldRegistrationLink.text),
                                   ApiParameters.broadcast_link:String.getString(textFieldBroadcastLink.text),
                                   ApiParameters.event_type:eventKeyType,
                                   ApiParameters.start_date:String.getString(textFieldStartDate.text),
                                   ApiParameters.end_date:String.getString(textFieldEndDate.text),
                                   ApiParameters.start_time:String.getString(textFieldStartTime.text),
                                   ApiParameters.end_time:String.getString(textFieldEndTime.text),
                                   ApiParameters.location:String.getString(self.buttonLocation.titleLabel?.text),
                                   ApiParameters.latitude:String(self.latitude),
                                   ApiParameters.longitude:String(self.longitude)
                                   ]
        
        if hasCameFrom == .editEvent{
            params[ApiParameters.event_id] = String.getString(editData?.id)
            
        }
        if hasCameFrom == .editCompanyEvent{
            url = ServiceName.update_company_event
        }
        if hasCameFrom == .createCompanyEvent && !companyId.isEmpty{
            params[ApiParameters.company_id] = companyId
            url = ServiceName.company_event
        }
//        var image:[[String:Any]] = [["imageName":ApiParameters.cover_pic,"image":self.imageCover.image],["imageName":"event_pic","image":self.imageEventIcon.image]]
        
        
        var image:[[String:Any]] = [["imageName":ApiParameters.cover_pic,"image":self.imageCover.image],["imageName":"event_pic","image":self.imageCover.image]]
        
        NetworkManager.shared.requestMultiParts(serviceName: url, method: .post, arrImages: image, video: [:],document: [],  parameters: params)
                {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    self?.moveToPopUp(text: "Event Saved Successfully!", completion: {
                        self?.navigationController?.popViewController(animated: true)
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
extension EditEventVC:GMSMapViewDelegate,CLLocationManagerDelegate{
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(mapView.center)
//        mapView.clear()
//        viewLocation.isHidden = false
//        updateMapView(mapView: mapView)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//       mapView.clear()
//        viewLocation.isHidden = true
//        updateMapView(mapView: mapView)
        
    }
}


extension EditEventVC{
    func getData(){
       
        globalApis.getEvent(type:hasCameFrom,id: String.getString(eventId), completion: { data in
            self.data = data
            self.updateData()
        })
    }
    
    func updateData(){
        if let obj = data{
            
            self.imageCover.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.event_pic)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder") )
            self.textFieldEventName.text = String.getString(obj.name)
            self.textFieldDescription.text = String.getString(obj.description)
            self.textFieldStartDate.text = String.getString(obj.start_date)
            self.textFieldEndDate.text = String.getString(obj.end_date)
            self.textFieldStartTime.text = String.getString(obj.start_time)
            self.textFieldEndTime.text = String.getString(obj.end_time)
            self.buttonLocation.setTitle(obj.location, for: .normal)
            self.switchIsEventOnline.isOn = obj.is_online_event == "1" ? true : false
            self.textFieldBroadcastLink.text = String.getString(obj.broadcast_link)
            self.textFieldRegistrationLink.text = String.getString(obj.registration_link)
            if obj.event_type == "public"{
                self.textFieldEventType.text = "Public Event"
            }else{
                self.textFieldEventType.text = "Private Event"
            }
        }
}
}
