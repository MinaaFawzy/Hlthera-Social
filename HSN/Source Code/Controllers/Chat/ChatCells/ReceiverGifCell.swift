//
//  ReceiverGifCell.swift
//  HSN
//
//  Created by Prashant Panchal on 26/08/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class ReceiverGifCell: UITableViewCell {

    @IBOutlet weak var viewGIF: UIView!
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var tickImgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageGif: UIImageView!
    
    var viewDocumentCallBack:(()->())?
    var DeleteCallBack :(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDocument))
//        self.viewGIF.addGestureRecognizer(tapGestureRecognizer)
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
    
//    @objc func handleDocument(_ sender:UIButton) {
//
//        self.viewDocumentCallBack?()
//    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.imgTrailingConstraint.constant = 15
            self.btnDelete.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.2) {
            self.imgTrailingConstraint.constant = 75
            self.btnDelete.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
}
