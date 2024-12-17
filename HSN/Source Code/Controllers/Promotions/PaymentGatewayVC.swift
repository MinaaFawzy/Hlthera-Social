//
//  PaymentGatewayVC.swift
//  HSN
//
//  Created by Mac02 on 07/10/21.
//  Copyright © 2021 Kartikeya. All rights reserved.
//

import UIKit
import WebKit
class PaymentGatewayVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var url = ""
    var callback:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL (string: self.url )
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
        self.webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension PaymentGatewayVC{
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    CommonUtils.showHudWithNoInteraction(show: false)
    if let text = webView.url?.absoluteString {
        print(text)
     
        
        if text.contains("hlthera-social-network-backend"){
            callback?()
                
                 if let urlComponents = URLComponents(string: text),
                     let queryItems = urlComponents.queryItems {
                     let value = queryItems[0].value
                    
 //                    let ordersummary =  UIStoryboard.init(name: Storyboard.kStoryboardOthers, bundle: nil).instantiateViewController(withIdentifier: Identifiers.kOrdersummaryVC) as! OrdersummaryVC
 //                    ordersummary.paymentId  = value ?? ""
 //                    self.navigationController?.pushViewController(ordersummary, animated: true)
                   print(queryItems)
                     
                 } else {
                     self.dismiss(animated: true, completion: {
                         print("home")
                     })
                     
                     
                 }
           
        }
        else {
            
                print("errorrrrf")
              
                
            
        }
   
    }
}

func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       CommonUtils.showHudWithNoInteraction(show: true)
      }

}
