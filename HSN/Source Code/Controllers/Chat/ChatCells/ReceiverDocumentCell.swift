//
//  ReceiverDocumentCell.swift
//  AdvisoryExpert
//
//  Created by Mohd Aslam on 23/01/21.
//

import UIKit

class ReceiverDocumentCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageDoc: UIImageView!
    @IBOutlet weak var labelDocName: UILabel!
    @IBOutlet weak var viewDocument: UIView!
 //  @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!
    
    var viewDocumentCallBack:(()->())?
    var DeleteCallBack :(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // profileImgView.clipsToBounds = true
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        self.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        self.addGestureRecognizer(rightSwipe)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDocument))
        self.viewDocument.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func tap_DeleteBtn(_ sender: UIButton) {
        self.DeleteCallBack?()
    }
    
    @objc func handleDocument(_ sender:UIButton) {
        
        self.viewDocumentCallBack?()
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
    
}
