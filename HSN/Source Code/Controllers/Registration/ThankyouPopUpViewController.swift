//
//  ThankyouPopUpViewController.swift
//  HSN
//
//  Created by Kartikeya on 13/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import JellyGif
//import Lottie
class ThankyouPopUpViewController: UIViewController {
    
   // @IBOutlet weak var img: JellyGifImageView!
    @IBOutlet weak var animationView: UIView!
    var callback:(()->())?
    @IBOutlet weak var viewGIF: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //    animationView = .init(name: "coffee")
          
       //   animationView!.frame = view.bounds
          
          // 3. Set animation content mode
          
//          animationView!.contentMode = .scaleAspectFit
//
//          // 4. Set animation loop mode
//          animationView!.loopMode = .loop
//          // 5. Adjust animation speed
//          animationView!.animationSpeed = 0.5
//
//       //   view.addSubview(animationView!)
//
//          // 6. Play animation
//
//          animationView!.play()
//
//
//        self.viewThankyou.contentMode = .scaleAspectFill
//        self.viewThankyou.loopMode = .playOnce
//        self.viewThankyou.animationSpeed = 1
//        self.viewThankyou.currentFrame =  AnimationFrameTime(30)
//        self.viewThankyou.play(fromFrame: AnimationFrameTime(90), toFrame: 30, loopMode: .playOnce) { finished in}
        viewGIF.backgroundColor = .clear
//        do {
//            let gif = try UIImage(gifName: "success.gif")
//            DispatchQueue.main.async {
//                let imageview = UIImageView(gifImage: gif, loopCount: -1) //Use -1 for infinite loop
//                imageview.contentMode = .scaleAspectFit
//                imageview.frame = self.viewGIF.bounds
//                self.viewGIF.addSubview(imageview)
//                print("added")
//            }
//        } catch {
//            print(error)
//        }
       // img.startGif(with: .name("success"))
    }

    @IBAction func buttonContinueTapped(_ sender:UIButton){
        self.dismiss(animated: true, completion: {
            self.callback?()
        })
       
    }

}
