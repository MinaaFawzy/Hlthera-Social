//
//  FitnessCalendarVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 24/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class FitnessCalendarVC: UIViewController {

    @IBOutlet weak var viewFitnessCalendar: UIView!
    @IBOutlet weak var buttonDay: UIButton!
    
    @IBOutlet weak var buttonWeek: UIButton!
    
    @IBOutlet weak var buttonMonth: UIButton!
    
    @IBOutlet weak var heightStackviewDays: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightStackviewDays.constant = 0
        DispatchQueue.main.async {
            self.viewFitnessCalendar.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        }
        
        
    }
    
    @IBAction func buttonBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonDayTapped(_ sender: UIButton) {
        
//        buttonDay.backgroundColor = UIColor(hexString: "#4276C2")
//
//        buttonWeek.setTitleColor(UIColor(hexString: "#4276C2" ), for: .normal)
//        buttonMonth.setTitleColor(UIColor(hexString: "#4276C2" ), for: .normal)
//
//        buttonDay.setTitleColor(UIColor(hexString: "#FFFFFF" ), for: .normal)
//
//        buttonWeek.backgroundColor = UIColor(hexString: "#FFFFFF" )
//
//        buttonMonth.backgroundColor = UIColor(hexString: "#FFFFFF" )
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessCalculationVC.getStoryboardID()) as? FitnessCalculationVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    
    @IBAction func buttonWeekTapped(_ sender: UIButton) {
        
//        buttonWeek.backgroundColor = UIColor(hexString: "#4276C2")
//
//        buttonDay.setTitleColor(UIColor(hexString: "#4276C2" ), for: .normal)
//        buttonMonth.setTitleColor(UIColor(hexString: "#4276C2" ), for: .normal)
//
//        buttonWeek.setTitleColor(UIColor(hexString: "#FFFFFF" ), for: .normal)
//
//        buttonDay.backgroundColor = UIColor(hexString: "#FFFFFF" )
//
//        buttonMonth.backgroundColor = UIColor(hexString: "#FFFFFF" )
        
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessPointsVC.getStoryboardID()) as? FitnessPointsVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    
    @IBAction func buttonMonthTapped(_ sender: UIButton) {
        buttonMonth.backgroundColor = UIColor(hexString: "#2E7AC5")
        
        buttonDay.setTitleColor(UIColor(hexString: "#2E7AC5" ), for: .normal)
        buttonWeek.setTitleColor(UIColor(hexString: "#2E7AC5" ), for: .normal)
   
        buttonMonth.setTitleColor(UIColor(hexString: "#FFFFFF" ), for: .normal)
        
        buttonDay.backgroundColor = UIColor(hexString: "#FFFFFF" )
        
        buttonWeek.backgroundColor = UIColor(hexString: "#FFFFFF" )
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessCalendarVC.getStoryboardID()) as? FitnessCalendarVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    
    
    @IBAction func buttonChallengeIconTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: ChallengePointsVC.getStoryboardID()) as? ChallengePointsVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
}
