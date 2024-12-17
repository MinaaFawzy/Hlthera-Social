//
//  CreatePollVC.swift
//  HSN
//
//  Created by Prashant Panchal on 06/05/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import DropDown

class CreatePollVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldQuestion: UITextField!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSelectPoll: UIButton!
   
    
    var dropDown = DropDown()
    var answersCount = 1
    var hasCameFrom:HasCameFrom = .createPost
    var groupId = ""
    var pageId = ""
    var answers:[String] = ["",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonAddMoreTapped(_ sender: Any) {
        self.view.endEditing(true)
        if answers.count > 3{
            CommonUtils.showToast(message: "Maximum 4 Answers allowed")
            return
        }
        else{
            if answers.last != ""{
                answers.append("")
                self.tableView.reloadData()
            }
            else{
                CommonUtils.showToast(message: "Please enter Answer")
                return
            }
        }
    }
    @IBAction func buttonPollDurationTapped(_ sender: UIButton) {
       
        var data:[String] = ["1 day"]
        for value in 2...10{
            data.append("\(Int.getInt(value)) days")
        }
      
        showDropDown(on: self.navigationController, for:data , completion: {
            value,index in
            
                self.buttonSelectPoll.setTitle(value, for: .normal)
                self.buttonSelectPoll.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.buttonSelectPoll.tag = index + 1
            
        })
        
       
    }
    @IBAction func buttonNextTapped(_ sender: Any) {
        self.view.endEditing(true)
        if String.getString(textFieldQuestion.text).isEmpty{
            CommonUtils.showToast(message: "Please enter question")
            return
        }
        if answers.isEmpty || answers.last == ""{
            CommonUtils.showToast(message: "Please enter answer")
            return
        }
        if answers.count < 2{
            CommonUtils.showToast(message: "Please enter atleast two answer")
            return
        }
        if buttonSelectPoll.tag == 0{
            CommonUtils.showToast(message: "Please select poll duration")
            return
        }
       
        
        createPoll()
    }
    
    

}
extension CreatePollVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        constraintTableViewHeight.constant = CGFloat(answers.count * 80)
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTVC.identifier, for: indexPath) as! AnswerTVC
        cell.textFieldAnswer.tag = indexPath.row
        if answers.indices.contains(indexPath.row){
            cell.textFieldAnswer.text = answers[indexPath.row]
        }
       
        if !String.getString(cell.textFieldAnswer.text).isEmpty{
            
            
            if answers.last != "" && answers.count == indexPath.row + 1{
                cell.textFieldAnswer.isUserInteractionEnabled =  true
               cell.buttonDelete.isHidden = true
            }
            else if answers[indexPath.row] == ""{
                cell.textFieldAnswer.isUserInteractionEnabled =  true
               cell.buttonDelete.isHidden = true
            }else{
                cell.textFieldAnswer.isUserInteractionEnabled =  false
               cell.buttonDelete.isHidden = false
            }
        }
        else{
            cell.textFieldAnswer.isUserInteractionEnabled = true
            cell.buttonDelete.isHidden = true
        }
        cell.textFieldAnswer.delegate = self
        cell.labelFieldTitle.text = "Answer Option " +  String.getString(indexPath.row + 1) + "*"
        cell.deleteCallback = {
            
            if self.answers.indices.contains(indexPath.row){
                cell.textFieldAnswer.text = ""
                self.answers.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            
            
          
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    
}
class AnswerTVC:UITableViewCell{
    @IBOutlet weak var textFieldAnswer: UITextField!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var labelFieldTitle: UILabel!
    var deleteCallback:(()->())?
    @IBAction func buttonDeleteAnswerTapped(_ sender: Any) {
        deleteCallback?()
    }
    
}
extension CreatePollVC {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !String.getString(textField.text).isEmpty{
            if answers.last == ""{
                answers[textField.tag] = (String.getString(textField.text))
                self.tableView.reloadData()
            }else if answers.last != "" && answers.count == textField.tag + 1{
                answers[textField.tag] = (String.getString(textField.text))
                self.tableView.reloadData()
            }
            else{
                answers.append(String.getString(textField.text))
                self.tableView.reloadData()
            }
        }
    }
}
extension CreatePollVC{
    func createPoll(){
        CommonUtils.showHudWithNoInteraction(show: true)
        var params:[String:Any] = [
            
            ApiParameters.question : String.getString(textFieldQuestion.text),
            ApiParameters.answer : answers,
            ApiParameters.poll_duration : String.getString(buttonSelectPoll.tag),
            
            
        
        ]
        if !pageId.isEmpty{
            params[ApiParameters.company_id] = pageId
            
                params[ApiParameters.is_company_post] = "1"
        }
        else{
            params[ApiParameters.is_company_post] = "0"
        }
        
        if hasCameFrom == .createGroupPost{
            params[ApiParameters.group_id] = groupId
        }
        
        
      
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.addPoll,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
            CommonUtils.showHudWithNoInteraction(show: false)
            
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    let data =  kSharedInstance.getArray(dictResult["employement_type"])
                    guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: PopUpVC.getStoryboardID()) as? PopUpVC else { return }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.popUpDescription = "Poll Created Successfully!"
                    vc.callback = {
                        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                self.dismiss(animated: true, completion: {
                                    kSharedAppDelegate?.moveToHomeScreen()
                                }
                            )
                        })
                    }
                    self.navigationController?.present(vc, animated: true)
                    
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

