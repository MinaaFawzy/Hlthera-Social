//
//  CreateJobAlertVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import GooglePlaces
class CreateJobAlertVC: UIViewController {
    @IBOutlet weak var textFieldJobTitle: UITextField!
    @IBOutlet weak var buttonLocation: UIButton!
    
    var latitude = 0.0
    var longitude = 0.0
    
    var callback:((String,GMSPlace)->())?
    var pageId = ""
    var selectedLocation:GMSPlace?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        self.present(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonCreateJobAlertTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            
            self.callback?(String.getString(self.textFieldJobTitle.text),self.selectedLocation ?? GMSPlace())
        })
    }
    
}
extension CreateJobAlertVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    
      self.buttonLocation.setTitle(place.name, for: .normal)
            
      self.buttonLocation.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
      self.buttonLocation.tag = 1
                                      
      self.selectedLocation = place
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
