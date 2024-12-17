//
//  LoungeOptionsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 19/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class LoungeOptionsVC: UIViewController {
    @IBOutlet weak var btnSendInvitation: OptionSheetButton!
    @IBOutlet var btnsOption: [OptionSheetButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnsOptionsTapped(_ sender: Any) {
        
    }
}
