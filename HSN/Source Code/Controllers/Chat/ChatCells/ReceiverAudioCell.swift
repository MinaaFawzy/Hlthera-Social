//
//  ReceiverAudioCell.swift
//  RippleApp
//
//  Created by Mohd Aslam on 06/05/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReceiverAudioCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imageWave: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageBubble: UIImageView!
    
    var DeleteCallBack :(()->())?
    var playCallback:(()->())?
    var saveCallback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        indicatorView.type = .lineScalePulseOut
        indicatorView.color = CustomColor.kRed
       
        let image =  #imageLiteral(resourceName: "pause_white")
        playBtn.setImage(image, for: .selected)
        playBtn.tintColor = .black
        
        let image1 = #imageLiteral(resourceName: "play_white")
        playBtn.setImage(image1, for: .normal)
        playBtn.tintColor = .black
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
        guard let image2 = UIImage(named: "bubble_chat_bg_right") else { return }
           imageBubble.image = image2
                  .resizableImage(withCapInsets:
                                    UIEdgeInsets(top: 17, left: 30, bottom: 17, right: 30),
                                  resizingMode: .stretch)
                  .withRenderingMode(.alwaysTemplate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func tap_SaveBtn(_ sender: UIButton) {
        self.saveCallback?()
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        self.playCallback?()
    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.viewLeadingConstraint.constant = 15
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        self.btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.viewLeadingConstraint.constant = 75
            self.layoutIfNeeded()
        }
    }
}