//
//  FitnessWalkThroughVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 30/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class FitnessWalkThroughVC: UIViewController {
    
    @IBOutlet var ViewAll: UIView!
    @IBOutlet weak var viewFitnessWalkThrough: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setStatusBarBackgroundColor(UIColor(red: 245, green: 247, blue: 249))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.ViewAll.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        }
    }
    
    @IBAction private func buttonBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func buttonNextTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: ChallengeVC.getStoryboardID()) as? ChallengeVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }

}
