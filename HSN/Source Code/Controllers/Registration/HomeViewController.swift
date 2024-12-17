//
//  HomeViewController.swift
//  HSN
//
//  Created by Kartikeya on 13/04/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonLogOutTapped(_ sender:UIButton){
        guard let nextvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                self.navigationController?.pushViewController(nextvc, animated: true)
    }
    

}
