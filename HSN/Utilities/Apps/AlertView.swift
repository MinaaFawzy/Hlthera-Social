//
//  AlertView.swift
//  Alert_View
//
//  Created by Shubham Kaliyar on 22/04/19.
//  Copyright © 2019 fluper. All rights reserved.

import Foundation
import UIKit

 let showAlertMessage = AlertView.instance

class AlertView: UIViewController, Loadable {
    var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    static  let instance  = AlertView()
    //MARK:- One Option Alert View ()Alert
    func alert(message:String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: AlertTitle.kOk, style: .cancel, handler: nil)
        alert.addAction(action1)
        UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
    }
    
    
    //MARK:- Two Option Alert StyleList
    func alert(title :String ,message:String , defaultButton : String , cancelButton: String  , Style : UIAlertController.Style , animated : Bool) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: Style)
        let action1 = UIAlertAction(title: defaultButton, style: .destructive, handler: nil)
        let action2 = UIAlertAction(title: cancelButton, style: .cancel, handler: nil)
        alert.addAction(action2)
        alert.addAction(action1)
        UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
    }
    
    //MARK:- UiAlert with textfield
    func alertwithTextField(title :String ,message:String , defaultButton : String , cancelButton: String  , Style : UIAlertController.Style , animated : Bool, completionClosure:@escaping (_ result: String?) -> Void ) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: Style)
        let action1 = UIAlertAction(title: defaultButton, style: .default) { (_) in
            if let txtField = alert.textFields?.first, let text = txtField.text {
                print("text" + text)
                completionClosure(text)
            }
        }
        let action2 = UIAlertAction(title: cancelButton, style: .cancel) { (_) in }
        alert.addTextField { (textField) in
            textField.placeholder = "PlaceHolder"
        }
        alert.addAction(action1)
        alert.addAction(action2)
       UIApplication.shared.windows.first?.rootViewController?.present(alert , animated: true)
    }
    
    
}
