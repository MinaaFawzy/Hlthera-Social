//
//  UIViewBorderWidthAndColor.swift
//  TheBeaconApp
//
//  Created by Ruchin Singhal on 04/11/16.
//  Copyright © 2016 finoit. All rights reserved.
//

import UIKit

class UIViewBorderWidthAndColor: UIView {
    @IBInspectable  override var borderWidth: CGFloat {
        didSet {
            layer.borderWidth = borderWidth1
        }
    }
    @IBInspectable override  var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor1?.cgColor
        }
    }
}
