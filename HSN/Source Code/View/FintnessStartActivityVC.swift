//
//  FintnessStartActivityVC.swift
//  HSN
//
//  Created by Kaustubh Rastogi on 30/11/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit

class FintnessStartActivityVC: UIViewController {

    @IBOutlet weak var viewFitnessStartActivity: UIView!
    @IBOutlet weak var collectionViewFitness: UICollectionView!
    var arrWalk = ["Walk","Running","Cycling","Elliptical","Rower"]
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.viewFitnessStartActivity.applyGradient(colours: [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.9137254902, alpha: 1)])
        }
        
        self.collectionViewFitness.delegate = self
        self.collectionViewFitness.dataSource = self
    }
    

    @IBAction func buttonBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
                                                                                                                                                                                                                                                                           
    
}
extension FintnessStartActivityVC : UICollectionViewDelegate , UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // self.collectionViewFitness;
        let cell = collectionViewFitness.dequeueReusableCell(withReuseIdentifier: StartActivityCVC.identifier, for: indexPath) as! StartActivityCVC
        cell.labelWalkType.text = arrWalk[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
      
            
            return CGSize(width: 100, height: 70)
            
        
    }
    
    
}
        
        
