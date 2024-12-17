//
//  UIButtonGradiant.swift
//  Abwab
//
//  Created by ABC on 21/03/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

class UIButtonGradiant: UIButton {
    @IBInspectable var firstColor:UIColor = UIColor.clear {
        didSet {
            updateVC()
        }
    }
    @IBInspectable var secondColor:UIColor = UIColor.clear {
        didSet {
            updateVC()
        }
    }

    func updateVC() {
        
        let layer = CAGradientLayer()
        layer.colors = [appThemeUp.cgColor,appThemeDown.cgColor]
        layer.frame = self.bounds
        self.layer.insertSublayer(layer, at: 0)
  }

}

@IBDesignable class WSRoundButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
        layer.masksToBounds = true
    }
}
