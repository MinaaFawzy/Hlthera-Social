//
//  StoryCVC.swift
//  HSN
//
//  Created by Prashant Panchal on 10/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class StoryCVC: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageStory: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageCreatePost: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var traiing: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    public var userDetails: (String,String)? {
        didSet {
            if let details = userDetails {
                self.labelName.text = details.0
                self.imageProfile.setImage(url: details.1)
               
            }
        }
    }
    
    func applyGradient() {
        imageStory.autoresizingMask =  [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageStory.contentMode = UIView.ContentMode.scaleAspectFill
        self.viewContent.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.viewContent.frame.size)
        gradient.colors =  [#colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1).cgColor, #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1).cgColor]
        let shape = CAShapeLayer()
        shape.lineWidth = 6
        shape.path = UIBezierPath(roundedRect: self.viewContent.bounds, cornerRadius: self.viewContent.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.viewContent.layer.addSublayer(gradient)
        leading.constant = 5
        traiing.constant = 5
        bottom.constant = 5
        top.constant = 5
    }
    
    override func layoutSubviews() {
        imageStory.cornerRadius = imageStory.frame.height/2
    }
    
    @IBAction private func buttonStoryTapped(_ sender: Any) {}

}
