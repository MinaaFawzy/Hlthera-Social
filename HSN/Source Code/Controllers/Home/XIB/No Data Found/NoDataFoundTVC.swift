//
//  NoDataFoundTVC.swift
//  HSN
//
//  Created by Prashant Panchal on 27/07/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
//import SwiftyGif
import JellyGif
class NoDataFoundTVC: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var img: JellyGifImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.backgroundColor = .clear
//        do {
//                    let gif = try UIImage(gifName: "noDataFound.gif")
//                    DispatchQueue.main.async {
//                        let imageview = UIImageView(gifImage: gif, loopCount: -1) //Use -1 for infinite loop
//                        imageview.contentMode = .scaleAspectFit
//                        imageview.frame = self.containerView.bounds
//                        self.containerView.addSubview(imageview)
//                    }
//                } catch {
//                    print(error)
//                }
        img.startGif(with: .name("noDataFound"))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
