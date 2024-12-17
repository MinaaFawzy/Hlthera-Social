//
//  CreateGroupVC.swift
//  HSN
//
//  Created by Prashant Panchal on 15/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import AlignedCollectionViewFlowLayout

class CreateGroupVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imageGroupIcon: UIImageView!
    @IBOutlet weak var textfieldGroupName: UITextField!
    @IBOutlet weak var textViewAboutGroup: IQTextView!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var textFieldLocation: UITextField!
    //@IBOutlet weak var textViewRules: IQTextView!
    @IBOutlet var buttonsGroupVisibility: [UIButton]!
    @IBOutlet var buttonsPermissions: [UIButton]!
    @IBOutlet weak var constraintCollectionViewIndustryHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonIndustry: UIButton!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var buttonCreateGroup: UIButton!
    
    // MARK: - Stored Properties
    var selectedIndustries: [String] = []
    var dropDown = DropDown()
    var nav: UINavigationController?
    var empTypes: [String] = []
    var industries: [ListingDataModel] = []
    var hasCameFrom: HasCameFrom = .createGroup
    var editData: HSNGroupModel?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//#colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        constraintCollectionViewIndustryHeight.constant = 0
        let alignedFlowLayout = collectionVIew?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        buttonIndustry.setTitle("Select Industry", for: .normal)
        buttonIndustry.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
        globalApis.getListingData(type: .industry, completion: {data in
            self.industries = data
        })
        buttonsGroupVisibility[0].isSelected = true
        buttonsPermissions[0].isSelected = true
        switch hasCameFrom{
        case .createGroup:
            self.labelPageTitle.text = "Create Group"
        case .editGroup:
            self.labelPageTitle.text = "Edit Group"
            fillDetails()
        default:break
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    func fillDetails() {
        if let obj = editData {
            self.textfieldGroupName.text = obj.name
            self.textViewAboutGroup.text = obj.about
            self.textFieldLocation.text = obj.location
            //self.textViewRules.text = obj.rules
            let industries:[String] = Array(obj.industries.components(separatedBy: ","))
            self.selectedIndustries = Array(industries)
            self.collectionVIew.reloadData()
            self.constraintCollectionViewIndustryHeight.constant = CGFloat(selectedIndustries.count * 50)
            if obj.discoverability == "1" {
                buttonsGroupVisibility[0].isSelected = true
                buttonsGroupVisibility[1].isSelected = false
            } else {
                buttonsGroupVisibility[0].isSelected = false
                buttonsGroupVisibility[1].isSelected = true
            }
            self.imageCover.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.cover_pic)),placeholder: #imageLiteral(resourceName: "event_cover_page"))
            self.imageGroupIcon.kf.setImage(with: URL(string: kBucketUrl+String.getString(obj.group_pic)),placeholder: #imageLiteral(resourceName: "profile_placeholder"))
            buttonCreateGroup.setTitle("Update Group", for: .normal)
            if obj.permission == "1" {
                buttonsPermissions[0].isSelected = true
            }
            else{}
        }
    }
    
    func validateField() {
        if String.getString(textfieldGroupName.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Group Name")
            return
        }
        if String.getString(textViewAboutGroup.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter About Group")
            return
        }
        if selectedIndustries.isEmpty{
            CommonUtils.showToast(message: "Please Select Industry")
            return
        }
        if String.getString(textFieldLocation.text).isEmpty{
            CommonUtils.showToast(message: "Please Enter Location")
            return
        }
        //if String.getString(textViewRules.text).isEmpty {
        //    CommonUtils.showToast(message: "Please Enter Rules")
        //    return
        //}
        if buttonsGroupVisibility.filter({ $0.isSelected }).isEmpty {
            CommonUtils.showToast(message: "Please Select Group Visibility")
            return
        }
        
        createGroup()
    }
    
    func createGroup() {
        CommonUtils.showHudWithNoInteraction(show: true)
        var url = ServiceName.add_group
        var params: [String: Any] = [ApiParameters.name: String.getString(textfieldGroupName.text),
                                     ApiParameters.about: String.getString(textViewAboutGroup.text),
                                     ApiParameters.industries: selectedIndustries.joined(separator: ","),
                                     ApiParameters.location: String.getString(textFieldLocation.text),
                                     //ApiParameters.rules: String.getString(textViewRules.text),
                                     ApiParameters.rules: "",
                                     ApiParameters.discoverability: buttonsGroupVisibility[0].isSelected ? "1" : "0",
                                     ApiParameters.permission: buttonsPermissions[0].isSelected ? "1" : "0",
        ]
        switch hasCameFrom {
        case .editGroup:
            url = ServiceName.edit_group
            params[ApiParameters.id] = String.getString(editData?.id)
        default: break
        }
        
        var image: [[String: Any]] = [["imageName": ApiParameters.cover_pic, "image": self.imageCover.image], ["imageName": ApiParameters.group_pic, "image": self.imageGroupIcon.image]]
        
        NetworkManager.shared.requestMultiParts(serviceName: url, method: .post, arrImages: image, video: [:],document: [],  parameters: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    self?.moveToPopUp(text: "Group Saved Successfully!", completion: {
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

// MARK: - Actions
extension CreateGroupVC {
    @IBAction func buttonCameraTapped(_ sender: Any) {
        
        ImagePickerHelper.shared.showPickerController( {image in
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            self.imageGroupIcon.image = image as! UIImage
            
        })
    }
    
    @IBAction func buttonUploadCoverTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController( {image in
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            self.imageCover.image = image as! UIImage
            
        })
    }
    
    @IBAction func buttonIndustryTapped(_ sender: UIButton) {
        
        showDropDown(on: self.navigationController, for: industries.map{$0.name}, completion: {
            value,index in
            self.buttonIndustry.setTitle(value, for: .normal)
            self.buttonIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonIndustry.tag = 1
            let res = self.selectedIndustries.filter{String.getString($0) == value}
            if res.isEmpty{
                self.selectedIndustries.append(value)
                self.collectionVIew.reloadData()
                self.constraintCollectionViewIndustryHeight.constant = 50
                
                self.buttonIndustry.setTitle("Select Industry", for: .normal)
                self.buttonIndustry.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
            }
        })
        //        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(identifier: ListPickerVC.getStoryboardID()) as? ListPickerVC else {
        //            return
        //        }
        //        vc.items = industries.map{$0.name}
        //        vc.callback = {
        //            value,index in
        //            self.dismiss(animated: true){ [self] in
        //
        //                buttonIndustry.setTitle(value, for: .normal)
        //                buttonIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //                buttonIndustry.tag = 1
        //                let res = selectedIndustries.filter{String.getString($0) == value}
        //                if res.isEmpty{
        //                    self.selectedIndustries.append(value)
        //                    self.collectionVIew.reloadData()
        //                    self.constraintCollectionViewIndustryHeight.constant = 50
        //
        //                    buttonIndustry.setTitle("Select Industry", for: .normal)
        //                    buttonIndustry.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
        //                }
        //            }
        //
        //        }
        //        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonGroupVisibilityTapped(_ sender: UIButton) {
        if sender.tag == 0{
            self.buttonsGroupVisibility[0].isSelected = true
            self.buttonsGroupVisibility[1].isSelected = false
        }
        else{
            self.buttonsGroupVisibility[1].isSelected = true
            self.buttonsGroupVisibility[0].isSelected = false
        }
        
    }
    
    @IBAction func buttonPermissionsTapped(_ sender: UIButton) {
        if sender.tag == 0{
            self.buttonsPermissions[0].isSelected = !self.buttonsPermissions[0].isSelected
        }
        else{
            self.buttonsPermissions[1].isSelected = !self.buttonsPermissions[1].isSelected
        }
    }
    
    @IBAction func buttonCreateGroupTapped(_ sender: Any) {
        validateField()
        
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateGroupVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedIndustries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndustriesCVC.identifier, for: indexPath) as! IndustriesCVC
        cell.labelName.text = selectedIndustries[indexPath.row]
        cell.removeCallback = {
            self.selectedIndustries.remove(at: indexPath.row)
            self.collectionVIew.reloadData()
            if self.selectedIndustries.isEmpty{
                self.constraintCollectionViewIndustryHeight.constant = 0
                
                self.buttonIndustry.setTitle("Select Industry", for: .normal)
                self.buttonIndustry.setTitleColor(#colorLiteral(red: 0.6431372549, green: 0.7215686275, blue: 0.8039215686, alpha: 1), for: .normal)
            }
        }
        self.constraintCollectionViewIndustryHeight.constant = self.collectionVIew.contentSize.height
        
        return cell
    }
}
