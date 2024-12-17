//
//  UIViewController.swift
//  Happy Event Demo
//
//  Created by fluper on 21/02/20.
//  Copyright © 2020 Manoj. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //func goToHome() {
    //           let storyBoard = UIStoryboard(name: Storyboards.kHome, bundle: nil)
    //           guard  let vc = storyBoard.instantiateViewController(identifier: Identifiers.kHomeController) as? HomeViewController  else{return}
    //       self.navigationController?.pushViewController(vc, animated: true)
    //
    //       }
    
    func statusBarStyleColor() {
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .darkContent
        }
    }
    
}


public extension UIViewController {
    func setStatusBar(color: UIColor = UIColor(red: 245, green: 247, blue: 249, transparency: 1)) {
        let tag = 12321
        if let taggedView = self.view.viewWithTag(tag) {
            taggedView.removeFromSuperview()
        }
        let overView = UIView()
        overView.frame = UIApplication.shared.statusBarFrame
        overView.backgroundColor = color
        overView.tag = tag
        self.view.addSubview(overView)
    }
}

class CardView: UIView {
    override func layoutSubviews() {
        let obj = layer
        obj.cornerRadius = 5
        obj.shadowColor = UIColor.lightGray.cgColor
        obj.shadowRadius = 2.5
        obj.shadowOpacity = 0.35
        obj.shadowOffset = CGSize(width: 0, height: 1)
        
    }
}

public extension UIStackView {
    func setRatings(value: Int) {
        if self.subviews.count == 5 {
            for (index,element) in self.subviews.enumerated() {
                if index < Int.getInt(value) {
                    element.isHidden = false
                } else {
                    element.isHidden = true
                }
            }
        }
    }
}
