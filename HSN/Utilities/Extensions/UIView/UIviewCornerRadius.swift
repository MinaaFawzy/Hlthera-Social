//
//  UIviewCornerRadius.swift
//  TheBeaconApp
//
//  Created by Ruchin Singhal on 04/11/16.
//  Copyright © 2016 finoit. All rights reserved.
//

import UIKit

class UIViewCornerRadius: UIViewBorderWidthAndColor {
    @IBInspectable override var cornerRadius: CGFloat {
        didSet {
            layer.cornerRadius = cornerRadius1
            layer.masksToBounds = false
        }
    }
    @IBInspectable var makeCircle: Bool = false {
        didSet {
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var shadowOffset1: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    @IBInspectable var shadowColor1: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable override var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadowOpacity1: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
}
