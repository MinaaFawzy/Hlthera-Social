//
//  UIButtonBorderWidthAndColor.swift
//  OneClickWash
//
//  Created by RUCHIN SINGHAL on 15/09/16.
//  Copyright © 2016 Appslure. All rights reserved.
//

import UIKit

class UIButtonBorderWidthAndColor: UIButtonCornerRadius {
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
