//
//  LoungeAlertVC.swift
//  HSN
//
//  Created by user206889 on 11/5/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeAlertVC: UIViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var btnYesTitle: UIButton!
    @IBOutlet weak var btnNoTitle: UIButton!
    var yesCallback:(()->())?
    var titleString = "End Audio Chat?"
    var msgString = "The audio chat will be end for everyone"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTitle.text = titleString
        self.labelMessage.text = msgString
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnEndTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.yesCallback?()
        })
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
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
