//
//  CustomClass.swift
//  Munch User
//
//  Created by Nitin Aggarwal on 12/04/18.
//  Copyright © 2018 Fluper. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {

    @IBInspectable var kCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
        }
    }
    @IBInspectable var kShadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    @IBInspectable var kShadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable var kShadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var kShadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
}

class CustomImage: UIImageView {
    @IBInspectable var kCornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
        }
    }
    @IBInspectable var kShadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    @IBInspectable var kShadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable var kShadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var kShadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
}
