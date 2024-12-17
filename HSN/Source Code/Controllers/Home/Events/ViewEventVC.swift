//
//  ViewEventVC.swift
//  HSN
//
//  Created by Prashant Panchal on 16/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import ActiveLabel
import GoogleMaps
import MapKit

class ViewEventVC: UIViewController {
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var buttonEdit: ResizableButton!
    @IBOutlet weak var buttonEventByName: UILabel!
    @IBOutlet weak var labelEventType: UILabel!
    @IBOutlet weak var labelTotalPeopleAttending: UILabel!
    @IBOutlet weak var labelKnownNames: UILabel!
    @IBOutlet var imagesPeople: [UIImageView]!
    @IBOutlet weak var labelTotalCount: UILabel!
    @IBOutlet weak var labelLink: ActiveLabel!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var scrollVIew: UIScrollView!
    @IBOutlet weak var imageEventOrganiser: UIImageView!
    @IBOutlet weak var buttonInvitePeople: ResizableButton!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var viewLocation: UIView!
    
    let marker = GMSMarker()
    let geocoder = GMSGeocoder()
    var latitude = 19.0760
    var longitude = 72.8777
    var pageId = ""
    var isCameFromNotififications = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleMaps()
        setupMapCamera()
        setupMarker(lat: self.latitude, long: self.longitude)
        setStatusBar()
        viewHeader.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewHeader.layer.cornerRadius = 25
        imageCover.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageCover.contentMode = UIView.ContentMode.scaleAspectFill
        imageProfile.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageProfile.contentMode = UIView.ContentMode.scaleAspectFill
        
        labelLink.handleURLTap { url in UIApplication.shared.openURL(url) }
        // Do any additional setup after loading the view.
    }
    
    var hasCameFrom:HasCameFrom = .viewEvent
    var data:EventModel?
    var eventId = ""
    
    func getData(){
       
        globalApis.getEvent(type:hasCameFrom,id: String.getString(eventId), completion: { data in
            self.data = data
            self.updateData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
      
            getData()
        
    }
 
    func updateData(){
        if let obj = data{
            
            self.imageProfile.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.event_pic)),placeholder:#imageLiteral(resourceName: "profile_placeholder") )
            
            self.imageEventOrganiser.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.event_orgnize_by?.profile_pic)),placeholder:#imageLiteral(resourceName: "profile_placeholder") )
            self.imageCover.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.cover_pic)),placeholder:#imageLiteral(resourceName: "cover_page_placeholder") )
            self.buttonEventByName.text = String.getString(obj.event_orgnize_by?.full_name)
            self.labelName.text = obj.name.capitalized
            self.labelDescription.text = obj.description
            self.labelLink.text = obj.broadcast_link.isEmpty ? "Not found" : obj.broadcast_link
            self.labelEventType.text = obj.event_type.capitalized + " Event"
            self.labelPageTitle.text = obj.name
            self.labelTotalPeopleAttending.text = obj.total_event_members_count + " Total People Attending"
            self.labelDateTime.text = obj.start_date
            self.labelTotalCount.text = "+ " +  obj.total_event_members_count
            
            if obj.latitude != 0.0 && obj.longitude != 0.0{
                self.latitude = obj.latitude
                self.longitude = obj.longitude
                setupMapCamera()
                setupMarker(lat: self.latitude, long: self.longitude)
                self.viewLocation.isHidden = false
            }
            else{
                self.viewLocation.isHidden = true
            }
            
            if obj.user?.event_status == "1"{
                buttonInvitePeople.setTitle("Invite People", for: .normal)
            }
            else{
                buttonInvitePeople.setTitle("Join Event", for: .normal)
            }
            switch hasCameFrom{
            case .viewEvent:
                self.buttonEdit.isHidden = true
            case .viewEventAdmin:
                self.buttonEdit.isHidden = false
            default:break
            }
            
        }
    }
    @objc func refresh(_ sender:UIRefreshControl)
     {
        getData()
     }
    
    func setupRefreshControl(){

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"5")
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self,
                                  action: #selector(refresh(_:)),
                                  for: .valueChanged)
        scrollVIew.refreshControl = refreshControl
    }
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateEventVC.getStoryboardID()) as? CreateEventVC else { return }
        vc.editData = data
        vc.hasCameFrom = .editEvent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonMoreTapped(_ sender: Any) {
        
    }
    @IBAction func buttonViewInMapsTapped(_ sender: Any) {
   
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = String.getString(data?.location)
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func buttonInvitePeopleTapped(_ sender: Any) {
        if String.getString(data?.user?.event_status) == "1" {
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectRecipientVC.getStoryboardID()) as? SelectRecipientVC else { return }
            vc.parentVC = self
            vc.hasCameFrom = .invitePeopleEvent
            vc.eventId = String.getString(data?.id)
            vc.callbackInvitePeople = { people in
                if !people.isEmpty{
                    
                
                    globalApis.sendEventInvitationApi(type:self.hasCameFrom,userIds: people.map{$0.recipient_id}, eventId:String.getString(self.data?.id), companyId: self.pageId , completion: {
                        self.navigationController?.moveToPopUp(text: "Invitation Sent Successfully!", completion: {
                            self.getData()

                        })
                    })
                }


            }

            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            globalApis.joinEvent(type:hasCameFrom,eventId: String.getString(data?.id),companyId: pageId, completion: {
                self.moveToPopUp(text: "Event Joined Successfullly", completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            })
        }
        
        
    }
    
    @IBAction func buttonViewAllPeopleTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: SelectGroupVC.getStoryboardID()) as? SelectGroupVC else { return }
        vc.eventMembers = self.data?.event_member ?? []
        vc.hasCameFrom = .viewEvent
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        if isCameFromNotififications{
            kSharedAppDelegate?.moveToHomeScreen(index: 3)
        }
        else{
            self.navigationController?.popViewController(animated: true)
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

}
extension ViewEventVC{
    func setupGoogleMaps(){
        viewMap.settings.myLocationButton = false
        viewMap.isMyLocationEnabled = false
        viewMap.isHidden = false
        viewMap.isUserInteractionEnabled = false
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
        self.viewMap.clear()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.marker.title = "Selected Location"
        self.marker.snippet = "Drag map to change location"
        self.marker.icon = #imageLiteral(resourceName: "location")
        self.marker.isDraggable = false
        self.marker.map = self.viewMap
    }
}
extension ViewEventVC:GMSMapViewDelegate,CLLocationManagerDelegate{
    
    
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
