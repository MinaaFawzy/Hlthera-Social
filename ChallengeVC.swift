//
//  ChallengeVC.swift
//  HSN
//
//  Created by Lav Kumar on 24/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ChallengeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.ViewAll.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
            
            self.viewTop.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        }
        
        
    }
   
    
    
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var viewOutermost: UIView!
    
    
    @IBOutlet var ViewAll: UIView!
    
    @IBOutlet weak var searchTextFieldViewheight: NSLayoutConstraint!
    
    
    @IBAction func buttonBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonChallengeTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessHomeVC.getStoryboardID()) as? FitnessHomeVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    
    
    @IBAction func buttonSearchTapped(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func searchTextfieldTapped(_
        sender: UITextField) {
        
    }
    
    
    @IBAction func buttonFitnessActivityTapped(_ sender: UIButton) {
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessSpeedVC.getStoryboardID()) as? FitnessSpeedVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    @IBAction func buttonNextTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessCalculationVC.getStoryboardID()) as? FitnessCalculationVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
