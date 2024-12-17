//
//  UITextFieldBorderWidthAndColor.swift
//  TheBeaconApp
//
//  Created by Aman Gupta on 25/10/16.
//  Copyright © 2016 finoit. All rights reserved.
//

import UIKit

class UITextFieldBorderWidthAndColor: UITextFieldSubLayerBorderWidthAndColor {
    @IBInspectable override var borderWidth: CGFloat {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable override var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
