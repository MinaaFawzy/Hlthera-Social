//
//  HomeHeaderView.swift
//  HSN
//
//  Created by Prashant Panchal on 24/09/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {
    @IBOutlet weak var viewHeader: UIView!
    var controller:UIViewController?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func updateData(vc:UIViewController){
        viewHeader.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        viewHeader.layer.cornerRadius = 15
        self.controller = vc
    }
    @IBAction func buttonMessageTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kChat, bundle: nil).instantiateViewController(withIdentifier: MessagesVC.getStoryboardID()) as? MessagesVC else { return }

        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonSearchTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: HomeSearchVC.getStoryboardID()) as? HomeSearchVC else { return }
        vc.callback = { index,user in
            globalApis.getProfile(id: String.getString(user?.id), completion: { data in
                guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: OtherUserProfileVC.getStoryboardID()) as? OtherUserProfileVC else { return }
                vc.data = data
                vc.id = data.id
                vc.hasCameFrom = .viewProfile
                self.controller?.navigationController?.pushViewController(vc, animated: true)

            })


        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        controller?.navigationController?.present(vc, animated: true)
    }
    
}
