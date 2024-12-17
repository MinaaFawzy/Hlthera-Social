//
//  CelebrateOccassionVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class CelebrateOccassionVC: UIViewController {
    var parentVC:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonsOptionTapped(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateOccassionVC.getStoryboardID()) as? CreateOccassionVC else { return }
            vc.occassionType = 0
            vc.parentVC = self.parentVC
            self.navigationController?.pushViewController(vc, animated: true)

        case 1:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateOccassionVC.getStoryboardID()) as? CreateOccassionVC else { return }
            vc.occassionType = 1
            self.navigationController?.pushViewController(vc, animated: true)

        case 2:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateOccassionVC.getStoryboardID()) as? CreateOccassionVC else { return }
            vc.occassionType = 2
            self.navigationController?.pushViewController(vc, animated: true)

        case 3:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateOccassionVC.getStoryboardID()) as? CreateOccassionVC else { return }
            vc.occassionType = 3
            self.navigationController?.pushViewController(vc, animated: true)

        case 4:
            guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: CreateOccassionVC.getStoryboardID()) as? CreateOccassionVC else { return }
            vc.occassionType = 4
            self.navigationController?.pushViewController(vc, animated: true)

        default:break
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
