//
//  String+Utilities.swift
//  HealthTotal
//
//  Created by Office on 23/05/16.
//  Copyright © 2016 Collabroo. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // To Check Whether Email is valid
    func isEmail() -> Bool {
        let emailRegex = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,4})$" as String
        let emailText = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        let isValid  = emailText.evaluate(with: self) as Bool
        return isValid
    }
    
    func isValidUserName() -> Bool{
        let RegEx = "^[a-z A-Z]$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func isBackSpace()->Bool {
        if let char = self.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            return isBackSpace == -92
        }
        return true
    }
    
    // To Check Whether Email is valid
    func isValidString() -> Bool {
        if self == "<null>" || self == "(null)" {
            return false
        }
        return true
    }
    
    func isValidPassword(text: String) -> Bool {
        
        let letters = CharacterSet.letters
        
        let phrase = text
        let range = phrase.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if range != nil {
            return false
        }
        else {
            return true
        }
    }
    
    // To Check Whether Phone Number is valid
    
    func isPhoneNumber() -> Bool {
        if self.isStringEmpty() {
            return false
        }
        let phoneRegex = "^\\d{8,15}$"
        let phoneText = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValid = phoneText.evaluate(with: self) as Bool
        return isValid
    }
    
    func isNumber() -> Bool {
        if self.isStringEmpty() {
            return false
        }
        let phoneRegex = "^\\d{1,15}$"
        let phoneText = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValid = phoneText.evaluate(with: self) as Bool
        return isValid
    }
    
    func isNumberContains() -> Bool {
        if self.isStringEmpty() {
            return false
        }
        let phoneRegex = "^\\d{0,30}$"
        let phoneText = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValid = phoneText.evaluate(with: self) as Bool
        return isValid
        //return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
        
    }
    // Password_Validation
    
    func isPasswordValidate() -> Bool {
        let passwordRegix = "[A-Za-z0-9.@#$%*?:!+-/]{8,25}"
        let passwordText  = NSPredicate(format:"SELF MATCHES %@",passwordRegix)
        
        return passwordText.evaluate(with:self)
    }
    func isSpecialCharactersExcluded()->Bool{
        let regex = "^[^<>'\"/;`%]*$"
        let regexText  = NSPredicate(format:"SELF MATCHES %@",regex)
        return regexText.evaluate(with:self)
    }
    
    // To Check Whether URL is valid
    
    func isURL() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
           let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
           let result = urlTest.evaluate(with: self)
           return result
    }
    
    // To Check Whether Image URL is valid
    
    func isImageURL() -> Bool {
        if self.isURL() {
            if self.range(of: ".png") != nil || self.range(of: ".jpg") != nil || self.range(of: ".jpeg") != nil {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func toInt() -> Int
    {
        return Int(self) ?? 0
    }
    
    func trimAll()->String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    static func getString(_ message: Any?) -> String {
        guard let strMessage = message as? String else {
            guard let doubleValue = message as? Double else {
                guard let intValue = message as? Int else {
                    guard let int64Value = message as? Int64 else{
                        return ""
                    }
                    return String(int64Value)
                }
                return String(intValue)
            }
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 20
            formatter.minimumIntegerDigits = 1
            guard let formattedNumber = formatter.string(from: NSNumber(value: doubleValue)) else {
                return ""
            }
            return formattedNumber
        }
        return strMessage.stringByTrimmingWhiteSpaceAndNewLine()
    }
    
    static func getLength(_ message: Any?) -> Int {
        return String.getString(message).stringByTrimmingWhiteSpaceAndNewLine().count
    }
    
    static func checkForValidNumericString(_ message: AnyObject?) -> Bool {
        guard let strMessage = message as? String else {
            return true
        }
        
        if strMessage == "" || strMessage == "0" {
            return true
        }
        return false
    }
    
    
    // To Check Whether String is empty
    
    func isStringEmpty() -> Bool {
        return self.stringByTrimmingWhiteSpace().count == 0 ? true : false
    }
    
    mutating func removeSubString(subString: String) -> String {
        if self.contains(subString) {
            guard let stringRange = self.range(of: subString) else { return self }
            return self.replacingCharacters(in: stringRange, with: "")
        }
        return self
    }
    
    // Get string by removing White Space & New Line
    
    func stringByTrimmingWhiteSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    // Get string by removing White Space
    
    func stringByTrimmingWhiteSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func getSubStringFrom(begin: NSInteger, to end: NSInteger) -> String {
        // var strRange = begin..<end
        // let str = self.substringWithRange(strRange)
        return ""
    }
}
extension NSAttributedString{
    static func setAttributedString(firstValue:String,firstColor:UIColor,firstFont:UIFont,secondValue:String,secondColor:UIColor,secondFont:UIFont) -> NSMutableAttributedString{
        let attributedText = NSMutableAttributedString(string: firstValue, attributes: [NSAttributedString.Key.font: firstFont,NSAttributedString.Key.foregroundColor: firstColor])
        attributedText.append(NSAttributedString(string:secondValue, attributes: [NSAttributedString.Key.font: secondFont, NSAttributedString.Key.foregroundColor: secondColor]))
        return attributedText
    }
}
extension UIFont{
   
    static func SFDisplayBold(fontSize:CGFloat) -> UIFont{
        return UIFont(name: "SFProDisplay-Bold", size: fontSize) ?? UIFont()
    }
    static func SFDisplaySemiBold(fontSize:CGFloat) -> UIFont{
        return UIFont(name: "SFProDisplay-Semibold", size: fontSize) ?? UIFont()
    }
    static func SFDisplayMedium(fontSize:CGFloat) -> UIFont{
        return UIFont(name: "SFProDisplay-Medium", size: fontSize) ?? UIFont()
    }
    static func SFDisplayRegular(fontSize:CGFloat) -> UIFont{
        return UIFont(name: "SFProDisplay-Regular", size: fontSize) ?? UIFont()
    }
    static func SFDisplayLight(fontSize:CGFloat) -> UIFont{
        return UIFont(name: "SFProDisplay-Light", size: fontSize) ?? UIFont()
    }
}
extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    func removeGradient() {
        for layer in self.layer.sublayers ?? []{
            if layer.isKind(of:CAGradientLayer.self){
                layer.removeFromSuperlayer()
            }
        }
    }
    
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }

    func createDottedLine(width: CGFloat, color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [4,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
  
    }
