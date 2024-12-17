//
//  UIImageViewBorderWidthAndColor.swift
//  TheBeaconApp
//
//  Created by Ruchin Singhal on 04/11/16.
//  Copyright © 2016 finoit. All rights reserved.
//

import UIKit

class UIImageViewBorderWidthAndColor: UIImageView {
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
