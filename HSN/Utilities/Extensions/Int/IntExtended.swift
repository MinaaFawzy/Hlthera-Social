//
//  IntExtended.swift
//  TheBeaconApp
//
//  Created by Ruchin Singhal on 21/12/16.
//  Copyright © 2016 finoit. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    static func getInt(_ value: Any?) -> Int {
        guard let intValue = value as? Int else {
            let strInt = String.getString(value)
            guard let intValueOfString = Int(strInt) else { return 0 }
            return intValueOfString
        }
        return intValue
    }
    
    func toCGFloat() -> CGFloat
    {
        return CGFloat(self)
    }
    
    func toBool() -> Bool
    {
        return self == 0 ? false : true
    }
    
    func toString(changeToDoubleDigit:Bool = false) -> String {
        
        let number = NSNumber(integerLiteral: self)
        let str = String(format:"%@",number).trimAll()
        
        return Localised((self < 10 && self > 0 && changeToDoubleDigit) ? "0\(str)" : str)
    }
    func dateFromTimeStamp() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self)/1000)
    }
}
//Used in chat
extension Bool
{
    static func getBool(_ value: Any?) -> Bool
    {
        guard let boolValue = value as? Bool else
        {
            let strBool = String.getString(value)
            guard let boolValueOfString = Bool(strBool) else { return false }
            
            return boolValueOfString
        }
        return boolValue
    }
}

