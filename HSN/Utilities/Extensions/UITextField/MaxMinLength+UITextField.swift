//
//  MaxMinLength+UITextField.swift
//  MAI
//
//  Created by Fluper on 06/12/17.
//  Copyright © 2017 Fluper. All rights reserved.
//

import Foundation
import UIKit

class MaxLengthTextField: UITextField, UITextFieldDelegate {
    private var characterLimit: Int?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    @IBInspectable var maxLength: Int {
        get {
            guard let length = characterLimit else {
                return Int.max
            }
            return length
        }
        set {
            characterLimit = newValue
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.count <= maxLength
    }
    
}
