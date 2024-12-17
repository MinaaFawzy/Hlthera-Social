//
//  ChallengePopUpVC.swift
//  HSN
//
//  Created by Shobhit Rastogi on 7/12/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class ChallengePopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // var callback:(()->())?
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0){
         let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FitnessHomeVC") as! FitnessHomeVC
            nextVC.callback = {
                
                    guard let nextVc = self.storyboard?.instantiateViewController(identifier: ChallengeDetailsVC.getStoryboardID()) as? ChallengeDetailsVC else {return}
                    self.navigationController?.pushViewController(nextVc, animated: true)
               
            }
           
                    self.present(nextVC, animated: true, completion: nil)
                }
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
