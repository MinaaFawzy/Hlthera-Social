//
//  CustomAlertPopupVC.swift
//  RippleApp
//
//  Created by Mohd Aslam on 12/05/20.
//  Copyright © 2020 Fluper. All rights reserved.
//

import UIKit

class CustomAlertPopupVC: UIViewController {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var titleStrr: String = "Are you sure you want to delete this message?"
    var cancelBtnTitle: String = "No"
    var deleteBtnTitle: String = "Yes"
    var deleteCallBack: (() -> ())? = nil
    var dismissCallBack: (() -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.drawShadow()
        titleLbl.text = titleStrr
        cancelBtn.setTitle(cancelBtnTitle, for: .normal)
        deleteBtn.setTitle(deleteBtnTitle, for: .normal)
        deleteBtn.titleLabel?.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.containerView{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.dismissCallBack?()
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.deleteCallBack?()
        }
        
    }


}
