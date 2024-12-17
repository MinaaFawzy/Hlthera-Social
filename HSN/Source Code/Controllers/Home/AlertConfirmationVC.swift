//
//  AlertConfirmationVC.swift
//  HSN
//
//  Created by Prashant Panchal on 28/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class AlertConfirmationVC: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    var alertTitle = "Alert"
    var alertDesc = "Are you sure you want to cancel this appointment?"
    var yesCallback:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTitle.text = alertTitle
        self.labelDesc.text = alertDesc
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonYesTapped(_ sender: Any) {
        yesCallback?()
    }
    @IBAction func buttonNoTapped(_ sender: Any) {
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
