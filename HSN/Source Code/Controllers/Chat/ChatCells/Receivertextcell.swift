//
//  Receivertextcell.swift
//  Traveller
//
//  Created by fluper on 23/07/19.
//  Copyright © 2019 Fluper. All rights reserved.
//

import UIKit

class Receivertextcell: UITableViewCell {

    //MARK:- IBOutlet
    //@IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblMsgTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatBoxView: UIView!
    @IBOutlet weak var imageBubble: UIImageView!
    
    //mARK:- OBject
    var DeleteCallBack :(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatBoxView.clipsToBounds = true
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
        guard let image = UIImage(named: "bubble_chat_bg_right") else { return }
           imageBubble.image = image
                  .resizableImage(withCapInsets:
                                    UIEdgeInsets(top: 17, left: 30, bottom: 17, right: 30),
                                  resizingMode: .stretch)
                  .withRenderingMode(.alwaysTemplate)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer){
        btnDelete.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.lblMsgTrailingConstraint.constant = 15
            self.layoutIfNeeded()
        }
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer){
        self.btnDelete.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.lblMsgTrailingConstraint.constant = 65
            self.layoutIfNeeded()
        }
    }
    
}
