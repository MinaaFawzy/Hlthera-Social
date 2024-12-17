//
//  ReviewPromotionVC.swift
//  HSN
//
//  Created by fluper on 05/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import Stripe
import PassKit
import StripePaymentSheet

class ReviewPromotionVC: UIViewController {
   
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var labelURl: UILabel!
    @IBOutlet weak var labelPostName: UILabel!
    @IBOutlet weak var labelPromotionType: UILabel!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var viewAutomatic: UIView!
    @IBOutlet weak var labelBudget: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelInterest: UILabel!
    @IBOutlet weak var labelAgeGroup: UILabel!
    @IBOutlet weak var labelAudienceHeading: UILabel!
    @IBOutlet weak var labelEstimatedPrice: UILabel!
    @IBOutlet weak var labelTotalTax: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    
    var postId = ""
    var serverKey = "STJN9J6LLD-J2GK22ZDTB-HJKZKR6J6T"
    var clientKey = "CBKM29-9QDT6M-TKMM9D-RNB6QG"
    var profileID = "57651"
    
    var stripePaymentIntent = ""
    var stripePaymentEphermeral = ""
    var stripePaymentCustomerId = ""
    var stripePaymentPublishable = ""
    var paymentSheet: PaymentSheet?
  
    
   // let backendCheckoutUrl = URL(string: "Your backend endpoint")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData(){
        self.postId = String.getString(promotionData[ApiParameters.post_id])
        
        self.labelPostName.text = postId.isEmpty ? "Select Promotion Post" : "Promotion Post"
        self.labelPromotionType.text = getPromotionType(index: Int.getInt(promotionData[ApiParameters.promotion_goal_type]))
        if Int.getInt(promotionData[ApiParameters.promotion_goal_type]) == 2{
            labelURl.isHidden = false
            self.labelURl.text = String.getString(promotionData[ApiParameters.promotion_goal])
        }
        else{
            labelURl.isHidden = true
        }
        if Int.getInt(promotionData[ApiParameters.target_audience_type]) == 3{
            viewCustom.isHidden = false
        }
        else{
            viewCustom.isHidden = true
        }
        self.labelAudienceHeading.text = getAudienceType(index:Int.getInt(promotionData[ApiParameters.target_audience_type]))
        self.labelLocation.text = "Location: " + String.getString(promotionData[ApiParameters.location])
        self.labelInterest.text = "Interest: " + String.getString(promotionData[ApiParameters.interest])
        self.labelAgeGroup.text = "Age Group: " + String.getString(promotionData[ApiParameters.age_group_from]) + " - " + String.getString(promotionData[ApiParameters.age_group_to])
        self.labelBudget.text = "Budget: AED " + String.getString(promotionData[ApiParameters.price])
        self.labelDuration.text = "Duration: " + String.getString(promotionData[ApiParameters.duration]) + " Days"
        self.labelEstimatedPrice.text = "Promotion Price: AED " + String.getString(promotionData[ApiParameters.price])
        self.labelTotalTax.text = "Estimated Tax: AED " + String.getString(promotionData[ApiParameters.tax])
        self.labelTotalAmount.text = "Total Spend: AED " + String.getString(promotionData[ApiParameters.total_amount])
        
        if kSharedAppDelegate?.promotionType == "louge" || kSharedAppDelegate?.promotionType == "event" {
            self.postId = postId.isEmpty ? kSharedAppDelegate?.loungeId ?? "" :  self.postId
            self.labelPostName.text = "Promotion Post"
        }
        
    }
    func getPromotionType(index:Int)->String{
        switch index{
        case 1:
            return "More profile visits"
        case 2:
            return "More website visits"
        case 3:
            return "More messages"
        default:
            return "Promotion Type"
        }
    }
    func getAudienceType(index:Int)->String{
        switch index{
        case 1:
            return "Automatic"
        case 2:
            return "Healers"
        case 3:
            return "Created your own"
        default:
            return "Promotion Type"
        }
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
          merchantCountryCode: "AE"
        )
        
        paymentSheet?.present(from: self) { paymentResult in
          // MARK: Handle the payment result
          switch paymentResult {
          case .completed:
            print("Your order is confirmed")
              guard let key = self.stripePaymentIntent.components(separatedBy: "_secret").first else { return }
              
              globalApis.verifyStripePayment(paymentIntent:  key, completion: {custId,refId in
                              promotionData[ApiParameters.tran_ref] = refId
                              promotionData[ApiParameters.cart_id] = custId
                              self.createPromotionPost {
                  
                                  promotionData = [ApiParameters.promotion_goal_type:"",
                                                                    ApiParameters.promotion_goal:"",
                                                                    ApiParameters.target_audience_type:"",
                                                                    ApiParameters.location:"",
                                                                    ApiParameters.interest:"",
                                                                    ApiParameters.gender:"",
                                                                    ApiParameters.age_group_to:"",
                                                                    ApiParameters.age_group_from:"",
                                                                //    ApiParameters.price:"",
                                                                    ApiParameters.duration:"",
                                                                    ApiParameters.audience_reach:"",
                                                                    ApiParameters.tax:"",
                                                                    ApiParameters.total_amount:"",
                                                                    ApiParameters.post_id:"",
                                                                    ApiParameters.tran_ref:"",
                                                                    ApiParameters.cart_id:""]
                                  kSharedAppDelegate?.moveToHomeScreen()
                  
                              }

              })
              CommonUtils.showToast(message: "Payment Successful!")
          case .canceled:
            print("Canceled!")
              CommonUtils.showToast(message: "Payment Cancelled!")
          case .failed(let error):
            print("Payment failed: \(error)")
              CommonUtils.showToast(message: "Payment Failed!")
          }
        }
    }
    func validateFields(){
        if postId.isEmpty{
            CommonUtils.showToast(message: "Please Select Post")
            return
        }
        promotionData[ApiParameters.post_id] = postId
        promotionData[ApiParameters.promotion_type] = kSharedAppDelegate?.promotionType
        
        
        if StripeAPI.deviceSupportsApplePay(){
            print("trueee")
        }
        else{
            print("falseee")
        }
        
        
        globalApis.initializeStripeGateway(amount:String.getString(promotionData[ApiParameters.total_amount]),completion: {paymentIntent,ephemeralKey,customerId,publishableKey in
            self.stripePaymentIntent = paymentIntent
            self.stripePaymentEphermeral = ephemeralKey
            self.stripePaymentCustomerId = customerId
            self.stripePaymentPublishable = publishableKey
            self.initializePaymentGateway()
            
        })
        
        
        
        
        
        
     
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        //paymentGateway()
//        let config = STPPaymentConfiguration()
//        config.publishableKey = "pk_test_51I9Qp6HYt9LR9IA3gP8DzBqBU61K7fK53IDh9PFllKUDlPpcFslBvBvtqpqXqN9A4ELSdAm7lJ9Y4ZzmbqfQ8TKK00GYUfBppq"
//        config.requiredBillingAddressFields = .name
//        config.additionalPaymentOptions = .all
//        config.appleMerchantIdentifier = "merchant.hltherasocialnetwork"
//        //config.apple
//
//
//        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
//
//
//       // let viewController =  STPPaymentOptionsViewController(configuration: config, theme: STPTheme.default(), customerContext: STPCustomerContext(), delegate: self)
//        viewController.delegate = self
//        let navigationController = UINavigationController(rootViewController: viewController)
//        present(navigationController, animated: true, completion: nil)
//       // let pr = Stripe.paymentRequest(withMerchantIdentifier: "merchant.hltherasocialnetwork", country: "IN", currency: "INR")
//       // pr.paymentSummaryItems = [PKPaymentSummaryItem(label: "test", amount: 1)]
////        if Stripe.canSubmitPaymentRequest(pr){
////
////
////        }
////        else{
////            print("unssupported")
////        }
////        let pvc = PKPaymentAuthorizationViewController(paymentRequest: pr)
////        pvc?.delegate = self
////        self.present(pvc ?? UIViewController(), animated: true, completion: nil)
        
        
    }
   
    func stripeGateway(){
        
    }
    
    func paymentGateway(){
        initializePayment { url,tran_ref in
            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: PaymentGatewayVC.getStoryboardID()) as? PaymentGatewayVC else {return}
            vc.url = url
            vc.callback = {
                self.verifyPayment(id: tran_ref, completion: {
                    status,reason,id,cartID in
                    if status{
                        promotionData[ApiParameters.tran_ref] = id
                        promotionData[ApiParameters.cart_id] = cartID
                        self.createPromotionPost {
                            
                            promotionData = [ApiParameters.promotion_goal_type:"",
                                                              ApiParameters.promotion_goal:"",
                                                              ApiParameters.target_audience_type:"",
                                                              ApiParameters.location:"",
                                                              ApiParameters.interest:"",
                                                              ApiParameters.gender:"",
                                                              ApiParameters.age_group_to:"",
                                                              ApiParameters.age_group_from:"",
                                                              ApiParameters.price:"",
                                                              ApiParameters.duration:"",
                                                              ApiParameters.audience_reach:"",
                                                              ApiParameters.tax:"",
                                                              ApiParameters.total_amount:"",
                                                              ApiParameters.post_id:"",
                                                              ApiParameters.tran_ref:"",
                                                              ApiParameters.cart_id:""]
                            kSharedAppDelegate?.moveToHomeScreen()
                        }
                    }
                    else{
                        CommonUtils.showAlert(title: kAppName, message: "Payment Failed", buttonTitle: "try again", completion: {_ in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                })
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    @IBAction func buttonSelectPostTapped(_ sender: Any) {
        if kSharedAppDelegate?.promotionType == "post"{
           guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: SelectPromotionPostVC.getStoryboardID()) as? SelectPromotionPostVC else {return}
            vc.callbackDone = {id in
                self.postId = id
                self.labelPostName.text = "Promotion Post"
            }
            UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: {})
        }else{
            guard let vc = UIStoryboard(name: Storyboards.kPromotions, bundle: nil).instantiateViewController(withIdentifier: SelectLougePromotionVC.getStoryboardID()) as? SelectLougePromotionVC else {return}
             vc.callbackDone = {id in
                 self.postId = id
                 self.labelPostName.text = "Promotion Lounge"
             }
             UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: {})
        }
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        validateFields()
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

extension ReviewPromotionVC{
    
    func createPromotionPost(completion: @escaping ()->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = promotionData

        TANetworkManager.sharedInstance.requestApi(withServiceName: ServiceName.create_promotion,
                                                   requestMethod: .POST,
                                                   requestParameters: params, withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in

            CommonUtils.showHudWithNoInteraction(show: false)

            if errorType == .requestSuccess {

                let dictResult = kSharedInstance.getDictionary(result)

                switch Int.getInt(statusCode) {

                case 200:
                    let data =  kSharedInstance.getDictionary(dictResult["data"])
                    completion()
//                    self.moveToPopUp(text: "Promotion Created Successfully", completion: {
//
//                    })
                    
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
    func initializePayment(completion: @escaping (String,String)->()){
        CommonUtils.showHudWithNoInteraction(show: true)
        let params:[String:Any] = [
            "tran_type": "sale",
            "tran_class": "ecom",
            "cart_currency": "AED",
            "cart_amount":String.getString(promotionData[ApiParameters.total_amount]) ,
            "cart_description": "payment for promotion",
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
                    completion(gatewayUrl,tran_ref)
                    
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

}
//extension ReviewPromotionVC:STPAddCardViewControllerDelegate{
//
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//        addCardViewController.dismiss(animated: true, completion: {})
//     print("cancel")
//    }
//
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: (Error?) -> Void) {
//
//        globalApis.initializeStripeGateway(amount: String.getString(promotionData[ApiParameters.total_amount]), isSaveCard: true, token:token.tokenId,completion: {id,refId in
//            promotionData[ApiParameters.tran_ref] = refId
//            promotionData[ApiParameters.cart_id] = id
//            self.createPromotionPost {
//
//                promotionData = [ApiParameters.promotion_goal_type:"",
//                                                  ApiParameters.promotion_goal:"",
//                                                  ApiParameters.target_audience_type:"",
//                                                  ApiParameters.location:"",
//                                                  ApiParameters.interest:"",
//                                                  ApiParameters.gender:"",
//                                                  ApiParameters.age_group_to:"",
//                                                  ApiParameters.age_group_from:"",
//                                                  ApiParameters.price:"",
//                                                  ApiParameters.duration:"",
//                                                  ApiParameters.audience_reach:"",
//                                                  ApiParameters.tax:"",
//                                                  ApiParameters.total_amount:"",
//                                                  ApiParameters.post_id:"",
//                                                  ApiParameters.tran_ref:"",
//                                                  ApiParameters.cart_id:""]
//                addCardViewController.dismiss(animated: true, completion: {
//                    kSharedAppDelegate?.moveToHomeScreen()
//                })
//
//            }
//        })
//    }
//}
extension ReviewPromotionVC:STPPaymentOptionsViewControllerDelegate{
    func paymentOptionsViewController(_ paymentOptionsViewController: STPPaymentOptionsViewController, didFailToLoadWithError error: Error) {
        print(paymentOptionsViewController)
    }
    
    func paymentOptionsViewControllerDidFinish(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        print(paymentOptionsViewController)
    }
    
    func paymentOptionsViewControllerDidCancel(_ paymentOptionsViewController: STPPaymentOptionsViewController) {
        print(paymentOptionsViewController)
    }
    
    
}

extension ReviewPromotionVC:PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print(controller)
    }
    
   
    private func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        STPAPIClient.shared().createToken(with: payment, completion: {_,_ in
//            print(payment)
//        })
        print(payment)
    }
    
}
