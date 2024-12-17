//
//  ReceiverVideoCell.swift
//  Traveller
//
//  Created by fluper on 19/08/19.
//  Copyright © 2019 Fluper. All rights reserved.
//

import UIKit

class ReceiverVideoCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var receiveimageView: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewSaveVideo: UIView!
    
    var DeleteCallBack :(()->())?
    var playVideo:(()->())?
    var saveVideoCallBack:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnSaveBtn(_:)))
        videoBtn.addGestureRecognizer(longGesture)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func btnPlayVideo(_ sender: UIButton) {
        if viewSaveVideo.isHidden {
            self.playVideo?()
        }else {
            viewSaveVideo.isHidden = true
        }
        
    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @IBAction func tap_SaveVideoBtn(_ sender: UIButton) {
        self.saveVideoCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.imageLeadingConstraint.constant = 15
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        self.btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.imageLeadingConstraint.constant = 75
            self.layoutIfNeeded()
        }
    }
    
    @objc func longPressOnSaveBtn(_ guesture: UILongPressGestureRecognizer) {
        if guesture.state == .began {
            print_debug(items: "Long Press started")
            viewSaveVideo.isHidden = false
            
        }else if guesture.state == .ended {
            print_debug(items: "Long Press Ended")
        }
    }
}
