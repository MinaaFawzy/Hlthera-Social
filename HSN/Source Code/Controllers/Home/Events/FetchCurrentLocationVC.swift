
//

import UIKit
import GoogleMaps
import GooglePlaces

class FetchCurrentLocationVC: UIViewController {
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var buttonCurrentLocation: UIButton!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var labelLocationTitle: UILabel!
    @IBOutlet weak var labelLocationAddressa: UILabel!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var buttonSearchLocation: UIButton!
    @IBOutlet weak var viewSearchLocation: UIView!
    
    var latitude = 19.0760
    var longitude = 72.8777
    var callback:((Double,Double)->())?
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
    let geocoder = GMSGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

    }
    func initialSetup(){
        viewSearchLocation.layer.cornerRadius = 5
        viewSearchLocation.clipsToBounds = true
        buttonCurrentLocation.layer.cornerRadius = 5
       
        viewLocation.layer.cornerRadius = 5
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        setupGoogleMaps()
        setStatusBar()
    }
    func setupGoogleMaps(){
        viewMap.settings.myLocationButton = false
        viewMap.isMyLocationEnabled = false
        viewMap.isHidden = false
        viewMap.isUserInteractionEnabled = true
        viewMap.settings.zoomGestures = true
        viewMap.delegate = self
        viewMap.clipsToBounds = true
        setupMarker(lat: latitude, long: longitude)
    }
    func setupMapCamera(){
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 18)
        viewMap.camera = camera
        if self.viewMap.isHidden {
            self.viewMap.isHidden = false
            self.viewMap.camera = camera
        } else {
            self.viewMap.animate(to: camera)
        }

    }
    func setupMarker(lat:Double,long:Double){
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.marker.title = "Selected Location"
        self.marker.snippet = "Drag map to change location"
        self.marker.icon = #imageLiteral(resourceName: "location_two")
        self.marker.isDraggable = false
        self.marker.map = self.viewMap
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
                self.labelLocationTitle.text = "\(subLocality), \(locality),\(country)"
                self.labelLocationAddressa.text = lines
                self.latitude = position.latitude
                self.longitude = position.longitude
            }
        }
        
        
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSearchLocationTapped(_ sender: Any) {
        searchPlaces()
    }
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        callback?(latitude,longitude)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCurrentLocationTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
}
extension FetchCurrentLocationVC:GMSMapViewDelegate,CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = manager.location?.coordinate.latitude ?? self.latitude
        self.longitude = manager.location?.coordinate.longitude ?? self.longitude
        DispatchQueue.main.async {
            self.setupMapCamera()
        }
        locationManager.stopUpdatingLocation()
       
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print(mapView.center)
        mapView.clear()
        viewLocation.isHidden = false
        updateMapView(mapView: mapView)
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       mapView.clear()
        viewLocation.isHidden = true
        updateMapView(mapView: mapView)
        
    }
}
extension FetchCurrentLocationVC:GMSAutocompleteViewControllerDelegate{
    func searchPlaces(){
        //Google Places
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField =
            GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                            UInt(GMSPlaceField.placeID.rawValue) |
                            UInt(GMSPlaceField.coordinate.rawValue) |
                            GMSPlaceField.addressComponents.rawValue |
                          GMSPlaceField.formattedAddress.rawValue)!
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        
    }
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true){
            self.latitude = place.coordinate.latitude
            self.longitude = place.coordinate.longitude
            DispatchQueue.main.async {
                self.setupMarker(lat: self.latitude, long: self.longitude)
                self.setupMapCamera()
            }
        }
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
