//
//  FilterVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    @IBOutlet var buttonsSortBy: [UIButton]!
    
    var callback:((String)->())?
    var selectedType = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton(buttonsSortBy[selectedType-1])

        // Do any additional setup after loading the view.
    }
    func selectButton(_ sender :UIButton){
        for button in buttonsSortBy{
            if sender == button{
                button.isSelected = true
            }
            else{
                button.isSelected = false
            }
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
    @IBAction func buttonSortByTapped(_ sender: UIButton) {
        selectButton(sender)
        
    }
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonResetTapped(_ sender: UIButton) {
        selectButton(buttonsSortBy[0])
    }
    @IBAction func buttonApplyTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            let selected = self.buttonsSortBy.filter{$0.isSelected}
            if selected.indices.contains(0){
                self.callback?(String.getString(selected[0].tag))
            }
           
        })
    }
    
}
