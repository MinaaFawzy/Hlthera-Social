//
//  CreateJobVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import AlignedCollectionViewFlowLayout
import Alamofire
class CreateJobVC: UIViewController {
    @IBOutlet weak var textFieldJobTitle: UITextField!
    @IBOutlet weak var buttonLocation: UIButton!
    @IBOutlet weak var textFieldFacility: UITextField!
    @IBOutlet weak var textViewJobDescription: IQTextView!
    @IBOutlet weak var buttonEmploymentType: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonIndustry: UIButton!
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var buttonEasyApply: UIButton!
    @IBOutlet weak var textFieldWebsiteLink: UITextField!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var buttonCreateJob: UIButton!
    
    
    var skills:[String] = ["Skill A","Skill B"]
    var selectedSkills:[String] = [] {
        didSet{
            collectionView.reloadData()
            self.constraintCollectionViewHeight.constant = CGFloat(selectedSkills.count * 100)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                
                self.constraintCollectionViewHeight.constant = self.collectionView.contentSize.height
            })
            
        }
    }
    var selectedIndustry:ListingDataModel?
    var selectedEmploymentType:ListingDataModel?
    var empTypes:[String] = []
    var pageId = ""
    var latitude = 0.0
    var longitude = 0.0
    var hasCameFrom:HasCameFrom = .createJob
    var data:JobModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MultipleSelectionCVC.nib, forCellWithReuseIdentifier: MultipleSelectionCVC.identifier)
        getEmploymentTypeApi()
        switch hasCameFrom{
        case .createJob:
            self.labelPageTitle.text = "Create Job"
        case .editJob:
            self.labelPageTitle.text = "Edit Job"
            self.buttonCreateJob.setTitle("Edit Job",for: .normal)
            self.updateData()
        default:break
        }
        // Do any additional setup after loading the view.
    }
    
    func updateData(){
        if let obj = data{
            self.textFieldJobTitle.text = obj.job_title
            self.textFieldFacility.text = obj.facility
            if !obj.location.isEmpty{
                self.buttonLocation.setTitle(obj.location, for: .normal)
                self.buttonLocation.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonLocation.tag = 1
            }
            self.textViewJobDescription.text = obj.job_description
            
            if !obj.employement_type.isEmpty{
                self.buttonEmploymentType.setTitle(obj.location, for: .normal)
                self.buttonEmploymentType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonEmploymentType.tag = 1
            }
            self.selectedSkills = obj.skill_required
            if !obj.industry_id.isEmpty{
                self.buttonIndustry.setTitle(obj.industry?.name, for: .normal)
                self.buttonIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonIndustry.tag = 1
                self.selectedIndustry = ListingDataModel(data: ["id":obj.industry_id,"name":obj.industry])
            }
            if obj.apply_type == "1"{
                 self.buttonApply.isSelected = true
            }
            if obj.apply_type == "0"{
                self.buttonEasyApply.isSelected = true
            }
            self.textFieldWebsiteLink.text = obj.website_link
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
    func validateFields(){
        if String.getString(textFieldJobTitle.text).isEmpty{
            CommonUtils.showToast(message: "Please enter Job Title")
            return
        }
        if String.getString(textFieldFacility.text).isEmpty{
            CommonUtils.showToast(message: "Please enter Job Facility")
            return
        }
        if buttonLocation.tag == 0{
            CommonUtils.showToast(message: "Please select Job Location")
            return
        }
        if String.getString(textViewJobDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please enter Job Description")
            return
        }
        if buttonEmploymentType.tag == 0{
            CommonUtils.showToast(message: "Please select Job Employment Type")
            return
        }
        if skills.isEmpty{
            CommonUtils.showToast(message: "Please select atleast one skill")
            return
        }
        if buttonIndustry.tag == 0{
            CommonUtils.showToast(message: "Please select Job Industry")
            return
        }
        if buttonApply.isSelected == false && buttonEasyApply.isSelected == false{
            CommonUtils.showToast(message: "Please select Job Application Type")
            return
        }
        if buttonApply.isSelected && String.getString(textFieldWebsiteLink.text).isEmpty{
            CommonUtils.showToast(message: "Please enter website link")
            return
        }
        if buttonApply.isSelected && !String.getString(textFieldWebsiteLink.text).isURL(){
            CommonUtils.showToast(message: "Please enter valid website link")
            return
        }
        createJob()
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonLocationTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
           autocompleteController.delegate = self

           // Specify the place data types to return.
           let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
             UInt(GMSPlaceField.placeID.rawValue))!
           autocompleteController.placeFields = fields

           // Specify a filter.
           let filter = GMSAutocompleteFilter()
        filter.type = .region
           autocompleteController.autocompleteFilter = filter

           // Display the autocomplete view controller.
           present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func buttonEmploymentTapped(_ sender: Any) {
        showDropDown(on: self.navigationController, for: empTypes, completion: {
            value,index in
           
            self.buttonEmploymentType.setTitle(value, for: .normal)
            self.buttonEmploymentType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonEmploymentType.tag = 1
            
        })
    }
    
    @IBAction func buttonIndustryTapped(_ sender: Any) {
        globalApis.getListingData(type: .industry, completion: {data in
            
                                                                 self.showDropDown(on: self.navigationController, for:  data.map{$0.name}, completion: {
                value,index in
                
                self.buttonIndustry.setTitle(value, for: .normal)
                self.buttonIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonIndustry.tag = 1
                self.selectedIndustry = data[index]
                })

        })
    }
    @IBAction func buttonSelectSkillsTapped(_ sender: Any) {
        showDropDown(on: self.navigationController, for:  skills.map{$0}, completion: { [self]
            value,index in
            
           
            let res = self.selectedSkills.filter{String.getString($0) == value}
                if res.isEmpty{
                    self.selectedSkills.append(value)
                    self.collectionView.reloadData()
                    self.constraintCollectionViewHeight.constant = CGFloat(selectedSkills.count * 100)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        
                        self.constraintCollectionViewHeight.constant = collectionView.contentSize.height
                    })
                    
                   
                }
            
        })
    }
    @IBAction func buttonTermsTapped(_ sender: Any) {
        guard let nextVc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
        nextVc.pageTitleString = "Terms and Conditions"
        nextVc.url = kBASEURL + "term_condition"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func buttonApplyTapped(_ sender: Any) {
        self.buttonApply.isSelected = true
        self.buttonEasyApply.isSelected = false
    }
    @IBAction func buttonEasyApplyTapped(_ sender: Any) {
        self.buttonApply.isSelected = false
        self.buttonEasyApply.isSelected = true
    }
    @IBAction func buttonCreateJobTapped(_ sender: Any) {
        validateFields()
    }
    
}
extension CreateJobVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    
      self.buttonLocation.setTitle(place.name, for: .normal)
            
      self.buttonLocation.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
      self.buttonLocation.tag = 1
                                      
      self.latitude = place.coordinate.latitude
      self.longitude = place.coordinate.longitude
            
             
    
    
    
    
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
extension CreateJobVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            
            return selectedSkills.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleSelectionCVC.identifier, for: indexPath) as! MultipleSelectionCVC
        
            cell.labelText.text = skills[indexPath.row]
            cell.removeCallback = {
                self.selectedSkills.remove(at: indexPath.row)
                self.collectionView.reloadData()
                if self.selectedSkills.isEmpty{
                    self.constraintCollectionViewHeight.constant = 0
                }
            }
            self.constraintCollectionViewHeight.constant = collectionView.contentSize.height
        
       
        
        return cell
      
    }
    
    
    
}
extension CreateJobVC{
    func getEmploymentTypeApi(){
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
    func createJob(){
        CommonUtils.showHudWithNoInteraction(show: true)
        
        
        var url = ServiceName.create_job
        var reqType:kHTTPMethod = .POST
        var params:[String:Any] = [ApiParameters.company_id:pageId,
                                   ApiParameters.job_title:String.getString(textFieldJobTitle.text),
                                   ApiParameters.facility:String.getString(textFieldFacility.text),
                                   ApiParameters.location:String.getString(buttonLocation.titleLabel?.text),
                                   ApiParameters.job_description:String.getString(textViewJobDescription.text),
                                   ApiParameters.employement_type:String.getString(buttonEmploymentType.titleLabel?.text),
                                   ApiParameters.skill_required:selectedSkills.joined(separator: ","),
                                   ApiParameters.industry_id:String.getString(selectedIndustry?.id),
                                   ApiParameters.apply_type:buttonApply.isSelected ? "1" : "0",
                                   ApiParameters.latitude:String(latitude),
                                   ApiParameters.longitude:String(longitude),
                                   ApiParameters.website_link:String.getString(textFieldWebsiteLink.text)
                                   ]
        
//        if hasCameFrom == .editEvent{
//            params[ApiParameters.event_id] = String.getString(editData?.id)
//
//        }
//        if hasCameFrom == .editCompanyEvent{
//            url = ServiceName.update_company_event
//        }
//        if hasCameFrom == .createCompanyEvent && !companyId.isEmpty{
//            params[ApiParameters.company_id] = companyId
//            url = ServiceName.company_event
//        }
        switch hasCameFrom{
        case .createJob:
             url = ServiceName.create_job
            reqType = .POST
        case .editJob:
            url = ServiceName.create_job + "/"+String.getString(data?.id)
            reqType = .PUT
        default:break
        }
        var image:[[String:Any]] = []
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: url ,
                                                   requestMethod: reqType,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    self.moveToPopUp(text: "Job Saved Successfully!", completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                case 405:
                    CommonUtils.showAlert(title: kAppName, message: String.getString(dictResult["message"]), firstTitle: "Change Subscription Plan", secondTitle: "Cancel",isSecondCancel: true, completion: {title in
                        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SubscriptionVC.getStoryboardID()) as? SubscriptionVC else { return }
                        self.navigationController?.pushViewController(vc, animated: true)
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
