//
//  locationManager.swift
//  Kawader
//
//  Created by fluper on 12/03/20.
//  Copyright © 2020 fluper. All rights reserved.

import Foundation
import CoreLocation
class LocationManager:NSObject,CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var latitiude:Double = 0.0
    var longitude:Double = 0.0
    var cllocations:[CLLocation] = []
    var currentLocation = ""
    var currentISOCode = ""
    var currentLocality = ""
    var callback:((Double,Double)->())?
    
    static var sharedInstance = LocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        cllocations = locations
        self.stopUpdatingLocation()
        self.latitiude = locations.first?.coordinate.latitude ?? 0.0
        self.longitude = locations.first?.coordinate.longitude ?? 0.0
        self.callback?(latitiude,longitude)
        print("latitude \(latitiude),longitude \(longitude)")
        let userLocation :CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks as? [CLPlacemark]
            if placemark?.count>0{
                let placemark = placemarks![0]
                
                self.currentLocation = "\(placemark.subThoroughfare ?? ""), \(placemark.thoroughfare ?? ""), \(placemark.subLocality ?? ""), \(placemark.locality ?? ""), \(placemark.postalCode ?? ""), \(placemark.administrativeArea ?? ""),  \(placemark.country ?? "")"
                print(self.currentLocation)
                self.currentISOCode = placemark.isoCountryCode ?? ""
                self.currentLocality = placemark.locality ?? ""
                
                
                //                  self.labelUserLocation.text = self.currentLocation
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
}
