//
//  ChallengePointsVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 25/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ChallengePointsVC: UIViewController {

    @IBOutlet weak var viewChallengePoints: UIView!
    @IBOutlet weak var tableViewFitness: UITableView!
    var arrNum = ["1","2","3","4","5","6"]
    var arrPoints = ["3400","4000","3200","4800","5400","6000"]
    var arrName = ["NaderNassar" ,"KaustubhRasstogi","Krishna","Vibhor","Aditya","Kaushal"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.viewChallengePoints.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        }
        self.tableViewFitness.delegate = self
        self.tableViewFitness.dataSource = self
       
    }
    
    @IBAction func buttonBackTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonLogOut(_ sender: UIButton) {
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: FitnessSpeedVC.getStoryboardID()) as? FitnessSpeedVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func buttonChallengeTap(_ sender: UIButton) {
        
        guard let nextVc = self.storyboard?.instantiateViewController(identifier: ChallengePointsVC.getStoryboardID()) as? ChallengePointsVC else {return}
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}
extension ChallengePointsVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PointsTVC.identifier, for: indexPath) as! PointsTVC
        cell.labelNumber.text = arrNum[indexPath.row]
        cell.labelName.text = arrName[indexPath.row]
        cell.labelPointss.text = arrNum[indexPath.row]
        
        
        return cell
        }
        
    }


   


