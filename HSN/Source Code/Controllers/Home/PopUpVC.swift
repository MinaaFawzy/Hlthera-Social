//
//  PopUpViewController.swift
//  MarineUser
//
//  Created by Prashant on 24/06/20.
//  Copyright © 2020 Zahid Shaikh. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var viewGIF: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    //@IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    //MARK: Variables
    var popUpDescription = "Report has been successfully submitted"
    var popUpImage:UIImage = #imageLiteral(resourceName: "done")
    var callback:(()->Void)?
    var cancelCallback:(()->())?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: Methods
    func initialSetup(){
        //self.imageIcon.image = popUpImage
        self.labelDescription.text = popUpDescription
        callback?()
        
        viewGIF.backgroundColor = .clear
        do {
            let gif = try UIImage(gifName: "success.gif")
            DispatchQueue.main.async {
                let imageview = UIImageView(gifImage: gif, loopCount: -1) //Use -1 for infinite loop
                imageview.contentMode = .scaleAspectFit
                imageview.frame = self.viewGIF.bounds
                self.viewGIF.addSubview(imageview)
                print("added")
            }
        } catch {
            print(error)
        }

    }
    
    //MARK: Actions
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true){
        }
    }


}
