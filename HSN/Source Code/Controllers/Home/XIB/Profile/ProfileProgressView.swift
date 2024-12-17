//
//  ProfileProgressView.swift
//  HSN
//
//  Created by Prashant Panchal on 01/02/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ProfileProgressView: UIView {
    
    @IBOutlet weak private var viewProgressBar: HSNPollProgressView!
    @IBOutlet weak private var labelTotalProgress: UILabel!
    @IBOutlet weak private var labelHeading: UILabel!
    
    func initialSetup(data: UserProfileModel?) {
        guard let obj = data else { return }
        let progressValue: Float = Float(convertArabicString(text: obj.profile_complete))
        progressValue == Float(100) ? (self.labelHeading.text = "Profile progress") : (labelHeading.text = "Complete your profile")
        viewProgressBar.progress = Float(progressValue / 100)
        labelTotalProgress.text = "\(progressValue)%"
    }
    
}

public func convertArabicString(text: String) -> Double {
    let formatter: NumberFormatter = NumberFormatter()
    formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
    let final = formatter.number(from: text) ?? NSNumber()
    return Double(truncating: final)
}
