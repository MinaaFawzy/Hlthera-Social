//
//  SenderVideoCell.swift
//  Traveller
//
//  Created by fluper on 19/08/19.
//  Copyright © 2019 Fluper. All rights reserved.
//

import UIKit

class SenderVideoCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var sendimageView: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tickImgView: UIImageView!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var imgTrailingConstraint: NSLayoutConstraint!
    
    
    var DeleteCallBack :(()->())?
    var playVideo:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
        guard let image = UIImage(named: "bubble_chat_bg_left") else { return }
           sendimageView.image = image
                  .resizableImage(withCapInsets:
                                    UIEdgeInsets(top: 17, left: 30, bottom: 17, right: 30),
                                  resizingMode: .stretch)
                  .withRenderingMode(.alwaysTemplate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnPlayVideo(_ sender: UIButton) {
        self.playVideo?()
    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.imgTrailingConstraint.constant = 75
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.2) {
            self.imgTrailingConstraint.constant = 15
            self.btnDelete.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
}
