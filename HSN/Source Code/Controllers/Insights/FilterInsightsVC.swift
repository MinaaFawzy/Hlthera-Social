//
//  FilterInsightsVC.swift
//  HSN
//
//  Created by Prashant Panchal on 09/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class FilterInsightsVC: UIViewController {
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet var buttonsType: [UIButton]!
    var callbackApply:(()->())?
    let datePickerView = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton(index: selectedFilter-1)
        setupDatePicker()
        // Do any additional setup after loading the view.
    }
    func selectButton(index:Int){
        buttonsType.forEach{$0.isSelected = false}
        buttonsType[index].isSelected = true
    }
    func setupDatePicker(){
        if #available(iOS 13.4, *) {
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250.0)
            datePickerView.preferredDatePickerStyle = .wheels
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        self.datePickerView.datePickerMode = .date
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        let maxDate = currentDate
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
       self.setToolBar(textField: textFieldDate)
        self.setToolBar(textField: textFieldEndDate)
    }
    func setToolBar(textField:UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let myColor : UIColor = UIColor( red: 2/255, green: 14/255, blue:70/255, alpha: 1.0 )
        toolBar.tintColor = myColor
        toolBar.sizeToFit()
        // Adding Button ToolBar
       
        toolBar.tag = 0
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick1))
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick2))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        if textField.tag == 0{
            toolBar.setItems([cancelButton, spaceButton, doneButton1], animated: false)
        }
        else if textField.tag == 1{
            toolBar.setItems([cancelButton, spaceButton, doneButton2], animated: false)
        }
        
        toolBar.isUserInteractionEnabled = true
        textField.inputView = self.datePickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick1() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            self.textFieldDate.text = dateFormatter.string(from: self.datePickerView.date)
    }
    @objc func doneClick2() {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldEndDate.text = dateFormatter.string(from: self.datePickerView.date)
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    @IBAction func buttonApplyTapped(_ sender: Any) {
        if buttonsType.filter({$0.isSelected}).isEmpty{
            CommonUtils.showToast(message: "Please Select Filter Type")
            return
        }
        self.dismiss(animated: true, completion: {
            selectedFilter = self.buttonsType.filter{$0.isSelected}[0].tag + 1
            selectedFilterStartDate = ""
            selectedFilterEndDate = ""
            self.callbackApply?()
        })
    }
    @IBAction func buttonResetTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            selectedFilter = 1
            selectedFilterStartDate = ""
            selectedFilterEndDate = ""
        })
    }
    @IBAction func buttonFilterTapped(_ sender: UIButton) {
        selectButton(index: sender.tag)
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
