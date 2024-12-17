//
//  EventDetailsVC.swift
//  HSN
//
//  Created by Ankur on 01/06/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import SwiftUI

class EventDetailsVC: UIViewController {
    
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelOnlineStatus: UILabel!
    @IBOutlet weak var labelEventDateAndTime: UILabel!
    @IBOutlet weak var labelOnlineLink: UILabel!
    @IBOutlet weak var labelTicketLink: UILabel!
    @IBOutlet weak var labelEventType: UILabel!
    @IBOutlet weak var labelEventInterestedCount: UILabel!
    @IBOutlet weak var labelAboutText: UILabel!
    @IBOutlet weak var imageInterested: UIImageView!
    @IBOutlet weak var viewInterestedButton: UIView!
    @IBOutlet weak var labelInterested: UILabel!
    @IBOutlet weak var ViewImage: UIView!
    @IBOutlet weak var viewLine: UIView!
    
    var hasCameFrom:HasCameFrom = .viewEvent
    var data:EventModel?
    var eventId = ""
    var IsInterested = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        imageEvent.roundCorners([.bottomLeft,.bottomRight], radius: 10)
      //r  ViewImage.roundedCornersNew(corners: [.bottomLeft,.bottomRight], radius: 10.0)
        ViewImage.clipsToBounds = true
        ViewImage.layer.cornerRadius = 10
        ViewImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    
        getData()
        labelOnlineStatus.isHidden = true
        setGradientSettingsBackgroundNew(view: viewLine)
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func buttonBookTicketsTapped(_ sender: UIButton) {
        let obj = data
        guard let nextVc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else {return}
        nextVc.pageTitleString = "Book Tickets"
        nextVc.url = obj?.registration_link ?? ""
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func buttonInterestedTapped(_ sender: UIButton) {
        let obj = data
        globalApis.eventInterest(event_id: "\(obj?.id ?? "")", is_interest: !IsInterested, interest_type: "public") { stat in
            if stat == "1" {
                self.imageInterested.image = UIImage(named: "filled_star")
                self.viewInterestedButton.backgroundColor = UIColor(hexString: "4276C2")
                self.labelInterested.textColor = .white
                self.IsInterested = true
            }else{
                self.imageInterested.image = UIImage(named: "hollow_star")
                self.viewInterestedButton.backgroundColor = UIColor(hexString: "D8DFE9")
                self.labelInterested.textColor = .label
                self.IsInterested = false
            }
    }
    }
}

extension EventDetailsVC {
    func getData(){
        globalApis.getEvent(type:hasCameFrom,id: String.getString(eventId), completion: { data in
            self.data = data
            self.updateData()
        })
    }
    
    func updateData(){
        if let obj = data{

            self.imageEvent.kf.setImage(with: URL(string: kBucketUrl + String.getString(obj.event_pic)),placeholder:#imageLiteral(resourceName: "profile_placeholder") )
            self.labelEventName.text = String.getString(obj.name)
            if String.getString(obj.is_online_event) == "1"{
                labelOnlineStatus.isHidden = false
            }
            let startDate = obj.start_date
            if startDate != ""{
//               let newDate = ankur_changeDateFormate(YourDate: startDate, FormatteFrom: "yyyy/MM/dd", FormatteTo: "EEEE, MMM d, yyyy")
//                self.labelEventDateAndTime.text = "\(newDate) at \(obj.start_time) onwards"
                let newDate = ankur_changeDateFormate(YourDate: startDate, FormatteFrom: "yyyy/MM/dd", FormatteTo: "EEEE, MMM d, yyyy")
                self.labelEventDateAndTime.text = "\(newDate) at \(obj.start_time) - \(obj.end_time)"
            }
            self.labelOnlineLink.text = obj.broadcast_link.isEmpty ? "Not found" : obj.broadcast_link
            self.labelTicketLink.text = obj.registration_link.isEmpty ? "Not found" : obj.registration_link
            self.labelEventType.text = obj.event_type.capitalized + " Event"
            self.labelEventInterestedCount.text = "\(obj.total_event_members_count)"
            self.labelAboutText.text = obj.description
           
            if IsInterested == true {
                self.imageInterested.image = UIImage(named: "filled_star")
                self.viewInterestedButton.backgroundColor = UIColor(hexString: "4276C2")
                self.labelInterested.textColor = .white
            }else{
                self.imageInterested.image = UIImage(named: "hollow_star")
                self.viewInterestedButton.backgroundColor = UIColor(hexString: "D8DFE9")
                self.labelInterested.textColor = .label
            }
    }
}
    func setGradientSettingsBackgroundNew(view:UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.9371727705, green: 0.9373074174, blue: 0.9371433854, alpha: 1).cgColor, #colorLiteral(red: 0.9881489873, green: 0.9882906079, blue: 0.9881181121, alpha: 1).cgColor]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(patternImage: image(from: gradientLayer)!)
    }
    func image(from layer: CALayer?) -> UIImage? {
        UIGraphicsBeginImageContext(layer?.frame.size ?? CGSize.zero)
        
        if let context = UIGraphicsGetCurrentContext() {
            layer?.render(in: context)
        }
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}


