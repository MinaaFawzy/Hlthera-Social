//
//  SenderImageCell.swift
//  Traveller
//
//  Created by fluper on 23/07/19.
//  Copyright © 2019 Fluper. All rights reserved.
//

import UIKit

class SenderImageCell: UITableViewCell {

    //MARK:- IBOutlet
  //  @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var sendimageView: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tickImgView: UIImageView!
    
    @IBOutlet weak var saveImgBtn: UIButton!
    var DeleteCallBack :(()->())?
    var openImageCallBack :(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sendimageView.clipsToBounds = true
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func openImageAction(_ sender: UIButton) {
        self.openImageCallBack?()
        
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
