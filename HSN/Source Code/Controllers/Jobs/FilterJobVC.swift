//
//  FilterJobVC.swift
//  HSN
//
//  Created by Prashant Panchal on 23/12/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class FilterJobVC: UIViewController {
    @IBOutlet var buttonsJobType: UIButton!
    @IBOutlet var buttonsDurations: [UIButton]!
    @IBOutlet var buttonsLocation: [UIButton]!
    var callback:((String,[Int:Int])->())?
    
    var empTypes:[String] = []
    var selectedFilter:[Int:Int] = [:]
    var selectedJobType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        if self.selectedFilter.keys.contains(1) || self.selectedFilter.keys.contains(2) || self.selectedFilter.keys.contains(3) {
            selectedFilter.forEach{
                selectButton(index: $0.value, type: $0.key)}
        }
        if !selectedJobType.isEmpty{
            self.buttonsJobType.setTitle(selectedJobType, for: .normal)
            self.buttonsJobType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.buttonsJobType.tag = 1
        }
        
        getEmploymentTypeApi()
        // Do any additional setup after loading the view.
    }
    func selectButton(index:Int,type:Int){
        selectedFilter[type] = index
        switch type{
        case 1:
           print("none")
            
            
        case 2:
            buttonsDurations.forEach{$0.isSelected = false}
            buttonsDurations[index].isSelected = true
        case 3:
            buttonsLocation.forEach{$0.isSelected = false}
            buttonsLocation[index].isSelected = true
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
    @IBAction func buttonsJobTypeTapped(_ sender: UIButton) {
        showDropDown(on: nil,present:true, for: empTypes, completion: {
            value,index in
           
            self.buttonsJobType.setTitle(value, for: .normal)
            self.buttonsJobType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.selectedJobType = value
            
        })
    }
    @IBAction func buttonsDurationTapped(_ sender: UIButton) {
        selectButton(index: sender.tag, type: 2)
    }
    @IBAction func buttonsLocationTapped(_ sender: UIButton) {
        selectButton(index: sender.tag, type: 3)
    }
    @IBAction func buttonApplyTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: { [self] in
            self.callback?(String.getString(selectedJobType.isEmpty ? "" : selectedJobType),selectedFilter)
        })
    }
    @IBAction func buttonResetTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: { [self] in
            self.callback?("",[:])
        })
    }
    
}
extension FilterJobVC{
    func getEmploymentTypeApi(){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [:]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.employement_type,
                                                   requestMethod: .GET,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["employement_type"])
                    self.empTypes = data.map{String.getString(kSharedInstance.getDictionary($0)["name"])}
                    
                default:
                    showAlertMessage.alert(message: String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}
