//
//  PickerVC.swift
//  HSN
//
//  Created by Prashant Panchal on 24/08/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class PickerVC: UIViewController {
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var callback:((_ selectedItem:String,_ index:Int)->Void)?
    
    var items:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
//        viewContent.layer.cornerRadius = 20
//        if #available(iOS 13.0, *) {
//            let window = UIApplication.shared.windows[0]
//            let topPadding = window.safeAreaInsets.top
//            let bottomPadding = window.safeAreaInsets.bottom
//            bottomConstraint.constant = bottomPadding + 15
//        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonDoneTapped(_ sender: Any) {
        callback?(items[picker.selectedRow(inComponent: 0)],picker.selectedRow(inComponent: 0))
    }
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
extension PickerVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(items[row])
    }
    
    
}
