//
//  viewshadow.swift
//  MAI
//
//  Created by Fluper on 24/11/17.
//  Copyright © 2017 Fluper. All rights reserved.
//




import Foundation
import UIKit

extension UIView {
    
//    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner) {
//
//        let shadowLayer = CAShapeLayer()
//        let size = CGSize(width: cornerRadius, height: cornerRadius)
//        let cgPath = UIBezierPath(roundedRect: UIScreen.main.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
//        shadowLayer.path = cgPath //2
////        shadowLayer.fillColor = fillColor.cgColor //3
//        shadowLayer.shadowColor = shadowColor.cgColor //4
//        shadowLayer.shadowPath = cgPath
//        shadowLayer.shadowOffset = offSet //5
//        shadowLayer.shadowOpacity = opacity
//        shadowLayer.shadowRadius = shadowRadius
//        shadowLayer.backgroundColor = UIColor.clear.cgColor
//        shadowLayer.frame = CGRect(origin: .zero, size: self.frame.size)
//        self.layer.addSublayer(shadowLayer)
//    }
    
    func drawShadowwithCorner() {
        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.cornerRadius = 12
    }
    
    func addShadowOnSideViewInCell() {
        self.layer.cornerRadius = 18
        self.layer.shadowColor = UIColor(white: 0.0, alpha: 0.7).cgColor
        self.layer.shadowOffset = CGSize(width:0, height: 1.0)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 4.0
    }
    
    func drawShadow() {
        let layer = self.layer
        layer.shadowColor = UIColor.lightGray.cgColor
          //  #colorLiteral(red: 0.168627451, green: 0.4705882353, blue: 0.7843137255, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
     //   layer.shadowRadius = 2.5
        layer.masksToBounds = false
    }
    func drawShadowEmojis() {
        let layer = self.layer
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        
        layer.cornerRadius = layer.frame.height/2
        
    }
    func removeShadow() {
        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 5
    }
    
    func drawShadowOnCell() {
        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 1, height: 0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }
    
    func makingViewCornerRoundWithShadow(withCornerRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize.init(width: 1.0, height: 0.0)
        self.layer.shadowRadius = 3.0
    }
    
    @IBInspectable
    var cornerRadius1: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth1: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor1: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius1: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.9
            layer.shadowRadius = shadowRadius
        }
    }
    
}

extension UIButton {
    
    func drawShadowOnButton(cornerRadius:CGFloat = 20) {
        let layer = self.layer
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.7233634591, green: 0.7233806252, blue: 0.7233713269, alpha: 1)
        layer.cornerRadius = cornerRadius
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}

extension UIImageView {
    
    func drawShadowOnImage() {
        self.layer.cornerRadius = 7
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 6.0
    }
    
}

extension UICollectionViewCell {
    
    func drawSadowOncollectionViewCell() {
        self.contentView.layer.cornerRadius = 12.0
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
    
}

extension UIView {
    
    //MARK: - Round corner method
    func maskingCorner(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
}
