//
//  DefineAudienceVC.swift
//  HSN
//
//  Created by fluper on 05/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import GooglePlaces
import AlignedCollectionViewFlowLayout

class DefineAudienceVC: UIViewController {
//    @IBOutlet weak var viewCustom: UIView!
//    @IBOutlet weak var collectionViewLocations: UICollectionView!
//    @IBOutlet weak var collectionViewInterest: UICollectionView!
    @IBOutlet weak var viewSlider: RangeSeekSlider!
    @IBOutlet var imagesGenderCheck: [UIImageView]!
    @IBOutlet var buttonsAudienceTarget: [UIButton]!
    @IBOutlet weak var constraintCollectionViewLocation: NSLayoutConstraint!
    @IBOutlet weak var constraintCollectionViewInterests: NSLayoutConstraint!
    @IBOutlet var buttonsGender: [UIButton]!
    @IBOutlet weak var collectionViewLocation: UICollectionView!
    @IBOutlet weak var collectionViewInterests: UICollectionView!
    @IBOutlet weak var viewCustom: UIView!
    var interests:[InterestModel] = []
    var selectedInterests:[String] = []
    var selectedLocations:[String] = []
    var ageGroupFrom:CGFloat = -1
    var ageGroupTo:CGFloat = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        interests = UserData.shared.interests
        viewSlider.delegate = self
        ageGroupTo = viewSlider.selectedMaxValue
        ageGroupFrom = viewSlider.selectedMinValue
        self.viewCustom.isHidden = true
        collectionViewInterests.delegate = self
        collectionViewInterests.dataSource = self
        collectionViewLocation.delegate = self
        collectionViewLocation.dataSource = self
        collectionViewLocation.register(UINib(nibName: MultipleSelectionCVC.identifier, bundle: nil), forCellWithReuseIdentifier: MultipleSelectionCVC.identifier)
        collectionViewInterests.register(UINib(nibName: MultipleSelectionCVC.identifier, bundle: nil), forCellWithReuseIdentifier: MultipleSelectionCVC.identifier)
        let alignedFlowLayout = collectionViewLocation?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        let alignedFlowLayout1 = collectionViewInterests?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout1?.horizontalAlignment = .left
        alignedFlowLayout1?.verticalAlignment = .top
        constraintCollectionViewLocation.constant = 0
        constraintCollectionViewInterests.constant = 0

        // Do any additional setup after loading the view.
    }
    func selectButton(index:Int){
        buttonsAudienceTarget.forEach{$0.isSelected = false}
        buttonsAudienceTarget[index].isSelected = true
    }
    func validateFields(){
        if buttonsAudienceTarget.filter({$0.isSelected}).isEmpty{
            CommonUtils.showToast(message: "Please select audience target")
            return
        }
        if selectedLocations.isEmpty && buttonsAudienceTarget[2].isSelected{
            CommonUtils.showToast(message: "Please select atleast one location")
            return
        }
        if selectedInterests.isEmpty && buttonsAudienceTarget[2].isSelected{
            CommonUtils.showToast(message: "Please select atleast one Interest")
            return
        }
        if buttonsGender.filter({$0.isSelected}).isEmpty && buttonsAudienceTarget[2].isSelected{
            CommonUtils.showToast(message: "Please select gender")
            return
        }
        if selectedLocations.isEmpty && buttonsAudienceTarget[2].isSelected{
            CommonUtils.showToast(message: "Please select atleast one location")
            return
        }
        if ageGroupFrom == -1 && buttonsAudienceTarget[2].isSelected || ageGroupTo == -1 && buttonsAudienceTarget[2].isSelected{
            CommonUtils.showToast(message: "Please select age group")
            return
        }
        
        promotionData[ApiParameters.location] = selectedLocations.joined(separator: ",")
        promotionData[ApiParameters.interest] = selectedInterests.joined(separator: ",")
        promotionData[ApiParameters.gender] = buttonsGender[0].isSelected ? "0" : "1"
        promotionData[ApiParameters.age_group_from] = Int(ageGroupFrom)
        promotionData[ApiParameters.age_group_to] = Int(ageGroupTo)
        
        if let vc = self.parent{
            if let pvc = vc as? PageViewController{
                pvc.changeViewController(index: 2, direction: .forward)
                if let parentOfPVC = pvc.parent{
                    if let ppvc = parentOfPVC as? CreatePromotionPostVC{
                        ppvc.selectScreen(index: 2)
                    }
                }
            }
        }
    }
    @IBAction func buttonSelectionTapped(_ sender: UIButton) {
        if sender.tag == 2{
            self.viewCustom.isHidden = false
        }
        else{
            self.viewCustom.isHidden = true
        }
        selectButton(index: sender.tag)
        promotionData[ApiParameters.target_audience_type] = sender.tag + 1
        
       
    }
    @IBAction func buttonAddLocationTapped(_ sender: Any) {
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
    @IBAction func buttonGenderTapped(_ sender: UIButton) {
        buttonsGender.forEach{
            $0.isSelected = false
        }
        buttonsGender[sender.tag].isSelected = true
    }
    @IBAction func buttonInterestTapped(_ sender:Any){
        showDropDown(on: self.navigationController, for:  interests.map{$0.name}, completion: { [self]
            value,index in
            
           
            let res = self.selectedInterests.filter{String.getString($0) == value}
                if res.isEmpty{
                    self.selectedInterests.append(value)
                    self.collectionViewInterests.reloadData()
                    self.constraintCollectionViewInterests.constant = CGFloat(selectedInterests.count * 100)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        
                        self.constraintCollectionViewInterests.constant = collectionViewInterests.contentSize.height
                    })
                    
                   
                }
            
        })
    }
    @IBAction func buttonNextTapped(_ sender: Any) {
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
extension DefineAudienceVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewLocation{
            
            return selectedLocations.count
        }
        else{
            return selectedInterests.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleSelectionCVC.identifier, for: indexPath) as! MultipleSelectionCVC
        if collectionView == collectionViewLocation{
            cell.labelText.text = selectedLocations[indexPath.row]
            cell.removeCallback = {
                self.selectedLocations.remove(at: indexPath.row)
                self.collectionViewLocation.reloadData()
                if self.selectedLocations.isEmpty{
                    self.constraintCollectionViewLocation.constant = 0
                }
            }
            self.constraintCollectionViewLocation.constant = collectionViewLocation.contentSize.height
        }
        else{
            cell.labelText.text = selectedInterests[indexPath.row]
            cell.removeCallback = {
                self.selectedInterests.remove(at: indexPath.row)
                self.collectionViewInterests.reloadData()
                if self.selectedInterests.isEmpty{
                    self.constraintCollectionViewInterests.constant = 0
                }
            }
            self.constraintCollectionViewInterests.constant = collectionViewInterests.contentSize.height
        }
        
        return cell
      
    }
    
    
    
}
extension DefineAudienceVC{
    func getInterests(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.getInterests,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["data"])
                    self.interests = data.map{InterestModel(data: kSharedInstance.getDictionary($0))}
                    self.collectionViewInterests.reloadData()
                    
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
extension DefineAudienceVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    
      if self.selectedLocations.filter{$0.lowercased() == place.name}.isEmpty{
          self.selectedLocations.append(place.name ?? "")
          self.constraintCollectionViewLocation.constant =  CGFloat(50 * selectedLocations.count)
          self.collectionViewLocation.reloadData()
      }
            
            
            
             
    
    
    
    
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
extension DefineAudienceVC:RangeSeekSliderDelegate{
   
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.ageGroupFrom = minValue
        self.ageGroupTo = maxValue
    }
}
