//
//  NavigationController.swift
//  Supersonicz
//
//  Created by fluper on 10/05/19.
//  Copyright © 2019 fluper. All rights reserved.
//

import Foundation
import UIKit


extension UIView{

    //MARK: - Round corner method
    func curve(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
   
}

extension UIView{
     func createGradient(gradient_from:UIColor,gradient_To:UIColor , view: UIView)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [gradient_from.cgColor, gradient_To.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 0.5)
        self.layer.addSublayer(gradientLayer)
    }

}

extension UIButton
{
   func createGradientr(gradient_from:UIColor,gradient_To:UIColor , height: CGFloat)
    {
        let gradientLayer = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let buttonFrame = CGRect(x: 0, y: 0, width: sizeLength, height: height)
        gradientLayer.frame = buttonFrame
        gradientLayer.colors = [gradient_from.cgColor, gradient_To.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 0.5)
        self.layer.addSublayer(gradientLayer)
    }

}

extension UITextField {
    func addPadding(to textfield: UITextField) {
         let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }
}

extension UITextView {
    func addPadding(to textfield: UITextView) {
        textfield.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
    }
}
extension UIView {
    //MARK: - Round corner method
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIButton {
    //MARK: - Round corner method
    func roundButtonCorner(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension UITableViewCell {
    
    static var identifier:String {
        return String(describing:self)
    }
}


extension UICollectionViewCell {
    static var identifier:String {
        return String(describing:self)
    }
}
