//
//  SplashScreenViewController.swift
//  Hlthera
//
//  Created by Akash on 27/10/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import JellyGif

class SplashVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imgLogo: JellyGifImageView!
    @IBOutlet weak var splashContainerView: UIView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashContainerView.backgroundColor = .clear
        //do {
        //    let gif = try UIImage(gifName: "splash.gif")
        //    DispatchQueue.main.async {
        //        let imageview = UIImageView(gifImage: gif, loopCount: 1) //Use -1 for infinite loop
        //        imageview.contentMode = .scaleAspectFill
        //        imageview.frame = self.splashContainerView.bounds
        //        self.splashContainerView.addSubview(imageview)
        //        imageView.startGif(with: .name("Gif name"))
        //    }
        //} catch {
        //    print(error)
        //}
        imgLogo.startGif(with:.name("splash"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
            //kSharedAppDelegate?.moveToHomeVC()
            if kSharedUserDefaults.isUserLoggedIn() {
                if kSharedUserDefaults.isFaceIdEnable() {
                    kSharedAppDelegate?.moveToLoginScreen()
                } else {
                    kSharedAppDelegate?.moveToHomeScreen()
                }
            } else {
                kSharedAppDelegate?.moveToWalkthrough()
            }
        }
    }
    
}
