//
//  PremiumExclusiveVC.swift
//  HSN
//
//  Created by Apple on 20/10/22.
//  Copyright © 2022 Kartikeya. All rights reserved.
//

import UIKit
import Stripe
import StripePaymentSheet

class PremiumExclusiveVC : UIViewController { 

    var stripePaymentIntent = ""
    var stripePaymentEphermeral = ""
    var stripePaymentCustomerId = ""
    var stripePaymentPublishable = ""
    @IBOutlet var separatorViews: [UIView]!
    var paymentSheet: PaymentSheet?
    var amount = 19
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBackTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buyPremiumAction(_ sender: UIButton){
        paymentGateway()
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


extension PremiumExclusiveVC {
    
    func paymentGateway(){
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
        
        promotionData[ApiParameters.total_amount] = amount
        globalApis.initializeStripeGateway(amount:String.getString(promotionData[ApiParameters.total_amount]),completion: {paymentIntent,ephemeralKey,customerId,publishableKey in
            self.stripePaymentIntent = paymentIntent
            self.stripePaymentEphermeral = ephemeralKey
            self.stripePaymentCustomerId = customerId
            self.stripePaymentPublishable = publishableKey
          //  self.selectedPlan = plan
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
                             
                  self.planPurchase(plan: PlanModel(data:[:]), tran_ref: refId, cartId: custId) {
                      CommonUtils.showToast(message: "Payment Successful!")
                      guard let vc = UIStoryboard(name: Storyboards.kHome, bundle: nil).instantiateViewController(withIdentifier: ExclusivePostVC.getStoryboardID()) as? ExclusivePostVC else { return }
                     self.navigationController?.pushViewController(vc, animated: true)
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
    
    func planPurchase(plan:PlanModel,tran_ref:String,cartId:String,completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [ApiParameters.price:amount,
                                   ApiParameters.tax:"0",
                                   ApiParameters.total_amount:amount,
                                   ApiParameters.tran_ref:tran_ref,
                                   ApiParameters.cart_id:cartId]

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.purchase_exclusive,
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

    
}
