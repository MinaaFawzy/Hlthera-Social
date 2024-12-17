//
//  RelevantCommentVC.swift
//  HSN
//
//  Created by Apple on 06/09/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class RelevantCommentVC: UIViewController {

    @IBOutlet weak var btnRelevant: UIButton!
    @IBOutlet weak var btnAllComment: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnAdmin: UIButton!
    @IBOutlet weak var shareView: UIView!
    
    var callBack:((Int) -> ())?
    var isAdmin = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareView.isHidden = !isAdmin
        // Do any additional setup after loading the view.
    }
    
    @IBAction func relevantAllCommentAction(_ sender: UIButton) {
        
        btnRelevant.isSelected = sender == btnRelevant ? true : false
        btnAllComment.isSelected = sender == btnAllComment ? true : false
        btnRelevant.setTitleColor(sender == btnRelevant ? UIColor.init(hexString: "#1E3F6C") : UIColor.init(hexString: "#8794AA"), for: .normal)
        btnAllComment.setTitleColor(sender == btnAllComment ? UIColor.init(hexString: "#1E3F6C") : UIColor.init(hexString: "#8794AA"), for: .normal)
        self.callBack?(sender == btnRelevant ? 1 : 2 )
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sharePostAction(_ sender: UIButton) {
        
        btnUser.isSelected = sender == btnUser ? true : false
        btnAdmin.isSelected = sender == btnAdmin ? true : false
        btnUser.setTitleColor(sender == btnUser ? UIColor.init(hexString: "#1E3F6C") : UIColor.init(hexString: "#8794AA"), for: .normal)
        btnAdmin.setTitleColor(sender == btnAdmin ? UIColor.init(hexString: "#1E3F6C") : UIColor.init(hexString: "#8794AA"), for: .normal)
        self.callBack?(sender == btnUser ? 1 : 2 )
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

