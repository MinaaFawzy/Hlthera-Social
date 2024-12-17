//
//  UITextFieldExtended.swift
//  OneClickWash
//
//  Created by RUCHIN SINGHAL on 19/10/16.
//  Copyright © 2016 Appslure. All rights reserved.
//

import UIKit

//@IBDesignable

class UITextFieldExtended: UITextFieldBorderWidthAndColor
{
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: (bounds.origin.x + iconWidth*2) + spacing , y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: (bounds.origin.x + iconWidth*2) + spacing, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        layer.cornerRadius = radius
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    var iconWidth: CGFloat = 10
    
    @IBInspectable var spacing: CGFloat = 0.0
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var radius: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    
    func updateView() {
        if let image = leftImage {
          leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: iconWidth, height: iconWidth))
            imageView.image = image
            imageView.tintColor = color
            leftView = imageView
        } else {
            
          leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        
      attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    @IBInspectable var KshadowColor:UIColor = UIColor.clear {
        didSet{
            shadowOnView()
        }
    }
    
    @IBInspectable var KshadowRadius:CGFloat = 0.0 {
        didSet{
            shadowOnView()
            
        }
    }
    
    private func shadowOnView() {
        
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = false
    }
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if bottomSublayer
        {
            setBottomBorderWithCALayer()
        }
    }
    
    fileprivate func setBottomBorderWithCALayer()
    {
        let border = CALayer()
        border.backgroundColor = sublayerBorderColor?.cgColor
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - sublayerBorderWidth, width: self.frame.size.width, height: sublayerBorderWidth)
        self.layer.addSublayer(border)
    }
    
    @IBInspectable var KcornerRadius:CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    
    
}

