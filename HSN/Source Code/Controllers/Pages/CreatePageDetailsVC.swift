//
//  CreatePageDetailsVC.swift
//  HSN
//
//  Created by user206889 on 11/16/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift
import AlignedCollectionViewFlowLayout
class CreatePageDetailsVC: UIViewController {
    @IBOutlet weak var textFieldPageName: UITextField!
    @IBOutlet weak var textViewDescription: IQTextView!
    @IBOutlet weak var btnIndustry: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var collectionViewLocation: UICollectionView!
    @IBOutlet weak var constraintCollectionViewLocation: NSLayoutConstraint!
    @IBOutlet weak var viewSlider: RangeSeekSlider!
    
    var interests:[InterestModel] = []
    var selectedLocations:[String] = []
    var minSize:CGFloat = -1
    var maxSize:CGFloat = -1
    var industries:[ListingDataModel] = []
    var selectedIndustry:ListingDataModel?
    
    var selectedCompany:ListingDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSlider.delegate = self
        self.maxSize = viewSlider.maxValue
        self.minSize = viewSlider.minValue
        collectionViewLocation.register(UINib(nibName: MultipleSelectionCVC.identifier, bundle: nil), forCellWithReuseIdentifier: MultipleSelectionCVC.identifier)
        let alignedFlowLayout = collectionViewLocation?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        // Do any additional setup after loading the view.
    }
    
    func validateFields(){
        if String.getString(textFieldPageName.text).isEmpty{
            CommonUtils.showToast(message: "Please enter page name")
            return
        }
        if String.getString(textViewDescription.text).isEmpty{
            CommonUtils.showToast(message: "Please enter description")
            return
        }
        if btnIndustry.tag == 0{
            CommonUtils.showToast(message: "Please select industry")
            return
        }
        if btnCompany.tag == 0{
            CommonUtils.showToast(message: "Please select company")
            return
        }
       
        if minSize == -1 || maxSize == -1{
            CommonUtils.showToast(message: "Please select age group")
            return
        }
        if selectedLocations.isEmpty {
            CommonUtils.showToast(message: "Please select atleast one location")
            return
        }
        pageData[ApiParameters.page_name] = String.getString(textFieldPageName.text)
        pageData[ApiParameters.description] = String.getString(textViewDescription.text)
        pageData[ApiParameters.industry] = String.getString(self.selectedIndustry?.name)
        pageData[ApiParameters.company_type] = String.getString(self.selectedCompany?.name)
        pageData[ApiParameters.company_size] = String(format: "%.0f",minSize) + "-" + String(format: "%.0f",maxSize)
        pageData[ApiParameters.location] = self.selectedLocations.joined(separator: ",")
        
        
        
        //pageData[ApiParameters.id] =
        //pageData[ApiParameters.is_delete] = ""
       
        
        if let vc = self.parent{
            if let pvc = vc as? CreatePageConnectionsVC{
                pvc.changeViewController(index: 2, direction: .forward)
                if let parentOfPVC = pvc.parent{
                    if let ppvc = parentOfPVC as? CreatePageVC{
                        ppvc.selectScreen(index: 2)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func btnIndustryTapped(_ sender: Any) {
        globalApis.getListingData(type: .industry, completion: {data in
            
                                                                 self.showDropDown(on: self.navigationController, for:  data.map{$0.name}, completion: {
                value,index in
                
                self.btnIndustry.setTitle(value, for: .normal)
                self.btnIndustry.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnIndustry.tag = 1
                                                                     self.selectedIndustry = data[index]
                
    
                
            })

        })

    }
    
    @IBAction func btnCompanyTapped(_ sender: Any) {
            globalApis.getListingData(type: .company, completion: {data in
                
                                                                     self.showDropDown(on: self.navigationController, for:  data.map{$0.name}, completion: {
                    value,index in
                    
                    self.btnCompany.setTitle(value, for: .normal)
                    self.btnCompany.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    self.btnCompany.tag = 1
                                                                         self.selectedCompany = data[index]
                    
        
                    
                })

            })

    }
    @IBAction func btnLocationTapped(_ sender: Any) {
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
extension CreatePageDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            
            return selectedLocations.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleSelectionCVC.identifier, for: indexPath) as! MultipleSelectionCVC
       
            cell.labelText.text = selectedLocations[indexPath.row]
            cell.removeCallback = {
                self.selectedLocations.remove(at: indexPath.row)
                self.collectionViewLocation.reloadData()
                if self.selectedLocations.isEmpty{
                    self.constraintCollectionViewLocation.constant = 0
                }
            }
            self.constraintCollectionViewLocation.constant = collectionViewLocation.contentSize.height
       
        return cell
      
    }
    
    
    
}
extension CreatePageDetailsVC{
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
//                    self.collectionViewInterests.reloadData()
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
}
extension CreatePageDetailsVC: GMSAutocompleteViewControllerDelegate {

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
extension CreatePageDetailsVC:RangeSeekSliderDelegate{
   
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.minSize = minValue
        self.maxSize = maxValue
    }
}

