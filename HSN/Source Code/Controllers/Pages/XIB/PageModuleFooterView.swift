//
//  PageModuleFooterView.swift
//  HSN
//
//  Created by Prashant Panchal on 01/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PageModuleFooterView: UIView {
    
    @IBOutlet weak var buttonAddModule: UIButton!
    
    var callback:(()->())?
    
    @IBAction func buttonAddModuleTapped(_ sender: Any) {
        callback?()
    }
    
}
