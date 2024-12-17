//
//  SelectBudgetDurationVC.swift
//  HSN
//
//  Created by fluper on 05/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit

class SelectBudgetDurationVC: UIViewController {

    @IBOutlet weak var viewSliderSpend: RangeSeekSlider!
    @IBOutlet weak var viewSliderDuration: RangeSeekSlider!
    @IBOutlet weak var labelTotalSpendValue: UILabel!
    @IBOutlet weak var labelEstimatedAudienceValue: UILabel!
    @IBOutlet var buttonsDuration: [UIButton]!
    
    var spendAmount:CGFloat = 0.0
    var duration:CGFloat = 0.0
    var totalViews = "0"
    var totalAmount:CGFloat = 0.0
    var tax = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSliderSpend.delegate = self
        viewSliderDuration.delegate = self
        self.spendAmount = viewSliderSpend.maxValue
        self.duration = viewSliderDuration.maxValue
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.calculateData(completion: {
                self.labelTotalSpendValue.text = "AED \(String(format: "%.0f", (self.totalAmount))) over \(String(format: "%.0f",(self.duration))) Days"
                self.labelEstimatedAudienceValue.text = self.totalViews
            })
        })
        // Do any additional setup after loading the view.
    }
    
    func validateFields(){
        //promotionData[ApiParameters.price] = String(format: "%.0f",spendAmount)
        promotionData[ApiParameters.duration] = String(format: "%.0f",duration)
        promotionData[ApiParameters.total_amount] = String(format: "%.0f",totalAmount)
        promotionData[ApiParameters.tax] = self.tax
        promotionData[ApiParameters.audience_reach] = self.totalViews
        if let vc = self.parent{
            if let pvc = vc as? PageViewController{
                pvc.changeViewController(index: 3, direction: .forward)
                if let parentOfPVC = pvc.parent{
                    if let ppvc = parentOfPVC as? CreatePromotionPostVC{
                        ppvc.selectScreen(index: 3)
                    }
                }
            }
        }
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
       validateFields()
    }
    
    @IBAction func selectDurationAction(_ sender: UIButton) {
        buttonsDuration.forEach{
            $0.isSelected = false
        }
        buttonsDuration[sender.tag-1].isSelected = true
        duration = CGFloat(sender.tag == 11 ? 15 : (sender.tag == 12 ? 30 : sender.tag))
        
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
extension SelectBudgetDurationVC:RangeSeekSliderDelegate{
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider == viewSliderSpend{
            self.spendAmount = maxValue
        }
        else{
            self.duration = maxValue
        }
        let d = Int.getInt(String(format: "%.0f",(self.duration)))
        self.viewSliderDuration.maxSuffix = d <= 1 ? "Day" : "Days"
      
    }
    func didEndTouches(in slider: RangeSeekSlider) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.calculateData(completion: {
                let d = Int.getInt(String(format: "%.0f",(self.duration)))
               
                self.labelTotalSpendValue.text = "AED \(String(format: "%.0f", (self.totalAmount))) over \(d <= 1 ? String(d) + " Day" : String(d) + " Days" )"
            self.labelEstimatedAudienceValue.text = self.totalViews
        })
        })
    }
}
extension SelectBudgetDurationVC{
    func calculateData(completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: false)
        let params:[String:Any] = [ApiParameters.duration :Int(self.duration),
                                   //ApiParameters.price:Int(self.spendAmount),
                                   "type" : kSharedAppDelegate?.promotionType ?? ""]

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.calculate_user_views,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    self.totalViews = String.getString(data["total_views"])
                    self.totalAmount = CGFloat(Double.getDouble(data["total_amount"]))
                    self.tax = String.getString(data["tax"])
                    completion()
                default:
                    print(String.getString(dictResult["message"]))
                }
            } else if errorType == .noNetwork {
                showAlertMessage.alert(message: AlertMessage.kNoInternet)
            } else {
                showAlertMessage.alert(message: AlertMessage.kDefaultError)
            }
        }
    }
}
