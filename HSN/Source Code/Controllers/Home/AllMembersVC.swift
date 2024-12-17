//
//  AllMembersVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class AllMembersVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelPageTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
