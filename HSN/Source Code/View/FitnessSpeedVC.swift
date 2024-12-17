//
//  FitnessSpeedVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 30/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class FitnessSpeedVC: UIViewController {

    @IBOutlet weak var viewFitnessSpeed: UIView!
    @IBOutlet weak var tableViewFitness: UITableView!
    var arrDate = ["22/11/2022","25/11/2022","3/11/2022","4/11/2022","5/11/2022","6/11/2022"]
    var arrSpeed = ["5","8","6","4800","4","7"]
    var arrMinutes = ["30","28","40","18","43","28"]
    var arraDurationHour = ["1","2","3","4800","4","5"]
    var arrDistance = ["5","10","30","48","42","15"]
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.viewFitnessSpeed.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        }
        self.tableViewFitness.delegate = self
        self.tableViewFitness.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func butttonCreateTapped(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FintnessStartActivityVC.getStoryboardID()) as? FintnessStartActivityVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func buttonChallengeTapped(_ sender: UIButton) {
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
