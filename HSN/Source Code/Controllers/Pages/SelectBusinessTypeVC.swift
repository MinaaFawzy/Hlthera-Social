//
//  SelectBusinessTypeVC.swift
//  HSN
//
//  Created by user206889 on 11/16/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
var pageData:[String:Any] = [ApiParameters.business_type:"",
                                  ApiParameters.website_url:"",
                                  ApiParameters.page_name:"",
                                  ApiParameters.description:"",
                                  ApiParameters.industry:"",
                                  ApiParameters.company_type:"",
                                  ApiParameters.company_size:"",
                                  ApiParameters.location:"",
                                  ApiParameters.is_delete:"0"]

class SelectBusinessTypeVC: UIViewController {
    @IBOutlet var buttonsBusinessType: [UIButton]!
    @IBOutlet var labelsBusinessType: [UILabel]!
    @IBOutlet weak var textFieldWebsiteURL: UITextField!
    @IBOutlet  var imagesBusinessType: [UIImageView]!
    @IBOutlet var viewBusinessType: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        // Do any additional setup after loading the view.
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetSelection()
    }
    
    func validateFields(){
        
        if buttonsBusinessType.filter({$0.isSelected}).isEmpty{
            CommonUtils.showToast(message: "Please select bussiness type")
            return
        }
        
        if String.getString(textFieldWebsiteURL.text).isEmpty{
            CommonUtils.showToast(message: "Please enter URL")
            return
        }
        
        if  !String.getString(textFieldWebsiteURL.text).isEmpty && !String.getString(textFieldWebsiteURL.text).isURL(){
            CommonUtils.showToast(message: "Please enter valid URL")
            return
        }
        
        let res = buttonsBusinessType.filter({$0.isSelected}).first
        
        pageData[ApiParameters.website_url] = String.getString(textFieldWebsiteURL.text)
        pageData[ApiParameters.business_type] = String.getString(Int(res?.tag ?? 0) + 1)
        if let vc = self.parent{
            if let pvc = vc as? CreatePageConnectionsVC{
                pvc.changeViewController(index: 1, direction: .forward)
                if let parentOfPVC = pvc.parent{
                    if let ppvc = parentOfPVC as? CreatePageVC{
                        ppvc.selectScreen(index: 1)
                    }
                }
            }
        }
    }
    
    func resetSelection(index:Int = 3){
        self.buttonsBusinessType.forEach{
            $0.isSelected = false
            $0.backgroundColor = .white
        }
        
        self.labelsBusinessType.forEach{
            $0.textColor = UIColor(hexString: "#A4B8CD")
        }
        
        self.viewBusinessType.forEach{
            $0.backgroundColor = UIColor(hexString: "#A4B8CD")
        }
        
        self.imagesBusinessType[0].image = index != 0 ? UIImage(named:"small_busines") : UIImage(named:"small_business_selection")
        self.imagesBusinessType[1].image = index != 1 ? UIImage(named:"medium_business") : UIImage(named:"medium_business_selection")
        self.imagesBusinessType[2].image = index != 2 ? UIImage(named:"educational_institute-1") : UIImage(named:"educational_institute_selection")
    }
    
    func selectButton(index:Int){
      
        resetSelection(index: index)
        self.labelsBusinessType[index].textColor = UIColor(named: "5")!
        self.buttonsBusinessType[index].isSelected = true
        self.viewBusinessType[index].backgroundColor = UIColor(hexString: "#194F73")
        self.buttonsBusinessType[index].backgroundColor = UIColor(hexString: "#D0E9FA")
//        promotidonData[ApiParameters.promotion_goal_type] = index + 1
//        if index == 1{
//            prsomotionData[ApiParameters.promotion_goal] = String.getString(textFieldWebsiteURL.text)
//        }
//        else{
//            promotionDatad[ApiParameters.promotion_goal] = ""
//        }
    }
    
    @IBAction func buttonSelectionTapped(_ sender: UIButton) {
        selectButton(index: sender.tag)
        guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: EditPageVC.getStoryboardID()) as? EditPageVC else { return }
        vc.hasCameFrom = .createPage
        vc.businessType = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func buttonAlreadyCreatedTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: Storyboards.kPages, bundle: nil).instantiateViewController(withIdentifier: AddPageProductVC.getStoryboardID()) as? AddPageProductVC else { return }
        vc.hasCameFrom = .addProduct
        self.navigationController?.pushViewController(vc, animated: true)
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
