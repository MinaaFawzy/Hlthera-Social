//
//  SubscriptionVC.swift
//  HSN
//
//  Created by Prashant Panchal on 17/06/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Stripe
import StripePaymentSheet
class SubscriptionVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBuy: UIButton!
    var data:[PlanModel] = []
    var activePlan:PlanModel?
    var selectedPlan:PlanModel?
    var stripePaymentIntent = ""
    var stripePaymentEphermeral = ""
    var stripePaymentCustomerId = ""
    var stripePaymentPublishable = ""
    var paymentSheet: PaymentSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()//(color: #colorLiteral(red: 0.1176470588, green: 0.2470588235, blue: 0.4235294118, alpha: 1))
        globalApis.getPlans(completion: { data,activePlan in
            self.data = data
            self.activePlan = activePlan
            
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func initializePayment(amount:String,completion: @escaping (String,String,String)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [
            "tran_type": "sale",
            "tran_class": "ecom",
            "cart_currency": "AED",
            "cart_amount":String.getString(amount) ,
            "cart_description": "payment for subscription",
            "return": "http://54.79.26.188/hlthera-social-network-backend",
            "callback": "http://54.79.26.188/hlthera-social-network-backend",
            "hide_shipping": true,
            "framed": true,
            "customer_details": [
                "name": UserData.shared.full_name,
                "email": UserData.shared.email,
                "phone": UserData.shared.mobile_number,
                "street1": "",
                "city": UserData.shared.city,
                "state": UserData.shared.state,
                "country": "AE",
                "zip": "",
                "ip": "1.1.1.1" ]]

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.payment_request,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    let gatewayUrl =  String.getString(dictResult["redirect_url"])
                    let cartId =  String.getString(dictResult["cart_id"])
                    let tran_ref =  String.getString(dictResult["tran_ref"])
                    let cartAmount =  String.getString(dictResult["cart_amount"])
                    let serviceId =  String.getString(dictResult["serviceId"])
                    let trace =  String.getString(dictResult["trace"])
                    completion(gatewayUrl,tran_ref,cartId)
                    
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
    func planPurchase(plan:PlanModel,tran_ref:String,cartId:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.subscription_id:plan.id,
                                   ApiParameters.price:plan.price,
                                   ApiParameters.tax:"35",
                                   ApiParameters.total_amount:plan.price,
                                   ApiParameters.tran_ref:tran_ref,
                                   ApiParameters.cart_id:cartId]

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.purchase_subscription,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    
                    self.moveToPopUp(text: "Subscription Plan Purchased Successfully", completion: {
                        completion()
                    })
                    
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
    
    func verifyPayment(id:String,completion: @escaping (Bool,String,String,String)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [
            "tran_ref": id]

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.payment_status,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    let data = kSharedInstance.getDictionary(dictResult["payment_result"])
                    var reason = ""
                    var status = false
                    switch String.getString(data["response_status"]){
                    case "A":
                        reason = "Authorised"
                        status = true
                    case "H":
                        reason = "Hold – (Authorised but on hold for further anti-fraud review)"
                        status = false
                    case "P":
                        reason = "Pending"
                        status = false
                    case "V":
                        reason = "Voided"
                        status = false
                    case "E":
                        reason = "Error"
                        status = false
                    case "D":
                        reason = "Declined"
                        
                        status = false
                    default:break
                    }
                    let gatewayUrl =  String.getString(dictResult["redirect_url"])
                    let cartId =  String.getString(dictResult["cart_id"])
                    let tran_ref =  String.getString(dictResult["tran_ref"])
                    let cartAmount =  String.getString(dictResult["cart_amount"])
                    let serviceId =  String.getString(dictResult["serviceId"])
                    let trace =  String.getString(dictResult["trace"])
                    completion(status,reason,tran_ref,cartId)
                    
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
    func paymentGateway(plan:PlanModel){
//        initializePayment(amount:plan.price) { url,tran_ref,_ in
//            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: PaymentGatewayVC.getStoryboardID()) as? PaymentGatewayVC else {return}
//            vc.url = url
//            vc.callback = {
//                self.verifyPayment(id: tran_ref, completion: {
//                    status,reason,id,cartID in
//                    if status{
//                        self.planPurchase(plan: plan, tran_ref: id, cartId: cartID) {
//
//                            self.navigationController?.popViewController(animated: true)
//                            self.tableView.reloadData()
//                        }
//                    }
//                    else{
//                        CommonUtils.showAlert(title: kAppName, message: "Payment Failed", buttonTitle: "try again", completion: {_ in
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                    }
//                })
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        promotionData[ApiParameters.total_amount] = plan.price
        globalApis.initializeStripeGateway(amount:String.getString(promotionData[ApiParameters.total_amount]),completion: {paymentIntent,ephemeralKey,customerId,publishableKey in
            self.stripePaymentIntent = paymentIntent
            self.stripePaymentEphermeral = ephemeralKey
            self.stripePaymentCustomerId = customerId
            self.stripePaymentPublishable = publishableKey
            self.selectedPlan = plan
            self.initializePaymentGateway()
            
        })
       
        
    }
    func initializePaymentGateway(){
        STPAPIClient.shared.publishableKey = stripePaymentPublishable
              // MARK: Create a PaymentSheet instance
              var configuration = PaymentSheet.Configuration()
              configuration.merchantDisplayName = kAppName
              configuration.customer = .init(id: stripePaymentCustomerId, ephemeralKeySecret: stripePaymentEphermeral)
        
        
              // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
              // methods that complete payment after a delay, like SEPA Debit and Sofort.
        // Comment by ankur
//              configuration.allowsDelayedPaymentMethods = true
              self.paymentSheet = PaymentSheet(paymentIntentClientSecret: stripePaymentIntent, configuration: configuration)
        
        configuration.primaryButtonColor = UIColor(named: "5")!
        
        
        configuration.applePay = .init(
          merchantId: "merchant.hltherasocialnetwork",
          merchantCountryCode: "IN"
        )
        
        paymentSheet?.present(from: self) { paymentResult in
          // MARK: Handle the payment result
          switch paymentResult {
          case .completed:
            print("Your order is confirmed")
              guard let key = self.stripePaymentIntent.components(separatedBy: "_secret").first else { return }
              
              globalApis.verifyStripePayment(paymentIntent:  key, completion: {custId,refId in
                             
                  self.planPurchase(plan: self.selectedPlan ?? PlanModel(data:[:]), tran_ref: refId, cartId: custId) {
                      CommonUtils.showToast(message: "Payment Successful!")
                      kSharedAppDelegate?.moveToHomeScreen()
                  }
              })
              
          case .canceled:
            print("Canceled!")
              CommonUtils.showToast(message: "Payment Cancelled!")
          case .failed(let error):
            print("Payment failed: \(error)")
              CommonUtils.showToast(message: "Payment Failed!")
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

}
extension SubscriptionVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return activePlan != nil ? 1 : 0
        }
        else{
            return data.count
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return tableView.createHeaderView(text: "Active Plan",backgroundColor: .white)
        }
        else{
            return tableView.createHeaderView(text: "Subscription Plans",backgroundColor: .white)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return activePlan != nil ? 40 : 0
        }
        else{
            return data.isEmpty ? 0 : 40
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionTVC.identifier) as! SubscriptionTVC
        var obj = PlanModel(data: [:])
        cell.selectionStyle = .none
        if indexPath.section == 0{
            obj = activePlan ?? PlanModel(data: [:])
            
            cell.labelTitle.text = obj.currentPlan.title
            let expiryDate = Date(unixTimestamp: Double.getDouble(obj.expire_date))
            let diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day
            cell.labelValidity.text = "Valids for " + String.getString(diffInDays) + " days"
           // cell.btnBuy.isHeld = true
            cell.btnBuy.isUserInteractionEnabled = true
            cell.btnBuy.setTitle("Renew", for: .normal)
        }else{
            obj = data[indexPath.row]
            cell.btnBuy.isUserInteractionEnabled = true
            cell.labelValidity.text = obj.duration + " " + obj.duration_type
            //cell.btnBuy.isHeld = false
                cell.labelTitle.text = obj.title
            cell.btnBuy.setTitle("Buy Now", for: .normal)
        }
        
        cell.data = obj
            cell.labelDescription.text = obj.description
        cell.labelPrice.text = "AED " + obj.price
        cell.callback = {
            self.paymentGateway(plan: obj)
            
           
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class SubscriptionTVC:UITableViewCell{
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelValidity: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnBuy: UIButton!
    
    var callback:(()->())?
    override func awakeFromNib(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: PlanFeatureTVC.identifier, bundle: nil), forCellReuseIdentifier: PlanFeatureTVC.identifier)
    }
    var data:PlanModel = PlanModel(data: [:]) {
        didSet{
            tableView.reloadData()
        }
    }
    @IBAction func btnBuyNowTapped(_ sender: Any) {
        callback?()
    }
}
extension SubscriptionTVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.constraintTableViewHeight.constant = CGFloat(data.features.count * 35)
        return data.features.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanFeatureTVC.identifier) as! PlanFeatureTVC
        cell.labelDescription.text = data.features[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
//extension SubscriptionVC:STPAddCardViewControllerDelegate{
//
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//
//     print("cancel")
//    }
//
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: (Error?) -> Void) {
//
//        globalApis.initializeStripeGateway(amount: String.getString(promotionData[ApiParameters.total_amount]), isSaveCard: true, token:token.tokenId,completion: {id,refId in
//
//            self.planPurchase(plan: self.selectedPlan ?? PlanModel(data: [:]), tran_ref: refId, cartId: id, completion: {
//                addCardViewController.dismiss(animated: true, completion: nil)
//                                            self.tableView.reloadData()
//            })
//        })
//    }
//}
