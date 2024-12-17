//
//  InvitesVC.swift
//  HSN
//
//  Created by Ankur on 17/06/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class InvitesVC: UIViewController {
    
    @IBOutlet weak var textfieldShareCode: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar()
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnInvitesFriendsTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: Storyboards.kLounge, bundle: nil).instantiateViewController(withIdentifier: InviteFriendsVC.getStoryboardID()) as? InviteFriendsVC else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton) {
        let textToShare = textfieldShareCode.text
        if let myWebsite = NSURL(string: "http://www.google.com") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }

}
